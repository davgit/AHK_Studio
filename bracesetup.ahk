bracesetup(win=1){
	v.brace:=[]
	on:=settings.ssn("//options/@Auto_Complete_Brace").text?"On":"Off"
	autoadd:=settings.sn("//autoadd/*")
	Hotkey,IfWinActive,% hwnd([win])
	while,aa:=autoadd.item(a_index-1){
		ea:=xml.ea(aa)
		if (ea.trigger){
			Hotkey,% Chr(ea.trigger),brace,%On%
			v.brace[Chr(ea.trigger)]:=Chr(ea.add)
		}
	}
}