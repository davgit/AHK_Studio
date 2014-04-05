/*
	custom_highlight_text(){
		static
		highlight:=setup(15)
		Gui,Add,Text,,Text should be space Delimited (this is a list)
		Gui,Add,ListView,w200 h500 AltSubmit gcht,List
		Gui,Add,Edit,x+10 w500 h500 gchtedit
		Loop,9
			LV_Add("","Custom List " A_Index)
		Gui,Show,,Custom Highlight Editor
		LV_Modify(1,"Select Vis Focus")
		return
		cht:
		if A_GuiEvent not in Normal,I
			return
		if list:=LV_GetNext()
			ControlSetText,Edit1,% settings.ssn("//custom/highlight/list" list).text,% hwnd([15])
		return
		chtedit:
		if !list:=LV_GetNext()
			return
		ControlGetText,newtext,Edit1,% hwnd([15])
		StringLower,newtext,newtext
		hlt:=settings.add({path:"custom/highlight/list" list,text:newtext,att:{list:list}})
		if !newtext
			return hlt.ParentNode.RemoveChild(hlt)
		return
		15GuiEscape:
		15GuiClose:
		hwnd({rem:15}),keywords(),list:=[],refreshthemes()
		parent:=settings.ssn("//custom/highlight")
		fix:=settings.sn("//custom/highlight/*")
		while,ff:=fix.item(A_Index-1)
			list[ssn(ff,"@list").text]:=ff
		for a,b in list
			parent.AppendChild(b)
		if v.theme
		if WinExist(hwnd([15])){
			v.themesc.2181(0,themetext())
			color(v.themesc)
		}
		for a,b in v.control
			color(s.ctrl[b])
		return
	}
*/