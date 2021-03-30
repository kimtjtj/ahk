
gosub initWinUtility

#Include %A_ScriptDir%\baseFunctionKey.ahk
#IncludeAgain %A_ScriptDir%\stretching.ahk
#IncludeAgain %A_ScriptDir%\timerTask.ahk
#IncludeAgain %A_ScriptDir%\svnUpdate.ahk

initWinUtility:
gosub init_stretching
gosub initSvnUpdate
strF1Label = DestroyInventory
strF2Label = 

return

^`::
Run, notepad++.exe "%A_ScriptDir%\winUtility.ini"
return

`::
gosub loadCommands
strTooltip = Esc : cancel`nF4 : ExitMacro
if(strF1Label != "")
	strTooltip .= "`nF1 : " . strF1Label
if(strF2Label != "")
	strTooltip .= "`nF2 : " . strF2Label
strTooltip .= "`n" . commandString

ToolTip, %strTooltip%

Input, inputKey, L1, {esc}``{F4}{F1}{F2}{F3}
if(ErrorLevel = "EndKey:``")
{
	Hotkey, ``, Off
	SendRaw, ``
	Hotkey, ``, On
}
else if(ErrorLevel = "EndKey:Escape")
{
	goto exitCommand
}
else if(ErrorLevel = "EndKey:F1")
{
	gosub exitCommand
	gosub f1Label
}
else if(ErrorLevel = "EndKey:F2")
{
	gosub exitCommand
	gosub f2Label
}
else if(ErrorLevel = "EndKey:F3")
{
	gosub exitCommand
	gosub f3Label
}
else if(ErrorLevel = "EndKey:F4")
{
	ExitApp
}

gosub, exitCommand

if inputKey is integer
{
	command = % commands[inputKey]
	quote := false
		
	;~ msgbox %command%
	each := StrReplace(command, "||", "`r`n")
	fileCommand(each)
}

exitCommand:
tooltip
return

; start at 15, 199

; 103, 94

f1Label:
MouseGetPos, x, y
Click, Right
d = 0
loop 9
{
	d += 50
	MouseMove, % x + d, %y%
	click, Right
}
MouseMove, %x%, %y%
return

f2Label:
	click WheelUp
return

f3Label:
	click WheelDown
return

loadCommands:
IniRead, commandString, %A_ScriptDir%\winUtility.ini, common, command

commands := StrSplit(commandString, "@@")
commandString =

for k, v in commands
{
	commandString .= k . " : " . v . "`n"
}

return

fileCommand(str)
{
	commandFile = e:\command.ahk
	FileDelete, %commandFile%
	FileAppend, %str%, %commandFile%
	command = %A_AhkPath% %commandFile%
	Run, %command%
	
	return
}
