<%@page import="org.w3c.dom.Element"%>

<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="OracleConnect.SQLRequest" import="OracleConnect.OracleConnect" import="NumGenerator.NumGenerate"%>
<%@page import="java.util.*"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<html>
<head>


<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<style type="text/css">
	.status-nomera{
		
	}
	.status-nomera-free{
		color: green;
	}
	
	.status-nomera-occupaied{
		color: red;
	}
	

</style>
<link rel="stylesheet" href="css/AutocompleteStyle.css" > 
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
	function AddExecute(){
		document.form1.Action.value="1";
	 	form1.submit();
	}
	function AddCancel(){
	 	form2.submit();
	}
</script>
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript" src="js/jquery.autocomplete.js"></script>
<%
SQLRequest sql = new SQLRequest();
NumGenerate num = new NumGenerate();
String OBOZ_THERD_NUM  = "";
int i=0;
//переменные для разбиаения строки
String delimiter = " ";
String[] temp;
String ExplodedOBOZ="";
//получаем переданные в сессию параметры
String SelectedItem= "";
String SessionUser = "";
String Action="";
String URL = "";

String zanyat = "";
	String ACADNEWFULLNAME="";

if(session.getAttribute("SessionUser") != null) SessionUser = session.getAttribute("SessionUser").toString();			//пользователь сессии
String FULLNAME = "";
if(session.getAttribute("FULLNAME") != null) FULLNAME = session.getAttribute("FULLNAME").toString();					//ФИО
String DEPARTMENT = "";
if(session.getAttribute("DEPARTMENT") != null) DEPARTMENT = session.getAttribute("DEPARTMENT").toString();				//Отдел
if(request.getParameter("SelectedItem") != null){
	SelectedItem = new String (request.getParameter("SelectedItem").getBytes("ISO-8859-1"));
	SelectedItem = URLDecoder.decode(SelectedItem, "windows-1251");
}
//Действие
if (request.getParameter("Action") != null) 
	Action = new String(request.getParameter("Action").getBytes("ISO-8859-1"));

	if(request.getParameter("ACADNEWFULLNAME")!=null){
		ACADNEWFULLNAME=new String(request.getParameter("ACADNEWFULLNAME").getBytes("ISO-8859-1"));
	}

	//----------------------------------------------------------------------------------------
	//                       ПЕРЕМЕННЫЕ ДЛЯ ДОБАВЛЕНИЯ
	//----------------------------------------------------------------------------------------
	String ID = "";
	String NAIM = "";
	String NEWOBOZ = "";
	String VHODIMOST = "";
	String NEWFULLNAME = "";
	String UZ_COUNT = "";
	String M_COUNT = "";
	String MASS = "";
	String FORMAT = "";
	String A1_COUNT="";
	String A4_COUNT="";
	String AUTOCAD = "";
	String PROE = "";
	String STATUS = "";
	String MATERIAL = "";
	String Type = "";
	String Note = "";
	String errorMessage="";
	//наименование изделия
	if(request.getParameter("NAIM") != null)
	  NAIM = new String (request.getParameter("NAIM").getBytes("ISO-8859-1"));
	//новое обозначение изделия/узла
	if(request.getParameter("NEWOBOZ") != null)
	  NEWOBOZ = new String (request.getParameter("NEWOBOZ").getBytes("ISO-8859-1"));
	
	
	if(request.getParameter("zanyat") != null)
		zanyat = new String (request.getParameter("zanyat").getBytes("ISO-8859-1"));
		
		
	
	
	//применяемость
	if(request.getParameter("VHODIMOST") != null)
	  VHODIMOST = new String (request.getParameter("VHODIMOST").getBytes("ISO-8859-1"));
	//имя пользователя которому назначен узел
	if(request.getParameter("NEWFULLNAME") != null)
	  NEWFULLNAME = new String (request.getParameter("NEWFULLNAME").getBytes("ISO-8859-1"));
	if(request.getParameter("ACADNEWFULLNAME") != null)
		ACADNEWFULLNAME = new String (request.getParameter("ACADNEWFULLNAME").getBytes("ISO-8859-1"));
	//количество в узле
	if(request.getParameter("UZ_COUNT") != null)
		  UZ_COUNT = new String (request.getParameter("UZ_COUNT").getBytes("ISO-8859-1"));
	//количество в машине
	if(request.getParameter("M_COUNT") != null)
		  M_COUNT = new String (request.getParameter("M_COUNT").getBytes("ISO-8859-1"));
	//масса
	if(request.getParameter("MASS") != null)
		  MASS = new String (request.getParameter("MASS").getBytes("ISO-8859-1"));
	//формат
	if(request.getParameter("FORMAT") != null)
		  FORMAT = new String (request.getParameter("FORMAT").getBytes("ISO-8859-1"));
	//количество А1
	if(request.getParameter("A1_COUNT") != null)
		  A1_COUNT = new String (request.getParameter("A1_COUNT").getBytes("ISO-8859-1"));
	//количество А4
	if(request.getParameter("A4_COUNT") != null)
		  A4_COUNT = new String (request.getParameter("A4_COUNT").getBytes("ISO-8859-1"));
	//модель AutoCAD
	if(request.getParameter("AUTOCAD") != null)
		  AUTOCAD = new String (request.getParameter("AUTOCAD").getBytes("ISO-8859-1"));
	//модель Pro/Engineer
	if(request.getParameter("PROE") != null)
		  PROE = new String (request.getParameter("PROE").getBytes("ISO-8859-1"));
	//статус
	if(request.getParameter("STATUS") != null)
		  STATUS = new String (request.getParameter("STATUS").getBytes("ISO-8859-1"));
	//материал
	if(request.getParameter("MATERIAL") != null)
		  MATERIAL = new String (request.getParameter("MATERIAL").getBytes("ISO-8859-1"));
	//примечание
	if(request.getParameter("Note") != null){
		Note = new String(request.getParameter("Note").getBytes("ISO-8859-1"));
		Note = URLDecoder.decode(Note, "windows-1251");
	}
	//Форматы----------------------------------------
	ArrayList <String> SelectedFormats=new ArrayList<String>();
	if(request.getParameter("A0") != null && (new String (request.getParameter("A0").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A0");
	}
	if(request.getParameter("A1") != null && (new String (request.getParameter("A1").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A1");
	}
	if(request.getParameter("A2") != null && (new String (request.getParameter("A2").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A2");
	}
	if(request.getParameter("A3") != null && (new String (request.getParameter("A3").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A3");
	}
	if(request.getParameter("A4") != null && (new String (request.getParameter("A4").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A4");
	}
	if(request.getParameter("A0x2") != null && (new String (request.getParameter("A0x2").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A0x2");
	}
	if(request.getParameter("A0x3") != null && (new String (request.getParameter("A0x3").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A0x3");
	}
	if(request.getParameter("A1x3") != null && (new String (request.getParameter("A1x3").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A1x3");
	}
	if(request.getParameter("A1x4") != null && (new String (request.getParameter("A1x4").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A1x4");
	}
	if(request.getParameter("A2x3") != null && (new String (request.getParameter("A2x3").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A2x3");
	}
	if(request.getParameter("A2x4") != null && (new String (request.getParameter("A2x4").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A2x4");
	}
	if(request.getParameter("A2x5") != null && (new String (request.getParameter("A2x5").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A2x5");
	}
	if(request.getParameter("A3x3") != null && (new String (request.getParameter("A3x3").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A3x3");
	}
	if(request.getParameter("A3x4") != null && (new String (request.getParameter("A3x4").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A3x4");
	}
	if(request.getParameter("A3x5") != null && (new String (request.getParameter("A3x5").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A3x5");
	}
	if(request.getParameter("A3x6") != null && (new String (request.getParameter("A3x6").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A3x6");
	}
	if(request.getParameter("A3x7") != null && (new String (request.getParameter("A3x7").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A3x7");
	}
	if(request.getParameter("A4x3") != null && (new String (request.getParameter("A4x3").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A4x3");
	}
	if(request.getParameter("A4x4") != null && (new String (request.getParameter("A4x4").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A4x4");
	}
	if(request.getParameter("A4x5") != null && (new String (request.getParameter("A4x5").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A4x5");
	}
	if(request.getParameter("A4x6") != null && (new String (request.getParameter("A4x6").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A4x6");
	}
	if(request.getParameter("A4x7") != null && (new String (request.getParameter("A4x7").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A4x7");
	}
	if(request.getParameter("A4x8") != null && (new String (request.getParameter("A4x8").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A4x8");
	}
	if(request.getParameter("A4x9") != null && (new String (request.getParameter("A4x9").getBytes("ISO-8859-1"))).equals("on")){
		SelectedFormats.add("A4x9");
	}
	int formats_count=SelectedFormats.size();
	FORMAT="";
	if(formats_count > 0){
		for(i=0; i<formats_count-1; i++){
			FORMAT+=SelectedFormats.get(i)+",";
		}
		FORMAT+=SelectedFormats.get(formats_count-1);
	}
	
	//----------------------------------------------------------------------------------------
	//  ВЫПОЛНЕНИЯ ДЕЙСТВИЯ В ЗАВИСИМОСТИ ОТ ЗНАЧЕНИЯ ПАРАМЕТРА ACTION
	//	             АCTION=1 - ДОБАВЛЕНИЕ ДОКУМЕНТА
	//----------------------------------------------------------------------------------------
	if(Action.equals("1")){
		if(NEWOBOZ.length()<7){
			errorMessage="Обозначение не корректно";
		}
		else if(NAIM.equals("")){
			errorMessage="Добавьте наименование";
		}
		else if(VHODIMOST.length()<7){
			errorMessage="Первичная применяемость указана не верно";
		}
		//else if(A4_COUNT.equals("0")){      ///vva
		//	errorMessage="Форматы не заданы";
		//}
		else{
			sql.SearchIzd(SelectedItem);
		  	sql.rs.next();
			ID = sql.rs.getString("ID");
			ExplodedOBOZ = num.ExplodeOBOZ(NEWOBOZ);
		 	temp = ExplodedOBOZ.split(delimiter);
		  	OBOZ_THERD_NUM = temp[3];
		  	if(OBOZ_THERD_NUM.charAt(2) == '0') Type = "3";
		  	else Type = "2";
			//Выполняем добавление
			sql.InsertStatistic("2",FULLNAME,NAIM,NEWOBOZ);
			sql.InsertUzel(NEWOBOZ,NAIM.replaceAll("'","\""),NEWFULLNAME,ID,UZ_COUNT,M_COUNT,MASS,FORMAT,A1_COUNT,A4_COUNT,AUTOCAD,PROE,Type,VHODIMOST,STATUS,MATERIAL.replaceAll("'","\""),Note.replaceAll("'","\""),ACADNEWFULLNAME);
			sql.Disconnect();
			//и возвращаемся на главную страницу
			URL = "index.jsp?SelectedItem=" + URLEncoder.encode(SelectedItem,"windows-1251");
			response.sendRedirect(URL);
	  	}
	}
	//----------------------------------------------------------------------------------------
	%>

<script type="text/javascript">
	/*$(document).ready(function(){
	  $("#NEWOBOZ").autocompleteArray([
	*/    <%/*
	  	    if(!SelectedItem.equals("")){
		    ExplodedOBOZ = num.GenerateNumbers(SelectedItem);
		    temp = ExplodedOBOZ.split(delimiter);
		    for(i=0;i<temp.length;i++){
		    	out.print("\"" + temp[i] + "\"");
		    	if(i<(temp.length-1)) out.println(",");
		    }	  
	    }
	*/
	    %>
	 /*   ],
	    {
	    delay:10,
	    minChars:1,
	    matchSubset:1,
	    autoFill:true,
	    maxItemsToShow:5
	    }  
	  );  
	  
	});*/
	
</script>


	



<script type="text/javascript">
function selChange_old()
{
	var format = document.getElementById('FORMAT');
	var A1_COUNT = document.getElementById('A1_COUNT');
	var A4_COUNT = document.getElementById('A4_COUNT');
	
	var a=new Array ( new Array ('8','4','2','1'),
			          new Array ('1','0.5','0.25','0.125'));

	var str=format.value;
	var reg=/a[1234]x\d+|а[1234]х\d+|a[1234]х\d+|а[1234]x\d+/gi;
	var reg_=/а[1234]|a[1234]/gi;
	var result1 = 0;
	var result2 = 0;
	//if (reg.test(str))
	if (str.search(reg) == 0)
	{ 
		var re=/[хХxX]/;
		var arr = str.split(re);
		var ind = parseInt(arr[0].charAt(1)) - 1;
		result1 = a[0][ind] * parseInt(arr[1]);
		result2 = a[1][ind] * parseInt(arr[1]);
	}
	//else if (reg_.test(str))
	else if ((str.search(reg_) == 0) && (str.length == 2))
	{ 
		var ind = parseInt(str.charAt(1)) - 1;
		result1 = a[0][ind];
		result2 = a[1][ind];
	}
	if (result1 == 0)
	{
		//A4_COUNT.value = "Неверный формат...";
		//A1_COUNT.value = "Неверный формат...";
	}
	else
	{
		A4_COUNT.value = result1;
		A1_COUNT.value = result2;
	}
};
</script>

<script type="text/javascript">
	function selChange(){
		//alert("A4");
		var a1=0;
		var a4=0;
		if(document.form1.A0.checked==true){
			a1=a1+2;
			a4+=16;
		}
		if(document.form1.A1.checked==true){
			a1=a1+1;
			a4+=8;
		}
		if(document.form1.A2.checked==true){
			a1=a1+0.5;
			a4+=4;
		}
		if(document.form1.A3.checked==true){
			a1=a1+0.25;
			a4+=2;
		}
		if(document.form1.A4.checked==true){
			a1=a1+0.125;
			a4+=1;
		}
		if(document.form1.A0x2.checked==true){
			a1+=4;
			a4+=32;
		}
		if(document.form1.A0x3.checked==true){
			a1+=6;
			a4+=48;
		}
		if(document.form1.A1x3.checked==true){
			a1+=3;
			a4+=24;
		}
		if(document.form1.A1x4.checked==true){
			a1+=4;
			a4+=32;
		}
		if(document.form1.A2x3.checked==true){
			a1+=1.5;
			a4+=12;
		}
		if(document.form1.A2x4.checked==true){
			a1+=2;
			a4+=16;
		}
		if(document.form1.A2x5.checked==true){
			a1+=2.5;
			a4+=20;
		}
		if(document.form1.A3x3.checked==true){
			a1+=0.75;
			a4+=6;
		}
		if(document.form1.A3x4.checked==true){
			a1+=1;
			a4+=8;
		}
		if(document.form1.A3x5.checked==true){
			a1+=1.25;
			a4+=10;
		}
		if(document.form1.A3x6.checked==true){
			a1+=1.5;
			a4+=12;
		}
		if(document.form1.A3x7.checked==true){
			a1+=1.75;
			a4+=14;
		}
		
		if(document.form1.A4x3.checked==true){
			a1+=0.375;
			a4+=3;
		}
		if(document.form1.A4x4.checked==true){
			a1+=0.5;
			a4+=4;
		}
		if(document.form1.A4x5.checked==true){
			a1+=0.625;
			a4+=5;
		}
		if(document.form1.A4x6.checked==true){
			a1+=0.75;
			a4+=6;
		}
		if(document.form1.A4x7.checked==true){
			a1+=0.875;
			a4+=7;
		}
		if(document.form1.A4x8.checked==true){
			a1+=1;
			a4+=8;
		}
		if(document.form1.A4x9.checked==true){
			a1+=1.125;
			a4+=9;
		}
		document.getElementById('A1_COUNT').value=a1;
		document.getElementById('A4_COUNT').value=a4;
	}
</script>
<title>Добавление детали или сборки</title>


<script type="text/javascript">
	$(document).ready(function(){
	  $("#NEWOBOZ").autocompleteArray([
	    <%
	  	    if(!SelectedItem.equals("")){
		    ExplodedOBOZ = num.GenerateNumbers(SelectedItem);
		    temp = ExplodedOBOZ.split(delimiter);
		    for(i=0;i<temp.length;i++){
		    	out.print("\"" + temp[i] + "\"");
		    	if(i<(temp.length-1)) out.println(",");
		    }	  
	    }
	    %>
	    ],
	    {
	    delay:10,
	    minChars:1,
	    matchSubset:1,
	    autoFill:true,
	    maxItemsToShow:5
	    }  
	  );  
	  
	});
	
</script>
<%
	ExplodedOBOZ = num.ExplodeOBOZ(SelectedItem);
	temp = ExplodedOBOZ.split(delimiter);
	//if(zanyat.equals("")){
		zanyat = sql.occupied(NEWOBOZ);
//	}
%>
<script>
	$(document).ready(function(){
		$("#NEWOBOZ").keyup(function(e){
			//if(e.keyCode == 13 ){
				
				$("#status").load("AJAXAutocompleteZanyat.jsp?q="+$("#NEWOBOZ").val());
			//}
		});		
	});
	
	
	
</script>

</head>
<body id="dt_example"  background="images/background.png">





 





 <form action="insert.jsp" method="GET" name=form1>
	<div class="full_width big" align=center>Добавление</div>
	<div style="color: red;">
		<%=errorMessage%>
	</div>
	<h1>Обазательные параметры</h1>
	<table border=0>
		<tr>
			<!-- ОБОЗНАЧЕНИЕ -->
			<%
			ExplodedOBOZ = num.ExplodeOBOZ(SelectedItem);
			temp = ExplodedOBOZ.split(delimiter);
			if(NEWOBOZ.equals("")){
				NEWOBOZ = temp[0] + temp[1] + temp[2].charAt(0);
			}
			%>
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
			<!-- ПЕРВИЧНАЯ ПРИМЕНЯЕМОСТЬ -->
			<td><font color="#6495ED">Первичная применяемость</font></td>
			<td><input type="text" size="20" name="VHODIMOST" value="<%=SelectedItem%>"><br></td>
		</tr>
		<tr>
			<th colspan=6>
			<div class="status" id="status" style="width: 100%;"></div>
			</th>
		</tr>
	</table>
	<h1>Дополнительные параметры</h1>
	<table border=0>	
		<tr>
			<!-- КОЛИЧЕСТВО В УЗЛЕ -->
			<td><font color="#6495ED">Кол-во в узле</font></td>
			<td><input type="text" size="5" name="UZ_COUNT" value="1"></td>
			<!--  КОЛИЧЕСТВО В МАШИНЕ -->
			<td><font color="#6495ED">Кол-во в машине</font></td>
			<td><input type="text" size="5" name="M_COUNT" value="1"></td>
			<!-- СТАТУС -->
			<td><font color="#6495ED">Статус</font></td>
			<td>
				<select name="STATUS" >
					<option selected title="Проработка" style="background-color: #FFFAFA">Проработка</option>
					<option title="Разрешено чертить" style="background-color: #FFFF00">Разрешено чертить</option>
					<option title="Чертеж готов" style="background-color: #97FFFF">Чертеж готов</option>
					<option title="Выдано в ЭП" style="background-color: #66CDAA">Выдано в ЭП</option>
					<option title="Завод-калька" style="background-color: #FFBBFF">Завод-калька</option>
					<option title="Завод - разрешение" style="background-color: #AB82FF">Завод - разрешение</option>
					<option title="Завод - извещение" style="background-color: #FFFACD">Завод - извещение</option>
					<option title="Аннулирован" style="background-color: #6495ED">Аннулирован</option>
					<option title="Корректировка" style="background-color: #FF3030">Корректировка</option>
				</select>
			</td>
			<!-- РАЗРАБОТЧИК CREO -->
			<td><font color="#6495ED">Исполнитель (в 3D)</font></td>
			<td><input type="text" name=NEWFULLNAME id=NEWFULLNAME size="30" value="<%=FULLNAME%>">
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
			<!-- РАЗРАБОТЧИК чертежа -->
			<td><font color="#6495ED">Разработчик чертежа</font></td>
			<td><input type="text" name=ACADNEWFULLNAME id=ACADNEWFULLNAME size="30" style="background-color: #E4E3EE" value="<%=ACADNEWFULLNAME%>">
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
			out.println("				$(\"#ACADNEWFULLNAME\").autocomplete(\"AJAXAutocompleteFULLNAME.jsp\", {");
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
			<!-- МАССА -->
			<td><font color="#6495ED">Масса</font></td>
			<td><input type="text" name=MASS id=MASS size="5">
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
			out.println("				$(\"#MASS\").autocomplete(\"AJAXAutocompleteMASS.jsp\", {");
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
	<table border=0>
		<tr>
			<!-- ФОРМАТ -->
			<td valign=top><font color="#6495ED">Формат</font></td>
			<td>
				<table border=1 style="text-align: center; border-bottom: none; border-top: none; border-right: none;">
					<tr>
						<td width="51px"></td>
						<td width="59px">А0</td>
						<td width="59px">A1</td>
						<td width="59px">A2</td>
						<td width="59px">A3</td>
						<td width="59px">A4</td>
					</tr>
					<tr>
						<td>1</td>
						<td><input type="checkbox" onClick="selChange()" name=A0></td>
						<td><input type="checkbox" onClick="selChange()" name=A1></td>
						<td><input type="checkbox" onClick="selChange()" name=A2></td>
						<td><input type="checkbox" onClick="selChange()" name=A3></td>
						<td><input type="checkbox" onClick="selChange()" name=A4></td>
					</tr>
					<tr>
						<td>2</td>
						<td><input type="checkbox" onClick="selChange()" name=A0x2></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>3</td>
						<td><input type="checkbox" onClick="selChange()" name=A0x3></td>
						<td><input type="checkbox" onClick="selChange()" name=A1x3></td>
						<td><input type="checkbox" onClick="selChange()" name=A2x3></td>
						<td><input type="checkbox" onClick="selChange()" name=A3x3></td>
						<td><input type="checkbox" onClick="selChange()" name=A4x3></td>
					</tr>
					<tr>
						<td>4</td>
						<td></td>
						<td><input type="checkbox" onClick="selChange()" name=A1x4></td>
						<td><input type="checkbox" onClick="selChange()" name=A2x4></td>
						<td><input type="checkbox" onClick="selChange()" name=A3x4></td>
						<td><input type="checkbox" onClick="selChange()" name=A4x4></td>
					</tr>
					<tr>
						<td>5</td>
						<td></td>
						<td></td>
						<td><input type="checkbox" onClick="selChange()" name=A2x5></td>
						<td><input type="checkbox" onClick="selChange()" name=A3x5></td>
						<td><input type="checkbox" onClick="selChange()" name=A4x5></td>
					</tr>
					<tr>
						<td>6</td>
						<td></td>
						<td></td>
						<td></td>
						<td><input type="checkbox" onClick="selChange()" name=A3x6></td>
						<td><input type="checkbox" onClick="selChange()" name=A4x6></td>
					</tr>
					<tr>
						<td>7</td>
						<td></td>
						<td></td>
						<td></td>
						<td><input type="checkbox" onClick="selChange()" name=A3x7></td>
						<td><input type="checkbox" onClick="selChange()" name=A4x7></td>
					</tr>
					<tr>
						<td>8</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td><input type="checkbox" onClick="selChange()" name=A4x8></td>
					</tr>
					<tr>
						<td>9</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td><input type="checkbox" onClick="selChange()" name=A4x9></td>
					</tr>
				</table>			
			</td>
			<td>
				<table border=0>
					<tr>
						<!-- МАТЕРИАЛ -->
						<td><font color="#6495ED">Материал</font></td>
						<td><input type="text" name=MATERIAL id=MATERIAL size="80" />
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
						out.println("				$(\"#MATERIAL\").autocomplete(\"AJAXAutocompleteMATERIAL.jsp\", {");
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
					<tr>	
						<!-- КОЛИЧЕСТВО А1 -->
						<td><font color="#6495ED">Количество А1</font></td>
						<td><input type="text" style="background-color: #E4E3EE" size="5" onMouseOver ="selChange()" name="A1_COUNT" id="A1_COUNT" value="0"></td>
					</tr>
					<tr>	
						<!-- КОЛИЧЕСТВО А4 -->
						<td><font color="#6495ED">Кличество А4</font></td>
						<td><input type="text" style="background-color: #E4E3EE" size="5" onMouseOver ="selChange()" name="A4_COUNT" id="A4_COUNT" value="0"></td>
					</tr>
					<tr>	
						<!-- МОДЕЛЬ AutoCAD -->
						<td><font color="#6495ED">Чертеж AutoCAD</font></td>
						<td><input type="text" size="60" name="AUTOCAD" value="\\Server3\GSKB\Внутренние\Разработки\"></td>
					</tr>
					<tr>	
						<!-- МОДЕЛЬ Creo/ElementsPro -->
						<td><font color="#6495ED">Модель Creo/Elements Pro</font></td>
						<td><input type="text" size="60" name="PROE" value="M:\"></td>
					</tr>
					<tr>	
						<!-- ПРИМЕЧАНИЕ -->
						<td><font color="#6495ED">Примечание</font></td>
						<td><textarea cols="10" rows="6" name="Note"  style="width: 380px"></textarea></td>
						
					</tr>
				</table>
			</td>
		</tr>
	</table>	
	<h1> </h1>
	<input type="text" value="<%=SelectedItem%>" name="SelectedItem" style="display: none;"/>
	<input type="text" value="2" name="Action" style="display: none;"/>  
 </form>
 <form name=form2 action="index.jsp">  
	 <input type="text" value="<%=SelectedItem%>" name="SelectedItem" style="display: none;"/>
 </form>	
 <table border=0 width=70% align=center>
 	<tr>
 		<td width=100><img name=pict1 border=0 onClick="AddExecute()" src="images/BUTTON_ADD.PNG" onMouseOver="changeImg1('images/BUTTON_ADD_SELECTED')" onMouseOut="changeImg1('images/BUTTON_ADD')"></td>
 		<td width=100% align=right><img name=pict2 border=0 onClick=AddCancel() src="images/BUTTON_CANCEL.PNG" onMouseOver="changeImg2('images/BUTTON_CANCEL_SELECTED')" onMouseOut="changeImg2('images/BUTTON_CANCEL')"></td>
 	</tr>
 </table>	
</body>
</html>