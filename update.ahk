update(info){
	static update:=[],updated:=[]
	if (info.edited)
		return updated[info.edited]:=1
	if (info="clearupdated")
		return updated:=[]
	if (info="get")
		return [update,updated]
	if (info.file&&info.text)
		return update[info.file]:=info.text
	if (info.get)
		return update[info.get]
	if (info.sc){
		fn:=files.ssn("//*[@sc='" info.sc "']/@file").text
		if !fn
			return
		updated[fn]:=1
		update[fn]:=csc().getuni()
		return
	}
}