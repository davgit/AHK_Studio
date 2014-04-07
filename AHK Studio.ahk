#SingleInstance,Off
;download complete
DetectHiddenWindows,On
OnMessage(0x4a,"WM_COPYDATA")
Sleep,1
if (AID:=OtherInstance()){
	File=%1%
	Send_WM_COPYDATA(AID,File)
	ExitApp
}
SetWorkingDir,%A_ScriptDir%
settings:=new xml("settings","lib\settings.xml"),files:=new xml("files"),menus:=new xml("menus","lib\menus.xml"),commands:=new xml("commands","lib\commands.xml")
positions:=new xml("positions","lib\positions.xml"),vversion:=new xml("version","lib\version.xml"),access_token:=settings.ssn("//access_token").text
vault:=new xml("vault","lib\vault.xml")
global v:=[],settings,files,menus,commands,positions,vversion,access_token,vault,preset
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
GuiDropFiles: ;this is ok
open(A_GuiEvent)
return
#Include %A_ScriptDir%
#Include about.ahk
#Include addbutton.ahk
#Include arrows.ahk
#Include auto update.ahk
#Include automenu.ahk
#Include brace.ahk
#Include bracesetup.ahk
#Include check id.ahk
#Include class ftp.ahk
#Include Class s.ahk
#Include clean.ahk
#Include close.ahk
#Include Code Explorer.ahk
#Include Code Vault.ahk
#Include compile main gist.ahk
#Include compile.ahk
#Include connect.ahk
#Include context.ahk
#Include convert_hotkey.ahk
#Include Create Multi-Line Comment.ahk
#Include Create Segment From Selection.ahk
#Include csc.ahk
#Include current.ahk
#Include debug.ahk
#Include defaultfont.ahk
#Include delete.ahk
#Include display.ahk
#Include Dlg_Color.ahk
#Include Dlg_font.ahk
#Include Duplicate Line.ahk
#Include dynarun.ahk
#Include edit replacements.ahk
#Include exit.ahk
#Include filecheck.ahk
#Include Find Nearest Brace.ahk
#Include find.ahk
#Include fix after.ahk
#Include fix indent.ahk
#Include ftp servers.ahk
#Include full backup.ahk
#Include get access.ahk
#Include getpos.ahk
#Include google search selected.ahk
#Include gui.ahk
#Include help.ahk
#Include hotkeys.ahk
#Include hwnd.ahk
#Include icon browser.ahk
#Include json.ahk
#Include jump to project.ahk
#Include Jump to Segment.ahk
#Include keywords.ahk
#Include lastfiles.ahk
#Include LV_Select.ahk
#Include marginwidth.ahk
#Include menu creator.ahk
#Include menu.ahk
#Include Move Selected Lines.ahk
#Include msgbox creator.ahk
#Include msgbox.ahk
#Include multiple file gist.ahk
#Include new segment.ahk
#Include new.ahk
#Include New_Scintilla_Window.ahk
#Include Next Found.ahk
#Include notify.ahk
#Include On Dropfiles.ahk
#Include open folder.ahk
#Include open.ahk
#Include options.ahk
#Include paste.ahk
#Include Personal Variable List.ahk
#Include posinfo.ahk
#Include Post All In One Gist.ahk
#Include publish.ahk
#Include qf.ahk
#Include rebar.ahk
#Include redo.ahk
#Include RefreshThemes.ahk
#Include Remove Segment.ahk
#Include remove spaces.ahk
#Include replace selected.ahk
#Include replace.ahk
#Include resize.ahk
#Include restore current file.ahk
#Include rgb.ahk
#Include run selected text.ahk
#Include run.ahk
#Include runfile.ahk
#Include save.ahk
#Include Scintilla Code Lookup.ahk
#Include Scratch Pad.ahk
#Include set as default editor.ahk
#Include set.ahk
#Include setpos.ahk
#Include setup.ahk
#Include show scintilla codes in line.ahk
#Include sn.ahk
#Include social.ahk
#Include Sort Selected.ahk
#Include ssn.ahk
#Include testing.ahk
#Include theme.ahk
#Include themetext.ahk
#Include toolbar.ahk
#Include traymenu.ahk
#Include tv.ahk
#Include undo.ahk
#Include update.ahk
#Include upload.ahk
#Include UrlDownloadToVar.ahk
#Include window.ahk
#Include xml.ahk