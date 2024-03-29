﻿#SingleInstance,Off
;download complete
/*
	breakpoints(){
		user defined, in includes as well.
	}
	Previous_Scripts(){
		History for scripts, user defined.
	}
	Help(){
		Context Sensitive Help for individual windows
	}
	fix adding toolbar borks stuff
*/
DetectHiddenWindows,On
OnMessage(0x4a,"WM_COPYDATA")
if (AID:=OtherInstance()){
	File=%1%
	Send_WM_COPYDATA(AID,File)
	ExitApp
}
SetWorkingDir,%A_ScriptDir%
settings:=new xml("settings","lib\settings.xml"),files:=new xml("files"),menus:=new xml("menus","lib\menus.xml"),commands:=new xml("commands","lib\commands.xml"),cexp:=new xml("code_explorer")
positions:=new xml("positions","lib\positions.xml"),vversion:=new xml("version","lib\version.xml"),access_token:=settings.ssn("//access_token").text
vault:=new xml("vault","lib\vault.xml")
global v:=[],settings,files,menus,commands,positions,vversion,access_token,vault,preset,cexp
v.color:=[],preset:=new xml("preset","lib\preset.xml")
if (A_PtrSize=8&&A_IsCompiled=""){
	SplitPath,A_AhkPath,,dir
	correct:=dir "\AutoHotkeyU32.exe"
	if !FileExist(correct){
		m("Requires AutoHotkey 1.1 to run")
		ExitApp
	}
	run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
	ExitApp
	return
}
filecheck(),v.quick:=[]
Menu,Tray,Icon,AHKStudio.ico
keywords(),gui()
openfile=%1%
if (openfile){
	open(openfile)
	TV(files.ssn("//main[@file='" openfile "']/file/@tv").text)
}
return
GuiDropFiles:
tv(open(A_GuiEvent))
return
+!Down::
+!Up::
sc:=csc(),line:=sc.2166(sc.2008)
column:=sc.2129(sc.2008)
nl:=A_ThisLabel="+!up"?-1:1
next:=sc.2456(line+nl,column)
if (next){
	sc.2573(next,next)
}
return
#Include %A_ScriptDir%
#Include about.ahk
#Include Add Spaces After Commas.ahk
#Include add spaces before and after commas.ahk
#Include Add Spaces Before Commas.ahk
#Include addbutton.ahk
#Include arrows.ahk
#Include auto insert.ahk
#Include automenu.ahk
#Include brace.ahk
#Include bracesetup.ahk
#Include center.ahk
#Include cgp.ahk
#Include changehotkey.ahk
#Include Check For Update.ahk
#Include check id.ahk
#Include Class Code Explorer.ahk
#Include class ftp.ahk
#Include class icon browser.ahk
#Include class rebar.ahk
#Include class s.ahk
#Include class search.ahk
#Include class toolbar.ahk
#Include class xml.ahk
#Include clean.ahk
#Include close.ahk
#Include Code Vault.ahk
#Include color.ahk
#Include compile main gist.ahk
#Include compile.ahk
#Include compilebox.ahk
#Include connect.ahk
#Include context.ahk
#Include convert hotkey.ahk
#Include create launcher.ahk
#Include Create Segment From Selection.ahk
#Include csc.ahk
#Include current.ahk
#Include debug.ahk
#Include Default.ahk
#Include defaultfont.ahk
#Include delete.ahk
#Include detach.ahk
#Include display.ahk
#Include Dlg Color.ahk
#Include Dlg Font.ahk
#Include Duplicate Line.ahk
#Include DynaRun.ahk
#Include edit replacements.ahk
#Include exit.ahk
#Include file search.ahk
#Include filecheck.ahk
#Include Find Nearest Brace.ahk
#Include find.ahk
#Include fix after.ahk
#Include fix indent.ahk
#Include forum.ahk
#Include ftp servers.ahk
#Include full backup.ahk
#Include function search.ahk
#Include get access.ahk
#Include getpos.ahk
#Include global.ahk
#Include google search selected.ahk
#Include gui.ahk
#Include help.ahk
#Include Hotkey Search.ahk
#Include hotkeys.ahk
#Include hwnd.ahk
#Include json.ahk
#Include jump to project.ahk
#Include Jump to Segment.ahk
#Include keywords.ahk
#Include lastfiles.ahk
#Include listvars.ahk
#Include local.ahk
#Include LV Select.ahk
#Include m.ahk
#Include marginwidth.ahk
#Include menu editor.ahk
#Include menu search.ahk
#Include menu.ahk
#Include Method Search.ahk
#Include move selected lines down.ahk
#Include move selected lines up.ahk
#Include Msgbox Creator.ahk
#Include New Scintilla Window.ahk
#Include new segment.ahk
#Include new.ahk
#Include newwin.ahk
#Include Next Found.ahk
#Include notify.ahk
#Include omni search.ahk
#Include open folder.ahk
#Include open.ahk
#Include options.ahk
#Include OtherInstance.ahk
#Include paste.ahk
#Include Personal Variable List.ahk
#Include popftp.ahk
#Include posinfo.ahk
#Include post all in one gist.ahk
#Include Post Multiple Segment Gist.ahk
#Include previous found.ahk
#Include publish.ahk
#Include qf.ahk
#Include redo.ahk
#Include refresh.ahk
#Include refreshthemes.ahk
#Include Remove Scintilla Window.ahk
#Include Remove Segment.ahk
#Include Remove Spaces From Selected.ahk
#Include replace selected.ahk
#Include replace.ahk
#Include resize.ahk
#Include restore current file.ahk
#Include rgb.ahk
#Include run program.ahk
#Include Run Script.ahk
#Include run selected text.ahk
#Include run.ahk
#Include runfile.ahk
#Include runit.ahk
#Include save.ahk
#Include savegui.ahk
#Include scintilla code lookup.ahk
#Include Scratch Pad.ahk
#Include Search Label.ahk
#Include Send WM COPYDATA.ahk
#Include set as default editor.ahk
#Include set.ahk
#Include setpos.ahk
#Include setup.ahk
#Include show scintilla code in line.ahk
#Include show.ahk
#Include sn.ahk
#Include social.ahk
#Include SocketEvent.ahk
#Include Sort Selected.ahk
#Include split code.ahk
#Include ssn.ahk
#Include step.ahk
#Include stop.ahk
#Include striperror.ahk
#Include t.ahk
#Include testing.ahk
#Include Theme.ahk
#Include themetext.ahk
#Include toggle comment line.ahk
#Include Toggle Multiple Line Comment.ahk
#Include togglemenu.ahk
#Include traymenu.ahk
#Include tv.ahk
#Include undo.ahk
#Include update.ahk
#Include upload.ahk
#Include URLDownloadToVar.ahk
#Include varbrowser.ahk
#Include window.ahk
#Include WM COPYDATA.ahk