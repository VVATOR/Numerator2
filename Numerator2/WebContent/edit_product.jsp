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
<link rel="stylesheet" href="css/AutocompleteStyle.css" > 
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/jquery.autocomplete.js"></script>
<script type="text/javascript" language="JavaScript">
 function changeImg1(source)
 {  
	 document.pict1.src = source + '.PNG';
 };
</script>
<script type="text/javascript" language="JavaScript">
 function changeImg1(source)
 {  document.pict1.src = source + '.PNG';
 };
 function changeImg2(source)
 {  document.pict2.src = source + '.PNG';
 };
 function changeImg3(source)
 {  document.pict3.src = source + '.PNG';
 };
</script>
<script type="text/javascript">
	function EditExecute(){
		document.form1.Action.value="1";
	 	form1.submit();
	}
	function EditCancel(){
	 	form2.submit();
	}
</script>
<title>Редактирование изделия</title>
<%
String ID = "";
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
//наименование изделия
String OBOZ = "";
if(request.getParameter("OBOZ") != null)
OBOZ = new String (request.getParameter("OBOZ").getBytes("ISO-8859-1"));
//наименование изделия
String NAIM = "";
if(request.getParameter("NAIM") != null)
NAIM = new String (request.getParameter("NAIM").getBytes("ISO-8859-1"));
//новое обозначение изделия/узла
String NEWOBOZ = "";
if(request.getParameter("NEWOBOZ") != null)
NEWOBOZ = new String (request.getParameter("NEWOBOZ").getBytes("ISO-8859-1"));
//имя пользователя которому назначен узел
String NEWFULLNAME = "";
if(request.getParameter("NEWFULLNAME") != null)
NEWFULLNAME = new String (request.getParameter("NEWFULLNAME").getBytes("ISO-8859-1"));
//Действие
String Action = "";
if (request.getParameter("Action") != null) 
	Action = new String(request.getParameter("Action").getBytes("ISO-8859-1"));
//----------------------------------------------------------------------------------------
//ВЫПОЛНЕНИЯ ДЕЙСТВИЯ В ЗАВИСИМОСТИ ОТ ЗНАЧЕНИЯ ПАРАМЕТРА ACTION
//             АCTION=1 - ДОБАВЛЕНИЕ ДОКУМЕНТА
//----------------------------------------------------------------------------------------
if(Action.equals("1")){
	//выполняем добавление нового изделия
	if(!NEWOBOZ.equals(""))
		if(!NAIM.equals(""))
			if(!NEWFULLNAME.equals("")){
				  //редактирование изделия
				  sql.SearchIzd(OBOZ);
				  sql.rs.next();
				  ID = sql.rs.getString("ID");
				  sql.InsertStatistic("3",FULLNAME,NAIM,NEWOBOZ);
				  sql.EditProduct(OBOZ,NEWOBOZ,NAIM,ID,NEWFULLNAME);
				  sql.Disconnect();
				  //и возвращаемся на главную страницу
				  URL = "index.jsp?SelectedItem=" + URLEncoder.encode(SelectedItem,"windows-1251");
				  response.sendRedirect(URL);
			}
}
	sql.Disconnect();
//----------------------------------------------------------------------------------------
%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>Редактирование изделия</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<br>
	<br>
	<h1>Обазательные параметры</h1>
	<form action="edit_product.jsp" method="GET" name=form1>
	  <input type="text" value="1" name="Action" style="display: none;" />  
	  <table border=0>
			<tr>
				<!-- ОБОЗНАЧЕНИЕ -->
				<td><font color="#6495ED">Обозначение</font></td>
				<td><input type="text" size="20" name="NEWOBOZ" id="NEWOBOZ" value="<%=NEWOBOZ%>"/></td>
				<!-- НАИМЕНОВАНИЕ -->
				<td><font color="#6495ED">Наименование</font></td>
				<td><input type="text" name=NAIM id=NAIM size="60" value="<%=NAIM%>">
				<%
				out.println("			<script type=\"text/javascript\">");
				out.println("				$(document).ready(function(){");
				out.println("				function liFormat (row, i, num) {");
				out.println("					var result = row[0] + '</p>';");
				out.println("					return result;");
				out.println("				}");
				out.println("				function selectItem(li) {");
				out.println("					if( li == null ) var sValue = 'А ничего не выбрано!';");
				out.println("					if( !!li.extra ) var sValue = li.extra[2];");
				out.println("					else var sValue = li.selectValue;");
				out.println("				}");
				out.println("				$(\"#NAIM\").autocomplete(\"AJAXAutocompleteNAIMENOVANIE.jsp\", {");
				out.println("					delay:10,");
				out.println("					minChars:2,");
				out.println("					matchSubset:1,");
				out.println("					autoFill:true,");
				out.println("					matchContains:1,");
				out.println("					cacheLength:10,");
				out.println("					selectFirst:true,");
				out.println("					formatItem:liFormat,");
				out.println("					maxItemsToShow:10,");
				out.println("					onItemSelect:selectItem");
				out.println("				}); ");
				out.println("				});");
				out.println("			</script>");
				%>
				</td>
				<!-- ВЛАДЕЛЕЦ -->
				<td><font color="#6495ED">Владелец</font></td>
				<td><input type="text" name=NEWFULLNAME id=NEWFULLNAME size="30" value="<%=NEWFULLNAME%>">
				<%
				out.println("			<script type=\"text/javascript\">");
				out.println("				$(document).ready(function(){");
				out.println("				function liFormat (row, i, num) {");
				out.println("					var result = row[0] + '</p>';");
				out.println("					return result;");
				out.println("				}");
				out.println("				function selectItem(li) {");
				out.println("					if( li == null ) var sValue = 'А ничего не выбрано!';");
				out.println("					if( !!li.extra ) var sValue = li.extra[2];");
				out.println("					else var sValue = li.selectValue;");
				out.println("				}");
				out.println("				$(\"#NEWFULLNAME\").autocomplete(\"AJAXAutocompleteFULLNAME.jsp\", {");
				out.println("					delay:10,");
				out.println("					minChars:2,");
				out.println("					matchSubset:1,");
				out.println("					autoFill:true,");
				out.println("					matchContains:1,");
				out.println("					cacheLength:10,");
				out.println("					selectFirst:true,");
				out.println("					formatItem:liFormat,");
				out.println("					maxItemsToShow:10,");
				out.println("					onItemSelect:selectItem");
				out.println("				}); ");
				out.println("				});");
				out.println("			</script>");
				%>
				</td>
			</tr>
	  </table>
	  <input type="text" value="<%=SelectedItem%>" name="SelectedItem" style="display: none;"/>
	  <input type="text" value="<%=OBOZ%>" name="OBOZ" style="display: none;"/>
	  <input type="text" value="2" name="Action" style="display: none;"/>  
	</form>
	<br>
	<br>
	<table border=0 width=70% align=center>
	 	<tr>
	 		<td width=100><img name=pict2 border=0 onClick="EditExecute()" src="images/BUTTON_OK.PNG" onMouseOver="changeImg2('images/BUTTON_OK_SELECTED')" onMouseOut="changeImg2('images/BUTTON_OK')"></td>
	 		<td width=100% align=right><img name=pict3 border=0 onClick="EditCancel()" src="images/BUTTON_CANCEL.PNG" onMouseOver="changeImg3('images/BUTTON_CANCEL_SELECTED')" onMouseOut="changeImg3('images/BUTTON_CANCEL')"></td>
	 	</tr>
 	</table>
 <form name=form2 action="index.jsp">  
	 <input type="text" value="<%=SelectedItem%>" name="SelectedItem" style="display: none;"/>
 </form>	
</body>
</html>