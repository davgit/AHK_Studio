checkerror(){
	IfWinExist,% "ahk_pid" v.pid
		WinGetText,text,% "ahk_pid" v.pid
	if InStr(text,"error at line"){
		for a,b in StrSplit(text,"`n")
		if InStr(b,"error at line"){
			RegExMatch(b,"(\d+)",find)
			v.line:=find1-1
			debug("disconnect")
			file:=StrSplit(b,Chr(34)).2
			if (file){
				tv(files.ssn("//main[@file='" ssn(current(1),"@file").text "']/file[@file='" file "']/@tv").text)
				csc().2400
			}
			SetTimer,selecterror,40
		}
	}
	return
}