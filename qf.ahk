qf(){
	static quickfind:=[],find
	qf:
	ControlGetText,find,Edit1,% hwnd([1])
	pre:="O",find1:=""
	find1:=v.options.regex?find:"\Q" find "\E"
	pre.=v.options.greed?"":"U"
	pre.=v.options.case_sensitive?"":"i"
	find1:=pre ")(" find1 ")"
	sc:=csc()
	if (find=""||find="."||find=".*"||find="\"){
		sc.2571
		return
	}
	text:=sc.getuni()
	if sc.2508(0,start:=quickfind[sc.2357]+1)!=""{
		end:=sc.2509(0,start)
		if end
			text:=SubStr(text,1,end)
	}
	pos:=start?start:1
	pos:=pos=0?1:pos
	sc.2571
	while,pos:=RegExMatch(text,find1,found,pos){
		if (A_Index=1&&found.len())
			sc.2160(pos-1+found.len(),pos-1)
		else
			sc.2573(pos-1+found.len(),pos-1)
		pos+=found.len()
	}
	sc.2574(0)
	sc.2169
	return
	next:
	sc:=csc()
	sc.2606
	sc.2169
	return
	Quick_Find_Settingsguiescape:
	sc:=csc()
	sc.2400
	return
	clear_selection:
	sc:=csc(),sc.2505(0,sc.2006)
	quickfind.remove(sc.2357),qf()
	return
	set_selection:
	sc:=csc()
	if (sc.2008=sc.2009)
		goto clear_selection
	sc.2505(0,sc.2006)
	minmax:=[]
	minmax[sc.2008]:=1,minmax[sc.2009]:=1
	for a,b in s.main
		b.2080(0,8),b.2082(0,0xff00ff)
	quickfind[sc.2357]:=MinMax.MinIndex()
	sc.2504(MinMax.MinIndex(),MinMax.MaxIndex()-MinMax.MinIndex()),sc.2571,qf()
	return
	quick_find:
	gosub,set_selection
	ControlFocus,Edit1,% hwnd([1])
	Send,^A
	qf()
	return
	Case_Sensitive:
	Regex:
	Greed:
	onoff:=settings.ssn("//Quick_Find_Settings/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"Quick_Find_Settings",att:att})
	togglemenu(A_ThisLabel)
	v.options[A_ThisLabel]:=onoff
	goto qf
	return
	checkqf:
	ControlGetFocus,Focus,% hwnd([1])
	if (Focus="Edit1")
		goto qf
	return
}
togglemenu(Label){
	item:=menus.ssn("//*[@clean='" Label "']")
	menu:=ssn(item.ParentNode,"@clean").text
	item:=ssn(item,"@name").text
	Menu,%Menu%,ToggleCheck,%item%
	
}