SocketEvent(info*){
	if (info.3=0x9987){
		if (info.2&0xFFFF=1)
			debug("receive")
		if (info.2&0xffff=8)
			debug("accept")
		if (info.2&0xFFFF=32)
			debug("disconnect")
	}
}