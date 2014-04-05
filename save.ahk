save(){
	info:=update("get"),now:=A_Now
	for filename in info.2{
		;if root:=files.ssn("//main[@file='" filename "']"){
		;inc:=sn(root,"*/@include")
		;text:=info.1[filename]
		;while,ii:=inc.item[A_Index-1]
		;text.="`r`n" ii.text
		;}
		;else{
		text:=info.1[filename]
		;}
		SplitPath,filename,file,dir
		if !FileExist(dir "\backup")
			FileCreateDir,% dir "\backup"
		if !FileExist(dir "\backup\" now)
			FileCreateDir,% dir "\backup\" now
		FileMove,%filename%,% dir "\backup\" now "\" file,1
		StringReplace,text,text,`n,`r`n,All
		FileAppend,%text%,%filename%,utf-8
	}
	getpos(),savegui(),positions.save(1),vversion.save(1)
	lastfiles()
	update("clearupdated")
}