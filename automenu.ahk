automenu(){
	automenu:
	SetTimer,automenu,Off
	if v.word
		if (l:=commands.ssn("//Context/*/*[text()='" RegExReplace(v.word,"#") "']/@list").text)
			sc:=csc(),sc.2100(0,l),v.word:=""
	return
}