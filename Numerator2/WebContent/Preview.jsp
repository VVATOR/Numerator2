<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css" title="currentStyle">
	@import "css/demo_page.css";
	@import "css/demo_table.css";
</style>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<title>Просмотр через Product View Express</title>
<%
String SessionUser = "";
if(session.getAttribute("SessionUser") != null) SessionUser = session.getAttribute("SessionUser").toString();			//пользователь сессии
String FULLNAME = "";
if(session.getAttribute("FULLNAME") != null) FULLNAME = session.getAttribute("FULLNAME").toString();					//ФИО
String DEPARTMENT = "";
if(session.getAttribute("DEPARTMENT") != null) DEPARTMENT = session.getAttribute("DEPARTMENT").toString();				//Отдел
String SelectedItem="";
if(request.getParameter("SelectedItem") != null)
	 SelectedItem = new String (request.getParameter("SelectedItem").getBytes("ISO-8859-1"));
String FILENAME="";
if(request.getParameter("FILENAME")!=null){//наименование изделия
	FILENAME = new String(request.getParameter("FILENAME").getBytes("ISO-8859-1"));
}
%>
</head>
<body id="dt_example"  background="images/background.png">
<div class="full_width big" align=center>Просмотр через Product View Express</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
<br><br>
<div>
	<object classid="clsid:F07443A6-02CF-4215-9413-55EE10D509CC" id="pview1" width="1280" height="1024">
	<%
	out.println("<param name=\"sourceurl\" value=\"" + FILENAME + "\">");
	 %>
	<param name="edurl" value>
	<param name="mapurl" value>
	<param name="urltemplate" value>
	<param name="getmarkupurl" value>
	<param name="viewableoid" value>
	<param name="uiconfigurl" value>
	<param name="thumbnailView" value>
	<param name="pvt" value>
	<param name="img" value>
	<param name="renderatstartup" value>
	<param name="urlbase" value>
	<param name="modifymarkupurl" value>
	<param name="username" value>
	<param name="useremail" value>
	<param name="usertelno" value>
	<param name="modifymarkupparam" value>
	<param name="backgroundcolor" value>
	<param name="viewingmode" value>
	<param name="helpurl" value>
	<param name="heading" value>
	<param name="renderannotation" value>
	<param name="renderviewable" value>
	<param name="edition" value>
	<param name="hosttype" value>
	<param name="configoptions" value>
	<param name="configurl" value>
	<param name="locParamNames" value>
	<param name="locParamValues" value>
	<param name="PVXConnectionID" value>
	<param name="saveurl" value>
	<param name="src" value>
	</object>
	</div>

</body>
</html>