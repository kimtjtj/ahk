start = 0

^!f9::
exitapp


removeToolTip:
tooltip
return

gemcraft1:
if(start = 0)
{
	MsgBox, , end
	return
}

IfWinNotExist, GemCraft Frostborn Wrath
	exitapp
	

CoordMode, mouse, client
;~ 466, 522, g down
;~ 620, 288, up uu
;~ 1428, 566, click
;~ 1518, 566, click
;~ 1434, 380, g, down
;~ 1470, 380, up u
;~ 963, 182, click

;~ ControlClick, x800 y400, GemCraft Frostborn Wrath, , left, 1

controlsend, , g, GemCraft Frostborn Wrath
controlclick, x620 y320, GemCraft Frostborn Wrath, , left, 1, d

controlclick, x466 y550, GemCraft Frostborn Wrath, , left, 1, u
controlsend, , uu, GemCraft Frostborn Wrath

controlclick, x1430 y600, GemCraft Frostborn Wrath, , left, 1
controlsend, , uu, GemCraft Frostborn Wrath

controlclick, x1518 y600, GemCraft Frostborn Wrath, , left, 1
controlsend, , uu, GemCraft Frostborn Wrath

controlsend, , g, GemCraft Frostborn Wrath
controlclick, x1434 y410, GemCraft Frostborn Wrath, , left, 1, d

controlclick, x1470 y410, GemCraft Frostborn Wrath, , left, 1, u
controlsend, , ddd, GemCraft Frostborn Wrath

controlclick, x960 y210, GemCraft Frostborn Wrath, , left, 1
controlsend, , uu, GemCraft Frostborn Wrath

controlclick, x690 y230, GemCraft Frostborn Wrath, , left, 1
controlsend, , uu, GemCraft Frostborn Wrath

controlclick, x620 y320, GemCraft Frostborn Wrath, , left, 1
controlsend, , uuuu, GemCraft Frostborn Wrath
;~ controlclick, x70 y50, GemCraft Frostborn Wrath, , left, 1

; 638, 648
controlclick, x638 y648 , GemCraft Frostborn Wrath, , left, 1
controlsend, , uu, GemCraft Frostborn Wrath

controlsend, , qq, GemCraft Frostborn Wrath

;~ controlclick, x70 y640, GemCraft Frostborn Wrath, , left, 1

sleep 43000

;~ settimer, removeToolTip, -2000

;~ 1396, 769, click
;~ sleep 2000
;~ 789, 416
;~ sleep 500
;~ 1148, 680
;~ sleep 5000

controlclick, x1400 y800, GemCraft Frostborn Wrath, , left, 1

if(start = 0)
{
	MsgBox, , end
	return
}

sleep 6000

controlclick, x800 y450, GemCraft Frostborn Wrath, , left, 1
sleep 1000

controlclick, x1150 y710, GemCraft Frostborn Wrath, , left, 1
sleep 8000

;~ tooltip, the end
;~ SetTimer, removeToolTip, -2000

goto gemcraft1

return

^!s::
CoordMode, pixel, screen
winmove, GemCraft Frostborn Wrath, , 0, 0, 1600, 880

if(start = 0)
	start = 1
else
	start = 0

tooltip gem %start%
SetTimer, removeToolTip, -2000

SetTimer, gemcraft1, -0

return


^!d::
exittime := -5 * 3600 * 1000
settimer, killgem, %exittime%
return

killgem:
Process, CLose, GemCraft Frostborn Wrath.exe
exitapp
return
