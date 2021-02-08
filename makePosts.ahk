maxLine = 150
outputDir = D:\kimtjtj\public\_posts\
sourceFile = C:\Users\teajun.kim\Downloads\cgr.txt
maxFile = ;5
readFileEncoding = cp51949  ; euckr = cp51949, cp949, utf-8
writeFileEncoding = utf-8  ; euckr = cp51949, cp949, utf-8
running=
FormatTime, datePost, , yyyy-MM-dd
datePost .= "-"

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

page = 
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
		page .= preFile
	}
	
	lastReadLine = %A_LoopReadLine%
	lastReadLine := StrReplace(lastReadLine, "<", "[")
	lastReadLine := StrReplace(lastReadLine, ">", "]")
	lastReadLine := StrReplace(lastReadLine, "#", "")
	page .= lastReadLine . "`n`n"

	line++
	if(line = maxLine)
	{
		FileAppend, %page%, %outFileName%
		page = 
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
