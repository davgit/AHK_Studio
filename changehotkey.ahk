changehotkey(){
	static hk,hotkey
	Gui,2:Default
	hotkey:=menus.ssn("//*[@tv='" TV_GetSelection() "']")
	setup(98,1)
	Gui,Add,Hotkey,gehk vhk Limit1,% ssn(Hotkey,"@hotkey").text
	Gui,Show,,Hotkey
	return
	ehk:
	Gui,98:Submit,NoHide
	Hotkey.setattribute("hotkey",hk),Hotkey.setattribute("last",1)	
	return
}