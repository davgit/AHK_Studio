﻿exit(x=""){
	GuiClose:
	rem:=settings.ssn("//last"),rem.ParentNode.RemoveChild(rem)
	for a,b in s.main{
		file:=files.ssn("//*[@sc='" b.2357 "']/@file").text
		if file
			settings.add({path:"last/file",text:file,dup:1})
	}
	toolbar.save(),rebar.save(),save()
	savegui(),menus.save(1)
	settings.save(1)
	if (x=""||InStr(A_ThisLabel,"Gui"))
		ExitApp
	return
	GuiEscape:
	ControlGetFocus,Focus,% hwnd([1])
	csc().2400
	return
}
savegui(){
	WinGet,max,MinMax,% hwnd([1])
	text:=max
	text:=max?settings.ssn("//gui/position[@window='1']").text:resize("get")
	top:=settings.ssn("//gui/position[@window='1']")
	if !top.text
		top:=settings.add({path:"gui/position",att:{window:1}})
	top.text:=text
	top.SetAttribute("max",max)
}