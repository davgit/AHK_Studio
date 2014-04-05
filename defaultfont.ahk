defaultfont(){
	temp:=new xml("temp")
	info=
	(
	<fonts>
	<name>PlasticCodeWrap</name>
	<author>joedf</author>
	<font background="0x1D160B" bold="1" color="0xF8F8F2" font="Consolas" size="10" style="5" italic="0" strikeout="0" underline="0"/>
	<font background="0x36342E" style="33" color="0xECEEEE"/>
	<font style="0" color="0xF8F8F2"/>
	<font style="1" color="0xE09A1E" bold="0" font="Consolas" italic="1" size="10" strikeout="0" underline="0"/>
	<font style="2" color="0x833AFF"/>
	<font style="3" color="0x39E455"/>
	<font style="4" color="0xAFA600"/>
	<font style="11" color="0xE09A1E" bold="0" font="Consolas" italic="1" size="10" strikeout="0" underline="0"/>
	<font style="13" color="0x2929EF"/>
	<font style="15" color="0x2D8BAA"/>
	<font style="17" color="0x9A93EB"/>
	<font style="18" color="0x54B4FF"/>
	<font style="19" color="0x0000AE"/>
	<font style="21" color="0x400080"/>
	<font style="22" color="0x8000FF"/>
	<font style="37" color="0xff00ff"/>
	<font bool="1" code="2067" color="0xECE000"/>
	<font bool="1" code="2068" color="0x3D2E16"/>
	<font code="2069" color="0xFF8080"/>
	<font code="2098" color="0x583F11"/>
	<font code="2600" color="0x222222"/>
	<font code="2601" color="0xAFA600"/>
	<highlight>
	<list1 list="1">custom list</list1>
	</highlight>
	</fonts>
	)
	top:=settings.ssn("//settings")
	temp.xml.loadxml(info)
	tt:=temp.ssn("//*")
	top.appendchild(tt)
}