Check_For_Update(){
	static version
	version=0.100.18
	Gui,55:Destroy
	Gui,55:Default
	Gui,Add,Edit,w500 h500,% URLDownloadToVar("http://files.maestrith.com/alpha/Studio/AHK Studio.text")
	Gui,Add,Button,gautoupdate,Update
	Gui,Show,,AHK Studio Version %version%
	return
	autoupdate:
	version=0.100.18
	save(),settings.save(1)
	SplitPath,A_ScriptName,,,ext,name
	if !InStr(ext,"exe"){
		studio:=URLDownloadToVar("http://files.maestrith.com/alpha/Studio/AHK Studio.ahk")
		if !InStr(studio,";download complete")
			return m("There was an error. Please contact maestrith@gmail.com if this error continues")
		FileMove,%A_ScriptName%,%name%%version%.ahk,1
		FileAppend,%studio%,%A_ScriptName%
		Run,%A_ScriptName%
		ExitApp
	}else{
		URLDownloadToFile,http://files.maestrith.com/alpha/Studio/AHK Studio.exe,AHK Studio temp.exe
		FileGetSize,size,AHK Studio temp.exe
		if (size>1000){
			FileMove,%A_ScriptName%,%name%%version%,1
			FileMove,AHK Studio temp.exe,%A_ScriptName%,1
			Run,%A_ScriptName%
			ExitApp
		}
		
	}
	return
	55GuiEscape:
	55GuiClose:
	Gui,55:Destroy
	return
}