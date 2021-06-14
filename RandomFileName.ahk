randomPath = %A_ScriptDir%\rand

Loop, Files, %randomPath%\*
{
	;~ %A_LoopFileFullPath%
	;~ %A_LoopFileName%
	
	randomPos := RegExMatch(A_LoopFileName, "[0-9][0-9][0-9][0-9][0-9]_")
	
	if(randomPos <= 0)
		randomPos = 1
	else
		randomPos += 6
	
	filename := SubStr(A_LoopFileName, randomPos)
	
	Random, rand, 10000, 99999
	filename := rand . "_" . filename
	
	FileMove, %randomPath%\%A_LoopFileName%, %RandomPath%\%filename%
}