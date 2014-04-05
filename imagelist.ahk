imagelist(icon,file=""){
	static il,list:=[]
	if !il
	il:=IL_Create(20,1,1)
	if icon{
		if list[icon]!=""
		return list[icon]
		index:=IL_icon(il,"shell32.dll",++icon)-1
		list[icon]:=index
		return index
	}
	v.imagelist:=il
	;Loop,322
	;IL_Add(il,"shell32.dll",A_Index)
	;return il
}