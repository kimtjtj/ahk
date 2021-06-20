randomPath = %A_ScriptDir%

Loop, Files, %randomPath%\*
{
	;~ %A_LoopFileFullPath%
	;~ %A_LoopFileName%
	
	if(A_LoopFileName == A_ScriptName)
		continue
	
	randomPos := RegExMatch(A_LoopFileName, "[0-9][0-9][0-9][0-9][0-9]_")
	
	if(randomPos <= 0)
		continue
	else
		randomPos += 6
	
	filename := SubStr(A_LoopFileName, randomPos)

	FileMove, %randomPath%\%A_LoopFileName%, %RandomPath%\%filename%
}
