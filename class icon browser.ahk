﻿class icon_browser{
	static start:="",window:=[],keep:=[]
	__New(info){
		win=85
		Gui,%win%:Destroy
		Gui,%win%:Default
		Gui,Add,ListView,w700 h500 hwndlv gselect AltSubmit,Icons
		Gui,Add,Button,gibprev,Previous 50 Icons
		Gui,Add,Button,x+10 gibnext,Next 50 Icons
		Gui,Add,Button,xm gloadfile,Load File
		Gui,Add,Button,x+10 gloaddefault,Load Default Icons
		Gui,Show,,Icon Browser
		this.file:=info.1.file?info.1.file:"shell32.dll"
		this.file:=InStr(this.file,".ahk")?A_AhkPath:this.file
		GuiControl,+Icon,%lv%
		this.create()
		LV_SetImageList(this.il)
		loop,50
			LV_Add("Icon" IL_Add(this.il,this.file,A_Index),A_Index)
		this.start:=50
		window[win]:=1
		this.win:=win
		this.keep[1]:=this
		this.id:=info.2,this.ahkid:=info.3,this.tb:=info.4
		return
		85GuiEscape:
		Gui,85:Destroy
		return
		loaddefault:
		this:=icon_browser.keep[1]
		this.file:="shell32.dll"
		this.start:=0
		this.next()
		return
	}
	select(num:=""){
		Select:
		if A_GuiEvent!=Normal
			return
		this:=icon_browser.keep[1]
		LV_GetText(number,LV_GetNext())
		number:=num="image"?0:number
		NumPut(VarSetCapacity(button,32),button,0)
		NumPut(0x1|0x20,button,4)
		NumPut(this.id,button,8)
		num:=this.tb.iconlist[this.file,number]!=""?this.tb.iconlist[this.file,number]:IL_Add(this.tb.imagelist,this.file,number)-1
		this.tb.iconlist[this.file,number]:=num
		NumPut(num,button,12)
		SendMessage,0x400+64,% this.id,&button,,% this.ahkid
		this.tb.id
		btn:=settings.ssn("//toolbar/bar[@id='" this.tb.id "']/button[@id='" this.id "']")
		btn.setattribute("icon",number-1),btn.setattribute("file",this.file)
		return
	}
	load(){
		loadfile:
		this:=icon_browser.keep[1]
		FileSelectFile,filename,,,,*.exe;*.dll;*.png;*.jpg;*.gif;*.bmp
		if ErrorLevel
			return
		this.file:=filename
		if filename contains .gif,.jpg,.png,.bmp
			return this.select("image")
		this.start:=0
		this.next()
		return
	}
	exit(){
		for win in icon_browser.window
			Gui,%win%:Destroy
	}
	create(){
		this.il:=IL_Create(50,10,1)
	}
	next(){
		ibnext:
		ibprev:
		this:=icon_browser.keep[1]
		if (A_ThisLabel="ibprev"&&this.start>=50)
			this.start:=this.start-100>=0?this.start-100:this.start-50
		start:=this.start
		LV_Delete()
		GuiControl,85:-Redraw,SysListView321
		this.create()
		LV_SetImageList(this.il)
		loop,50
			LV_Add("Icon" IL_Add(this.il,this.file,A_Index+this.start),A_Index+this.start)
		this.start+=50
		GuiControl,85:+Redraw,SysListView321
		return
	}
}