﻿class xml{
	keep:=[]
	__New(param*){
		if !FileExist(A_ScriptDir "\lib")
			FileCreateDir,%A_ScriptDir%\lib
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
		found:=this.xml.SelectNodes(node "[contains(.,'" RegExReplace(find,"&","')][contains(.,'") "')]")
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
		file.write(this[])
		file.length(file.position)
	}
	remove(rem){
		if !IsObject(rem)
			rem:=this.ssn(rem)
		rem.ParentNode.RemoveChild(rem)
	}
	ea(path){
		list:=[]
		if nodes:=path.nodename
			nodes:=path.SelectNodes("@*")
		else if path.text
			nodes:=this.sn("//*[text()='" path.text "']/@*")
		else if !IsObject(path)
			nodes:=this.sn(path "/@*")
		else
			for a,b in path
				nodes:=this.sn("//*[@" a "='" b "']/@*")
		while,n:=nodes.item(A_Index-1)
			list[n.nodename]:=n.text
		return list
	}
}