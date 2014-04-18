<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<%@page import="OracleConnect.SQLRequest" import="OracleConnect.SQLRequest_1" import="OracleConnect.OracleConnect" import="java.util.*"%>
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
<title>Ваши изделия</title>
<%
//массив доверенных лиц
ArrayList<String> TrustedUsers = new ArrayList<String>();
String URL = "";
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
//--------------------------------------------------------------------------------
//ФОРМИРУЕМ МАССИВ ЛИЦ ИМЕЮЩИХ ДОСТУП
//--------------------------------------------------------------------------------
TrustedUsers.add(FULLNAME);
sql.GetUsersHaveAcces(SessionUser);
while(sql.rs.next()){
	if(sql.rs.getString("FULLNAME") != null) TrustedUsers.add(sql.rs.getString("FULLNAME"));
}
//--------------------------------------------------------------------------------
%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>Ваши изделия</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<br>
	<%
	out.println("<table border=1 style=\"width: 800px\" align=center>");
    out.println("  <tr bgcolor=\"#C0C0C0\">");
    out.println("    <td>Обозначение</td>");
    out.println("    <td>Действия</td>");
    out.println("    <td>Наименование</td>");
    out.println("    <td>Ответственный</td>");
    out.println("  </tr>");
    sql.GetProductList();
    while(sql.rs.next()){
    	if(TrustedUsers.contains(sql.rs.getString("FULLNAME"))){
    		//заменяем в строках наименование и обозначение пробеелы на спецсимволы
 			out.println("  <tr bgcolor=\"white\">");
 			out.println("    <td>");
 			out.println("    <a href=\"index.jsp?SelectedItem=" + URLEncoder.encode(sql.rs.getString("OBOZNACHENIE"),"windows-1251")  + "\">" + sql.rs.getString("OBOZNACHENIE") + "</a>");
 			out.println("    </td>");
 			out.println("    <td>");
 			if(sql.rs.getString("FULLNAME").equals(FULLNAME)){
	 			URL = "edit_product.jsp?";
	 			URL += "SelectedItem=" + URLEncoder.encode(SelectedItem,"windows-1251");
	 			URL += "&OBOZ=" + URLEncoder.encode(sql.rs.getString("OBOZNACHENIE"),"windows-1251");
	 			URL += "&NEWOBOZ=" + URLEncoder.encode(sql.rs.getString("OBOZNACHENIE"),"windows-1251");
	 			URL += "&NAIM=" + URLEncoder.encode(sql.rs.getString("NAIMENOVANIE"),"windows-1251");
	 			URL += "&NEWFULLNAME=" + URLEncoder.encode(sql.rs.getString("FULLNAME"),"windows-1251");
	 			out.println("	 <a href=\"" + URL + "\"><img src=\"images/edit.png\" border=0 width=24 height=24 title=\"Редактирование\"></img></a>");
	 			URL = "Delete.jsp?SelectedItem=" + SelectedItem + "&OBOZ=" + sql.rs.getString("OBOZNACHENIE");
	 			out.println("	 <a href=\"" + URL + "\"><img src=\"images/delete.png\" border=0 width=24 height=24 title=\"Удаление\"></img></a>");
 			}
 			out.println("    </td>");
 			out.println("    <td><a href=\"index.jsp?SelectedItem=" + URLEncoder.encode(sql.rs.getString("OBOZNACHENIE"),"windows-1251")  + "\">" + sql.rs.getString("NAIMENOVANIE") + "</a></td>");
 			out.println("    <td>" + sql.rs.getString("FULLNAME") + " </td>");
			out.println("  </tr>");	
    	}
    }
    out.println("</table>");
    sql.Disconnect();
	%>
</body>
</html>