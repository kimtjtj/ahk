timestamp = 20160815000000
timestamp -= 19700101000000, Seconds

lotto:

Random, rand, 1000000, 5999999
MsgBox, %rand%

Random, , timestamp
Loop, %rand%
	Random, rand, 1000000, 5999999
MsgBox, %rand%

lotto := Array()
str=
Loop, 6
{
	while 1<2
	{
		bAlready := false
		Random, rand, 1, 45
		for key, val in lotto
		{
			if(val = rand)
				bAlready := true
		}
		
		if(bAlready = false)
		{
			lotto.Push(rand)
			str = %str%`n%rand%
			break
		}
	}
}

Sort, str, N
MsgBox, %str%

ToolTip, `n`n`ncontinue? y/n`n`n`n.
Input, var, L1
tooltip
if(var = "y")
	goto, lotto
exitapp
