set(){
	sc:=csc()
	color(sc)
}
refresh(){
	for a,b in s.Ctrl
		color(b)
}
color(con){
	static options:={show_eol:2356,Show_Caret_Line:2096}
	list:={Font:2056,Size:2055,Color:2051,Background:2052,Bold:2053,Italic:2054,Underline:2059}
	nodes:=settings.sn("//fonts/*")
	while,n:=nodes.item(A_Index-1){
		ea:=settings.ea(n)
		if (ea.style=33)
			for a,b in [2290,2291]
				con[b](1,ea.Background)
		ea.style:=ea.style=5?32:ea.style
		for a,b in ea{
			if list[a]&&ea.style!=""
				con[list[a]](ea.style,b)
			else if ea.code&&ea.bool!=1
				con[ea.code](ea.color,0)
			else if ea.code&&ea.bool
				con[ea.code](ea.bool,ea.color)
			if ea.style=32
				con.2050
		}
	}
	for a,b in [[2040,25,13],[2040,26,15],[2040,27,11],[2040,28,10],[2040,29,9],[2040,30,12],[2040,31,14],[2244,2,0xFE000000],[2242,0,20],[2242,2,13],[2460,3],[2462,1],[2134,1],[2260,1],[2246,2,1],[2115,1],[2242,1,0],[2029,2],[2031,2]]
		con[b.1](b.2,b.3)
	con.2132(1)con.2242(2,13),con.2077(0,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ#_")
	con.2115(1),con.2036(5)
	con.2056(38,"Tahoma")
	con.4006(0,"asm"),con.2212,con.2371
	;con.2037(65001)
	con.2080(7,6)
	con.2082(7,0xff00ff)
	con.2498(1,7)
	for a,b in options
		if v.options[a]
			con[b](b)
	kwind:={indent:1,Directives:2,KeyNames:8,builtin:4,keywords:5,functions:6,Commands:3,flow:7,Personal:0}
	for a,b in v.color
		con.4005(kwind[a],RegExReplace(b,"#"))
}