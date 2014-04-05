close(){
	sc:=csc(),save()
	main:=files.ssn("//*[@sc='" sc.2357 "']..")
	rem:=settings.sn("//file[text()='" ssn(main,"@file").text "']")
	while,rr:=rem.item[A_Index-1]
		rr.ParentNode.RemoveChild(rr)
	udf:=update("get").1
	close:=sn(main,"*")
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	while,cc:=close.item[A_Index-1]{
		ea:=xml.ea(cc)
		if ea.tv
			TV_Delete(ea.tv)
		if ea.sc
			sc.2377(0,ea.sc)
		udf.Remove(ea.file)
	}
	TV_Modify(TV_GetNext(0),"Select Vis Focus")
	main.ParentNode.RemoveChild(main)
	if files.sn("//*").length=1
		new(1)
}