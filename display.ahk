display(store){
	static recieve:=new xml("recieve")
	start:=1
	if !store
		return
	if !WinExist(hwnd([99])){
		Gui,99:Default
		Gui,99:Destroy
		Gui,+hwndhwnd +Owner1
		hwnd(99,hwnd)
		sc:=v.debugwin:=new s(99,{pos:"w400 h600"})
		Gui,99:Show,x0 y0 NA,Debug
		Gui,1:Default
		debug(1)
	}
	sc:=v.debugwin
	recieve.xml.loadxml(store)
	if info:=recieve.ssn("//stream[@type='stderr']"){
		debug("send","stop"),debug(0)
		info:=debug("decode",info.text)
		sc.2003(sc.2006,"`r`n" info),sc.2629
		sc:=csc("Scintilla1")
		for a,b in StrSplit(info,"`n"){
			if RegExMatch(b,"i)Error in.+include file " Chr(34) "(.+)" Chr(34),found)
				tv(files.ssn("//main[@file='" ssn(current(1),"@file").text "']/file[@file='" found1 "']/@tv").text),sc.2400
			if InStr(b,"--->"){
				RegExMatch(b,"(\d+)",line)
				v.line:=line-1
				SetTimer,selecterror,100
				debug("disconnect")
				exit
			}
		}
	}
	if init:=recieve.ssn("//init"){
		debug("send","stderr -c 2")
		debug(1)
	}
	if recieve.ssn("//property"){
		if property:=recieve.sn("//property"){
			if property.length>1000
				ToolTip,Compiling List Please Wait...,350,150
			varbrowser()
			list:=[],variablelist:=[],value:=[]
			object:=recieve.sn("//response/property")
			Gui,97:Default
			GuiControl,97:-Redraw,SysTreeView321
			TV_Delete()
			while,oo:=object.item[A_Index-1]{
				ea:=xml.ea(oo),value:=debug("decode",oo.text)
				list[ea.fullname]:=TV_Add(ea.fullname a:=ea.type="object"?"":" = " value)
				if (ea.type!="object")
					variablelist[list[ea.fullname]]:={value:value,variable:ea.fullname}
				descendant:=sn(oo,"descendant::*")
				while,des:=descendant.item[A_Index-1]{
					ea:=xml.ea(des),value:=debug("decode",des.text)
					list[ea.fullname]:=TV_Add(ea.fullname a:=ea.type="object"?"":" = " value,list[prev:=SubStr(ea.fullname,1,InStr(ea.fullname,".",0,0)-1)],"Sort")
					if (ea.type!="object")
						variablelist[list[ea.fullname]]:={value:value,variable:ea.fullname}
				}
			}
			v.variablelist:=variablelist
			debug("send","run")
			GuiControl,97:+Redraw,SysTreeView321
			return t()
			sc.2629
			return t()
		}
	}else if command:=recieve.ssn("//response"){
		if recieve.sn("//response").length>1
			m("more info")
		ea:=recieve.ea(command)
		if (ea.status="stopped"&&ea.command="run"&&ea.reason="ok")
			debug(0)
		disp:="Command:"
		for a,b in ea
			if (a&&b)
				disp.="`r`n" a " = " Chr(34) b Chr(34)
		info:=disp
	}
	disp:=sc.2006?"`r`n" disp:disp
	disp:=disp?disp:store
	sc.2003(sc.2006,disp)
	sc.2629
	return
	disp:=recieve[]
	store:=disp?disp:store
	return sock
	99GuiEscape:
	99GuiClose:
	debug("detach")
	/*
		WinWaitClose,% hwnd
		csc("Scintilla1")
	*/
	return
	selecterror:
	SetTimer,selecterror,Off
	sc:=csc(),line:=v.line,sc.2400
	start:=sc.2128(line),end:=sc.2136(line)
	sc.2160(start,end)
	return
}
varbrowser(){
	if !WinExist(hwnd([97])){
		setup(97)
		Gui,Add,TreeView,w300 h400 gvalue AltSubmit
		Gui,Add,Button,greloadvar,Reload Variables
		Gui,Show,,Variable Browser
	}
	return
	97GuiEscape:
	97GuiClose:
	hwnd({rem:97})
	return
	value:
	if A_GuiEvent!=Normal
		return
	if value:=v.variablelist[A_EventInfo]{
		ei:=A_EventInfo
		InputBox,newvalue,% "Current value for " value.variable,% "Change value for " value.variable,,,,,,,,% value.value
		if ErrorLevel
			return
		debug("send","property_set -n " value.variable " -- " debug("encode",newvalue))
		TV_Modify(ei,"",value.variable " = " newvalue)
	}
	return
	reloadvar:
	listvars()
	return
}
run_program(){
	if !debug("check")
		return m("Currently no file being debugged"),debug(0)
	debug("send","run")
}
Run_Script(){
	save(),debug("run",ssn(current(1),"@file").text)
}
step(){
	if !debug("check")
		return m("Currently no file being debugged"),debug(0)
	debug("send","step_into")
}
listvars(){
	if !debug("check")
		return m("Currently no file being debugged"),debug(0)
	debug("send","context_get -c 1")
}
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
detach(){
	debug("send","detach"),debug(0)
}
local(){
	debug("send","context_get -c 0")
}
global(){
	debug("send","context_get -c 1")
}