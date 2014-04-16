run_program(){
	;if !debug("check")
	if !debug.socket
		return m("Currently no file being debugged"),debug.off()
	debug.send("run")
	;debug("send","run")
}