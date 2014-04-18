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
<title>Автопростановка моделей CREO</title>
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
String Action = "";
if(request.getParameter("Action")!=null)//наименование изделия
	Action = new String(request.getParameter("Action").getBytes("ISO-8859-1"));
String NAIM = "";
if(request.getParameter("NAIM")!=null)//наименование изделия
	NAIM = new String(request.getParameter("NAIM").getBytes("ISO-8859-1"));
String OBOZ = "";
if(request.getParameter("OBOZ")!=null)//обозначение изделия
	OBOZ = new String(request.getParameter("OBOZ").getBytes("ISO-8859-1"));
%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>Автопростановка моделей CREO</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<%
		sql.GetProeModelsByLogin(SessionUser);
			if(!Action.equals("1")){
		//вывод данных
		out.println("<font color=\"#336699\"><H4> Произведен поиск моделей по пути \"M:\\\". Найдено: </H4></font>");
		out.println("<form action=\"Creo.jsp\" method=\"GET\">");
		out.println("<input type=hidden name=NAIM value="+NAIM+">");
		out.println("<input type=hidden name=OBOZ value="+OBOZ+">");
		out.println("<input type=hidden name=Action value=1>");
		out.println("<table align=\"center\" border=1>");
		out.println("<thead>");
		out.println("<tr bgcolor=\"#C0C0C0\" align=center>");
		out.println("<td width=\"300 px\">Обозначение</td>");
		out.println("<td width=\"200 px\">Наименование</td>");
		out.println("<td width=\"400 px\">Модель Pro/ENGINEER</td>");
		out.println("<td width=\"400 px\">Данные с сервера</td>");
		out.println("</tr>");
		out.println("</thead>");
		out.println("<tbody>");
		while(sql.rs.next()){
			if(!sql.rs.getString("PROENGINEER").equals(sql.rs.getString("PROE"))){
		out.println("  <tr bgcolor=\"white\">");
		out.println("    <td>" + sql.rs.getString("REPOBOZNACHENIE") + " </td>");
		out.println("    <td>" + sql.rs.getString("NAIMENOVANIE") + " </td>");
		out.println("    <td>" + sql.rs.getString("PROENGINEER") + " </td>");
		out.println("    <td>" + sql.rs.getString("PROE") + " </td>");
		out.println("  </tr>");
			}
		}
		out.println("</tbody>");
		out.println("</table>");
		out.println("<BR><input type=\"submit\" name=\"upload\" id=\"upload\" value=\"Заменить\">");
		out.println("<BR> После нажатия кнопки, на выполнение команды потребуется некоторое время. Ожидайте ответа сервера.");
		out.println("</form>");
			}else{
		SQLRequest_1 sql_1 = new SQLRequest_1();
		while(sql.rs.next()){
			sql_1.SetProeByID(sql.rs.getString("UNIQIDENTIFIER"),sql.rs.getString("PROE"));	
		}
		sql_1.Disconnect();
		//обновление данных
		out.println("<font color=\"#336699\"><H4> Пути к моделям Pro/ENGINEER успешно заменены на найденные. </H4></font>");
			}
			sql.Disconnect();
	%>	

</body>
</html>