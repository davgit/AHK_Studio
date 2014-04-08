update(info){
	static update:=[],updated:=[]
	if (info="updated")
		return updated
	if (info.edited)
		return updated[info.edited]:=1
	if (info="clearupdated")
		return updated:=[]
	if (info="get")
		return [update,updated]
	if (info.file){
		update[info.file]:=info.text
		if !info.load
			updated[info.file]:=1
		return 
	}
	if (info.get)
		return update[info.get]
	if (info.sc){
		fn:=files.ssn("//*[@sc='" info.sc "']")
		ea:=xml.ea(fn),fn:=ssn(fn,"@file").text
		if !fn
			return
		if (updated[info.file]=""){
			Gui,1:TreeView,% hwnd("fe")
			TV_Modify(ea.tv,"",ea.filename "*")
		}
		updated[fn]:=1
		update[fn]:=csc().getuni()
		return
	}
}