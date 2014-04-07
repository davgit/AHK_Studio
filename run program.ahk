run_program(){
	if !debug("check")
		return m("Currently no file being debugged"),debug(0)
	debug("send","run")
}