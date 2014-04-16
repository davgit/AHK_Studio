fix_indent(sc=""){
	Critical
	move_selected:
	auto_delete:
	if !sc
		sc:=csc()
	cpos:=sc.2008,begin:=cpos-sc.2128(sc.2166(cpos))
	fullauto:
	fix_paste:
	settimer,%A_ThisLabel%,off
	Critical
	next:=0,cpos:=0,indent:=0,add:=0
	lock:=[],track:=[]
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
		if (SubStr(b,1,1)=")"&&v.skip){
			v.skip:=0
			continue
		}
		if v.skip
			continue
		if found:=RegExMatch(b,"\s\" Chr(59),flan,1)
			b:=Trim(SubStr(b,1,found))
		RegExMatch(b,"iUA)\b(" v.indentregex ")\b",found)
		if (lastfound&&SubStr(lastb,0,1)!="{")
			add++
		if (add&&lastfound&&SubStr(b,0,1)="{")
			add--
		if (add&&b="{")
			lock.Insert({add:add,line:a})
		if (lock.MaxIndex()=""&&add&&lastfound="")
			add:=0
		if (SubStr(b,1,1)="}")
			indent--
		if (SubStr(b,1,2)="*/")
			indent--
		if (lock.MinIndex()){
			if (track[a-2]&&track[a-1]="")
				add--
		}
		if (SubStr(b,1,2)="/*"){
			if (indent*5!=sc.2127(a-1))
				sc.2126(a-1,indent*5)
			indent++
		}else if (SubStr(b,0,1)="{"){
			if ((indent+add)*5!=sc.2127(a-1))
				sc.2126(a-1,(indent+add)*5)
			indent++
		}else{
			if (SubStr(b,1,1)="}"||SubStr(b,1,2)="*/"){
				dd:=lock.MaxIndex()?lock[lock.MaxIndex()].add:add
				lock.remove(lock.MaxIndex())
			}
			else
				dd:=add
			if ((indent+dd)*5!=sc.2127(a-1))
				sc.2126(a-1,(indent+dd)*5)
		}
		lastb:=b
		lastfound:=found
		if lock.MinIndex()
			track[a]:=found
	}
	if indent
		ToolTip,Segment Open,0,0
	else
		t()
	line:=sc.2166(sc.2008)
	if (A_ThisLabel="fullauto"){
		begin:=A_ThisLabel="fullauto"?sc.2128(line):begin+sc.2128(line)
		sc.2160(begin,begin)
	}
	sc.2079
	lastb:=""
	return
}