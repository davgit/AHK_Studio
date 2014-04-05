posinfo(){
	sc:=csc()
	current:=sc.2008
	line:=sc.2166(current),se:=[]
	ind:=sc.2128(line)
	lineend:=sc.2136(line)
	se[current]:=1,se[sc.2009]:=1
	return {current:current,line:line,ind:ind,lineend:lineend,start:se.minindex(),end:se.maxindex()}
}