<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<%@page import="OracleConnect.SQLRequest" import="OracleConnect.SQLRequest_1" import="OracleConnect.OracleConnect"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<style type="text/css" title="currentStyle">
	@import "css/demo_page.css";
	@import "css/demo_table.css";
</style>
<script type="text/javascript" language="JavaScript">
 function changeImg1(source)
 {  
	 document.pict1.src = source + '.PNG';
 };
</script>
<title>������� ������������� �������� � ������</title>
<%
String SelectedItem="";
if(request.getParameter("SelectedItem") != null)
	 SelectedItem = new String (request.getParameter("SelectedItem").getBytes("ISO-8859-1"));
%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>������� ������������� �������� � ������</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<br>
	<table border=1 width=800 align=center>
	  <tr bgcolor="#C0C0C0">
	    <td align=center>������</td>
	  </tr>
	  <tr bgcolor="#FFFAFA">
	    <td align=center>����������</td>
	  </tr>
	  <tr bgcolor="#FFFF00">
	    <td align=center>��������� �������</td>
	  </tr>
	  <tr bgcolor="#97FFFF">
	    <td align=center>������ �����</td>
	  </tr>
	  <tr bgcolor="#66CDAA">
	    <td align=center>������ � ��</td>
	  </tr>
	  <tr bgcolor="#FFBBFF">
	    <td align=center>�����-������</td>
	  </tr>
	  <tr bgcolor="#AB82FF">
	    <td align=center>����� - ����������</td>
	  </tr>
	  <tr bgcolor="#FFFACD">
	    <td align=center>����� - ���������</td>
	  </tr>
	  <tr bgcolor="#6495ED">
	    <td align=center>�����������</td>
	  </tr>
	  <tr bgcolor="#FF3030">
	    <td align=center>�������������</td>
	  </tr>
	</table>
</body>
</html>