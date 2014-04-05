﻿new(filename=""){
	if (filename=1){
		index:=0
		if !FileExist(A_WorkingDir "\Projects")
			FileCreateDir,% A_WorkingDir "\Projects"
		if !FileExist(A_WorkingDir "\Projects\Untitled")
			FileCreateDir,% A_WorkingDir "\Projects\Untitled"
		while,FileExist(A_WorkingDir "\Projects\Untitled\Untitled" A_Index)
			index:=A_Index
		index++
		FileCreateDir,% A_WorkingDir "\Projects\Untitled\Untitled" index
		filename:=A_WorkingDir "\Projects\Untitled\Untitled" index "\Untitled.ahk"
		FileAppend,`;New File,%filename%
	}else if (filename=""){
		FileSelectFile,filename,S,,Create A New Project,*.ahk
		if ErrorLevel
			return
		filename:=InStr(filename,".ahk")?filename:filename ".ahk"
		FileAppend,`;New File,%filename%
	}
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	root:=open(filename,1)
	TV_Modify(root,"Select Vis Focus")
}