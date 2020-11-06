
gosub init

#include %A_ScriptDir%\baseFunctionKey.ahk
#IncludeAgain %A_ScriptDir%\stretching.ahk
#IncludeAgain %A_ScriptDir%\timerTask.ahk
#IncludeAgain %A_ScriptDir%\gem.ahk

init:
gosub init_stretching
return

^`::
Run, notepad++ %A_ScriptDir%\winUtility.ini
return

`::
gosub loadCommands
ToolTip, `Esc : cancel`nF4 : ExitMacro`nF1 : buildTower`nF2 : fesizingGemWin`n%commandString%.

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
send {esc}
click, 550, 370
Sleep, 300
click, 550, 370
sleep, 300
send {esc}
return

f2Label:
MouseGetPos, outX, outY
Click Down

y=%outy%
while(y > 10)
{
	MouseMove, 0, -200, , R
	MouseGetPos, , y
}
click up
MouseMove, %outX%, %outY%

return

f3Label:
WinActivate, ahk_exe Solar-PuTTY.exe
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
	FileDelete, d:\command.ahk
	FileAppend, %str%, d:\command.ahk
	command = "%A_AhkPath%" "d:\command.ahk"
	Run, %command%
	
	return
}
