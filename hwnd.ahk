hwnd(win,hwnd=""){
	static window:=[],remove
	if win=get
		return window
	if (win.rem){
		Gui,1:-Disabled
		Gui,1:Default
		if (WinExist("ahk_id" window[win.rem])&&window[win.rem]),remove:=win.rem
			SetTimer,Destroy,10
		window.remove(win.rem)
	}
	if IsObject(win)
		return "ahk_id" window[win.1]
	if !hwnd
		return window[win]
	window[win]:=hwnd
	return
	destroy:
	SetTimer,Destroy,Off
	Gui,%remove%:Destroy
	return
}
close_window(a*){
	if (a.1=0)
		hwnd({rem:A_Gui})
	return 0
}