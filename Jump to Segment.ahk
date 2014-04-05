Jump_to_Segment(){
	static list:=[]
	setup(4),hotkeys([4],{up:"jtsup",down:"jtsdown"})
	Gui,Add,edit,w200 gsortjts,Enter text here
	Gui,Add,ListView,w200 h400 -Multi,Files
	Gui,Add,Button,gjump Default,Jump to Segment
	Gui,Show,,Jump To Segment
	sc:=csc(),list:=[]
	file:=files.sn("//*[@sc='" sc.2357 "']../file/@filename")
	while,ff:=file.item[A_Index-1].text
		LV_Add("",ff),list[ff]:=1
	LV_Modify(1,"Select Vis Focus")
	return
	4GuiEscape:
	hwnd({rem:4})
	return
	sortjts:
	GuiControl,4:-Redraw,SysListView321
	LV_Delete()
	ControlGetText,find,Edit1,% hwnd([4])
	for a in list
		if InStr(a,find)
			LV_Add("",a)
	GuiControl,4:+Redraw,SysListView321
	LV_Modify(1,"Select Vis Focus")
	return
	jtsup:
	jtsdown:
	return lv_select(4,A_ThisLabel="jtsup"?-1:1)
	jump:
	Gui,4:Default
	LV_GetText(file,LV_GetNext()),sc:=csc()
	file:=files.ssn("//*[@sc='" sc.2357 "']../file[@filename='" file "']")
	tv(ssn(file,"@tv").text)
	hwnd({rem:4})
	csc().2400
	return
}