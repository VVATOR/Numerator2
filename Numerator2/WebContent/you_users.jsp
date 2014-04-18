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
<title>Ваши доверенные пользователи</title>
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
//Действие
String Action="";
if (request.getParameter("Action") != null) 
	Action = new String(request.getParameter("Action").getBytes("ISO-8859-1"));
String NEWTRUSTEDFULLNAME = "";
if(request.getParameter("NEWTRUSTEDFULLNAME") != null)
	  NEWTRUSTEDFULLNAME = new String (request.getParameter("NEWTRUSTEDFULLNAME").getBytes("ISO-8859-1"));
//--------------------------------------------------------------------------------
//               Обработчик команд прислынных странице
//  1 - добавление доверенного пользователя
//  2 - удаление доверенного пользователя
//--------------------------------------------------------------------------------
if(Action.equals("1"))
{
	  //добавление довереного пользователя
	  sql.AddTrustesUsers(SessionUser,NEWTRUSTEDFULLNAME);
}
if(Action.equals("2"))
{
	  //удаление довереного пользователя
	  sql.DeleteTrustesUsers(SessionUser,NEWTRUSTEDFULLNAME);
}

%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>Ваши доверенные пользователи</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<br>
	<%
	out.println("<div align=center>");
	out.println("<form action=\"you_users.jsp\" method=\"GET\">");
	out.println("<input type=\"text\" value=\"1\" name=\"Action\" style=\"display: none;\" />");  
	sql.GetAllFio("");
	out.println("Чтобы добавить выберите и нажмите \"Добавить\":<BR>");
	out.println("<select name=\"NEWTRUSTEDFULLNAME\" >");
	while(sql.rs.next())
	{
	  out.println("<option title=\"" + sql.rs.getString("FULLNAME") + "\">" + sql.rs.getString("FULLNAME") + "</option>");		  
	}
	out.println("</select>");
	out.println("<input type=\"submit\" value=\"Добавить\" />"); 
	out.println("</form>");
	out.println("</div>");
	out.println("<br>");
	sql.GetUzListFromLogin(SessionUser);
	out.println("<table border=1 style=\"width: 800px\" align=center>");
	   out.println("  <tr bgcolor=\"#C0C0C0\">");
	   out.println("    <td>ФИО</td>");
	   out.println("    <td>Отдел</td>");
	   out.println("  </tr>");
	   sql.GetAllTrustesUsers(SessionUser);
	   while(sql.rs.next()){
		    out.println("  <tr bgcolor=\"white\">");
			out.println("    <td><a href=you_users.jsp?Action=2&NEWTRUSTEDFULLNAME=" + URLEncoder.encode(sql.rs.getString("FULLNAME"),"windows-1251") +  "><img src=images/delete.png width=24 height=24 title=\"Удалить\" border=0></a>" + sql.rs.getString("FULLNAME") + " </td>");
			out.println("    <td>" + sql.rs.getString("DEPARTMENT") + " </td>");
			out.println("  </tr>");	
	   }
	   out.println("</table>");
	   sql.Disconnect();
	   %>
</body>
</html>