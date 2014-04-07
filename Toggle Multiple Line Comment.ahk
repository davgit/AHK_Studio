Toggle_Multiple_Line_Comment(){
	sc:=csc(),pos:=posinfo()
	if (sc.2010(sc.2008)!=11&&sc.2010(sc.2009)!=11){
		start:=sc.2128(sc.2166(pos.start)),end:=sc.2136(sc.2166(pos.end))
		sc.2003(start,inline "/*`n")
		if (pos.start=pos.end)
			sc.2003(end+4,"*/`n")
		else
			sc.2003(end+4,"*/`n")
	}else{
		/*
			top:=sc.2225(sc.2166(sc.2008))
			bottom:=sc.2224(top,-1)
			if (top>=0&&bottom>=0){
				for a,b in [bottom,top]{
					start:=sc.2167(b),end:=sc.2167(b+1)-start
					if end<4
						start:=start-(4-end),end:=4
					sc.2645(start,end)
				}
			}
		*/
	}
	fix_indent()
}