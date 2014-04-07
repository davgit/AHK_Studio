forum(){
	MsgBox,36,Which forum?,Yes for AutoHotkey.com and No for ahkscript.org
	IfMsgBox,Yes
		Run,http://www.autohotkey.com/board/topic/85996-ahk-studio/
	Else
		Run,http://ahkscript.org/boards/viewtopic.php?f=6&t=300
}