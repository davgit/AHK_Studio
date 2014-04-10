delete(){
	backspace:
	ControlGetFocus,Focus,% hwnd([1])
	sc:=csc() 
	if !InStr(Focus,"Scintilla"){
		ControlSend,%Focus%,{%A_ThisHotkey%}
		return
	}
	
	if (sc.2009!=sc.2008){
		text:=sc.getseltext()
		if (RegExMatch(text,"(\{|\})")&&v.options.full_auto)
			SetTimer,auto_delete,20
	}else{
		if (A_ThisHotkey="bs")
			if (RegExMatch(Chr(sc.2007(sc.2008-1)),"(\{|\})")&&v.options.full_auto)
				SetTimer,auto_delete,20
		else if(A_ThisHotkey="Del")
			if (RegExMatch(Chr(sc.2007(sc.2008)),"(\{|\})")&&v.options.full_auto)
				SetTimer,auto_delete,20
	}	
	ControlSend,%Focus%,{%A_ThisHotkey%}
	update({sc:sc.2357})
	return
}