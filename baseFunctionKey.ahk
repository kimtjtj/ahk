enable=1
listKeys := ["f1", "f2"]

f1::
click
sleep 1

return

f2::
MouseGetPos, mouseX, mouseY
click
sleep, 50
click, 750, 550
MouseMove, %mouseX%, %mouseY%
return


ScrollLock::
if(enable=0)
{
	for k, v in listKeys
		Hotkey, %v%, On
	enable=1
}
else
{
	for k, v in listKeys
		Hotkey, %v%, Off
	enable=0
}

if(enable = 1)
	tooltipString = macro ON
else
	tooltipString = macro OFF

tooltip, %tooltipString%

SetTimer, removeToolTip, -2000
return

removeToolTip:
ToolTip
return
