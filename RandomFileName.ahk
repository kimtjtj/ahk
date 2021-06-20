randomPath = %A_ScriptDir%

Loop, Files, %randomPath%\*
{
	;~ %A_LoopFileFullPath%
	;~ %A_LoopFileName%
	
	if(A_LoopFileName == A_ScriptName)
		continue
	
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

Loop, Files, %randomPath%\*
{
	
	randomPos := RegExMatch(A_LoopFileName, "[0-9][0-9][0-9][0-9][0-9]_")
	
	if(randomPos <= 0)
		randomPos = 1
	else
		randomPos += 6
	
	filename := SubStr(A_LoopFileName, randomPos)

	SplitPath, filename, , , filenameExt, filenameWithoutExt

	if(filenameExt != "smi" && filenameExt != "srt")
		continue

	findFileName = %randomPath%\*%filenameWithoutExt%*
	Loop, Files, %findFileName%
	{
		SplitPath, A_LoopFileName, , , findFileExt, findFileWithoutExt
		if(findFileExt = "smi" || findFileExt = "srt")
			continue
		
		
		found = %findFileWithoutExt%.%filenameExt%
	}
	
	if(found = "")
		continue
	
	FileMove, %randomPath%\%A_LoopFileName%, %RandomPath%\%found%
}