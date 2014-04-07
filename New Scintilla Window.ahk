New_Scintilla_Window(file=""){
	sc:=csc()
	doc:=sc.2357
	sc:=new s(1,{main:1,hide:1})
	csc(sc)
	if file{
		newdoc:=files.ssn("//*[@file='" file "']")
		m(newdoc.xml)
	}else{
		sc.2358(0,doc)
	}
	Resize()
	sc.show()
}