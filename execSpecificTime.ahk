gosub init

^!+F4::
ExitApp

^!+F3::
gosub, svnUpdate
return

^!+F2::
gosub, init
return

init:
;~ InputBox, svnpath, SVN.exe path, input svn.exe path

IniRead, paths, %A_ScriptDir%\svnUpdate.ini, svnUpdate, paths
paths := StrReplace(paths, "|", "`n")

if(once = "")
{
	Gui, Add, Text, , input path to svnupdate
	Gui, Add, Edit, w300 r10 vResizeCL, %paths%
	Gui, Add, Button, gSubmit Default, OK
}
once = ran

Gui, Show, , name
return

Submit:
Gui, Submit

paths := ResizeCL
paths := StrReplace(paths, "`n", "|")

IniWrite, %paths%, %A_ScriptDir%\svnUpdate.ini, svnUpdate, paths

period := 1 * 60 * 60 * 1000
SetTimer, timerCommands, %period%
;~ SetTimer, timerCommands, -0

return


timerCommands:
FormatTime, now, , HH

if(now = 4)
	goto svnUpdate
return

svnUpdate:
if(svnpath == "")
{
	svnpaths := StrSplit(ResizeCL, "`n")
	for k, path in svnpaths
	{
		temppath := StrReplace(path, "/", "\")
		
		last4char := SubStr(temppath, 0, 4)
		lastchar := SubStr(last4char, 0, 1)
		
		if(lastchar != "\")
			temppath .= "\"

		svnpath = %temppath%ProjectMCServer\Tools\Subversion\svn.exe
		if(FileExist(svnpath) != "")
			break ; svn.exe is found
		
		svnpath = %temppath%Binaries\Subversion\svn.exe
		if(FileExist(svnpath) != "")
			break ; svn.exe is found
	}
}
else
{
	last4char := SubStr(svnpath, -3, 4)
	lastchar := SubStr(svnpath, 0, 1)
	
	StringLower, last4char, last4char
	if(last4char != ".exe" && lastchar != "\")
	{
		;~ msgbox %last4char% %lastchar%
		svnpath .= "\svn.exe"
	}
	else if(lastchar = "\")
		svnpath .= "svn.exe"
}

for k, path in svnpaths
{
	if(FileExist(path) = "")
		continue
;~ MsgBox %svnpath% up %path%
	
	Run, %svnpath% up %path%
	;~ msgbox %svnpath% up %path%
}
return
