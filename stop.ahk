stop(){
	return debug("detach")
	if !debug("check")
		return m("Currently no file being debugged"),debug(0)
	debug("send","detach")
	sleep,500
	hwnd({rem:99}),debug("disconnect")
	WinWaitClose,% hwnd
	debug(0)
	csc("Scintilla1")
}