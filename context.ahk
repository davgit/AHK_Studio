﻿context(){
	sc:=csc()
	if sc.2102
		return
	cp:=sc.2008,kw:=v.kw,add:=0,pos:=cp-1,start:=sc.2128(sc.2166(cp))
	if (start>=pos+1)
		return
	content:=sc.textrange(start,pos+1)
	RegExMatch(content,"(#?\w+)",word)
	search=U)"(.*)"
	cb:=RegExReplace(content,search),RegExReplace(cb,"\)","",Count)
	cou:=[],cbb:=cb
	for a,b in ["(",")"]
		while,pos:=InStr(cb,b,0,1,A_Index)
			cou[pos]:=b
	for a,b in cou{
		if (b="(")
			ccc++
		else if (b=")")
			ccc--
		if ccc=0
			cbb:=SubStr(cb,a+1)
	}
	cbb:=SubStr(cbb,1,InStr(cbb,"(",0,1,ccc))
	RegExMatch(cbb,"(\w+)\($",command)
	found:=kw[command1]?kw[command1]:kw[word1]
	if !found
		return
	if syn:=commands.ssn("//Commands/*[text()='" found "']/@syntax").text
		info:=found " " syn
	else
	{
		root:=commands.sn("//Context/" found "/syntax")
		while,r:=root.item(A_Index-1)
		if cc:=RegExMatch(cb,"i)\b(" RegExReplace(r.text," ","|") ")\b",ff){
			info:=ssn(r,"@syntax").text
			break
		}
		if !cc
			return
		info:=SubStr(cb,1,cc+StrLen(ff)-1) " " info
	}
	RegExReplace(info,",","",count)
	if !count
		return sc.2207(0),sc.2200(start,info),sc.2204(0,StrLen(info))
	newstr:=RegExReplace(SubStr(cb,InStr(cb,found,0,0)+StrLen(found)),"U)\((.*)\)")
	newstr:=Trim(newstr,"(")
	RegExReplace(newstr,",","",count)
	ss:=InStr(info,",",0,1,count),ee:=InStr(info,",",0,1,count+1)
	if !sc.2202
		sc.2200(start,info),sc.2207(0xFF0000)
	if (ss&&ee)
		sc.2204(ss,ee)
	else if (ss&&ee=0)
		sc.2204(ss,StrLen(info))
	else if (ss=0&&ee)
		sc.2204(ss,ee)
	else
		sc.2207(0x0000FF),sc.2204(0,StrLen(info))
	return
	context:
	SetTimer,context,Off
	context()
	return
}