/*
	Code_Explorer(){
		static
		;global width
		explore:=[]
		Gui,1:TreeView,% hwnd("ce")
		GuiControl,-Redraw,% hwnd("ce")
		TV_Delete()
		file:=sn(current(1),"*")
		functions:=TV_Add("Functions"),labels:=TV_Add("Labels"),hotkeys:=TV_Add("Hotkeys"),class:=TV_Add("Class")
		codes:=update("get").1
		while,out:=ssn(file.item[a_index-1],"@file"){
			code:=codes[out.text],pos:=1
			for type,find in {hotkeys:"(([#|!|^|\+|~|\$|&|<|>|*]*)?\w+)::",labels:"(\w+):[\s+;]"}{
				pos:=1
				while,pos:=RegExMatch(code,"OUim`n)^[\s+]?" find,fun,pos){
					explore[TV_Add(fun.value(1),%type%,"Sort")]:={file:out.text,pos:fun.Pos(1)-1}
					pos+=fun.len(1)
					last:=fun.value(1)
				}
			}
			pos:=1
			Loop
			{
				fpos:=[]
				for type,find in {class:"^[\s+]?(class[\s*](\w+))",functions:"^[\s*]?((\w|[^\x00-\x7F])+)\((.*)?\)[\s+;.*\s+]?[\s*]?{"}{
					if pp:=RegExMatch(code,"Oim`n)" find,fun,pos)
						fpos[fun.Pos(1)]:={type:type,fun:fun,pos:fun.Pos(1)}
				}
				if !fpos.minindex()
					break
				findit:=SubStr(code,fpos[fpos.minindex()].pos)
				left:="",count:=0,foundone:=0
				for a,b in StrSplit(findit,"`n"){
					orig:=b
					left.=orig "`n"
					b:=RegExReplace(b,"i)(\s+" Chr(59) ".*)")
					b:=RegExReplace(b,"U)(" Chr(34) ".*" Chr(34) ")","_")
					RegExReplace(b,"{","",open)
					count+=open
					if open
						foundone:=1
					RegExReplace(b,"}","",close)
					count-=close
					if (count=0&&foundone)
						break
				}
				type:=fpos[fpos.MinIndex()].type
				treeview:=fpos[fpos.MinIndex()].fun.value(1)
				if (treeview!=lastfun){
					type:=InStr(type,"class")?class:%type%
					ppp:=fpos.MinIndex()-1
					explore[ttt:=TV_Add(treeview,type,"Sort")]:={file:out.text,pos:ppp}
				}
				;for finding methods
				if (fpos[fpos.minindex()].type="class"){
					pp:=1
					while,pp:=RegExMatch(left,"Om`n)^[\s*]?((\w|[^\x00-\x7F])+)\((.*)?\)[\s+;.*\s+]?[\s*]?{",method,pp){
						explore[TV_Add(method.value(1),ttt,"Sort")]:={file:out.text,pos:method.Pos(1)+fpos.minindex()-2}
						pp:=method.Pos(1)
					}
				}
				pos:=pos+StrLen(left)
				lastfun:=TreeView
			}
		}
		explore[TV_Add("Refresh")]:="Refresh"
		GuiControl,+Redraw,% hwnd("ce")
		Gui,1:TreeView,% hwnd("fe")
		return
		if (explore[A_EventInfo]="refresh")
			return code_explorer()
		if A_GuiEvent!=Normal
			return
		Gui,1:TreeView,SysTreeView322
		if found:=explore[TV_GetSelection()]{
			TV_GetText(ff,TV_GetSelection())
			tv(ssn(current(1),"//*[@file='" found.file "']/@tv").text)
			Sleep,200
			csc().2160(found.pos,found.pos+StrLen(ff)),v.sc.2169,v.sc.2400
		}
		return
	}
	
*/
