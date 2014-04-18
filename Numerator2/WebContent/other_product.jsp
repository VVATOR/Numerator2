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
<title>Изделия смежных разработчиков</title>
<%
SQLRequest sql = new SQLRequest();
String SessionUser = "";
if(session.getAttribute("SessionUser") != null) SessionUser = session.getAttribute("SessionUser").toString();			//пользователь сессии
String FULLNAME = "";
if(session.getAttribute("FULLNAME") != null) FULLNAME = session.getAttribute("FULLNAME").toString();					//ФИО
String DEPARTMENT = "";
if(session.getAttribute("DEPARTMENT") != null) DEPARTMENT = session.getAttribute("DEPARTMENT").toString();				//Отдел
String SelectedItem="";
if(request.getParameter("SelectedItem") != null)
	 SelectedItem = new String (request.getParameter("SelectedItem").getBytes("ISO-8859-1"));
%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>Изделия смежных разработчиков</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<br>
	<%
	out.println("<table border=1 style=\"width: 800px\" align=center>");
    out.println("  <tr bgcolor=\"#C0C0C0\">");
    out.println("    <td>Обозначение</td>");
    out.println("    <td>Наименование</td>");
    out.println("    <td>Ответственный</td>");
    out.println("  </tr>");
    sql.GetProductList();
    while(sql.rs.next()){
    	if(!sql.rs.getString("FULLNAME").equals(FULLNAME)){
    		//заменяем в строках наименование и обозначение пробеелы на спецсимволы
 			out.println("  <tr bgcolor=\"white\">");
 			out.println("    <td><a href=\"index.jsp?SelectedItem=" + URLEncoder.encode(sql.rs.getString("OBOZNACHENIE"),"windows-1251")  + "\">" + sql.rs.getString("OBOZNACHENIE") + "</td></a>");
 			out.println("    <td><a href=\"index.jsp?SelectedItem=" + URLEncoder.encode(sql.rs.getString("OBOZNACHENIE"),"windows-1251")  + "\">" + sql.rs.getString("NAIMENOVANIE") + " </td></a>");
 			out.println("    <td>" + sql.rs.getString("FULLNAME") + " </td>");
			out.println("  </tr>");	
    	}
    }
    out.println("</table>");
    sql.Disconnect();
	%>
</body>
</html>