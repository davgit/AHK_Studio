paste(){
	paste:
	ControlGetFocus,Focus,% hwnd([1])
	if !InStr(Focus,"Scintilla"){
		ControlSend,%focus%,^v
		return
	}
	csc().2179
	if InStr(Clipboard,"`n")||InStr(Clipboard,"`r")
		SetTimer,fix_paste,On
	return
}