
gosub init_stretching

^!+f1::
MsgBox, %lastTime%
return

init_stretching:
IniRead, periodMin, %A_ScriptDir%\stretch.ini, common, periodMin, 60
IniRead, startWorkHour, %A_ScriptDir%\stretch.ini, common, startWorkHour, 10
IniRead, endWorkHour, %A_ScriptDir%\stretch.ini, common, endWorkHour, 20

IniWrite, %periodMin%, %A_ScriptDir%\stretch.ini, common, periodMin
IniWrite, %startWorkHour%, %A_ScriptDir%\stretch.ini, common, startWorkHour
IniWrite, %endWorkHour%, %A_ScriptDir%\stretch.ini, common, endWorkHour

if(periodMin != "" && periodMin != 0)
{
	periodMS := periodMin * 60 * 1000
	MAX_TOOLTIP_REPEAT = 5
	tooltipMessage := "`n`n`n`n`n`n`n`n`n`n                    stretching                    `n`n`n`n`n`n`n`n`n`n  "

	lastTime = %A_Hour%:%A_Min%
	settimer, label_tooltip, %periodMS%
	gosub, label_tooltip
}

minToMs := 1 * 60 * 1000

;~ gosub label_tooltip
return

label_work:
tempHour := startWorkHour - 1
tempMin = 55
timeoutMs := 20 * 60
if(tempHour = A_Hour && tempMin = A_Min)
	MsgBox, 0x40000, Start Work, `n`n`n`t`tStart Work`t`t `n`n`n, %timeoutMs%

tempHour = %endWorkHour%
if(tempHour = A_Hour && A_Min = 0)
	MsgBox, 0x40000, END Work, `n`n`n`t`tEND Work`t`t `n`n`n, %timeoutMs%
return

label_tooltip:
lastTime = %A_Hour%:%A_Min%
gosub, showToolTip
removeTooltipRepeat = 0
SetTimer, label_removeTooltip, 1000
MsgBox, % 0x40000, stretching, %tooltipMessage%, 5
return

label_removeTooltip:
removeTooltipRepeat++
if(removeTooltipRepeat >= MAX_TOOLTIP_REPEAT)
{
	settimer, label_removeTooltip, off
	ToolTip
	return
}
gosub, showToolTip
return

showToolTip:
MouseGetPos, mouseX, mouseY
ToolTip, %tooltipMessage%, %mouseX%, %mouseY%
return

