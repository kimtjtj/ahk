revisions := [921624, 921605]  ; 내림차순으로 입력해야함
fromBranch = beta

elems := []
aarray := {}
RunCommand("cmd /c p4 changes -l -u taejun.kim > d:\a.txt", "")
;~ RunCommand("cmd /c p4 changes -l -m 4000 > d:\a.txt", "")
FileRead, total, *p51949 d:\a.txt
allChanges = %total%

i = 1
findRevision := % revisions[i]
while(1)
{
	foundPosChange := InStr(total, "`r`nChange ") 
	if(foundPosChange = 0)
		break

	StringLeft, elem, total, foundPosChange
	revision := SubStr(elem, 8, 6)
	if(revision != findRevision)
		goto notFound

	i++
	findRevision = % revisions[i]
	foundPosNewline := InStr(elem, "`r`n`r`n")
	StringRight, elem, elem, % StrLen(elem) - foundPosNewline - 4

	StringReplace, elemRemoveTab, elem, %A_Tab%, , A
	elems.Push(elemRemoveTab)
	;~ MsgBox %revision%-%elem%
	
	notFound:
	total := SubStr(total, foundPosChange + 2)
}


index = 1
str = Merged revision(s)
while(index < i)
{
	str .= " " . revisions[index]
	if(index < i - 1)
		str .= ","
	index++
}
str .= " from " . fromBranch . "`r`n"

index = 1
while(index <= i)
{
	str .= elems[index] . "`r`n"
	index++
}

if(revisions.Length() != i - 1)
{
	MsgBox cannot found %i%`n%str%
	gui, add, edit, , %total%
	clipboard = %allChanges%
	ExitApp
}


Gui, Add, Edit, w400 r10 vResizeCL, %str%
Gui, Add, Button, gSubmit Default, OK
Gui, Show, , name


RunCommand(exec, filename)
{
	str := ComObjCreate("WScript.Shell").Exec(exec).StdOut.ReadAll()
	FileEncoding, UTF-8-RAW
	FileAppend, % "command : " . exec . "`n`nResult : " . str . "`n`n", %filename%
	return str
}

Esc::
exitapp

Submit:
exitapp
