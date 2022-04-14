inifile = %A_ScriptDir%\pok.go.friend.ini
gosub, label_init
gosub, label_iniread
gosub, label_iniwrite

f9::
gosub, label_gift
return

f4::
if(idxGetPos = 0) ; 1stFriendPos
{
	MouseGetPos, 1stFriendPosX, 1stFriendPosY
	ToolTip, 1stFriendPos is (%1stFriendPosX%`, %1stFriendPosY%)
}
else if(idxGetPos = 1) ; 2ndFriendPos
{
	MouseGetPos, 2ndFriendPosX, 2ndFriendPosY
	ToolTip, 2ndFriendPos is (%2ndFriendPosX%`, %2ndFriendPosY%)
}
else if(idxGetPos = 2) ; openButtonPos
{
	MouseGetPos, openButtonPosX, openButtonPosY
	ToolTip, openButtonPos is (%openButtonPosX%`, %openButtonPosY%)
}
else if(idxGetPos = 3) ; closeButtonPos
{
	MouseGetPos, closeButtonPosX, closeButtonPosY
	ToolTip, closeButtonPos is (%closeButtonPosX%`, %closeButtonPosY%)
}
else if(idxGetPos = 4) ; sendButtonPos
{
	MouseGetPos, sendButtonPosX, sendButtonPosY
	ToolTip, sendButtonPos is (%sendButtonPosX%`, %sendButtonPosY%)
}
else if(idxGetPos = 5) ; 1stGiftPos
{
	MouseGetPos, 1stGiftPosX, 1stGiftPosY
	ToolTip, 1stGiftPos is (%1stGiftPosX%`, %1stGiftPosY%)
}

if(idxGetPos >= 5)
	idxGetPos = 0
else
	idxGetPos++

gosub, label_iniwrite
SetTimer, label_removetooltip, Off
SetTimer, label_removetooltip, -3000
return

f12::
ExitApp

label_iniread:
IniRead, title, %inifile%, config, title, 000-000-000

IniRead, 1stFriendPosX, %inifile%, config, 1stFriendPosX, 0
IniRead, 1stFriendPosY, %inifile%, config, 1stFriendPosY, 0

IniRead, 2ndFriendPosX, %inifile%, config, 2ndFriendPosX, 0
IniRead, 2ndFriendPosY, %inifile%, config, 2ndFriendPosY, 0

IniRead, openButtonPosX, %inifile%, config, openButtonPosX, 0
IniRead, openButtonPosY, %inifile%, config, openButtonPosY, 0

IniRead, closeButtonPosX, %inifile%, config, closeButtonPosX, 0
IniRead, closeButtonPosY, %inifile%, config, closeButtonPosY, 0

IniRead, sendButtonPosX, %inifile%, config, sendButtonPosX, 0
IniRead, sendButtonPosY, %inifile%, config, sendButtonPosY, 0

IniRead, 1stGiftPosX, %inifile%, config, 1stGiftPosX, 0
IniRead, 1stGiftPosY, %inifile%, config, 1stGiftPosY, 0

IniRead, clickInterval, %inifile%, config, clickInterval, 0

IniRead, clickIntervalOpen, %inifile%, config, clickIntervalOpen, 0
IniRead, clickIntervalSend, %inifile%, config, clickIntervalSend, 0

IniRead, clickCountClose, %inifile%, config, clickCountClose, 0

return

label_iniwrite:
IniWrite, %title%, %inifile%, config, title

IniWrite, %1stFriendPosX%, %inifile%, config, 1stFriendPosX
IniWrite, %1stFriendPosY%, %inifile%, config, 1stFriendPosY

IniWrite, %2ndFriendPosX%, %inifile%, config, 2ndFriendPosX
IniWrite, %2ndFriendPosY%, %inifile%, config, 2ndFriendPosY

IniWrite, %openButtonPosX%, %inifile%, config, openButtonPosX
IniWrite, %openButtonPosY%, %inifile%, config, openButtonPosY

IniWrite, %closeButtonPosX%, %inifile%, config, closeButtonPosX
IniWrite, %closeButtonPosY%, %inifile%, config, closeButtonPosY

IniWrite, %sendButtonPosX%, %inifile%, config, sendButtonPosX
IniWrite, %sendButtonPosY%, %inifile%, config, sendButtonPosY

IniWrite, %1stGiftPosX%, %inifile%, config, 1stGiftPosX
IniWrite, %1stGiftPosY%, %inifile%, config, 1stGiftPosY

IniWrite, %clickInterval%, %inifile%, config, clickInterval
IniWrite, %clickIntervalOpen%, %inifile%, config, clickIntervalOpen
IniWrite, %clickIntervalSend%, %inifile%, config, clickIntervalSend

IniWrite, %clickCountClose%, %inifile%, config, clickCountClose

return


label_gift:
gosub, label_iniread

x = x%1stFriendPosX%
y = y%1stFriendPosY%
controlClickOnceAndSleep(title, x, y, clickInterval)

x = x%openButtonPosX%
y = y%openButtonPosY%
controlClickOnceAndSleep(title, x, y, clickIntervalOpen)

x = x%closeButtonPosX%
y = y%closeButtonPosY%
Loop, %clickIntervalClose%
	controlClickOnceAndSleep(title, x, y, 100)

x = x%sendButtonPosX%
y = y%sendButtonPosY%
controlClickOnceAndSleep(title, x, y, clickInterval)

x = x%1stGiftPosX%
y = y%1stGiftPosY%
controlClickOnceAndSleep(title, x, y, clickIntervalSend)

x = x%closeButtonPosX%
y = y%closeButtonPosY%
Loop, %clickIntervalClose%
	controlClickOnceAndSleep(title, x, y, 100)

return

controlClickOnceAndSleep(title, x, y, sleepSec)
{
	MsgBox %x% %y%
	ControlClick, %x% %y%, %title%, , LEFT, 1
	sleepSec *= 1000
	Sleep, %sleepSec%
	return
}

label_removetooltip:
ToolTip
return

label_init:
idxGetPos = 0
CoordMode, mouse, client
return