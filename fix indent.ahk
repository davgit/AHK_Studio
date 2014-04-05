fix_indent(sc=""){
	critical
	move_selected:
	auto_delete:
	if !sc
		sc:=csc()
	cpos:=sc.2008,begin:=cpos-sc.2128(sc.2166(cpos))
	auto_indent:
	fix_paste:
	settimer,%A_ThisLabel%,off
	next:=0,cpos:=0,indent:=0,add:=0
	if !sc
		sc:=csc()
	sc.2078
	lines:=sc.2154,pos:=0
	text:=sc.gettext()
	if !text
		return
	for a,b in strsplit(text,"`n","`n"){
		b:=Trim(b),start:=0
		if (SubStr(b,1,1)="(")
			v.skip:=1
		if (SubStr(b,0,1)=")"&&v.skip){
			v.skip:=0
			continue
		}
		if v.skip
			continue
		if InStr(b,";")
		while,start:=RegExMatch(b,"\;",found,++start){
			linestart:=sc.2128(a-1)
			if (sc.2010(linestart+start-1)=1){
				b:=Trim(SubStr(b,1,start-1))
				break
			}
		}
		add:=0
		if (pos:=RegExMatch(lastb,"iUA)(\b(" v.indentregex ")(.+)?)\b",found)&&(SubStr(b,0,1)!="{")){
			if InStr(v.color.indent,found)
				add+=1
			if (SubStr(lastb,0,1)="{")
				add:=0
		}
		if (SubStr(b,1,1)="}"){
			indent:=indent>0?indent-1:0
			if (indent*5!=sc.2127(a-1))
				sc.2126(a-1,indent*5)
		}
		if (SubStr(b,1,2)="*/"){
			indent:=indent>0?indent-1:0
			if (indent*5!=sc.2127(a-1))
				sc.2126(a-1,indent*5)
		}
		if (SubStr(b,1,2)="/*"){
			if (indent*5!=sc.2127(a-1))
				sc.2126(a-1,indent*5)
			indent++
		}else if (SubStr(b,0,1)="{"){
			if (indent*5!=sc.2127(a-1))
				sc.2126(a-1,indent*5)
			indent++
		}else{
			if (add){
				prev:=sc.2127(a-2)
				if (prev+5!=sc.2127(a-1))
					sc.2126(a-1,prev+5)
			}else if (indent*5!=sc.2127(a-1))
			sc.2126(a-1,indent*5)
		}
		lastb:=b
	}
	if indent
		ToolTip,Segment Open,0,0
	else
		t()
	line:=sc.2166(sc.2008)
	if (A_ThisLabel="auto_indent"){
		begin:=A_ThisLabel="auto_indent"?sc.2128(line):begin+sc.2128(line)
		sc.2160(begin,begin)
	}
	sc.2079
	return
}