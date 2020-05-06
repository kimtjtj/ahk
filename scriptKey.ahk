
Init:

InputBox, scriptKey, 스크립트 키를 입력하세요

if(ErrorLevel=1)
	ExitApp

binScriptKey := Format("{1:032s}", Bin(scriptKey))
StringRight, binRightScriptKey, binScriptKey, 24
msgbox % Dec(binRightScriptKey)


goto Init

Bin(x){
	while x
		r:=1&x r,x>>=1
	return r
}
Dec(x){
	b:=StrLen(x),r:=0
	loop,parse,x
		r|=A_LoopField<<--b
	return r
}


ExitApp