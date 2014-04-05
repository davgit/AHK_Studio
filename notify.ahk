notify(csc=""){
	notify:
	static last,painted:=0
	if A_EventInfo=512
		return csc(1)
	sc:=csc?csc:csc()
	csc:=""
	if sc.sc!=NumGet(A_EventInfo){
		if (sc.2353(sc.2008-1)>0){
			sc.2351(sc.2008-1,sc.2353(sc.2008-1)),v.highlight:=1
		}else if (sc.2353(sc.2008)>0){
			sc.2351(sc.2008,sc.2353(sc.2008)),v.highlight:=1
		}else if v.highlight{
			sc.2351(-1,-1),v.highlight:=0
		}
		text:="Line:" sc.2166(sc.2008)+1 " Column:" sc.2129(sc.2008)
		width:=sc.2276(32,"a")
		SB_SetText(text)
		SB_SetParts(width*StrLen(text "1"),last)
		first:=width*StrLen(text "1")
	}
	fn:=[ ],info:=A_EventInfo
	;,2:"id",4:"position",5:"ch",6:"modifiers",7:"modType",8:"text",9:"length",10:"linesAdded",11:"macMessage",12:"macwParam",13:"maclParam",14:"line",15:"foldLevelNow",16:"foldLevelPrev",17:"margin",18:"listType",19:"x",20:"y",21:"token",22:"annotLinesAdded",23:"updated"}
	for a,b in {0:"Obj",2:"Code",3:"position",4:"ch",5:"mod",6:"modType",7:"text",8:"length",9:"linesadded",10:"msg",11:"wparam",12:"lparam",13:"line",14:"fold",22:"updated"}
		fn[b]:=NumGet(Info+(A_PtrSize*a))
	cpos:=sc.2008
	if (fn.code=2022){
		actext:=StrGet(fn.text,"cp0")
		selcount:=sc.2570
		Loop,%selcount%
		{
			b:=sc.2577(A_Index-1),start:=sc.2266(b,1),text:=sc.textrange(start,b)
			if !InStr(actext,text){
				b:=sc.2577(A_Index-1),sc.2003(b,actext)
			}else{
				b:=sc.2579(A_Index-1)
				if (l:=commands.ssn("//Context/*/*[text()='" RegExReplace(actext,"#") "']/@list").text){
					if !v.lastbrace
						v.word:=actext,actext:=actext ","
				}
				sc.2190(start),sc.2192(b),sc.2194(StrLen(actext),actext)
				b:=sc.2579(A_Index-1),sc.2578(A_Index-1,b+StrLen(actext)),sc.2576(A_Index-1,b+StrLen(actext))
			}
		}
		sc.2101
		if !v.lastbrace
			SetTimer,automenu,10
		v.lastbrace:=""
	}
	;if (fn.code=2027)
	;switch this out with 2027 and use GetKeyState("Control","P") and stuff
	if (fn.code=2019){
		v.style:={style:sc.2010(fn.position),mod:fn.mod}
		if fn.mod=0
			SetTimer,styleclick,1
		if fn.mod=2
			SetTimer,editfont,1
		if fn.mod=4
			SetTimer,editback,1
	}
	if (fn.code=2008){
		if ((fn.modtype&0x01)||(fn.modtype&0x02)){
			update({sc:sc.2357})
			v.word:=sc.textrange(sc.2266(cpos,1),sc.2267(cpos,1))
		}
		if fn.linesadded
			marginwidth(sc)
		if (sc.sc=v.codevault.sc){
			LV_GetText(code,LV_GetNext())
			if !locker:=vault.ssn("//code[@name='" code "']")
				locker:=vault.Add({path:"code",att:{name:code},dup:1})
			locker.text:=sc.gettext()
		}
	}
	if (fn.code=2004&&sc.sc=v.codevault.sc){
		m("Please create or select a code snippet")
	}
	if (fn.code=2001){
		if ((fn.ch=10||fn.ch=123||fn.ch=125)&&v.options.full_auto&&sc.2102=0){
			if fn.ch=10
				SetTimer,auto_indent,50
			else
				SetTimer,auto_delete,250
		}else if (fn.ch=10&&v.options.fix_next_line){
			SetTimer,fix_next,50
		}
		cpos:=sc.2008,start:=sc.2266(cpos,1),end:=sc.2267(cpos,1),word:=sc.textrange(sc.2266(cpos,1),cpos)
		if (StrLen(word)>1&&sc.2102=0){
			list:=Trim(v.keywords[SubStr(word,1,1)])
			if list&&instr(list,word)
				sc.2100(StrLen(word),list)
		}
		style:=sc.2010(sc.2008-2)
		settimer,context,150
		c:=fn.ch
		lll=44,32
		if c in %lll%
			replace()
	}
	if (fn.code=2010){
		margin:=NumGet(info+64)
		if margin=0
			return theme({margin:margin,mod:fn.mod})
		scpos:=NumGet(info+12)
		modifier:=NumGet(info+20)
		if margin=2
			sc.2231(sc.2166(scpos))
	}
	if (fn.code=2001){
		width:=sc.2276(32,"aaa")
		text1:="Last Entered Character: " Chr(fn.ch) " Code:" fn.ch
		SB_SetText(text1,2),SB_SetParts(first,width*StrLen(text1 1),40)
		last:=width*StrLen(text1 1)
	}
	if (fn.code=2007){
		if (sc.2353(sc.2008-1)>0){
			sc.2351(sc.2008-1,sc.2353(sc.2008-1)),v.highlight:=1
		}else if (sc.2353(sc.2008)>0){
			sc.2351(sc.2008,sc.2353(sc.2008)),v.highlight:=1
		}else if v.highlight{
			sc.2351(-1,-1),v.highlight:=0
		}		text:="Line:" sc.2166(sc.2008)+1 " Column:" sc.2129(sc.2008)
		width:=sc.2276(32,"a")
		SB_SetText(text)
		SB_SetParts(width*StrLen(text "1"),last)
		first:=width*StrLen(text "1")
	}
	return
	Full_Auto:
	Fix_Next_Line:
	onoff:=settings.ssn("//Auto_Indent/@ " A_ThisLabel).text?0:1
	att:=[],att[A_ThisLabel]:=onoff
	settings.add({path:"Auto_Indent",att:att})
	Menu,%A_ThisMenu%,ToggleCheck,%A_ThisMenuItem%
	v.options[A_ThisLabel]:=onoff
	return
}