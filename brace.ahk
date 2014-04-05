brace(){
	brace:
	sc:=csc(),cp:=sc.2008,line:=sc.2166(cp),min:=posinfo() ;,min:=mm(sc)
	v.lastbrace:=A_ThisHotkey
	if sc.2102
		sc.2104
	ControlGetFocus,Focus,A
	if !InStr(Focus,"Scintilla"){
		Send,{%A_ThisHotkey%}
		return
	}
	selcount:=sc.2570
	pos:=[],count:=0,rev:=[]
	loop,%selcount%
	{
		pos[sc.2008]:={start:sc.2008,end:sc.2009}
		sc.2606
		count++
	}
	for a,b in pos
		rev.Insert(pos[a])
	if (A_ThisHotkey="{"&&sc.2128(line)=cp&&cp=sc.2136(line)){
		sc.2003(cp,"{`n`n}")
		fix_indent()
		Send,{Down}
		sc.2314
	}else{
		sc.2078()
		for a in rev{
			b:=rev[rev.maxindex()-A_Index+1]
			mm:=[]
			mm[b.start]:=1,mm[b.end]:=1
			sc.2003(mm.MinIndex(),A_ThisHotkey)
			sc.2003(mm.MaxIndex()+1,v.brace[A_ThisHotkey])
		}
		for a,b in rev{
			if A_Index=1
				sc.2160(b.start+1,b.end+1)
			else
				sc.2573(b.end+(A_Index*2)-1,b.start+(A_Index*2)-1)
		}
		sc.2079
	}
	width:=sc.2276(32,"a")
	text1:="Last Entered Character: " A_ThisHotkey " Code:" Asc(A_ThisHotkey)
	SB_SetText(text1,2),SB_SetParts(first,width*StrLen(text1 1),40)
	last:=width*StrLen(text1 1)
	replace()
	return
}