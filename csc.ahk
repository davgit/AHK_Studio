csc(set=0){
	static current
	global findme
	if (set.hwnd)
		return current:=s.ctrl[set.hwnd]
	if (set=1){
		ControlGetFocus,focus,A
		if !InStr(focus,"Scintilla")
			return
		ControlGet,hwnd,hwnd,,%focus%,A
		if s.ctrl[hwnd]
			current:=s.ctrl[hwnd]
		current.2400
		return current
		return 
	}
	if InStr(set,"Scintilla"){
		ControlGet,hwnd,hwnd,,%set%,% hwnd([1])
		current:=s.ctrl[hwnd]
		return current
	}
	if !current{
		ControlGet,hwnd,hwnd,,Scintilla1,% hwnd([1])
		current:=s.ctrl[hwnd]
	}
	FINDME:=current
	return current
}