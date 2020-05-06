periodMin = 60
periodMS := periodMin * 60 * 1000
MAX_TOOLTIP_REPEAT = 5
tooltipMessage := "`n`n`n`n`n`n`n`n`n`n                    stretching                    `n`n`n`n`n`n`n`n`n`n  "

settimer, label_tooltip, %periodMS%

^!+f1::
exitapp

label_tooltip:
gosub, showToolTip
removeTooltipRepeat = 0
SetTimer, label_removeTooltip, 1000
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

