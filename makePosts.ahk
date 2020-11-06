maxLine = 150
outputDir = D:\kimtjtj\myblog\_posts\
sourceFile = ca.txt
maxFile = ;5
readFileEncoding = cp51949  ; euckr = cp51949, cp949, utf-8
writeFileEncoding = utf-8  ; euckr = cp51949, cp949, utf-8
running=
datePost = 2020-10-26-

SetTimer, Running, 2000

Running:
tooltip, makePosts %running%
return

^f1::
Run, %A_WorkingDir%
return

f1::
outFile = 1
line = 0

Loop, Read, %sourceFile%
{
	totalLine = %A_Index%
}

fileCount := floor(totalLine / maxLine) + 1

FileEncoding, %readFileEncoding%
Loop, Read, %sourceFile%
{
	running = PROCESSING %outFile% / %fileCount%

	FileEncoding, %writeFileEncoding%
	if(outFile = maxFile)
		break
	
	outFileName := outputDir . datePost . Format("{1:03i}_{2:03i}", outFile, fileCount) . ".markdown"
	if(line = 0)
	{
		SetFormat, FloatFast, 0.2
		percentage := outFile / fileCount * 100
		
		preFile = ---`nlayout: post`n`ntitle:  `"%outFile% / %fileCount%. (%percentage%`%)`"`ncategories: jekyll update`n---`n
		FileDelete, %outFileName%
		FileAppend, %preFile%, %outFileName%
		if(lastReadLine!="")
			FileAppend, %lastReadLine%`n`n, %outFileName%
	}
	
	lastReadLine = %A_LoopReadLine%
	lastReadLine := StrReplace(lastReadLine, "<", "[")
	lastReadLine := StrReplace(lastReadLine, ">", "]")
	lastReadLine := StrReplace(lastReadLine, "#", "")
	FileAppend, %lastReadLine%`n`n, %outFileName%

	line++
	if(line = maxLine)
	{
		outFile++
		line = 0
	}
	FileEncoding, %readFileEncoding%
}

running =
msgbox Complete
return

f9::
ExitApp
