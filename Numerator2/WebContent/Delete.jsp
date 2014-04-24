<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<%@page import="OracleConnect.SQLRequest" import="OracleConnect.SQLRequest_1" import="OracleConnect.OracleConnect"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css" title="currentStyle">
@import "css/demo_page.css";
@import "css/demo_table.css";
</style>
<script type="text/javascript" language="JavaScript">
 function changeImg1(source)
 {  document.pict1.src = source + '.PNG';
 };
 function changeImg2(source)
 {  document.pict2.src = source + '.PNG';
 };
</script>
<script type="text/javascript">
	function GoHome(){
	 	form2.submit();
	}
	function Delete(){
		document.form1.Action.value="1";
	 	form1.submit();
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<title>Удаление</title>
<%
	int i=0;
int index=0;
String URL = "";
String DEL_OBOZ = "";
String DEL_PARENT_OBOZ = "";
String DEL_TYPE = "";
String Note = "";
String DELETE_LIST = "";
SQLRequest sql = new SQLRequest();
SQLRequest_1 sql_1 = new SQLRequest_1();
//переменные для разбиаения строки
String delimiter = " ";
String[] temp;
String ExplodedOBOZ="";
String SessionUser = "";
if(session.getAttribute("SessionUser") != null) SessionUser = session.getAttribute("SessionUser").toString();			//пользователь сессии
String FULLNAME = "";
if(session.getAttribute("FULLNAME") != null) FULLNAME = session.getAttribute("FULLNAME").toString();					//ФИО
String DEPARTMENT = "";
if(session.getAttribute("DEPARTMENT") != null) DEPARTMENT = session.getAttribute("DEPARTMENT").toString();				//Отдел
String SelectedItem="";
if(request.getParameter("SelectedItem") != null)
	 SelectedItem = new String (request.getParameter("SelectedItem").getBytes("ISO-8859-1"));
String OBOZ="";
if (request.getParameter("OBOZ") != null) 
	OBOZ = new String(request.getParameter("OBOZ").getBytes("ISO-8859-1"));
//список удаляемых объектов
if(request.getParameter("DELETE_LIST") != null)
	  DELETE_LIST = new String (request.getParameter("DELETE_LIST").getBytes("ISO-8859-1"));
%>
</head>
<body  id="dt_example"  background="images/background.png">

<%
//Действие
String Action="";
if (request.getParameter("Action") != null){
	Action = new String(request.getParameter("Action").getBytes("ISO-8859-1"));
	if(Action.equals("1"))
	{
		System.out.println("lol");
		  //--------------------------------------- удаление выбранных узлов ---------------------------------------------------------
		  // ОБОЗНАЧЕНИЕ УДАЛЯЕМОГО     ОБОЗНАЧЕНИЕ СОДЕРЖАЩЕГО ЕГО КОМПОНЕНТА   ОПЦИЯ УДАЛЯТЬ СВЯЗЬ ИЛИ ВСЕ
		  //                                                                     0 - удалить связь (NUM_RELATIONS)
		  //                                                                     1 - далить связь и запись (NUM_RELATIONS,NUM_NUMBERS)
		  //--------------------------------------------------------------------------------------------------------------------------
		  temp = DELETE_LIST.split(delimiter);
		  i = 0;
		  //out.println("DELETE_COMMAND: Action = 9 Count = " + temp.length + "<BR>");
		  while((i+3) <= temp.length){  
		  	DEL_OBOZ = temp[i];
		   	DEL_PARENT_OBOZ = temp[i+1];
		  	DEL_TYPE = temp[i+2];
		  	//out.println("DELETE_COMMAND: " + DEL_OBOZ + " - " + DEL_PARENT_OBOZ + " - " + DEL_TYPE + "<BR>");
		  	i=i+3;
		  	sql.InsertStatistic("4",FULLNAME,"Определение наименования отключено для ускорения работы",DEL_OBOZ);
		  	sql.DeleteRecord(DEL_TYPE,DEL_OBOZ,DEL_PARENT_OBOZ );
		  }	  
		  //и возвращаемся на главную страницу
		  URL = "index.jsp?SelectedItem=" + URLEncoder.encode(SelectedItem,"windows-1251");
		  response.sendRedirect(URL);
	 
		
	}
	
}else{
%>


	<div class="full_width big" align=center>Удаление</div>
	<img name=pict1 border=0 onClick="GoHome()" src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')">
	<h4><font color="#6495ED">Будет удалено выбранное обозначение а так же связанные объекты в случае их наличия:</font></h4>
	<form name="form1" id="form1" name="form1"  action=Delete.jsp>
		<input type="text" value="2" name="Action" id="Action" style="display: none;"/>  
		<input type="text" value="<%=SelectedItem%>" name="SelectedItem" style="display: none;"/>
		<%
		out.println("<table border=1>");
		  out.println("  <tr bgcolor=\"#C0C0C0\">");
		  out.println("    <td>Действие</td>");
		  out.println("    <td>№ п/п</td>");
		  out.println("    <td>Обозначение</td>");
		  out.println("    <td>Наименование</td>");	   		
		  out.println("    <td>Первичная применяемость</td>");
		  out.println("    <td>Кол-во в узле</td>");
		  out.println("    <td>Кол-во в машине</td>");
		  out.println("    <td>Масса</td>");
		  out.println("    <td>Формат</td>");
		  out.println("    <td>А1</td>");
		  out.println("    <td>А4</td>");
		  out.println("    <td>Исполнитель</td>");
		  out.println("    <td>AutoCAD</td>");
		  out.println("    <td>ProE</td>");
		  out.println("<td>Разработчик чертежа</td>");
		  out.println("  </tr>");
		  //отображаем данные для удаления
		  sql.GetTreeForOBOZ(OBOZ);
		  index = 1;
		  System.out.println("xxxx");
		  while(sql.rs.next()){
			out.println("  <tr bgcolor=\"white\">");
			sql_1.GetOBOZRelationsCount(sql.rs.getString("TREE").trim());
			if(sql_1.rs1.next())
			 if(sql_1.rs1.getInt("CNT") == 1){
			  out.println("    <td>Полное удаление</td>");
			  DELETE_LIST += sql.rs.getString("TREE") + " " + OBOZ + " 1 ";
			 }
			 else{
			  out.println("    <td>Удаление связи с " + OBOZ + "</td>");
			  DELETE_LIST += sql.rs.getString("TREE") + " " + OBOZ + " 0 ";
			 }
			else{
			  out.println("    <td>Не будет удаляться" + OBOZ + "</td>");
			}
			out.println("    <td><strike>" + index + "</strike></td>");
			out.println("    <td><strike>" + sql.rs.getString("TREE") + "</strike></td>"); 
			out.println("    <td><strike>" + sql.rs.getString("NAIMENOVANIE") + "</strike></td>");  	
			out.println("    <td><strike>" + sql.rs.getString("PRIMENAETSA") + "</strike></td>"); 
			if(sql.rs.getString("UZ_COUNT") != null)
			 out.println("    <td><strike>" + sql.rs.getString("UZ_COUNT") + "</strike></td>");
			else
			 out.println("    <td><strike>Не задано</strike></td>");	
			if(sql.rs.getString("M_COUNT") != null)
			 out.println("    <td><strike>" + sql.rs.getString("M_COUNT") + "</strike></td>");
			else
			 out.println("    <td><strike>Не задано</strike></td>");	
			if(sql.rs.getString("MASS") != null)
			 out.println("    <td><strike>" + sql.rs.getString("MASS") + "</strike></td>");
			else
			 out.println("    <td><strike>Не задана</strike></td>");	
			if(sql.rs.getString("FORMAT") != null)
			 out.println("    <td><strike>" + sql.rs.getString("FORMAT") + "</strike></td>");
			else
			 out.println("    <td><strike>Не задан</strike></td>");	
			if(sql.rs.getString("A1_COUNT") != null)
			 out.println("    <td><strike>" + sql.rs.getString("A1_COUNT") + "</strike></td>");
			else
			 out.println("    <td><strike>Не задано</strike></td>");	
			if(sql.rs.getString("A4_COUNT") != null)
			 out.println("    <td><strike>" + sql.rs.getString("A4_COUNT") + "</strike></td>");
			else
			 out.println("    <td><strike>Не задано</strike></td>");	
			out.println("    <td><strike>" + sql.rs.getString("FULLNAME") + "</strike></td>");
			if(sql.rs.getString("AUTOCAD") != null)
			 out.println("    <td><strike>" + sql.rs.getString("AUTOCAD") + "</strike></td>");
			else
			 out.println("    <td><strike>Не задан</strike></td>");	
			if(sql.rs.getString("PROE") != null)
			 out.println("    <td><strike>" + sql.rs.getString("PROE") + "</strike></td>");
			else
			 out.println("    <td><strike>Не задан</strike></td>");
			if(sql.rs.getString("acad_fullname")!=null){
				out.println("<td><strike>"+sql.rs.getString("acad_fullname")+"</strike></td>");
			}
			else{
				out.println("<td><strike>Не задан</strike></td>");
			}
			out.println("  </tr>");	
			index ++;
		   }
		  out.println("</table>");
		  out.println("<input type=\"text\" value=\"" + DELETE_LIST + "\" name=\"DELETE_LIST\" style=\"display: none;\" />"); 
		  sql.Disconnect();
		 // sql_1.Disconnect();
		%>
		<br>
		<img name=pict2 border=0 onClick="Delete();" src="images/BUTTON_DELETE.PNG" onMouseOver="changeImg2('images/BUTTON_DELETE_SELECTED')" onMouseOut="changeImg2('images/BUTTON_DELETE')">
	</form>
	<form name=form2 action=index.jsp>
		<input type="text" value="<%=SelectedItem%>" name="SelectedItem" style="display: none;"/>
	</form>
	<%} %>
</body>
</html>