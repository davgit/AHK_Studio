menu(menuname){
	menu:=menus.sn("//" menuname "/descendant::*")
	list:=[]
	Menu,main,UseErrorLevel,On
	while,mm:=menu.item[A_Index-1]{
		if !ssn(mm,"@clean")
			mm.SetAttribute("clean",clean(ssn(mm,"@name").text))
		if IsLabel(clean(ssn(mm,"@name").text))
			route:=clean(ssn(mm,"@name").text)
		else
			route:="menuroute"
		if hotkey:=ssn(mm,"@hotkey").text{
			ea:=xml.ea(mm),key:=[]
			key[ea.hotkey]:=ea.name
			Hotkeys([1,3],key)
		}
		hotkey:=hotkey?"`t" convert_hotkey(hotkey):""
		if mm.childnodes.length>0
			list.Insert({menu:ssn(mm,"@name").text,under:clean(ssn(mm.ParentNode,"@name").Text)})
		else	if !clean(ssn(mm.ParentNode,"@name").text){
			list.Insert({top:ssn(mm,"@name").text,route:route})
			continue
		}else{
			name:=clean(ssn(mm.ParentNode,"@name").text)
			if (mm.nodename="separator"){
				Menu,%name%,Add
				continue
			}
			Menu,%name%,Add,% ssn(mm,"@name").text hotkey,%route%
			if value:=settings.ssn("//*/@" clean(ssn(mm,"@name").text)).text{
				Menu,% name,Check,% ssn(mm,"@name").text hotkey
				v.options[clean(ssn(mm,"@name").text)]:=value
			}
		}
	}
	for a,b in list{
		if b.top{
			Menu,%menuname%,Add,% b.top,% b.route
			continue
		}
		b.under:=b.under?b.under:menuname
		Menu,% b.under,Add,% b.menu,% ":" clean(b.menu)
	}
	return menuname
	menuroute:
	item:=clean(A_ThisMenuItem)
	%item%()
	return
	show:
	WinActivate,% hwnd([1])
	return
}