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
<title>Поиск</title>
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
String SEARCH_OBOZ = "";
if(request.getParameter("SEARCH_OBOZ") != null)
	 SEARCH_OBOZ = new String (request.getParameter("SEARCH_OBOZ").getBytes("ISO-8859-1"));
%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>Поиск</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<form action="search.jsp" method="GET">
	  <% 
	   out.println("<font color=\"#336699\"><H4> Введите данные для поиска:  </H4></font>");
	   if(SEARCH_OBOZ.equals(""))
		   out.println("Обозначение либо часть обозначения: <input type=\"text\" size=\"60\" name=\"SEARCH_OBOZ\" /><br />");
	   else
		   out.println("Обозначение либо часть обозначения: <input type=\"text\" size=\"60\" name=\"SEARCH_OBOZ\" value=\"" + SEARCH_OBOZ + "\" /><br />");
	  %>
	  <input type="submit" value="Найти" />
	  <%
	   if(!SEARCH_OBOZ.equals("")){
		   //что-то задано для поиска формируем таблицу
		    out.println("<h4>Ваши изделия:</h4>");
		    out.println("<table border=1>");
		    out.println("  <tr bgcolor=\"#C0C0C0\">");
		    out.println("    <td>Обозначение</td>");
		    out.println("    <td>Наименование</td>");
		    out.println("    <td>Ответственный</td>");
		    out.println("    <td>Отдел</td>");
		    out.println("    <td>Первичаня применяемость</td>");
		    out.println("    <td>Статус</td>");
		    out.println("  </tr>");
		    //подклучаемся к базе и берем нужные данные
		    sql.Search(SEARCH_OBOZ);
		    while(sql.rs.next()){
		   		out.println("  <tr bgcolor=\"" + sql.rs.getString("COLOR") + "\">");	
		    	out.println("    <td>" + sql.rs.getString("FULLOBOZ") + " </td>");
		    	out.println("    <td>" + sql.rs.getString("NAIMENOVANIE") + " </td>");
		    	out.println("    <td>" + sql.rs.getString("FULLNAME") + " </td>");
		    	out.println("    <td>" + sql.rs.getString("DEPARTMENT") + " </td>");
		    	out.println("    <td>" + sql.rs.getString("PRIMENAETSA") + " </td>");
		    	out.println("    <td>" + sql.rs.getString("STATUS") + " </td>");
		    	out.println("  </tr>");
		    }
		    out.println("  </table>");
		    sql.Disconnect();
	   }
	  %>  
	</form>
</body>
</html>