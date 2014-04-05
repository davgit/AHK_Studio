Msgbox_Creator(){
	static
	msgbox:=setup(17)
	Gui,Add,Text,Section hwndheight,Title:
	h:=cgp(height).h*1.25
	Gui,Add,Edit,w320
	Gui,Add,Text,,Text:
	Gui,Add,Edit,w320 hwndedit
	pos:=cgp(edit)
	Gui,Add,GroupBox,% "x" pos.x " y" pos.y+pos.h+10 " w320 R8 hwndgb Section",Buttons and Icons
	Gui,Add,Radio,xs+10 ys+%h% Checked,OK
	list=OK/Cancel,Abort/Retry/Ignore,Yes/No/Cancel,Yes/No,Retry/Cancel,Cancel/Try Again/Continue
	Loop,Parse,list,`,
		Gui,Add,Radio,hwndlast,%A_LoopField%
	Gui,Add,Checkbox,,Help
	pos:=cgp(last),nx:=pos.x+pos.w+20
	for a,b in [4,3,2,5]
		if A_Index=1
			Gui,Add,Picture,x%nx% ys+%h% Icon4 Section,%A_WinDir%\system32\user32.dll
	else
		Gui,Add,Picture,Icon%b% ,%A_WinDir%\system32\user32.dll
	color:=RGB(settings.ssn("//font[@style='5']/@background").text)
	Gui,Color,%color%,%color%
	Gui,Add,Radio,y+10 Checked vicon1,No Icon
	Gui,Add,Radio,ys+8 xs+40 section vicon2
	Gui,Add,Radio,ys+40 section xs vicon3
	Gui,Add,Radio,ys+40 section xs vicon4
	Gui,Add,Radio,ys+40 xs vicon5
	Gui,Add,GroupBox,ym x340 R4 Section hwndgb1,Modal
	Gui,Add,Radio,xs+10 ys+%h% Checked,Normal
	Gui,Add,Radio,,Task Modal
	Gui,Add,Radio,,Always On Top
	Gui,Add,Radio,,System Modal
	pos:=cgp(gb1)
	Gui,Add,GroupBox,% "x" pos.x " y" pos.y+pos.h " R1 hwndgb2 Section",Default Button
	Gui,Add,Radio,xs+10 ys+%h% Checked,1st
	Gui,Add,Radio,x+10,2nd
	Gui,Add,Radio,x+10,3rd
	pos:=cgp(gb2)
	Gui,Add,GroupBox,% "x" pos.x " y" pos.y+pos.h " R1 hwndgb3 Section",Alignment
	Gui,Add,Checkbox,xs+10 ys+%h%,Right
	Gui,Add,Checkbox,x+10,Reverse
	pos:=cgp(gb3)
	Gui,Add,GroupBox,% "x" pos.x " y" pos.y+pos.h " R3 hwndgb4 Section",Timeout and Insert
	Gui,Add,Text,xs+10 ys+%h% Section,Timeout:
	Gui,Add,Edit,w50 x+5 number
	Gui,Add,Button,x+5 hwndthird gmbcopy,Copy
	Gui,Add,Button,xs gmbtest Default,Test
	Gui,Add,Button,x+5 gmbinsert,Insert
	Gui,Add,Button,x+5 gmbreset,Reset
	pos:=cgp(third),pos1:=cgp(gb1),w:=pos.x+pos.w+10-pos1.x
	Loop,4
	{
		con:=gb%A_Index%
		ControlMove,,,,%w%,,ahk_id%con%
	}
	Gui,Show,AutoSize,Msgbox Creator
	return
	mbcopy:
	Clipboard:=compilebox(msgbox)
	MsgBox,0,Complete,Text coppied to the clipboard,.5
	return
	mbreset:
	Loop,3
		ControlSetText,Edit%A_Index%,,% hwnd([17])
	for a,b in {2:1,10:1,16:1,21:1,9:0,25:0,26:0}
		GuiControl,17:,Button%a%,%b%
	return
	mbinsert:
	sc:=csc(),sc.2003(sc.2008,compilebox(msgbox))
	return
	17GuiEscape:
	17GuiClose:
	hwnd({rem:17})
	return
	mbtest:
	dynarun(compilebox(msgbox))
	return
}
cgp(Control){
	SysGet,Border,7
	SysGet,Caption,4
	pos:=[]
	ControlGetPos,x,y,w,h,,ahk_id%control%
	return pos:={x:x-border,y:y-Border-Caption,w:w,h:h}
}
compilebox(win){
	static list:={2:0,3:1,4:2,5:3,6:4,7:5,8:6,9:16384,11:16,12:32,13:48
	,14:64,17:8192,18:262144,19:4096,22:256,23:512,25:524288,26:1048576}
	total=0
	
	for a,b in ["Edit1","Edit2","Edit3"]
		ControlGetText,edit%a%,Edit%a%,ahk_id%win%
	for a,b in list{
		ControlGet,value,Checked,,Button%a%
		if value
			total+=b
	}
	edit1:=edit1?edit1:"Testing"
	msg=MsgBox,%total%,%edit1%,%edit2%
	msg.=edit3?"," edit3:""
	return msg
}