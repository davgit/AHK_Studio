debug(info*){
	static socket:="",running:=""
	if (info.1="run"){
		debug("new")
		;sleep,200
		v.running:=info.2
		SetTimer,runit,50
	}
	if (info.1=0){
		for a,b in [10002,10003,10004]
			toolbar.list.10002.setstate(b,16)
		for a,b in [10000,10001]
			toolbar.list.10002.setstate(b,4)
	}
	if (info.1=1){
		for a,b in [10002,10003,10004]
			toolbar.list.10002.setstate(b,4)
		for a,b in [10000,10001]
			toolbar.list.10002.setstate(b,16)
	}
	if (info.1="new"){
		if (socket>0){
			debug("disconnect")
		}
		sock:=-1
		DllCall("LoadLibrary","str","ws2_32","ptr"),VarSetCapacity(wsadata,394+A_PtrSize)
		DllCall("ws2_32\WSAStartup","ushort",0,"ptr",&wsadata)
		DllCall("ws2_32\WSAStartup","ushort",NumGet(wsadata,2,"ushort"),"ptr",&wsadata)
		OnMessage(0x9987,"SocketEvent"),socket:=sock
		next:=debug("addrinfo"),sockaddrlen:=NumGet(next+0,16,"uint"),sockaddr:=NumGet(next+0,16+(2*A_PtrSize),"ptr")
		socket:=DllCall("ws2_32\socket","int",NumGet(next+0,4,"int"),"int",1,"int",6,"ptr")
		if (DllCall("ws2_32\bind","ptr",socket,"ptr",sockaddr,"uint",sockaddrlen,"int")!=0)
			return m(DllCall("ws2_32\WSAGetLastError")) ;,enable(debug("check"))
		DllCall("ws2_32\freeaddrinfo","ptr",next)
		debug("__eventProcRegister",socket,0x29)
		DllCall("ws2_32\listen","ptr",socket,"int",32)
		return socket
	}
	if (info.1="__eventProcRegister"){
		DllCall("ws2_32\WSAAsyncSelect","ptr",socket,"ptr",A_ScriptHwnd,"uint",0x9987,"uint",info.3)
	}
	if (info.1="addrinfo"){
		VarSetCapacity(hints,8*A_PtrSize,0)
		for a,b in {6:8,1:12}
			NumPut(a,hints,b)
		DllCall("ws2_32\getaddrinfo",astr,"127.0.0.1",astr,"9000","uptr",hints,"ptr*",results)
		return results
	}
	if (info.1="accept"){
		if ((sock:=DllCall("ws2_32\accept","ptr",socket,"ptr",0,"int",0,"ptr"))!=-1){
			socket:=sock
			debug("__eventProcRegister","newsock",0x21)
			return
		}
	}
	if (info.1="receive"){
		;Thank you Lexikos and fincs http://hkscript.org/download/tools/DBGP.ahk
		VarSetCapacity(buffer)
		while,DllCall("ws2_32\recv","ptr",socket,"char*",c,"int",1,"int",0){
			if c=0
				break
			length.=chr(c)
		}
		VarSetCapacity(packet,++length)
		received:=0
		While(received<length){
			r:=DllCall("ws2_32\recv","ptr",socket,"ptr",&packet+received,"int",length-received,"int",0)
			if (r<1)
				return m("An error occured",DllCall("GetLastError"))
			received += r
			sleep,100
		}
		info:=StrGet(&packet,"utf-8")
		if InStr(info,"init"){
			for a,b in v.breaks{
				debug("send","breakpoint_set -t line -n " b)
				sleep,200
			}
		}
		if (info)
			display(info)
	}
	if (info.1="send"){
		message:=info.2,message.=Chr(0),len:=strlen(message),VarSetCapacity(buffer,len)
		ll:=StrPut(info.2,&buffer,"utf-8")
		if (DllCall("ws2_32\send",uint,socket,uptr,&buffer,"int",ll,"int",0,"cdecl")<1&&A_ThisLabel="menu"){
			t("Currently there is no connection")
			sleep,500
			t()
		}
	}
	if (info.1="detach"){
		SetTimer,drop,10
		return
		drop:
		SetTimer,drop,Off
		debug("send","stderr -c 0")
		SetTimer,dropnext,500
		return
		dropnext:
		SetTimer,dropnext,Off
		debug("send","detach")
		SetTimer,droplast,500
		return
		droplast:
		SetTimer,droplast,off
		settimer,laster,500
		debug("disconnect")
		return
		laster:
		SetTimer,laster,Off
		hwnd({rem:99}),debug(0)
		return
	}
	if (info.1="disconnect"){
		DllCall("ws2_32\WSAAsyncSelect","uint",socket,"ptr",A_ScriptHwnd,"uint",0,"uint",0)
		DllCall("ws2_32\closesocket","uint",socket,"int")
		DllCall("ws2_32\WSACleanup"),socket:=""
		debug(0)
	}
	if (info.1="encode"){ ;original http://www.autohotkey.com/forum/viewtopic.php?p=238120#238120
		text:=info.2!=""?info.2:return
		cp:=0
		VarSetCapacity(rawdata,StrPut(text,"utf-8")),sz:=StrPut(text,&rawdata,"utf-8")-1
		DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"ptr",0,"uint*",cp)
		VarSetCapacity(str,cp*(A_IsUnicode?2:1))
		DllCall("Crypt32.dll\CryptBinaryToString","ptr",&rawdata,"uint",sz,"uint",0x40000001,"str",str,"uint*",cp)
		return str
	}
	if (info.1="decode"){ ;original http://www.autohotkey.com/forum/viewtopic.php?p=238120#238120
		string:=info.2!=""?info.2:return
		DllCall("Crypt32.dll\CryptStringToBinary","ptr",&string,"uint",StrLen(string),"uint",1,"ptr",0,"uint*",cp:=0,"ptr",0,"ptr",0) ;getsize
		VarSetCapacity(bin,cp)
		DllCall("Crypt32.dll\CryptStringToBinary","ptr",&string,"uint",StrLen(string),"uint",1,"ptr",&bin,"uint*",cp,"ptr",0,"ptr",0)
		return StrGet(&bin,cp,"utf-8")
	}
	if (info.1="check")
		return socket
}