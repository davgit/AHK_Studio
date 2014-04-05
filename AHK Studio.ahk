#SingleInstance,Off
;download complete
;git only
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
#Include D:\AHK Studio\about.ahk
#Include D:\AHK Studio\addbutton.ahk
#Include D:\AHK Studio\arrows.ahk
#Include D:\AHK Studio\auto update.ahk
#Include D:\AHK Studio\automenu.ahk
#Include D:\AHK Studio\brace.ahk
#Include D:\AHK Studio\bracesetup.ahk
#Include D:\AHK Studio\check id.ahk
#Include D:\AHK Studio\class ftp.ahk
#Include D:\AHK Studio\Class s.ahk
#Include D:\AHK Studio\clean.ahk
#Include D:\AHK Studio\close.ahk
#Include D:\AHK Studio\Code Explorer.ahk
#Include D:\AHK Studio\Code Vault.ahk
#Include D:\AHK Studio\compile main gist.ahk
#Include D:\AHK Studio\compile.ahk
#Include D:\AHK Studio\connect.ahk
#Include D:\AHK Studio\context.ahk
#Include D:\AHK Studio\convert_hotkey.ahk
#Include D:\AHK Studio\Create Multi-Line Comment.ahk
#Include D:\AHK Studio\Create Segment From Selection.ahk
#Include D:\AHK Studio\csc.ahk
#Include D:\AHK Studio\current.ahk
#Include D:\AHK Studio\debug.ahk
#Include D:\AHK Studio\defaultfont.ahk
#Include D:\AHK Studio\delete.ahk
#Include D:\AHK Studio\display.ahk
#Include D:\AHK Studio\Dlg_Color.ahk
#Include D:\AHK Studio\Dlg_font.ahk
#Include D:\AHK Studio\Duplicate Line.ahk
#Include D:\AHK Studio\dynarun.ahk
#Include D:\AHK Studio\edit replacements.ahk
#Include D:\AHK Studio\exit.ahk
#Include D:\AHK Studio\filecheck.ahk
#Include D:\AHK Studio\Find Nearest Brace.ahk
#Include D:\AHK Studio\find.ahk
#Include D:\AHK Studio\fix after.ahk
#Include D:\AHK Studio\fix indent.ahk
#Include D:\AHK Studio\ftp servers.ahk
#Include D:\AHK Studio\full backup.ahk
#Include D:\AHK Studio\get access.ahk
#Include D:\AHK Studio\getpos.ahk
#Include D:\AHK Studio\google search selected.ahk
#Include D:\AHK Studio\gui.ahk
#Include D:\AHK Studio\help.ahk
#Include D:\AHK Studio\hotkeys.ahk
#Include D:\AHK Studio\hwnd.ahk
#Include D:\AHK Studio\icon browser.ahk
#Include D:\AHK Studio\json.ahk
#Include D:\AHK Studio\jump to project.ahk
#Include D:\AHK Studio\Jump to Segment.ahk
#Include D:\AHK Studio\keywords.ahk
#Include D:\AHK Studio\lastfiles.ahk
#Include D:\AHK Studio\LV_Select.ahk
#Include D:\AHK Studio\marginwidth.ahk
#Include D:\AHK Studio\menu creator.ahk
#Include D:\AHK Studio\menu.ahk
#Include D:\AHK Studio\Move Selected Lines.ahk
#Include D:\AHK Studio\msgbox creator.ahk
#Include D:\AHK Studio\msgbox.ahk
#Include D:\AHK Studio\multiple file gist.ahk
#Include D:\AHK Studio\new segment.ahk
#Include D:\AHK Studio\new.ahk
#Include D:\AHK Studio\New_Scintilla_Window.ahk
#Include D:\AHK Studio\Next Found.ahk
#Include D:\AHK Studio\notify.ahk
#Include D:\AHK Studio\On Dropfiles.ahk
#Include D:\AHK Studio\open folder.ahk
#Include D:\AHK Studio\open.ahk
#Include D:\AHK Studio\options.ahk
#Include D:\AHK Studio\paste.ahk
#Include D:\AHK Studio\Personal Variable List.ahk
#Include D:\AHK Studio\posinfo.ahk
#Include D:\AHK Studio\Post All In One Gist.ahk
#Include D:\AHK Studio\publish.ahk
#Include D:\AHK Studio\qf.ahk
#Include D:\AHK Studio\rebar.ahk
#Include D:\AHK Studio\redo.ahk
#Include D:\AHK Studio\RefreshThemes.ahk
#Include D:\AHK Studio\Remove Segment.ahk
#Include D:\AHK Studio\remove spaces.ahk
#Include D:\AHK Studio\replace selected.ahk
#Include D:\AHK Studio\replace.ahk
#Include D:\AHK Studio\resize.ahk
#Include D:\AHK Studio\restore current file.ahk
#Include D:\AHK Studio\rgb.ahk
#Include D:\AHK Studio\run selected text.ahk
#Include D:\AHK Studio\run.ahk
#Include D:\AHK Studio\runfile.ahk
#Include D:\AHK Studio\save.ahk
#Include D:\AHK Studio\Scintilla Code Lookup.ahk
#Include D:\AHK Studio\Scratch Pad.ahk
#Include D:\AHK Studio\set as default editor.ahk
#Include D:\AHK Studio\set.ahk
#Include D:\AHK Studio\setpos.ahk
#Include D:\AHK Studio\setup.ahk
#Include D:\AHK Studio\show scintilla codes in line.ahk
#Include D:\AHK Studio\sn.ahk
#Include D:\AHK Studio\social.ahk
#Include D:\AHK Studio\Sort Selected.ahk
#Include D:\AHK Studio\ssn.ahk
#Include D:\AHK Studio\testing.ahk
#Include D:\AHK Studio\theme.ahk
#Include D:\AHK Studio\themetext.ahk
#Include D:\AHK Studio\toolbar.ahk
#Include D:\AHK Studio\traymenu.ahk
#Include D:\AHK Studio\tv.ahk
#Include D:\AHK Studio\undo.ahk
#Include D:\AHK Studio\update.ahk
#Include D:\AHK Studio\upload.ahk
#Include D:\AHK Studio\UrlDownloadToVar.ahk
#Include D:\AHK Studio\window.ahk
#Include D:\AHK Studio\xml.ahk