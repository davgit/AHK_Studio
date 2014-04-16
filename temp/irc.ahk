#SingleInstance,Force
DetectHiddenWindows,On
OnExit,exit
Gui,1:+hwndhwnd
hwnd(1,hwnd),sul:=new xml("sul"),srvrlist:=new xml("srvrlist")
global v:=[],settings,tv1,sul,srvrlist
v.message:=[],settings:=new xml("settings"),v.lastlist:=[],v.nicklist:=[]
setglobal()
checkfiles(),gui()
return
;sul=server-user-list
;srvrlist=server list

class Socket{
	static __eventMsg:=0x9987,list:=[]
	__New(host,port){
		static init
		if (!init){
			DllCall("LoadLibrary","str","ws2_32","ptr"),VarSetCapacity(wsadata,394+A_PtrSize)
			DllCall("ws2_32\WSAStartup","ushort",0x0000,"ptr",&wsadata),DllCall("ws2_32\WSAStartup","ushort",NumGet(wsadata,2,"ushort"),"ptr",&wsadata)
			OnMessage(Socket.__eventMsg,"SocketEventProc"),init:=1
		}
		this.list.insert(this)
		this.socket:=-1,this.users:=[]
		this.connect(host,port)
	}
	onrecv(info){
		rr:="onrecv"
		if IsFunc(rr)
		%rr%(info)
	}
	connect(host,port=6667){
		static flan:=[]
		this.host:=host,this.port:=port,this.server:=host
		next:=this.addrinfo(host,port),this.server:=host
		sockaddrlen:=NumGet(next+0,16,"uint"),sockaddr:=NumGet(next+0,16+(2*A_PtrSize),"ptr")
		if !(sockaddrlen||sockaddr)
		return m("Something happened")
		this.socket:=DllCall("ws2_32\socket","int",NumGet(next+0,4,"int"),"int",1,"int",6,"ptr")
		this.list[this.socket]:=this
		if((r:=DllCall("ws2_32\WSAConnect","ptr",this.socket,uptr,sockaddr,int,sockaddrlen,"ptr",0,"ptr",0,"ptr",0,"ptr",0,"int"))=0){
			DllCall("ws2_32\freeaddrinfo",uptr,next)
			return Socket.__eventProcRegister(this,0x21)
		}
		this.disconnect()
	}
	AddrInfo(host,port){
		VarSetCapacity(hints,8*A_PtrSize,0)
		for a,b in {6:8,1:12}
		NumPut(a,hints,b)
		DllCall("ws2_32\getaddrinfo",astr,host,astr,port,"uptr",hints,"ptr*",results)
		return results
	}
	msgSize(){
		VarSetCapacity(argp,4,0)
		if (DllCall("ws2_32\ioctlsocket","ptr",this.socket,"uint",0x4004667F,"ptr",&argp)!=0)
		return 0
		return NumGet(argp,0,"int")
	}
	recv(byref buffer,wait=1){
		Critical
		while ((wait)&&((length:=this.msgSize())=0))
		sleep,100
		if (length){
			VarSetCapacity(buffer, length)
			if ((r:=DllCall("ws2_32\recv","ptr",this.socket,"ptr",&buffer,"int",length,"int",0))<=0)
			return 0
			return r
		}
		return 0
	}
	recvText(wait=1, encoding="UTF-8"){
		Critical
		if (length:=this.recv(buffer,wait))
		return StrGet(&buffer, length, encoding)
		return
	}
	send(addr,length){
		if ((r:=DllCall("ws2_32\send","ptr",this.socket,"ptr",addr,"int",length,"int",0,"int"))<=0)
		return 0
		return r
	}
	sendText(msg){
		msg.="`r`n"
		VarSetCapacity(buffer,length:=(StrPut(msg,"UTF-8"))),StrPut(msg,&buffer,"UTF-8")
		return this.send(&buffer,length-1)
	}
	__eventProcRegister(obj,msg){
		a:=SocketEventProc([1])
		a[obj.socket]:=obj
		return (DllCall("ws2_32\WSAAsyncSelect","ptr",obj.socket,"ptr",A_ScriptHwnd,"uint",Socket.__eventMsg,"uint",msg)=0)?1:0
	}
	__Delete(){
		this.disconnect()
	}
	disconnect(){
		a:=SocketEventProc([1])
		a.remove(this.socket)
		DllCall("ws2_32\WSAAsyncSelect","ptr",this.socket,"ptr",A_ScriptHwnd,"uint",0,"uint",0)=0
		DllCall("ws2_32\closesocket","ptr",this.socket,"int")
		this.socket:=-1
		return 1
	}
}
;---------------------------------------end socket--------------
onrecv(sock){
	static store:=[]
	if !sock
	return store
	store[sock.socket].=sock.recvText(sock)
	pos:=InStr(store[sock.socket],"`r`n",0,0)
	v.message.Insert({sock:sock,msg:SubStr(store[sock.socket],1,pos)})
	store[sock.socket]:=SubStr(store[sock.socket],pos)
	if v.message.1
	SetTimer,processmsg,On
}
processmsg:
if !(v.message.1){
	SetTimer,processmsg,Off
	return
}
next(v.message.1.msg,v.message.1.sock)
v.message.remove(1)
sleep,100
return
m(x*){
	for a,b in x
	list.=b "`n"
	MsgBox,% list
}
t(x*){
	for a,b in x
	list.=b "`n"
	Tooltip,% list
}
SocketEventProc(info*){
	Critical
	static a:=[]
	if info.1.1
	return a
	if (info.3=socket.__eventmsg){
		if (info.2&0xFFFF=1)
		onrecv(a[info.1])
		if (info.2&0xFFFF=32)
		return a[info.1].disconnect()
	}
}
recv(this,byref buffer,wait=1){
	Critical
	while ((wait)&&((length:=this.msgSize())=0))
	sleep,100
	if (length){
		VarSetCapacity(buffer, length)
		if ((r:=DllCall("ws2_32\recv","ptr",this.socket,"ptr",&buffer,"int",length,"int",0))<=0)
		return 0
		return r
	}
	return 0
}
recvText(this,wait=1,encoding="UTF-8"){
	Critical
	if (length:=recv(this,buffer))
	return StrGet(&buffer,length,encoding)
	return
}
next(in,sock){
	static lll:=[]
	if !in:=Trim(in,"`r`n")
	return
	for a,b in StrSplit(in,"`r`n"){
		in:=StrSplit(b," "),msg:=SubStr(b,InStr(b,":",0,1,2)+1),regexmatch(in.1,"A):(.+)!",user)
		if (in.2="quit"){
			display({text:user1 " just quit the channel`r`n" b,nick:"System"},sock)
		}
		if (in.2="NICK"){
			;newnick:=in.3,oldnick:=user1
			newnick:=InStr(in.3,":")?SubStr(in.3,2):in.3
			if (sock.user=user1)
			sock.user:=newnick
			for chan,b in sock.users[user1]{
				op:=b.op?"@":b.vo?"+":""
				sock.users[newnick,chan]:={op:b.op,vo:b.vo,tv:TV_Add(op newnick,TV_GetParent(b.tv),"Sort")}
				TV_Delete(b.tv)
				sock.users.remove(user1)
			}
			if chan:=sul.ssn("//server[@socket='" sock.socket "']/channel[@name='" user1 "']"){
				ssn(chan,"@name").text:=newnick
				TV_Modify(ssn(chan,"@tv").text,"",newnick)
				debug()
			}
			return
		}
		if (in.2=433){
			nick:=settings.ssn("//server[@name='" sock.server "']/@user").text
			sock.user:=(nick "_" A_MSec)
			sock.sendtext("NICK " sock.user)
		}else if (in.2="join"){
			if (user1!=sock.user){
				;nickkeep.add(sock,user1,msg)
				;ch:=get({path:sock.socket "/" SubStr(in.3,InStr(in.3,"#"))}),tt:=ch.att.tv
				;v.nicklist[sock.socket,msg,user1]:=tv1.Add(user1,ch.att.no)
				
				;here is where you would add users
				
				
				;start here
				;new users(sock,msg,user1)
				display({text:user1 " just joined the channel",chan:SubStr(in.3,InStr(in.3,"#")),nick:"System"},sock)
			}
		}else if (in.2="PART"){
			if (user1=sock.user){
				;add:=add()
				;users.part(sock,in.3,user1)
				display({text:user1 " just left the channel",chan:in.3,nick:"System"},sock)
				;here is where you remove them
				/*
					for a,b in v.nicklist[sock.socket,in.3]
					if b is number
					tv1.Delete(b)
					v.nicklist[sock.socket].remove(in.3)
					for a,b in add.path[sock.socket "/" in.3].att{
						if a is number
						tv1.Delete(a)
						if a=sc
						b.remove()
					}
					add.path.Remove(sock.socket "/" in.3)
				*/
			}else{
				;tv1.Delete(v.nicklist[sock.socket,in.3,user1])
				;v.nicklist[sock.socket,in.3].remove(user1)
			}
		}else if (in.2=376||in.2=422){
			if Password:=settings.search("//server/@name",sock.server,"@password").text
			sock.sendtext("PRIVMSG NICKSERV :IDENTIFY " Password)
			list:=sn(settings.search("//server/@name",sock.server),"*")
			while,item:=list.item(a_index-1)
			servlist.=item.text ","
			Sort,servlist,D`,
			sock.sendtext("JOIN " servlist)
		}else if (in.1="ping")
		sock.Sendtext("PONG " in.2),display({text:msg},sock)
		else if (in.2=353){
			if !lll[sock.socket,in.5]
			lll[sock.socket,in.5]:=[]
			for c,d in StrSplit(msg," ")
			if d
			lll[sock.socket,in.5,d]:=1
		}else if (in.2=366){ ;big join
			display({chan:in.4,text:"Joined " in.4,user:"Server"},sock)
			for nick in lll[sock.socket,in.4]{
				op:=SubStr(nick,1,1)="@"?1:0,vo:=SubStr(nick,1,1)="+"?1:0
				nick1:=op||vo?SubStr(nick,2):nick
				ss:=sock.users[nick1,in.4]:={op:op,vo:vo,tv:TV_Add(nick,sul.ssn("//server[@socket='" sock.socket "']/channel[@name='" in.4 "']/@tv").text)}
			}
		}else if (in.2="topic"){ ;Topic change
			
			/*
				get({path:sock.socket "/" in.3}).att.topic:=msg
				if (tv1.gettext(tv1.getselection())=in.3)
				WinSetTitle,% hwnd([1]),,% in.3 " : " msg
			*/
		}else if (in.2="MODE"&&in.5){
			/*
				ch:=get({path:sock.socket "/" in.3}),tt:=ch.att.tv
				for a,b in {op:ch.att.op,vo:ch.att.vo,no:ch.att.no}{
					next:=TV_GetChild(b),last:=a
					if (tv1.gettext(next)=in.5){
						TV1.Delete(next)
						break
					}
					while,next:=tv1.getnext(next)
					if (tv1.gettext(next)=in.5){
						tv1.Delete(next)
						break
					}
				}
				for a,b in {"+o":ch.att.op,"+v":ch.att.vo}
				if InStr(in.4,a)
				tv1.Add(in.5,b)
				if InStr(in.4,"-o")||InStr(in.4,"-v")
				if (last="op")
				tv1.Add(in.5,ch.att.vo)
				if (last="vo")
				tv1.Add(in.5,ch.att.no)
			*/
		}else if (in.2="PRIVMSG"){
			cc:=if InStr(in.3,"#")?in.3:user1
			mark:=regexmatch(msg,"i)\b" ea.user "\b")?1:0
			display({text:msg,chan:cc,user:user1,mark:mark,encode:msg},sock)
		}
		else
		display({text:msg},sock)
	}
}
exit(){
	GuiClose:
	GuiEscape:
	exit:
	settings.save(1)
	ExitApp
	return
}
hwnd(win,hwnd=""){
	static window:=[]
	if (win.rem){
		Gui,% win.rem ":Destroy"
		window.remove[win.rem]
	}
	if IsObject(win)
	return "ahk_id" window[win.1]
	if !hwnd
	return window[win]
	window[win]:=hwnd
}
gui(){
	Gui,+hwndhwnd +Resize
	Gui,Margin,0,0
	hwnd(1,hwnd),Resize(),OnMessage(0x05,"Resize")
	Hotkey,IfWinActive,% hwnd([1])
	for a,b in {alt:"deadend",f1:"hide",f2:"Caption",f3:"unread",f4:"emote"}{
		Hotkey,%a%,hotkeys,On
		v.hotkeylist[a]:=b
	}
	for a,b in ["Tab","+Tab","Esc","Enter"]
		Hotkey,%b%,Tab,On
	Gui,Add,TreeView,w150 h344 hwndhwnd AltSubmit gservers
	hwnd(100,hwnd),v.help:=new s(1,"x+2 ym w500 h500",0,"help"),help(v.help)
	v.edit:=new s(1,"xm w500 r1",1,"edit"),v.edit.2171(0),v.connected:=TV_Add("Connected Servers")
	populateservers()
	Gui,Show
	/*
		loop,1
		{
			connect("127.0.0.1")
			sleep,600
		}
	*/
	return
	hotkeys:
	func:=v.hotkeylist[A_ThisHotkey],%func%()
	deadend:
	return
}
send(){
	static sendtext:=[]
	keep:=v.edit.gettext()
	text:=keep.2
	keep:=keep.1
	send:
	tt:=TV_GetSelection()
	for a,b in [tt,TV_GetParent(tt)]
	if sock:=socket.list[sul.ssn("//*[@tv='" b "']/ancestor-or-self::*/@socket").text]
	break
	TV_GetText(channel,tt),char:=SubStr(channel,1,1)
	channel:=char="@"||char="+"?SubStr(channel,2):channel
	if !(sock.socket){
		server:=TVGetText(tt)
		if settings.ssn("//server[@name='" server "']")
		return connect()
		return m("please select at least a server")
	}
	if !text
	return
	v.edit.2004
	if (SubStr(text,1,1)!="/"){
		if (channel=""){
			if InStr(text,"`r`n"){
				sss:=sul.ssn("//*[@tv='" tt "']/@sc").text
				sc:=s.ctrl[sss]
				v.multi:={chan:channel,user:sock.user,text:text,sock:sock,raw:keep,sc:sc}
				settimer,multi,On
			}else{
				display({chan:channel,user:sock.user,text:text,raw:keep},sock)
				sock.sendtext(text)
			}
		}else{
			if InStr(text,"`r`n"){
				sss:=sul.ssn("//*[@tv='" tt "']/@sc").text
				sc:=s.ctrl[sss]
				v.multi:={chan:channel,user:sock.user,text:text,sock:sock,pre:"PRIVMSG " channel " :",raw:keep,sc:sc}
				SetTimer,multi,On
			}else{
				display({chan:channel,user:sock.user,text:text,raw:keep},sock)
				sock.sendtext("PRIVMSG " channel " :" text)
			}
		}
	}else{
		info:=StrSplit(text," ")
		if (info.1="/msg"||info.1="/m"){
			return sock.sendtext("PRIVMSG " info.2 " :" compile(info,2))
		}else if (info.1="/n"||info.1="/nick"){
			return sock.sendtext("NICK " info.2)
		}else if (info.1="/nn"){
			return sock.sendtext("NAMES #maestrith")
		}else if (info.1="/me"){
			pre:="PRIVMSG " channel " :" 
			text:=chr(1) "ACTION " compile(info,1) chr(1)
			sock.sendtext(pre text)
		}else if (info.1="/deop"){
			return sock.sendtext("MODE " channel " -o " info.2)
		}else if (info.1="/op"){
			return sock.sendtext("MODE " channel " +o " info.2)
		}else if (info.1="/topic"){
			return sock.sendtext("TOPIC " channel " " compile(info,1))
		}else if (info.1="/j"||info.1="/join"){
			chan:=SubStr(info.2,1,1)="#"?info.2:"#" info.2
			v.autojoin:=chan
			return sock.sendtext("JOIN " chan)
		}else if (info.1="/p"||info.1="/part"){
			ch:=info.2?info.2:channel,ms:=info.3?compile(info,2):""
			return sock.sendtext("PART " ch " " ms)
		}else if (info.1="/quit"||info.1="/q"){
			add.tv(TV_GetSelection()).Deletesock()
			return sock.sendtext("QUIT :" compile(info,1))
		}else{
			text:=info.1 " not available yet."
		}
		display({chan:channel,user:sock.user,text:text,raw:keep},sock)
	}
	return
}
display(info,sock){
	static search:=Chr(1) "ACTION"
	text:=info.text
	if InStr(text,search){
		StringReplace,text,text,%search%,,All
		StringReplace,text,text,% Chr(1),,All
		un:="***" info.user
		ul:=StrLen(un)
		info.text:=un text
	}
	ff:=sul.ssn("//server[@socket='" sock.socket "']")
	if (info.chan){
		ff1:=ssn(ff,"descendant::channel[@name='" info.chan "']")
		if !ff1{
			ff1:=sul.under({under:ff,node:"channel",att:{name:info.chan,tv:TV_Add(info.chan,ssn(ff,"@tv").text,"Sort"),sc:new s(1,"cover").sc+0}})
			debug()
		}
	}
	disp:=ff1?ff1:ff
	tt:=ssn(disp,"@tv").text
	if (TV_GetSelection()!=tt)
	TV_Modify(tt,"bold")
	TV_Modify(tt,"Vis")
	main:=s.ctrl[ssn(disp,"@sc").text]
	move:=pos(main)
	message:=un||info.user=""?info.text:"<" info.user ">:" info.text
	message:=main.2006?"`r`n" message:message
	ttt:=""
	ttt:=info.raw?info.raw:message
	main.2171(0)
	while,(message){
		StringLeft,asdf,message,50
		StringTrimLeft,message,message,50
		length:=VarSetCapacity(flan,StrLen(asdf)),StrPut(asdf,&flan,"utf-8")
		DllCall(main.fn,"Ptr",main.ptr,"UInt",2003,int,main.2006,uint,&flan,"Cdecl")
	}
	main.2171(1)
	if (move){
		v.move[main]:=1
		SetTimer,bottom,10
	}
	return
	bottom:
	SetTimer,bottom,Off
	for a,b in v.move
	a.2629
	v.move:=[]
	return
}
pos(main){
	size:=VarSetCapacity(info,52),NumPut(size,info,0),NumPut(0x7,info,4)
	work:=DllCall("GetScrollInfo","uptr",main.sc,"uint",1,"uptr",&info)
	total:={max:NumGet(info,12),page:NumGet(info,16),pos:NumGet(info,20)}
	return total.move:=total.page+total.pos<total.max?0:1
}
class s{
	static ctrl:=[],lc:=""
	__New(window="",pos="",skipts="",makehwnd=""){
		static int
		if !init
		DllCall("LoadLibrary","str","scilexer.dll"),init:=1
		if InStr(pos,"channel")
		pos:="x170 ym w500 h500 Hidden"
		else if InStr(pos,"cover")
		pos:="x170 ym w500 h500 Hidden"
		win:=window?window:1
		tabstop:=skipts?"":"-TabStop"
		Gui,%win%:Add,custom,classScintilla hwndsc %pos% +1387331584 gnotify %tabstop%
		this.sc:=sc,s.ctrl[sc]:=this,t:=[]
		for a,b in {fn:2184,ptr:2185}
		this[a]:=DllCall("SendMessageA","UInt",sc,"int",b)
		for a,b in [[2563,1],[2565,1],[2614,1],[2402,0x15,75],[2171,1],[2660,1],[2056,0,"Consolas"],[2268,1],[2037,65001]]
		this[b.1](b.2,b.3)
		if makehwnd
		hwnd(makehwnd,sc)
		resize()
		return this
	}
	__Get(x*){
		return DllCall(this.fn,"Ptr",this.ptr,"UInt",x.1,int,0,int,0,"Cdecl")
	}
	__Call(code,lparam=0,wparam=0){
		if (code="remove"){
			s.ctrl.remove(this.hwnd)
			DllCall("DestroyWindow",uptr,this.hwnd)
		}
		if (code="addtext"){
			this.2171(0),VarSetCapacity(text,StrLen(wparam)),StrPut(wparam,&text,"utf-8")
			DllCall(this.fn,"Ptr",this.ptr,"uInt",2003,int,lparam,uptr,&text,"cdecl")
			this.2171(1)
		}else if (code="settext"){
			this.2171(0),this.2181(0,lparam),this.2171(1)
		}else if (code="getseltext"){
			VarSetCapacity(text,this.2161),length:=this.2161(0,&text)
			return StrGet(&text,length,"cp0")
		}else if (code="textrange"){
			VarSetCapacity(text,abs(lparam-wparam)),VarSetCapacity(textrange,12,0),NumPut(lparam,textrange,0),NumPut(wparam,textrange,4),NumPut(&text,textrange,8)
			this.2162(0,&textrange)
			return strget(&text,"","cp0")
		}else if (code="gettext"){
			cap:=VarSetCapacity(text,vv:=this.2182),this.2182(vv,&text)
			return [StrGet(&text),StrGet(&text,vv,"utf-8")]
		}
		wp:=(wparam+0)!=""?"Int":"AStr"
		if wparam.1
		wp:="AStr"
		if wparam=0
		wp:="int"
		return DllCall(this.fn,"Ptr",this.ptr,"UInt",code,int,lparam,wp,wparam,"Cdecl")
	}
}
checkfiles(){
	if !FileExist("scilexer.dll"){
		SplashTextOn,,,Downloading Required Files,Please Wait...
		urldownloadtofile,http://www.maestrith.com/files/AHKStudio/SciLexer.dll,SciLexer.dll
	}
	SplashTextOff
}
notify(){
	notify:
	Critical
	info:=A_EventInfo,con:=NumGet(info+0)
	sc:=s.ctrl[con]
	if !sc
	return
	fn:=[]
	for a,b in {0:"Obj",2:"Code",4:"ch",7:"text",6:"modType",9:"linesadded",8:"length",3:"position"}
	fn[b]:=NumGet(Info+(A_PtrSize*a))
	word:=sc.2267(sc.2008,1)-sc.2266(sc.2008,1)
	/*
		if (fn.code=2001&&fn.ch=33){
			ControlSend,Scintilla2,{BackSpace},% hwnd([1])
			sc.2100(0,"(?°?°)????? ----¯\_(?) ?????(`?´)????? ---?(º_º?) (????)?????")
		}
	*/
	if (fn.code=2001&&sc.2102=0&&word>1){
		
		sc.2100(2,"flan flap flip") ;nicknames here
	}
	if (fn.code=2018&&sc.sc=v.edit.sc){
		Resize()
	}
	/*
		if (fn.code=2004)
		ControlFocus,Edit1,% hwnd([1])
		if (fn.code=2016){
			;ss:=find(tv1.getselection()).obj.att
			;scin:=ss.sc
			;this:=scin
			;VarSetCapacity(text,this.2161),length:=this.2161(0,&text)
			;flan:=StrGet(&text,length,"utf-8")
			;m(this.2161,length,StrGet(&text,length,cp0),flan,StrGet(text,cp0),"fart")
			;return
			line:=sc.2166(fn.position)
			
			
			VarSetCapacity(text,sc.2350(line)),text:=sc.2153(line,&line)
			t(StrGet(&line,length,cp0))
		}
		if (fn.code=2017){
			t()
		}
	*/
	return
}
class xml{
	keep:=[]
	__New(param*){
		root:=param.1,file:=param.2
		file:=file?file:root ".xml"
		temp:=ComObjCreate("MSXML2.DOMDocument"),temp.setProperty("SelectionLanguage","XPath")
		this.xml:=temp
		ifexist %file%
		temp.load(file),this.xml:=temp
		else
		this.xml:=this.CreateElement(temp,root)
		this.file:=file
		xml.keep[root]:=this
	}
	CreateElement(doc,root){
		return doc.AppendChild(this.xml.CreateElement(root)).parentnode
	}
	search(node,find,return=""){
		found:=this.xml.SelectNodes(node "[contains(.,'" RegExReplace(find,"'","')][contains(.,'") "')]")
		while,ff:=found.item(a_index-1)
		if (ff.text=find){
			if return
			return ff.SelectSingleNode("../" return)
			return ff.SelectSingleNode("..")
		}
	}
	lang(info){
		info:=info=""?"XPath":"XSLPattern"
		this.xml.temp.setProperty("SelectionLanguage",info)
	}
	unique(info){
		if (info.check&&info.text)
		return
		if info.under{
			if info.check
			find:=info.under.SelectSingleNode("*[@" info.check "='" info.att[info.check] "']")
			if info.Text
			find:=this.cssn(info.under,"*[text()='" info.text "']")
			if !find
			find:=this.under({under:info.under,att:info.att,node:info.path})
			for a,b in info.att
			find.SetAttribute(a,b)
		}
		else
		{
			if info.check
			find:=this.ssn("//" info.path "[@" info.check "='" info.att[info.check] "']")
			else if info.text
			find:=this.ssn("//" info.path "[text()='" info.text "']")
			if !find
			find:=this.add({path:info.path,att:info.att,dup:1})
			for a,b in info.att
			find.SetAttribute(a,b)
		}
		if info.text
		find.text:=info.text
		return find
		;can have EITHER info.check or info.text, not both
	}
	add(info){
		path:=info.path,p:="/",dup:=this.ssn("//" path)?1:0
		if next:=this.ssn("//" path)?this.ssn("//" path):this.ssn("//*")
		Loop,Parse,path,/
		last:=A_LoopField,p.="/" last,next:=this.ssn(p)?this.ssn(p):next.appendchild(this.xml.CreateElement(last))
		if (info.dup&&dup)
		next:=next.parentnode.appendchild(this.xml.CreateElement(last))
		for a,b in info.att
		next.SetAttribute(a,b)
		if info.text!=""
		next.text:=info.text
		return next
	}
	find(info){
		if info.att.1&&info.text
		return m("You can only search by either the attribut or the text, not both")
		search:=info.path?"//" info.path:"//*"
		for a,b in info.att
		search.="[@" a "='" b "']"
		if info.text
		search.="[text()='" info.text "']"
		current:=this.ssn(search)
		return current
	}
	under(info){
		new:=info.under.appendchild(this.xml.createelement(info.node))
		for a,b in info.att
		new.SetAttribute(a,b)
		new.text:=info.text
		return new
	}
	ssn(node){
		return this.xml.SelectSingleNode(node)
	}
	sn(node){
		return this.xml.SelectNodes(node)
	}
	__Get(x=""){
		return this.xml.xml
	}
	transform(){
		static
		if !IsObject(xsl){
			xsl:=ComObjCreate("MSXML2.DOMDocument")
			style=
			(
			<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
			<xsl:template match="@*|node()">
			<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:for-each select="@*">
			<xsl:text></xsl:text>
			</xsl:for-each>
			</xsl:copy>
			</xsl:template>
			</xsl:stylesheet>
			)
			xsl.loadXML(style),style:=null
		}
		this.xml.transformNodeToObject(xsl,this.xml)
	}
	save(x*){
		if x.1=1
		this.Transform()
		filename:=this.file?this.file:x.1.1
		file:=fileopen(filename,"rw")
		file.seek(0)
		file.write(this.xml.xml)
		file.length(file.position)
	}
	remove(rem){
		if !IsObject(rem)
		rem:=this.ssn(rem)
		rem.ParentNode.RemoveChild(rem)
	}
	ea(path){
		list:=[]
		if !IsObject(path)
		nodes:=this.sn(path "/@*")
		else
		nodes:=sn(path,"@*")
		while,n:=nodes.item(A_Index-1)
		list[n.nodename]:=n.text
		return list
	}
	easyatt(path){
		list:=[]
		if nodes:=path.nodename
		nodes:=path.SelectNodes("@*")
		else if path.text
		nodes:=this.sn("//*[text()='" path.text "']/@*")
		else
		for a,b in path
		nodes:=this.sn("//*[@" a "='" b "']/@*")
		while,n:=nodes.item(A_Index-1)
		list[n.nodename]:=n.text
		return list
	}
}
ssn(node,path){
	return node.SelectSingleNode(path)
}
sn(node,path){
	return node.SelectNodes(path)
}
connect(server=""){
	connect:
	if !(server){
		if (TV_GetParent(TV_GetSelection())=v.serverlist)
		server:=TVGetText(TV_GetSelection())
		else
		return
	}
	ea:=settings.ea("//server/server[@name='" server "']")
	if !server
	if !(ea.user&&ea.name)
	return m("Please select a server")
	for a,b in s.Ctrl
	if (a!=v.edit.sc)
	WinHide,% "ahk_id" a
	sock:=new socket(ea.name,ea.port)
	if (sock.socket=-1)
	return m("Unable to connect")
	sock.user:=ea.user
	root:=TV_Add(ea.name,v.connected,"bold")
	sul.add({path:"server",att:{socket:sock.socket,server:ea.name,sc:new s(1,"cover").sc+0,tv:root},dup:1})
	TV_Modify(root,"Select Vis Focus")
	CoordMode,ToolTip,Screen
	debug()
	sock.sendtext("PASS " ea.password)
	sock.sendtext("NICK " ea.user)
	sock.Sendtext("USER " ea.user " 0 * :" ea.user)
	tv1.Modify(root,"Vis Select Focus")
	return
}
populateservers(){
	if !v.serverlist{
		serv:=settings.sn("//server/*")
		if (serv.length=0){
			settings.add({path:"server/server",att:{name:"irc.freenode.net",port:6667,user:A_UserName,password:""}})
			serv:=settings.sn("//server/*")
		}
	}
	v.serverlist:=TV_Add("Server List")
	v.addserver:=TV_Add("Add Server","","bold")
	v.helptv:=TV_Add("Help","","bold")
	while,ss:=serv.item[A_Index-1]{
		if !ssn(ss,"@name").text
		continue
		srvr(ss)
	}
	TV_Modify(v.serverlist,"Expand")
}
servers(){
	servers:
	if (A_GuiEvent="*")
	return
	if (A_GuiEvent="Normal"&&A_EventInfo=v.addserver)
	return add_server()
	if (A_EventInfo=v.helptv){
		for a,b in s.ctrl
		WinHide,ahk_id%a%
		WinShow,% hwnd(["help"])
		resize()
	}
	if (A_GuiEvent="K"&&A_EventInfo=46){
		ei:=TV_getselection(),item:=srvrlist.ssn("//*[@tv='" ei "']")
		if (item.nodename="server"){
			MsgBox,292,Delete Server,% "Are you sure you want to delete " ssn(item,"@name").text "?"
			IfMsgBox,No
			return
			rem:=settings.ssn("//server[@name='" ssn(item,"@name").text "']")
			TV_Delete(ei),rem.ParentNode.RemoveChild(rem)
		}
		if (item.nodename="channel"){
			channame:=item.text
			parent:=ssn(item,"ancestor::server")
			rem:=settings.ssn("//server[@name='" ssn(parent,"@name").text "']/*[text()='" channame "']")
			TV_Delete(ei),rem.ParentNode.RemoveChild(rem)
			return
		}
		return
	}else if (A_GuiEvent="K"){
		return
	}
	find:=srvrlist.ssn("//*[@tv='" A_EventInfo "']")
	if (find.xml){
		if (A_GuiEvent="Normal"&&find.nodename="value"){
			ei:=A_EventInfo,list:={name:"Server",password:"Password",user:"Username",port:"Port"}
			name:=ssn(find,"ancestor::server/@name").text
			top:=settings.ssn("//server[@name='" name "']"),node:=ssn(find,"@name").text
			InputBox,value,% "Input a new value for " node,% "New Value for " node,,,,,,,,% ssn(top,"@" node).text
			if ErrorLevel
			return
			text:=node="password"?RegExReplace(value,".","*"):value
			TV_modify(ei,"",list[node] ": " text)
			ssn(top,"@" node).text:=value
		}
		if (A_GuiEvent="rightclick"&&find.nodename="channels"){
			srvr:=settings.ssn("//server[@name='" ssn(find,"ancestor::server/@name").text "']")
			InputBox,channel,Add Channel,Enter the name of a channel or space separated list of channels you would like to auto-join
			if ErrorLevel
			return
			for a,channel in StrSplit(channel," "){
				channel:=InStr(channel,"#")?channel:"#" channel
				settings.under({under:srvr,node:"channel",text:channel})
				TV_add(channel,A_EventInfo)
			}
		}
		return
	}
	if flan:=sul.ssn("//*[@tv='" A_EventInfo "']"){
		if sc:=ssn(flan,"@sc").text{
			WinGet,style,style,% "ahk_id" sc
			if (style&0x10000000)
			return
			TV_modify(A_EventInfo,"-bold")
			for a,b in s.ctrl{
				WinGet,style,style,% "ahk_id" a
				if (style&0x10000000&&a!=v.edit.sc)
				WinHide,% "ahk_id" a
			}
			WinShow,ahk_id%sc%
		}
	}
	return
}
/*
	class tv{
		static tracker:=[]
		__New(info){
			static count:=0
			count++
			win:=info.win?info.win:1,hwnd:=info.hwnd
			this.tracker[hwnd]:=this,this.win:=win,this.hwnd:=hwnd
			tv[count]:=this
			return this
		}
		__Call(x*){
			if !IsFunc(tv[x.1]){
				this.Default()
				info:="tv_" x.1
				if !x.2
				return %info%()
				if (x.3=""&&x.4="")
				return %info%(x.2)
				if (x.2&&x.3&&x.4="")
				return %info%(x.2,x.3)
				return %info%(x.2,x.3,x.4)
			}
		}
		item(item){
			WinGetPos,x,y,w,h,% "ahk_id" this.hwnd
			t(x,y)
			VarSetCapacity(rect,16),NumPut(item,rect),info:=[]
			SendMessage,% 0x1100+4,1,&rect,,% "ahk_id" this.hwnd
			for a,b in {t:4,b:12,l:0,r:8}
			info[a]:=NumGet(rect,b)
			info.t+=y,info.b+=y
			return info
		}
		gettext(item){
			this.default()
			TV_GetText(text,item)
			return text
		}
		Default(){
			Gui,% this.win ":Default"
			Gui,% this.win ":TreeView",% this.hwnd
		}
		Redraw(x=0){
			oo:=x?"+":"-"
			GuiControl,% this.win ":" oo "Redraw",% this.hwnd
		}
	}
*/
compile(info,index){
	for a,b in info
	if (A_Index>index)
	message.=b " "
	return Trim(message)
}
help(sc){
	help=
	(
	Selecting a server from the server list and pressing enter will connect to that server
	Right clicking on a servers "Channels" entry will allow you to add auto-join channels to the list
	
	F1: Show/Hide the Servers window
	F2: Toggle the caption
	F3: Jump to a channel with a new message in it
	
	Commands:
	-/j or /join <channel> joins a channel
	-/p or /part while in a channel will part the channel. adding the channel name will part a channel
	-/m or /msg <user> sends a private message to <user>
	-/q or /quit quits whatever server you have selected (channel, or server)
	
	
	License for Scintilla and SciTE
	
	Copyright 1998-2002 by Neil Hodgson <neilh@scintilla.org>
	
	All Rights Reserved 
	
	Permission to use, copy, modify, and distribute this software and its 
	documentation for any purpose and without fee is hereby granted, 
	provided that the above copyright notice appear in all copies and that 
	both that copyright notice and this permission notice appear in 
	supporting documentation. 
	
	NEIL HODGSON DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS 
	SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY 
	AND FITNESS, IN NO EVENT SHALL NEIL HODGSON BE LIABLE FOR ANY 
	SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
	WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
	WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER 
	TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE 
	OR PERFORMANCE OF THIS SOFTWARE. 
	)
	StringReplace,help,help,`t,,All
	sc.settext(help)
}
add_server(){
	InputBox,server,Server Address,Server Address
	if !server
	return
	if settings.ssn("//server/server[@name='" server "']")
	return m("Server already exists.")
	info:={name:Server,user:A_UserName,password:"",port:6667}
	if settings.ssn("//server/server[@name='" server "']")
	return m("Server already exists")
	ss:=settings.add({path:"server/server",att:info,dup:1})
	srvr(ss)
}
tab(){
	tab:
	hk:=A_ThisHotkey,ac:=v.edit.2102
	shift:=GetKeyState("Shift","P")?"+":""
	ControlGetFocus,Focus,% hwnd([1])
	if (ac&&hk!="Esc")
	return v.edit.2104
	if (InStr(hk,"tab")){
		if (Focus!="Scintilla2")
		ControlSend,%focus%,%shift%{Tab},% hwnd([1])
		if (Focus="scintilla2")
		ControlFocus,SysTreeView321,% hwnd([1])
		return
	}
	if (ac=0&&hk="Esc")
	ExitApp
	if (ac=1&&hk="Esc")
	v.edit.2101
	if (hk="Enter"&&ac=0&&Focus="Scintilla2")
	send()
	if (ac=0&&Focus="SysTreeView321"){
		if (srvrlist.ssn("//*[@tv='" TV_GetSelection() "']").nodename="server")
		connect()
	}
	return
}	
resize(a="",b="",c="",d=""){
	static pos:=[],width,height
	if (A_Gui=1||a=""){
		ch:=v.edit.2279(0)+5
		if b&0xffff
		width:=b&0xffff,height:=b>>16
		else
		VarSetCapacity(size,16,0),DllCall("user32\GetClientRect","uint",hwnd(1),"uint",&size),width:=NumGet(size,8),height:=NumGet(size,12)
		if height{
			WinGet,style,style,% hwnd([100])
			left:=(style&0x10000000)?158:0
			ControlMove,,,,,height-v.caption-ch+20,% hwnd([100])
			for c,d in s.Ctrl{
				if (c=v.edit.sc)
				ControlMove,,,height+v.size-ch+5,width,%ch%,ahk_id%c%
				else
				ControlMove,,left,,width-left+7,height-v.caption-ch+20,ahk_id%c%
			}
		}
		sleep,10
	}
}
srvr(ss){
	static info:={name:"Server",user:"Username",password:"Password",port:"Port"}
	root:=TV_Add(ssn(ss,"@name").text,v.serverlist)
	top:=srvrlist.add({path:"server",att:{tv:root,name:ssn(ss,"@name").text},dup:1})
	for a,b in xml.easyatt(ss){
		b:=a="password"?RegExReplace(b,".","*"):b
		child:=TV_Add(info[a] ": " b,root)
		srvrlist.under({under:top,node:"value",att:{name:a,tv:child},text:b})
	}
	chan:=sn(ss,"*")
	channels:=TV_Add("Channels",root)
	chz:=srvrlist.under({under:top,node:"channels",att:{tv:channels}})
	while,cc:=chan.item[A_Index-1]
	cha:=TV_Add(cc.text,channels),srvr.chan(cha),srvrlist.under({under:chz,node:"channel",att:{tv:cha},text:cc.text})
	Loop,2
	srvrlist.Transform()
	debug(srvrlist)
}
class add{
	static k:=[]
	__New(info){
		
	}
}
/*
	__New(info){
		for a,b in info
		this[a]:=b
		;cross reference stuff added here eg sock=tv&&tv:=sock
		this.k["|" info.tv]:=this
		this.k["|" info.path]:=this
	}
	swap(new){
		old:=this.chan
		this.chan:=new
		this.path:="|" this.sock.socket "/" new
		this.k["|" this.sock.socket "/" new]:=this
		this.k.remove("|" this.sock.socket "/" old)
	}
	Deletesock(){
		main:=this.k.main["|" this.sock.socket]
		for a,b in main
		TV_Delete(b.tv),this.k.remove("|" b.tv),this.k.remove(b.path)
		this.k.main.remove("|" this.sock.socket)
	}
	get(info){
		return add.k["|" info]
	}
	tv(info){
		return add.k["|" info]
	}
	Deletechan(){
		if !this.chan
		return
		flan:=this.k[this.sock.socket "/" this.chan]
		TV_delete(flan.tv)
		this.k.tv.remove(flan.tv)
		this.k.remove(this.sock.socket "/" this.chan)
	}
*/
/*
	Usage:
	-info:=add.k[(tv or path(sock||sock/chan))] gets the object
	info.tv would be the treeview
	info.sock would be the socket
*/
class users{
	static userlist:=[]
	__New(sock,chan,user){
		if !user
		return
		
	}
	get(info){
		;return users.userlist["|" info]
	}
	swap(sock,old,new){
		/*
			tt:=add.k["|" sock.socket "/" old]
			add.k["|" sock.socket "/" new]:=tt
			tt.chan:=new
			tv1.modify(tt.tv,"bold",new)
			for a,b in users.get(sock.socket "/" old){
				parent:=tv1.getparent(b.tv)
				tv1.delete(b.tv)
				new users(sock,b.chan,new,parent)
			}
			this.userlist.remove("|" sock.socket "/" old)
		*/
	}
	/*
		__Delete(){
			t("Delete")
		}
	*/
	part(sock,chan,user){
		/*
			top:=users.get(sock.socket "/" user)
			for a,b in top
			if (b.chan=chan){
				tv1.Delete(b.tv)
				top.remove(a)
			}
		*/
	}
}
emote(){
	v.edit.2100(0,"(?°?°)????? ----¯\_(?) ?????(`?´)????? ---?(º_º?) (????)?????")
}
debug(info=""){
	if !hwnd(99){
		Gui,99:Destroy
		Gui,99:+hwndhwnd
		hwnd(99,hwnd)
		Gui,99:Add,Edit,w460 h500 -Wrap
		Gui,99:Show,x0 y0 NA,Debug
	}
	iii:=info?info:sul
	Loop,2
	iii.Transform()
	ControlSetText,Edit1,% iii[],% hwnd([99])
	return
	99GuiEscape:
	ExitApp
	return
}
/*
	class nickkeep{
		add(sock,nick,channel){
			top:=sul.ssn("//server[@socket='" sock.socket "']")
			chan:=ssn(top,"descendant::*[@name='" channel "']")
			root:=sul.under({under:chan,node:"user",att:{name:nick,tv:TV_Add(nick,ssn(chan,"@tv").text,"Sort")}})
			if (SubStr(nick,1,1)="@")
			root.SetAttribute("operator",1)
			if (SubStr(nick,1,1)="+")
			root.SetAttribute("voice",1)
			sock.nicklist[nick]:=tv
			debug()
		}
		bulk(sock,lll,channel){
			if !channel
			return
			for nick in lll[sock.socket,channel]{
				if channel
				nickkeep.add(sock,nick,channel)
			}
		}
	}
*/
caption(){
	SysGet,Caption,4
	v.cc:=v.cc?0:1,v.size:=v.cc?caption:0
	pm:=v.cc?"+":"-",mp:=pm="+"?"-":"+"
	Gui,1:%pm%Caption %mp%AlwaysOnTop
}
hide(){
	WinGet,style,style,% hwnd([100])
	if (style&0x10000000)
	WinHide,% hwnd([100])
	else
	WinShow,% hwnd([100])
	Resize()
}
setglobal(){
	SysGet,Caption,4
	v.cc:=1
	v.size:=v.caption:=caption
}
unread(){
	list:=sul.sn("//@tv")
	while,next:=list.item[A_Index-1]{
		if (ssn(next,"..").nodename="server")
		continue
		if TV_Get(next.text,"bold"){
			TV_Modify(next.text,"Vis Focus Select")
			break
		}
	}
	servers()
}
TVGetText(info){
	TV_GetText(text,info)
	return text
}
multi:
multi()
return
multi(){
	SetTimer,Multi,Off
	for a,b in v.multi
	%a%:=b
	CoordMode,ToolTip,Relative
	for a,b in StrSplit(text,"`r`n"){
		ToolTip,% "Please wait... Sending :" b,0,0
		sock.sendtext(pre b)
		display({chan:chan,user:user,text:b},sock)
		sc.2629
		sleep,450
	}
	t()
	return
}