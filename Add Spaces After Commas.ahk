﻿Add_Space_After_Commas(){
	sc:=csc()
	if !sc.getseltext()
		return m("Please select some text")
	replace:=RegExReplace(sc.getseltext(),",",", ")
	sc.2170(0,replace)
}