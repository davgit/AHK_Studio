hwnd(win,hwnd=""){
	static window:=[]
	if win=get
	return window
	if (win.rem){
		Gui,1:-Disabled
		Gui,% win.rem ":Destroy"
		Gui,1:Default
		window.remove[win.rem]
	}
	if IsObject(win)
		return "ahk_id" window[win.1]
	if !hwnd
		return window[win]
	window[win]:=hwnd
}