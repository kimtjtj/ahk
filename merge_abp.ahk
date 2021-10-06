goto init

init:
IniRead, alphaPath, %A_ScriptDir%\merge_abp.ini, merge, alphaPath
IniRead, betaPath, %A_ScriptDir%\merge_abp.ini, merge, betaPath
IniRead, livePath, %A_ScriptDir%\merge_abp.ini, merge, livePath

gui, add, Text, , alpha path
gui, add, edit, w400 valphaPath, %alphaPath%

gui, add, Text, , beta path
gui, add, edit, w400 vbetaPath, %betaPath%

gui, add, Text, , live path
gui, add, edit, w400 vlivePath, %livePath%

gui, add, button, gSubmit Default, OK

gui, show, , Working Path
return

Submit:
gui, submit

IniWrite, %alphaPath%, %A_ScriptDir%\merge_abp.ini, merge, alphaPath
IniWrite, %betaPath%, %A_ScriptDir%\merge_abp.ini, merge, betaPath
IniWrite, %livePath%, %A_ScriptDir%\merge_abp.ini, merge, livePath

goto svnup
return

svnup:
InputBox, which, which branches to merge, A(a) : alpha to BETA`nB(b) : beta to LIVE`nM(m) : mergeOnly`nex) "ab" => merge to beta`, live`n`"am`" => merge to beta without commit(mergeOnly), , , 230

InputBox, rev, Revision Numbers to merge, ex) 61013`n63301`, 63304`n
rev := StrReplace(rev, " ")

if(which = "" || rev = "")
{
	MsgBox, WRONG input
	ExitApp
}

global svnpath
svnpath = %alphaPath%\ProjectMCServer\Tools\Subversion\svn.exe
IfNotExist, %svnpath%
{
	MsgBox, SVN.exe not found, %svnpath%
	exitapp
}

betaRev := rev
liveRev := rev

branchCount = 0
Loop, Parse, which
{
	;~ if(A_LoopField = "a" || A_LoopField = "b" || A_LoopField = "p")
	if(A_LoopField = "a" || A_LoopField = "b")
		branchCount++
}
if(branchCount = 0)
{
	MsgBox, branch to merge isn't selected.
	exitapp
}

mergeOnly := false
global mergeOnly
mergeOnlyPos := InStr(which, "m", true)
;~ MsgBox, %mergeOnlyPos%
if(mergeOnlyPos > 0)
{
	mergeOnly := true
	if(branchCount > 1) ; mergeOnly는 브랜치 하나만 가능
	{
		;~ MsgBox mergeOnly는 브랜치 하나만 가능
		exitapp
	}
}


logOnly := false
global logOnly
logOnlyPos := InStr(which, "l", true)
;~ MsgBox, %mergeOnlyPos%
if(logOnlyPos > 0)
{
	logOnly := true
	if(branchCount > 1) ; logOnly는 브랜치 하나만 가능
	{
		exitapp
	}
}

alphaPos := InStr(which, "a", true)
if(alphaPos > 0)
{
	betaRev := merge(alphaPath, betaPath, rev)
}

betaPos := InStr(which, "b", true)
if(betaPos > 0)
{
	liveRev := merge(betaPath, livePath, betaRev)
}

MsgBox, Complete

exitapp

merge(from, to, rev)
{
	if(rev = "" || rev = 0)
	{
		msgbox merge failed from : %from%`nto : %to%`nrev : %rev%
		ExitApp
	}
	
	logFile = %A_ScriptDir%\merge_abp.log

	exec = cmd.exe /c %svnpath% info  %from% | findstr "^URL:"
	url := RunCommand(exec, logFile)
	url := StrReplace(url, "URL: ")
	url := removeNewLine(url)
	
	exec = cmd.exe /c %svnpath% info  %from% | findstr /B /C:"Repository Root:"
	root := RunCommand(exec, logFile)
	root := StrReplace(root, "Repository Root: ")
	root := removeNewLine(root)

	url := StrReplace(url, root)
	if(url = "")
		url = /
	else if(SubStr(url, 1, 1) = "/" && StrLen(url) >= 2 )
		url := SubStr(url, 2)
	;~ MsgBox %exec%`n`nurl %url%`n`nroot %root%
	
	;~ msgbox %svnpath% merge -c %rev% %from% %to%
	commitMessage = Merged revision(s) %rev% from %url%:`n
	;~ msgbox %commitMessage%
	
	revs := StrSplit(rev, ",")
	for key, val in revs
	{
		exec = cmd.exe /c %svnpath% propget svn:log --revprop -r %val% %from%
		commitMessage .= RunCommand(exec, logFile) . "`r`n"
	}
	
	messageFile = %A_ScriptDir%\svn_log.txt
	FileDelete, %messageFile%
	commitMessage := StrReplace(commitMessage, "`r`n", "`n")
	FileAppend, %commitMessage%, %messageFile%

	if(logOnly = true)
		ExitApp

	exec = cmd.exe /c %svnpath% merge -c %rev% --allow-mixed-revisions %from% %to%
	mergeResult := RunCommand(exec, logFile)
	;~ msgbox %mergeResult%
	
	errorMessage := ""
	if(InStr(mergeResult, "Conflict", false) > 0)
		errorMessage = merge failed from : %from%`nto : %to%`nrev : %rev%`nmessage : %mergeResult%
	
	fromCSCommon = %from%\ProjectMCServer\MCCSCommon
	toCSCommon = %to%\ProjectMCServer\MCCSCommon
	if(FileExist(fromCSCommon) = "D" && FileExist(toCSCommon) = "D") ; cscommon 머지
	{
		exec = cmd.exe /c %svnpath% merge -c %rev% --allow-mixed-revisions %fromCSCommon% %toCSCommon%
		mergeResult := RunCommand(exec, logFile)
		
		if(InStr(mergeResult, "Conflict", false) > 0)
			errorMessage = merge failed from : %fromCSCommon%`nto : %toCSCommon%`nrev : %rev%`nmessage : %mergeResult%
	}
	
	if(errorMessage != "")
	{
		MsgBox %errorMessage%
		exitapp
	}
	
	if(mergeOnly = false)
	{
		exec = cmd.exe /c %svnpath% commit --encoding UTF-8 -F %messageFile% --include-externals %to%
		;~ msgbox %exec%
		commitResult := RunCommand(exec, logFile)
		
		;~ MsgBox %commitResult%
		commitRevPos := InStr(commitResult, "Committed revision")
		if(commitRevPos <= 0)
		{
			msg = commitRevPos <= 0. commit failed from : %from%`nto : %to%`nrev : %rev%`nmessage : %commitResult%`n
			msgbox %msg%
			ExitApp
		}
		
		for key, val in StrSplit(commitResult, "`n")
		{
			if(InStr(val, "Committed revision") > 0)
			{
				tempRev = %val%
				tempRev := StrReplace(tempRev, "Committed revision ")
				tempRev := StrReplace(tempRev, ".")
				tempRev := removeNewLine(tempRev)
			}
		}
		
		if(tempRev = "")
		{
			msg = tempRev = "". commit failed from : %from%`nto : %to%`nrev : %rev%`nmessage : %commitResult%`n
			msgbox %msg%
			ExitApp
		}
	}

	;~ msgbox %tempRev%
	return %tempRev%
}

GuiClose:
ExitApp

removeNewLine(str)
{
	str := StrReplace(str, "`n")
	str := StrReplace(str, "`r")
	return str
}

RunCommand(exec, filename)
{
	str := ComObjCreate("WScript.Shell").Exec(exec).StdOut.ReadAll()
	FileEncoding, UTF-8-RAW
	FileAppend, % "command : " . exec . "`n`nResult : " . str . "`n`n", %filename%
	return str
}