setpos(tv){
	static
	Sleep,0
	sc:=csc()
	GuiControl,-Redraw,% sc.sc
	node:=files.ssn("//*[@tv='" tv "']")
	file:=ssn(node,"@file").text
	parent:=ssn(node,"../@file").text
	posinfo:=positions.ssn("//main[@file='" parent "']/file[@file='" file "']")
	doc:=ssn(node,"@sc").text
	ea:=xml.ea(posinfo),fold:=ea.fold
	if ea.start&&ea.end
		sc.2613(ea.scroll),sc.2160(ea.start,ea.end)
	Loop,Parse,fold,`,
		if A_LoopField is number
			sc.2231(A_LoopField)
	GuiControl,+Redraw,% sc.sc
}