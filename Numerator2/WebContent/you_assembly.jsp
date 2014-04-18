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
 {  document.pict1.src = source + '.PNG';
 };
</script>
<title>Ваши узлы</title>
<%
//массив доверенных лиц
ArrayList<String> TrustedUsers = new ArrayList<String>();
SQLRequest sql = new SQLRequest();
String SessionUser = "";
if(session.getAttribute("SessionUser") != null) SessionUser = session.getAttribute("SessionUser").toString();			//пользователь сессии
String FULLNAME = "";
if(session.getAttribute("FULLNAME") != null) FULLNAME = session.getAttribute("FULLNAME").toString();					//ФИО
String DEPARTMENT = "";
if(session.getAttribute("DEPARTMENT") != null) DEPARTMENT = session.getAttribute("DEPARTMENT").toString();				//Отдел
String SelectedItem="";
String URL="";
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
	<div class="full_width big" align=center>Ваши узлы</div>
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
    sql.GetBigUzList();
    while(sql.rs.next()){
    	if(TrustedUsers.contains(sql.rs.getString("FULLNAME"))){
    		//заменяем в строках наименование и обозначение пробеелы на спецсимволы
 			out.println("  <tr bgcolor=\"white\">");
 			out.println("    <td><a href=\"index.jsp?SelectedItem=" + URLEncoder.encode(sql.rs.getString("OBOZNACHENIE"),"windows-1251")  + "\">" + sql.rs.getString("OBOZNACHENIE") + "</a></td>");
 			out.println("  <td>");
 				if(sql.rs.getString("FULLNAME").equals(FULLNAME)){
		 			URL = "edit.jsp?";
					if(sql.rs.getString("OBOZNACHENIE") != null)
					URL += "SelectedItem=" + URLEncoder.encode(SelectedItem,"windows-1251");
					if(sql.rs.getString("GENERAL_ID") != null)
					URL += "&ID=" + URLEncoder.encode(sql.rs.getString("GENERAL_ID"),"windows-1251");
					if(sql.rs.getString("OBOZNACHENIE") != null)
					URL += "&NEWOBOZ=" + URLEncoder.encode(sql.rs.getString("OBOZNACHENIE"),"windows-1251");
					if(sql.rs.getString("NAIMENOVANIE") != null)
					URL += "&NAIM=" + URLEncoder.encode(sql.rs.getString("NAIMENOVANIE"),"windows-1251");
					if(sql.rs.getString("PRIMENAETSA") != null)
					URL += "&VHODIMOST=" + URLEncoder.encode(sql.rs.getString("PRIMENAETSA"),"windows-1251");
					if(sql.rs.getString("UZ_COUNT") != null)
					URL += "&UZ_COUNT=" + URLEncoder.encode(sql.rs.getString("UZ_COUNT"),"windows-1251");
					if(sql.rs.getString("M_COUNT") != null)
					URL += "&M_COUNT=" + URLEncoder.encode(sql.rs.getString("M_COUNT"),"windows-1251");
					if(sql.rs.getString("STATUS") != null)
					URL += "&STATUS=" + URLEncoder.encode(sql.rs.getString("STATUS"),"windows-1251");
					if(sql.rs.getString("FULLNAME") != null)
					URL += "&NEWFULLNAME=" + URLEncoder.encode(sql.rs.getString("FULLNAME"),"windows-1251");
					if(sql.rs.getString("FULLNAME") != null)
					URL += "&ACADNEWFULLNAME=" + URLEncoder.encode(sql.rs.getString("FULLNAME"),"windows-1251");
					if(sql.rs.getString("MASS") != null)
					URL += "&MASS=" + URLEncoder.encode(sql.rs.getString("MASS"),"windows-1251");
					if(sql.rs.getString("FORMAT") != null)
					URL += "&FORMAT=" + URLEncoder.encode(sql.rs.getString("FORMAT"),"windows-1251");
					if(sql.rs.getString("MATERIAL") != null)
					URL += "&MATERIAL=" + URLEncoder.encode(sql.rs.getString("MATERIAL"),"windows-1251");
					if(sql.rs.getString("A1_COUNT") != null)
					URL += "&A1_COUNT=" + URLEncoder.encode(sql.rs.getString("A1_COUNT"),"windows-1251");
					if(sql.rs.getString("A4_COUNT") != null)
					URL += "&A4_COUNT=" + URLEncoder.encode(sql.rs.getString("A4_COUNT"),"windows-1251");
					if(sql.rs.getString("AUTOCAD") != null)
					URL += "&AUTOCAD=" + URLEncoder.encode(sql.rs.getString("AUTOCAD"),"windows-1251");
					if(sql.rs.getString("PROE") != null)
					URL += "&PROE=" + URLEncoder.encode(sql.rs.getString("PROE"),"windows-1251");
					if(sql.rs.getString("NOTE") != null)
					URL += "&Note=" + URLEncoder.encode(sql.rs.getString("NOTE"),"windows-1251");
					out.println("<a href=\"" + URL + "\"><img src=\"images/edit.png\" border=0 width=24 height=24 title=\"Редактирование\"></img></a>");
					out.println("<a href=\"Delete.jsp?SelectedItem=" + SelectedItem + "&OBOZ=" + sql.rs.getString("OBOZNACHENIE") + "\"><img src=\"images/delete.png\" border=0 width=24 height=24 title=\"Удаление\"></img></a>");								
				}else{
				}
    		out.println("  </td>");
 			out.println("    <td><a href=\"index.jsp?SelectedItem=" + URLEncoder.encode(sql.rs.getString("OBOZNACHENIE"),"windows-1251")  + "\">" + sql.rs.getString("NAIMENOVANIE") + "</a></td>");
 			out.println("    <td>" + sql.rs.getString("FULLNAME") + "</td>");
			out.println("  </tr>");	
    	}
    }
    out.println("</table>");
    sql.Disconnect();
	%>
</body>
</html>