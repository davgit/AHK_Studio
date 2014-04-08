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
	for filename in v.filelist{
		SplitPath,filename,file,outdir
		menulist.file[file]:={filename:filename,additional:outdir}
	}
	Gui,-Caption
	Gui,Add,Edit,w500 gsortmenu,%start%
	Gui,Add,ListView,w500 h200 -hdr -Multi,Menu Command|Additional|Rating
	Gui,Add,Button,Default gmsgo w500 Hide,Execute Command
	Gui,Show,% Center(20),Omni-Search
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
	tv(files.ssn("//*[@file='" file.filename "']/@tv").text)
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
		for a,r in b{
			rating:=0
			for c,d in search{
				RegExReplace(a,"i)" c,"",count)
				if (d>count)
					continue 2
				if count
					rating+=count
			}
			if InStr(a,find)
				rating+=10
			if RegExMatch(a,"i)^" find)
				rating+=200
			if (find=""&&files.ssn("//main[@file='" r.additional "\" a "']"))
				rating+=100
			rated.Insert({rating:rating,value:a,additional:r.additional})
		}
	}
	for a,b in rated
		LV_Add("",b.value,b.additional,b.rating)
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	LV_ModifyCol(3,0),LV_ModifyCol(3,"SortDesc Logical"),LV_Modify(1,"Select Vis Focus")
	GuiControl,20:+Redraw,SysListView321
	Return
	20GuiEscape:
	Gui,20:Destroy
	hwnd({rem:20})
	return
	omniup:
	omnidown:
	return lv_select(20,A_ThisLabel="omniup"?-1:1)
	return
}