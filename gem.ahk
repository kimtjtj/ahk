start = 0

resizingGem:
CoordMode, mouse, window
winmove, GemCraft Frostborn Wrath, , 0, 0, 1500, 880
return

; 1275 745
buildTower:
; 46 per tile
tile = 43

MouseGetPos, mouseX, mouseY

x = %mouseX%
y = %mouseY%

controlsend, , t, GemCraft Frostborn Wrath
controlclick, x%x% y%y%, GemCraft Frostborn Wrath, , left, 1

controlsend, , a, GemCraft Frostborn Wrath

buildAmplifier(x - tile, y - tile)
buildAmplifier(x - tile, y)
buildAmplifier(x - tile, y + tile)
buildAmplifier(x, y + tile)
buildAmplifier(x + tile, y + tile)
buildAmplifier(x + tile, y)
buildAmplifier(x + tile, y - tile)
buildAmplifier(x, y - tile)

controlsend, , {numpad4}, GemCraft Frostborn Wrath
controlsend, , {numpad1}, GemCraft Frostborn Wrath
controlsend, , {numpad6}, GemCraft Frostborn Wrath

; 1415, 410
; 1460, 410
; 1374, 410

controlsend, , g, GemCraft Frostborn Wrath
controlclick, x1415 y410, GemCraft Frostborn Wrath, , left, 1, d
controlclick, x1460 y410, GemCraft Frostborn Wrath, , left, 1, u
controlclick, x1374 y410, GemCraft Frostborn Wrath, , left, 1
controlsend, , u, GemCraft Frostborn Wrath

controlsend, , g, GemCraft Frostborn Wrath
controlclick, x1460 y410, GemCraft Frostborn Wrath, , left, 1, d
controlclick, x1374 y410, GemCraft Frostborn Wrath, , left, 1, u
controlsend, , gdddddddd, GemCraft Frostborn Wrath

buildAmplifier(x, y)
controlsend, , uuuuuuuuu, GemCraft Frostborn Wrath

buildAmplifier(x - tile, y - tile)
buildAmplifier(x - tile, y)
buildAmplifier(x - tile, y + tile)
buildAmplifier(x, y + tile)
buildAmplifier(x + tile, y + tile)
buildAmplifier(x + tile, y)
buildAmplifier(x + tile, y - tile)
buildAmplifier(x, y - tile)


; 27, 54
controlsend, , d, GemCraft Frostborn Wrath
controlclick, x27 y54, GemCraft Frostborn Wrath, , left, 1
controlsend, , uuuuuuuuu{tab}, GemCraft Frostborn Wrath


return

buildAmplifier(x, y)
{
controlclick, x%x% y%y%, GemCraft Frostborn Wrath, , left, 1
	
}


gemcraft1:
if(start = 0)
{
	MsgBox, , end
	return
}

IfWinNotExist, GemCraft Frostborn Wrath
	exitapp
	

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
controlsend, , uuuuuu, GemCraft Frostborn Wrath

controlclick, x1430 y600, GemCraft Frostborn Wrath, , left, 1
controlsend, , uu, GemCraft Frostborn Wrath

controlclick, x1518 y600, GemCraft Frostborn Wrath, , left, 1
controlsend, , uu, GemCraft Frostborn Wrath

controlsend, , g, GemCraft Frostborn Wrath
controlclick, x1434 y410, GemCraft Frostborn Wrath, , left, 1, d

controlclick, x1470 y410, GemCraft Frostborn Wrath, , left, 1, u
controlsend, , ddd, GemCraft Frostborn Wrath

controlclick, x960 y210, GemCraft Frostborn Wrath, , left, 1
controlsend, , uuu, GemCraft Frostborn Wrath

controlclick, x690 y230, GemCraft Frostborn Wrath, , left, 1
controlsend, , uuu, GemCraft Frostborn Wrath

controlclick, x620 y320, GemCraft Frostborn Wrath, , left, 1
controlsend, , uuu, GemCraft Frostborn Wrath
;~ controlclick, x70 y50, GemCraft Frostborn Wrath, , left, 1

; 638, 648
controlclick, x638 y648 , GemCraft Frostborn Wrath, , left, 1
controlsend, , uuu, GemCraft Frostborn Wrath

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
sleep 11000

;~ tooltip, the end
;~ SetTimer, removeToolTip, -2000

goto gemcraft1

return

firststage:
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
