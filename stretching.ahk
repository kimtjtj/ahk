
gosub init_stretching

^!+f1::
MsgBox, %lastTime%
return

init_stretching:
periodMin = 60
periodMS := periodMin * 60 * 1000
MAX_TOOLTIP_REPEAT = 5
tooltipMessage := "`n`n`n`n`n`n`n`n`n`n                    stretching                    `n`n`n`n`n`n`n`n`n`n  "

lastTime = %A_Hour%:%A_Min%
settimer, label_tooltip, %periodMS%

;~ gosub label_tooltip
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

