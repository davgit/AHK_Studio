options(){
	static list:={show_eol:2356,Show_Caret_Line:2096,show_whitespace:2021,word_wrap:2268,center_caret:[2403,0x15,75]}
	Show_EOL:
	Show_Caret_Line:
	Show_WhiteSpace:
	Word_Wrap:
	Center_Caret:
	sc:=csc()
	onoff:=settings.ssn("//options/@" A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	v.options[A_ThisLabel]:=onoff	
	sc[list[A_ThisLabel]](onoff)
	option:=settings.ssn("//options")
	ea:=settings.ea(option)
	for c,d in s.main
		for a,b in ea
	if !IsObject(List[a]){
		d[list[a]](b)
	}Else if IsObject(List[a])&&b
	d[list[a].1](List[a].2,List[a].3)
	else if IsObject(List[a])&&onoff=0
		d[list[a].1](0)
	return
	onoff:=settings.ssn("//options/@" A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	return
	Small_Icons:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	m("Requires a reboot to take effect.")
	return
}