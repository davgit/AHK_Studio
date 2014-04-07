omni_search(start=""){
	static menulist:=[],searchin
	Setup(20),hotkeys([20],{up:"omniup",down:"omnidown"})
	Gui,Margin,0,0
	list:=menus.sn("//@clean")
	menulist:=[],menulist.menu:=[],menulist.file:=[]
	while,mm:=list.item[A_Index-1]{
		if IsFunc(mm.text)
			menulist.menu[RegExReplace(mm.text,"_"," ")]:="func"
		if IsLabel(mm.text)
			menulist.menu[RegExReplace(mm.text,"_"," ")]:="label"
	}
	fz:=files.sn("//@file")
	while,fn:=fz.item[A_Index-1]
		menulist.file[fn.text]:="file"
	Gui,-Caption
	Gui,Add,Edit,w500 gsortmenu,%start%
	Gui,Add,ListView,w500 h200 -hdr -Multi,Menu Command|Rating
	Gui,Add,Button,Default gmsgo w500,Execute Command
	Gui,Show,,Menu Command
	ControlSend,Edit1,^{End},% hwnd([20])
	goto sortmenu
	return
	msgo:
	LV_GetText(menu,LV_GetNext())
	if (type:=menulist.menu[menu]){
		menu:=clean(menu)
		if (type="label"){
			SetTimer,%menu%,10
			Sleep,11
			SetTimer,%menu%,Off
		}else
		%menu%()
	}else if (file:=menulist.file[menu])
	tv(files.ssn("//*[@file='" menu "']/@tv").text)
	hwnd({rem:20})
	return
	sortmenu:
	Gui,20:Default
	GuiControl,20:-Redraw,SysListView321
	LV_Delete()
	ControlGetText,find,Edit1,% hwnd([20])
	search:=[],searchin:=""
	if (SubStr(find,1,1)="@")
		find:=SubStr(find,2),searchin:="menu"
	if (SubStr(find,1,1)="^")
		find:=SubStr(find,2),searchin:="file"
	Loop,Parse,find
	{
		if !search[A_LoopField]
			search[A_LoopField]:=0
		search[A_LoopField]++
	}
	fff:=RegExReplace(find,"(.)","$1|"),rated:=[]
	ffff:=searchin="menu"?[menulist.menu]:searchin="file"?[menulist.file]:[menulist.menu,menulist.file]
	for q,b in ffff{
		for a in b{
			rating:=0
			for c,d in search{
				RegExReplace(a,"i)" c,"",count)
				if (d>count)
					continue 2
				if count
					rating+=1
			}
			if InStr(a,find)
				rating+=10
			if RegExMatch(a,"i)^" find)
				rating+=200
			rated.Insert({rating:rating,value:a})
		}
	}
	for a,b in rated
		LV_Add("",b.value,b.rating)
	LV_ModifyCol(1,470),LV_ModifyCol(2,0),LV_ModifyCol(2,"SortDesc Logical"),LV_Modify(1,"Select Vis Focus")
	GuiControl,20:+Redraw,SysListView321
	Return
	20GuiEscape:
	20GuiClose:
	hwnd({rem:20})
	return
	omniup:
	omnidown:
	return lv_select(20,A_ThisLabel="omniup"?-1:1)
	return
}