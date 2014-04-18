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
<title>Замечания и предложения</title>
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
//получаем переданные параметры
String TEXT = "";
if(request.getParameter("TEXT") != null)
	 TEXT = new String (request.getParameter("TEXT").getBytes("ISO-8859-1"));
String TYPE = "";
if(request.getParameter("TYPE") != null)
	 TYPE = new String (request.getParameter("TYPE").getBytes("ISO-8859-1"));
String Action="";
if(request.getParameter("Action") != null)
	 Action = new String (request.getParameter("Action").getBytes("ISO-8859-1"));
//--------------------------------------
// Action = 1 - добавление предложения
//--------------------------------------
if(Action.equals("1")){
	 if(!TEXT.equals(""))
		if(!FULLNAME.equals("")) 
	  		sql.InsertUpdate(FULLNAME,TYPE,TEXT);
}
%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>Замечания и предложения</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem," windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<form action="BugTracker.jsp" method="GET">
	   <%
	    //видимые компоненты
	    out.println("<font color=\"#336699\"><H4> Введите Ваше предложение или отчет об ошибке и нажмите 'Отправить':  </H4></font>");
	    out.println("<select name=\"TYPE\" >");
	    out.println("<option selected title=\"Добавление новых возможностей\">Добавление возможностей</option>");
	    out.println("<option title=\"Редактирование существующих возможностей\">Редактирование существующих возможностей</option>");
	    out.println("<option title=\"Замечания по интерфесу программы\">Замечания по интерфейсу программы</option>");
	    out.println("<option title=\"Отчет о незначительной ошибке\">Отчет о незначительной ошибке</option>");
	    out.println("<option title=\"Отчет о критической ошибке\">Отчет о критической ошибке</option>");
	    out.println("<option title=\"Благодарность\">Благодарность</option>");
	    out.println("</select>");
	    out.println("Тип обращения к разработчикам<br />");
	    out.println("<input type=\"text\" size=\"90\" name=\"TEXT\"/> Текст обращения<br />");
	    //невидимые компоненты
	    out.println("<input type=\"text\" value=\"" + SessionUser + "\" name=\"SessionUser\" style=\"display: none;\" />"); 
	    out.println("<input type=\"text\" value=\"" + FULLNAME + "\" name=\"FULLNAME\" style=\"display: none;\" />"); 
	    out.println("<input type=\"text\" value=\"" + DEPARTMENT + "\" name=\"DEPARTMENT\" style=\"display: none;\" />");
	    //выполнить действие - добавление обращения
	    out.println("<input type=\"text\" value=\"1\" name=\"Action\" style=\"display: none;\" />"); 
	   %>
	   <input type="submit" value="Отправить" />
	  </form>
	  <HR>
	  <%
	  out.println("<h4>Все обращения:</h4>");
	  out.println("<table border=1>");
	  out.println("  <tr bgcolor=\"#C0C0C0\">");
	  out.println("    <td>От кого</td>");
	  out.println("    <td>Тип</td>");
	  out.println("    <td>Текст</td>");
	  out.println("    <td>Ответ разработчиков</td>");
	  out.println("  </tr>");
	  sql.GetAllUpgrade();
	  while(sql.rs.next()){
		if(sql.rs.getString("FINISH").equals("0"))
		  	out.println("  <tr bgcolor=\"white\">");
	  	if(sql.rs.getString("FINISH").equals("1"))
	  		out.println("  <tr bgcolor=\"#BFEFFF\">");
	  	if(sql.rs.getString("FINISH").equals("2"))
	  		out.println("  <tr bgcolor=\"#FF6347\">");
	  	out.println("    <td>" + sql.rs.getString("FULLNAME") + " </td>");
	  	out.println("    <td>" + sql.rs.getString("TYPE") + " </td>");
	  	out.println("    <td>" + sql.rs.getString("TEXT") + " </td>");
	  	if(sql.rs.getString("ANSWER") != null)
	  	 out.println("    <td>" + sql.rs.getString("ANSWER") + " </td>");
	  	else
	  	 out.println("    <td>Ожидает обработки</td>");	
	  	out.println("  </tr>");
	  }
	  out.println("  </table>");
		sql.Disconnect();
	  %>
</body>
</html>