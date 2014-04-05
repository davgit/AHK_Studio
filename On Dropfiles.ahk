Send_WM_COPYDATA(AID,String,Key=25565){
	VarSetCapacity(Struct,12,0)
	NumPut(StrPut(string,"utf-8")*2,struct,4),NumPut(&string,struct,8)
	SendMessage,0x4a,%Key%,&Struct,,ahk_id %AID% ahk_class AutoHotkey
}
WM_COPYDATA(wParam,lParam){
	if wParam != 25565
		return false
	file:=StrGet(NumGet(lparam+8))
	if (file){
		open(file)
		v.tv:=files.ssn("//main[@file='" file "']/file/@tv").text
		tv(v.tv)
		WinActivate,% hwnd([1])
	}
	return true
}
OtherInstance(){
	WinGet,Wins,List,%A_ScriptFullPath% ahk_class AutoHotkey
	Loop, %Wins%
		if (Wins%A_Index% != A_ScriptHwnd)
			return Wins%A_Index%
	return 0
}