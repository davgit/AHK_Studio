options(){
	static list:={show_eol:2356,Show_Caret_Line:2096,show_whitespace:2021,word_wrap:2268}
	Show_EOL:
	Show_Caret_Line:
	Show_WhiteSpace:
	sc:=csc()
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	v.options[A_ThisLabel]:=onoff	
	sc[list[A_ThisLabel]](onoff)
	option:=settings.ssn("//options")
	ea:=settings.ea(option)
	for c,d in s.main
	for a,b in ea
	d[list[a]](b)
	return
	Small_Icons:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	m("Requires a reboot to take effect.")
	return
	word_wrap:
	onoff:=settings.ssn("//options/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"options",att:att})
	togglemenu(A_ThisLabel)
	csc().2268(onoff)
	return
}