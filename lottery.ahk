timestamp = 20211007195000
timestamp -= 19700101000000, Seconds

Random, rand, 1000000, 5999999
MsgBox, %rand%

Random, , timestamp
Loop, %rand%
	Random, rand, 1000000, 5999999
MsgBox, %rand%

lotto:
lotto := Array()
str=
Loop, 6
{
	Random, rand, 1, 45
	str = %str% %rand%
	lotto.Push(rand)
}

MsgBox, %str%

ToolTip, `n`n`ncontinue? y/n`n`n`n.
Input, var, L1
tooltip
if(var = "y")
	goto, lotto
exitapp
