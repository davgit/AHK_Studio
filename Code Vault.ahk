Code_Vault(){
	static ev,mainfile
		v.lastsc:=csc(),mainfile:=ssn(current(1),"@file").text,setup(19)
	Gui,Add,ListView,w100 h400 AltSubmit gdisplayvault,Code
	v.codevault:=new s(19,{pos:"x+10 w600 h400"}),csc({hwnd:v.codevault.sc}),hotkeys([19],{esc:"19GuiClose"})
	sc:=csc(),sc.2400,sc.2171(1),bracesetup(19)
	Gui,Add,Button,xm gaddcode,Add Code
	Gui,Add,Button,x+10 ginsertcode Default,Insert Into Segment
	pupulatevault:
	locker:=vault.sn("//code"),LV_Delete()
	while,ll:=locker.item[A_Index-1]
		LV_Add("",ssn(ll,"@name").text)
	LV_Modify(1,"Vis Focus Select")
	Gui,Show,,Code Vault
	WinWaitActive,% hwnd([19])
	ControlFocus,SysTreeView321,% hwnd([19])
	Return
	insertcode:
	text:=csc().gettext()
	sc:=v.lastsc
	sc.2003(sc.2008,text)
	fix_indent(sc)
	return
	19GuiClose:
	19GuiEscape:
	hwnd({rem:19}),vault.save(1)
	Return
	addcode:
	InputBox,newcode,Name for code snippet,Please enter a name for a new code snippet.
	if ErrorLevel
		return
	if !locker:=vault.ssn("//code[@name='" newcode "']")
		locker:=vault.Add({path:"code",att:{name:newcode},dup:1})
	Gosub,pupulatevault
	return
	displayvault:
	sc:=csc()
	if LV_GetNext()
		sc.2171(0)
	LV_GetText(code,LV_GetNext())
	sc.2181(0,vault.ssn("//code[@name='" code "']").text),sc.2400
	return
}