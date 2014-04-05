Scratch_Pad(){
	static file
	if !IsObject(file){
		FileCreateDir,Projects
		file:=FileOpen("projects\Scratch Pad.ahk","rw")
	}
	setup(14)
	v.scratch:=new s(14,{pos:"w500 h300"}),hotkeys([14],{Esc:"14guiclose"})
	csc({hwnd:v.scratch.sc}),v.scratch.2181(0,file.read(file.length))
	Gui,Add,Button,gsprun,Run
	Gui,Add,Button,x+10 gspdyna,Dyna Run
	Gui,Add,Button,x+10 gspkill,Kill Process
	Gui,Show,,Scratch Pad
	bracesetup(14)
	return
	14GuiClose:
	gosub spsave
	hwnd({rem:14})
	csc("Scintilla1")
	goto spkill
	return
	sprun:
	gosub spsave
	Run,projects\Scratch Pad.ahk,,,pid
	v.scratchpid:=pid
	return
	spdyna:
	v.scratchpid:=dynarun(v.scratch.getText())
	return
	spkill:
	if (v.scratchpid){
		while,WinExist("ahk_pid" v.scratchpid){
			WinClose,% "ahk_pid" v.scratchpid " ahk_class AutoHotkey",, 2
			Sleep,500
			if WinExist("ahk_pid" v.scratchpid)
				MsgBox,51,Unable to close the previous script,Try again?
			IfMsgBox,no
				break
			IfMsgBox,Cancel
				break
		}
	}
	return
	spsave:
	file.seek(0)
	file.write(v.scratch.gettext())
	file.length(file.position),file.seek(0)
	return
}