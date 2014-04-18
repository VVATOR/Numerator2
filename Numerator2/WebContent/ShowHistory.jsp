<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="OracleConnect.SQLRequest"%>
<%@page import="java.text.DateFormat" import="java.util.Locale"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<title>История</title>
</head>
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
SQLRequest sql = new SQLRequest();
boolean first = false;
Locale local = new Locale("ru","RU");
DateFormat df = DateFormat.getDateInstance(DateFormat.DEFAULT, local);
%>
<body>
	<div align=center><font size=3 color="#6495ED"><%=FULLNAME%> Вы запросили историю изменений записи нумератора для  <%=SelectedItem%> </font>
	<br>
	<br>
	<%
	sql.GetStatisticByOboz(SelectedItem);
	while(sql.rs.next()){
		if(first == false){
			out.println("<table border=1>");
			out.println("<tr>");
			out.println("	<td>Дата</td>");
			out.println("	<td>Действие</td>");
			out.println("</tr>");
			first = true;
		}
		out.println("<tr>");
		out.println("	<td>" + df.format(sql.rs.getDate("DATE_OF_ACTION")) + "</td>");
		out.println("	<td align=left><font color=\"#6495ED\"><b>" + sql.rs.getString("USERNAME") + "</b> производил операцию <b>" + sql.rs.getString("ACTION") + "</b> для объекта <b>" + sql.rs.getString("OBOZ") + " (" + sql.rs.getString("NAIM") + ")</b>" + "</font></td>");
		out.println("</tr>");
	}
	if(first != false) out.println("</table>");
	else out.println("<font color=\"#FF0000\">Информация не найдена</font>");
	sql.Disconnect();
	%>
	</div>
</body>
</html>