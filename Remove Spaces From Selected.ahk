Remove_Spaces_From_Selected(){
	sc:=csc(),pos:=posinfo()
	replace:=sc.textrange(pos.start,pos.end)
	replace:=RegExReplace(replace,"[\t]")
	sc.2170(0,replace)
}