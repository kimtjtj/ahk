macroOn := {7:false, 8:false, 9:false, 0:false}
interval := {7:0, 8:0, 9:0, 0:0}
lastSendTime := {7:0, 8:0, 9:0, 0:0}

7::
idx=7
goto macroOnOff
return

8::
idx=8
goto macroOnOff
return

9::
idx=9
goto macroOnOff
return

0::
idx=0
goto macroOnOff
return

macroOnOff:
SetTimer, timerSendKey, Off

if(macroOn[idx] = true)
{
	macroOn[idx] := false
	goto macroOnExit
}

Hotkey, 7, off
Hotkey, 8, off
Hotkey, 9, off
Hotkey, 0, off
InputBox, inputInterval, 전송 주기
Hotkey, 7, on
Hotkey, 8, on
Hotkey, 9, on
Hotkey, 0, on

if(inputInterval = "")
	goto macroOnExit

macroOn[idx] := true
interval[idx] := inputInterval

macroOnExit:
if( macroOn[7] || macroOn[8] || macroOn[9] || macroOn[0] )
{
	SetTimer, timerSendKey, 1000
	ToolTip
}

lastSendTime[idx] := A_Now

return


timerSendKey:
;~ msgbox % macroOn[7] " " A_Now " " lastTime[7] " " interval[7]
if( !(macroOn[7] || macroOn[8] || macroOn[9] || macroOn[0]) )
{
	settimer, timerSendKey, Off
	return
}

idx=7
key=1
gosub, sendkey

idx=8
key=2
gosub, sendkey

idx=9
key=3
gosub, sendkey

idx=0
key=4
gosub, sendkey

return

sendkey:
if(macroOn[idx] = true && A_Now >= lastSendTime[idx] + interval[idx])
{
	send %key%
	lastSendTime[idx] := A_Now
}
return

^!f9::
exitapp

-::
msgbox % lastSendTime[8] " " interval[8]
return

