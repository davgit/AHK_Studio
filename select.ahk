select(obj){
	if !pos:=positions.ssn("//file[@file='" obj.file "']"){
		pos:=positions.unique({path:"main",att:{file:files.ssn("//file[@file='" obj.file "']../@file").text},check:"file"})
		pos:=positions.unique({under:fix,path:"file",att:{start:obj.pos,end:obj.pos+StrLen(obj.text),file:obj.file},check:"file"})
	}else{
		for a,b in {start:obj.pos,end:obj.pos+StrLen(obj.text)}
			pos.SetAttribute(a,b)
	}
	tv(files.ssn("//*[@file='" obj.file "']/@tv").text)
}