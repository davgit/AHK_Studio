togglemenu(Label){
	item:=menus.ssn("//*[@clean='" Label "']")
	menu:=ssn(item.ParentNode,"@clean").text
	item:=ssn(item,"@name").text
	Menu,%Menu%,ToggleCheck,%item%
	
}