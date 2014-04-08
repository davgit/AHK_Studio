save(){
	info:=update("get"),now:=A_Now,sc:=csc(),currentdoc:=sc.2357
	for filename in info.2{
		text:=info.1[filename]
		SplitPath,filename,file,dir
		if !FileExist(dir "\backup")
			FileCreateDir,% dir "\backup"
		if !FileExist(dir "\backup\" now)
			FileCreateDir,% dir "\backup\" now
		FileMove,%filename%,% dir "\backup\" now "\" file,1
		StringReplace,text,text,`n,`r`n,All
		FileAppend,%text%,%filename%,utf-8
		Gui,1:TreeView,% hwnd("fe")
		ea:=xml.ea(files.ssn("//file[@file='" filename "']"))
		TV_Modify(ea.tv,"",ea.filename)
	}
	getpos(),savegui(),positions.save(1),vversion.save(1)
	lastfiles()
	update("clearupdated")
}