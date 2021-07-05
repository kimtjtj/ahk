
gosub initWinUtility

#Include %A_ScriptDir%\baseFunctionKey.ahk
#Include %A_ScriptDir%\stretching.ahk
#Include %A_ScriptDir%\timerTask.ahk
#Include %A_ScriptDir%\svnUpdate.ahk

initWinUtility:
gosub init_stretching
gosub initSvnUpdate
strF1Label = DestroyInventory
strF2Label = 
commandFile = %A_AppData%\command.ahk

return

^`::
Run, notepad++.exe "%A_ScriptDir%\winUtility.ini"
return

InputCommand:
`::
gosub loadCommands
strTooltip = Esc : cancel`nF4 : ExitMacro
strTooltip .= "`n" . commandString

ToolTip, %strTooltip%

Input, inputKey, L1, {esc}``{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{up}{down}{left}{right}{Insert}{Delete}{Home}{End}{PGUP}{PGDN}
if(ErrorLevel = "EndKey:``")
{
	Hotkey, ``, Off
	SendRaw, ``
	Hotkey, ``, On
}
if(ErrorLevel = "EndKey:F4")
{
	exitapp
}

inputErrorLevel = %ErrorLevel%

gosub, exitCommand
gosub, execCommand

exitCommand:
tooltip
return

execCommand:
IniRead, strCommands, %A_ScriptDir%\winUtility.ini, commands
objCommands := StrSplit(strCommands, "`n")

for key, val in objCommands
{
	posKey := InStr(val, "key_")
	posEqual := Instr(val, "=")
	length := posEqual - posKey - 4
	
	commandKey := SubStr(val, posKey + 4, length)
	commandContent := SubStr(val, posEqual + 1)

	posEndKey := InStr(inputErrorLevel, "EndKey:")
	commandEndKey := SubStr(inputErrorLevel, posEndKey + 7)
	
	if(inputKey = commandKey || commandEndKey = commandKey)
	{
		each := StrReplace(commandContent, "||", "`r`n")
		fileCommand(each, commandFile)
		break
	}
}

return

loadCommands:
IniRead, strCommands, %A_ScriptDir%\winUtility.ini, commands
objCommands := StrSplit(strCommands, "`n")

commandString =
for key, val in objCommands
{
	posKey := InStr(val, "key_")
	posEqual := Instr(val, "=")
	length := posEqual - posKey - 4
	
	commandKey := SubStr(val, posKey + 4, length)
	commandContent := SubStr(val, posEqual + 1)

	commandString .= commandKey . " : " . commandContent . "`n"
}

return

fileCommand(str, commandFile)
{
	FileDelete, %commandFile%
	FileAppend, %str%, %commandFile%
	command = %A_AhkPath% %commandFile%
	Run, %command%
	
	return
}
