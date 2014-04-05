#SingleInstance,Force
loop,*.ahk
{
	FileRead,akmf,%A_LoopFileFullPath%
	pos:=1

	while,pos:=regexmatch(akmf,"m)^\s*((\w|[^\x00-\x7F])+)\((.+)?\)(\s+;.+\s+)?(\s+)?{",found,pos){
	;while,pos:=regexmatch(akmf,"m)^\s*((\w|[^\x00-\x7F])+)\((.+)?\)(\s+;.+\s+)?(\s+)?{(\s+;)?",found,pos){
		;while,pos:=regexmatch(akmf,"m)^\s*((\w|[^\x00-\x7F])+)\(.*\)(\s+`;.*)*\s*{",found,pos){
		word:=""
		loop,parse,found
		{
			if (a_loopfield!="(")
				word:=
			if (a_loopfield="(")
				break
		}
		list.=trim(found1) " "
		pos+=strlen(found)+strlen(found1)
	}
}
loop,*.ahk
{
	FileRead,akmf,%A_LoopFileFullPath%
	pos:=1
	;while,pos:=regexmatch(akmf,"m)^\s*((\w|[^\x00-\x7F])+)\((.+)?\)[^\s+`;](\s+;.+\s+)?(\s+)?{[^\s+`;]",found,pos){
	while,pos:=regexmatch(akmf,"m)^\s*((\w|[^\x00-\x7F])+)\(.*\)(\s+`;.*)*\s*{",found,pos){
		word:=""
		loop,parse,found
		{
			if (a_loopfield!="(")
				word:=
			if (a_loopfield="(")
				break
		}
		lll.=trim(found1) " "
		pos+=strlen(found)+strlen(found1)
	}
}
for a,b in StrSplit(list," ")
	lll:=RegExReplace(lll,"\b" b "\b")
m("Are they the same?" list=lll,"What mine found",list,"","What yours found that mine did not",lll)
return
m(x*){
	for a,b in x
		ll.=b "`n"
	MsgBox,%ll%
}