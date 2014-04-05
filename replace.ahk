replace(){
	sc:=csc(),cp:=sc.2008
	sc:=csc()
	selcount:=sc.2570
	loop,%selcount%
	{
		word:=sc.textrange(start:=sc.2266(sc.2577(A_Index-1)-1,1),end:=sc.2267(sc.2577(A_Index-1)-1,1))
		if w:=settings.ssn("//replacements/*[@replace='" word "']").text
			sc.2190(start),sc.2192(end),sc.2194(StrLen(w),w)
	}
	v.word:=w?w:word
	if !v.lastbrace
		SetTimer,automenu,10
}