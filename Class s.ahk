﻿class s{
	static ctrl:=[],lc:="",main:=[]
	__New(window,info){
		static int
		if !init
			DllCall("LoadLibrary","str","scilexer.dll"),init:=1
		win:=window?window:1
		static count=1
		pos:=info.pos?info.pos:"x0 y0"
		if info.hide
			pos.=" Hide"
		notify:=info.label?info.label:"notify"
		Gui,%win%:Add,custom,classScintilla hwndsc w500 h400 %pos% +1387331584 g%notify%
		this.sc:=sc,s.ctrl[sc]:=this,t:=[]
		for a,b in {fn:2184,ptr:2185}
			this[a]:=DllCall("SendMessageA","UInt",sc,"int",b,int,0,int,0)
		v.focus:=sc
		this.2660(1)
		for a,b in [[2563,1],[2565,1],[2614,1],[2402,0x15,75],[2124,1]]{
			b.2:=b.2?b.2:0,b.3:=b.3?b.3:0
			this[b.1](b.2,b.3)
		}
		if info.main
			s.main.Insert(this)
		this.2052(32,0),this.2051(32,0xaaaaaa),this.2050,this.2052(33,0x222222)
		this.2069(0xAAAAAA),this.2067(1,0),this.2601(0xaa88aa)
		this.2563(1),this.2614(1),this.2565(1)
		this.2660(1),this.2458(0)
		this.2036(5),this.2124(1),this.2260(1),this.2122(5),this.2132(1)
		color(this)
		return this
	}
	delete(x*){
		if s.main.MaxIndex()=1
			return m("Can not delete the last control")
		this:=x.1
		for a,b in s.main{
			if (b.sc=this.sc)
				s.main.remove(a)
		}
		DllCall("DestroyWindow",uptr,this.sc)
		csc("Scintilla1").2400
		Resize()
	}
	__Delete(x*){
		m("should not happen")
	}
	__Get(x*){
		return DllCall(this.fn,"Ptr",this.ptr,"UInt",x.1,int,0,int,0,"Cdecl")
	}
	__Call(code,lparam=0,wparam=0){
		if (code="getseltext"){
			VarSetCapacity(text,this.2161),length:=this.2161(0,&text)
			return StrGet(&text,length,"cp0")
		}
		if (code="textrange"){
			VarSetCapacity(text,abs(lparam-wparam)),VarSetCapacity(textrange,12,0),NumPut(lparam,textrange,0),NumPut(wparam,textrange,4),NumPut(&text,textrange,8)
			this.2162(0,&textrange)
			return strget(&text,"","cp0")
		}
		if (code="getline"){
			length:=this.2350(lparam)
			cap:=VarSetCapacity(text,length,0),this.2153(lparam,&text)
			return StrGet(&text,length,"cp0")
		}
		if (code="gettext"){
			cap:=VarSetCapacity(text,vv:=this.2182),this.2182(vv,&text),t:=strget(&text,vv,"cp0")
			return t
		}
		if (code="getuni"){
			cap:=VarSetCapacity(text,vv:=this.2182),this.2182(vv,&text),t:=StrGet(&text,vv,"utf-8")
			return t
		}
		wp:=(wparam+0)!=""?"Int":"AStr"
		if wparam.1
			wp:="AStr"
		if wparam=0
			wp:="int"
		info:=DllCall(this.fn,"Ptr",this.ptr,"UInt",code,"int",lparam,wp,wparam,"Cdecl")
		return info
	}
	show(){
		GuiControl,+Show,% this.sc
	}	
}