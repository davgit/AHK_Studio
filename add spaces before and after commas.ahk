﻿add_space_before_and_after_commas(){
	sc:=csc()
	if !sc.getseltext()
		return m("Please select some text")
	replace:=RegExReplace(sc.getseltext(),","," , ")
	sc.2170(0,replace)
}