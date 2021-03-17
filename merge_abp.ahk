goto init

init:
IniRead, alphaPath, %A_ScriptDir%\merge_abp.ini, merge, alphaPath
IniRead, betaPath, %A_ScriptDir%\merge_abp.ini, merge, betaPath
IniRead, prPath, %A_ScriptDir%\merge_abp.ini, merge, prPath
IniRead, ptrPath, %A_ScriptDir%\merge_abp.ini, merge, ptrPath

gui, add, Text, , alpha path
gui, add, edit, w400 valphaPath, %alphaPath%

gui, add, Text, , beta path
gui, add, edit, w400 vbetaPath, %betaPath%

gui, add, Text, , pr path
gui, add, edit, w400 vprPath, %prPath%

gui, add, Text, , ptr path
gui, add, edit, w400 vptrPath, %ptrPath%

gui, add, button, gSubmit Default, OK

gui, show, , Working Path
return

Submit:
gui, submit

IniWrite, %alphaPath%, %A_ScriptDir%\merge_abp.ini, merge, alphaPath
IniWrite, %betaPath%, %A_ScriptDir%\merge_abp.ini, merge, betaPath
IniWrite, %prPath%, %A_ScriptDir%\merge_abp.ini, merge, prPath
IniWrite, %ptrPath%, %A_ScriptDir%\merge_abp.ini, merge, ptrPath

goto svnup
return

svnup:
InputBox, which, which branches to merge, A(a) : alpha to BETA`nB(b) : beta to PR`nP(p) : pr to PTR`nex) "abp" => merge to beta, pr, ptr

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
prRev := rev
ptrRev := rev

alphaPos := InStr(which, "a", true)
if(alphaPos > 0)
{
	betaRev := merge(alphaPath, betaPath, rev)
}

betaPos := InStr(which, "b", true)
if(betaPos > 0)
{
	prRev := merge(betaPath, prPath, betaRev)
}

ptrPos := InStr(which, "p", true)
if(ptrPos > 0)
{
	ptrRev := merge(prPath, ptrPath, prRev)
}

exitapp

merge(from, to, rev)
{
	if(rev = "" || rev = 0)
	{
		msgbox merge failed from : %from%`nto : %to%`nrev : %rev%
		ExitApp
	}
	
	exec = cmd.exe /c %svnpath% info  %from% | findstr "^URL:"
	url := ComObjCreate("WScript.Shell").Exec(exec).StdOut.ReadAll()
	url := StrReplace(url, "URL: ")
	url := StrReplace(url, "`n")
	url := StrReplace(url, "`r")

	exec = cmd.exe /c %svnpath% info  %from% | findstr /B /C:"Repository Root:"
	root := ComObjCreate("WScript.Shell").Exec(exec).StdOut.ReadAll()
	root := StrReplace(root, "Repository Root: ")
	root := StrReplace(root, "`n")
	root := StrReplace(root, "`r")
	url := StrReplace(url, root)
	if(url = "")
		url = /
	;~ MsgBox %exec%`n`nurl %url%`n`nroot %root%
	
	;~ msgbox %svnpath% merge -c %rev% %from% %to%
	commitMessage = Merged revision(s) %rev% from %url%:`n
	;~ msgbox %commitMessage%
	
	revs := StrSplit(rev, ",")
	for key, val in revs
	{
		exec = cmd.exe /c %svnpath% propget svn:log --revprop -r %val% %from%
		commitMessage .= ComObjCreate("WScript.Shell").Exec(exec).StdOut.ReadAll()
	}

	;~ MsgBox, %message%
	
	exec = cmd.exe /c %svnpath% merge -c %rev% --allow-mixed-revisions %from% %to%
	mergeResult := ComObjCreate("WScript.Shell").Exec(exec).StdOut.ReadAll()
	;~ msgbox %mergeResult%
	
	if(InStr(mergeResult, "Conflict", false) > 0)
	{
		msgbox merge failed from : %from%`nto : %to%`nrev : %rev%`nmessage : %mergeResult%
		ExitApp
	}

	messageFile = %A_ScriptDir%\svn_log.txt
	FileDelete, %messageFile%
	commitMessage := StrReplace(commitMessage, "`r`n", "`n")
	FileAppend, %commitMessage%, %messageFile%
	
	exec = cmd.exe /c %svnpath% commit -F %messageFile% %to%
	;~ msgbox %exec%
	commitResult := ComObjCreate("WScript.Shell").Exec(exec).StdOut.ReadAll()
	
	;~ MsgBox %commitResult%
	commitRevPos := InStr(commitResult, "Committed revision")
	if(commitRevPos <= 0)
	{
		msg = commitRevPos <= 0. commit failed from : %from%`nto : %to%`nrev : %rev%`nmessage : %commitResult%`n
		msgbox %msg%
		FileAppend, %msg%, %messageFile%
		ExitApp
	}
	
	for key, val in StrSplit(commitResult, "`n")
	{
		if(InStr(val, "Committed revision") > 0)
		{
			tempRev = %val%
			tempRev := StrReplace(tempRev, "Committed revision ")
			tempRev := StrReplace(tempRev, ".")
		}
	}
	
	if(tempRev = "")
	{
		msg = tempRev = "". commit failed from : %from%`nto : %to%`nrev : %rev%`nmessage : %commitResult%`n
		msgbox %msg%
		FileAppend, %msg%, %messageFile%
		ExitApp
	}

	;~ msgbox %tempRev%
	return %tempRev%
}

GuiClose:
ExitApp