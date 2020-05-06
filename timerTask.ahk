^!t::
inputbox, hour, Hour(0~24)
inputbox, min, Min(0~59), , , , , , , , , 0

inputbox, where, meeting WHERE?, , , , , , , , , ACT1 or ACT2

remainHour := hour - A_Hour
remainMin := min - A_Min

totalSec := (remainHour * 3600 + remainMin * 60) * 1000 - 60000
;~ msgbox hour : %remainHour%, min : %remainMin%, total : %totalSec%

if(totalSec < 0)
{
	msgbox, cannot set past time
	return
}

SetTimer, notificationNow, -%totalSec%, 10
totalSec := totalSec - 240000
if(totalSec > 0)
	SetTimer, notification, -%totalSec%, 11

return


notification:
msgbox MEETING`nMEETING`nMEETING`n%hour% : %min%`nwhere : %where%
return

notificationNow:
ToolTip, `n`n`nMEETING NOW`n`n`nGOGOGO
msgbox, , , `n`n`nMEETING NOW`n`n`nGOGOGO`nwhere : %where%
Tooltip
return




inputbox, waitSec, time, time(sec)

inputFlag = true
inputNum = 0
while(inputFlag = "true")
{
	InputBox, input, task, task%inputNum%
	if(input = "")
	{
		inputFlag = false
		continue
	}
	
	input%inputNum% = %input%
	inputNum++
}

waitSec := "-0" waitSec * 1000

;~ msgbox %waitSec%
SetTimer, timerTask, %waitSec%
return

^!f9::
exitapp


timerTask:
Loop %inputNum%
{
	i := A_Index - 1
	task = % input%i%
	;~ msgbox % A_Index " " task
	
	run %task%
}
ExitApp
