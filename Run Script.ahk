﻿Run_Script(){
	if (ssn(current(1),"@file").text=A_ScriptFullPath)
		Return m("Can not debug AHK Studio using AHK Studio.")
	save(),debug.Run(ssn(current(1),"@file").text) ;debug("run",ssn(current(1),"@file").text)
}