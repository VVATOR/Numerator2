<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="OracleConnect.SQLRequest" import="NumGenerator.NumGenerate" import="java.util.*"%>
<%@page import="java.util.ArrayList" %>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<style type="text/css" title="currentStyle">
@import "css/demo_page.css";
@import "css/demo_table.css";
</style>
<script type="text/javascript" language="javascript" src="js/jquery.js"></script>
<script type="text/javascript" language="javascript" src="js/jquery.dataTables.js"></script>
<script type="text/javascript" language="javascript" src="js/Scroller.js"></script>
<script type="text/javascript" language="javascript" src="js/jquery.loading.min.js"></script>
<script type="text/javascript" charset="windows-1251">
<%
//----------------------------------------------------------------------------------------
//									ОБЪЯВЛЕНИЕ ПЕРЕМЕННЫХ
//----------------------------------------------------------------------------------------
 //создаем переменную разбиения на части обозначения
 NumGenerate num = new NumGenerate();
 //массив доверенных лиц
 ArrayList<String> TrustedUsers = new ArrayList<String>();
 //массив статусов
 ArrayList<String> Status = new ArrayList<String>();
 //массив цветов статусов
 ArrayList<String> StatusColors = new ArrayList<String>();
 //переменные для разбиаения строки
 String delimiter = " ";
 String[] temp;
 String ExplodedOBOZ="";
 //разбитое обозначение
 String URL = "";
 String OBOZ_PREFIX = "";
 String OBOZ_FIRST_NUM = "";
 String OBOZ_SECOND_NUM = "";
 String OBOZ_THERD_NUM = "";
 String OBOZ_POSTFIX = "";
 String tempFULLNAME = "";
 String ACADNEWFULLNAME="";
 String Type = "";
 SQLRequest sql = new SQLRequest();
 String SessionUser = "";
 if(session.getAttribute("SessionUser") != null) SessionUser = session.getAttribute("SessionUser").toString();			//пользователь сессии
 String FULLNAME = "";
 if(session.getAttribute("FULLNAME") != null) FULLNAME = session.getAttribute("FULLNAME").toString();					//ФИО
 String DEPARTMENT = "";
 if(session.getAttribute("DEPARTMENT") != null) DEPARTMENT = session.getAttribute("DEPARTMENT").toString();				//Отдел
 String SelectedItem="";
 if(request.getParameter("SelectedItem") != null){
 	 SelectedItem = new String (request.getParameter("SelectedItem").getBytes("ISO-8859-1"));
 }
 
 String Action="";
 if(request.getParameter("Action") != null)
	 Action = new String (request.getParameter("Action").getBytes("ISO-8859-1"));
 
	if(request.getParameter("ACADNEWFULLNAME")!=null){
		ACADNEWFULLNAME=new String(request.getParameter("ACADNEWFULLNAME").getBytes("ISO-8859-1"));
	}
 
 int i=0;
 boolean lbl = false;
 boolean full_access = false;
 ArrayList<String> lSelectedTree;
 lSelectedTree = new ArrayList<String>(); 
 int lSelectedTreeCount=0;
 //----------------------------------------------------------------------------------------
 //                        выполняем переданные странице действия
 //----------------------------------------------------------------------------------------
 if(Action.equals("1")){
	 //изменение статуса
	 String changeStatusOboz = "";
	 String changeStatusID = "";
	 if(request.getParameter("changeStatusOboz") != null)
		 changeStatusOboz = new String (request.getParameter("changeStatusOboz").getBytes("ISO-8859-1"));
	 if(request.getParameter("changeStatusID") != null)
		 changeStatusID = new String (request.getParameter("changeStatusID").getBytes("ISO-8859-1"));
	 sql.InsertStatistic("5",FULLNAME,"Определение наименования отключено",changeStatusOboz);
	 sql.UpdateStatus(changeStatusID, changeStatusOboz);
 }
 //----------------------------------------------------------------------------------------
 //                          Получение текущего пользователя
 //         выполняется, если странице не были переданы данные о пользователе
 //----------------------------------------------------------------------------------------
	if (SessionUser.equals("")) {
		String s = "";
		response.setHeader("Cache-Control", "no-cache");
		String auth = request.getHeader("Authorization");
		if (auth == null) {
			response.setStatus(response.SC_UNAUTHORIZED);
			response.setHeader("WWW-Authenticate", "NTLM");
			return;
		}
		if (auth.startsWith("NTLM ")) {
			byte[] msg = new sun.misc.BASE64Decoder().decodeBuffer(auth
					.substring(5));
			int off = 0, length, offset;
			if (msg[8] == 1) {
				off = 18;
				byte z = 0;
				byte[] msg1 = { (byte) 'N', (byte) 'T', (byte) 'L',
						(byte) 'M', (byte) 'S', (byte) 'S', (byte) 'P',
						z, (byte) 2, z, z, z, z, z, z, z, (byte) 40, z,
						z, z, (byte) 1, (byte) 130, z, z, z, (byte) 2,
						(byte) 2, (byte) 2, z, z, z, z, z, z, z, z, z,
						z, z, z };
				response.setStatus(response.SC_UNAUTHORIZED);
				response.setHeader("WWW-Authenticate",
						"NTLM "
								+ new sun.misc.BASE64Encoder()
										.encodeBuffer(msg1).trim());
				return;
			} else if (msg[8] == 3) {
				off = 30;
				length = msg[off + 17] * 256 + msg[off + 16];
				offset = msg[off + 19] * 256 + msg[off + 18];
				s = new String(msg, offset, length);
			} else
				return;
			length = msg[off + 1] * 256 + msg[off];
			offset = msg[off + 3] * 256 + msg[off + 2];
			s = new String(msg, offset, length);
			length = msg[off + 9] * 256 + msg[off + 8];
			offset = msg[off + 11] * 256 + msg[off + 10];
			s = new String(msg, offset, length);
			//убираем лишние символы
			i = 0;
			String str1 = "";
			while (i < s.length()) {
				str1 += s.charAt(i);
				i = i + 2;
			}
			s = str1;
		}
		//s = "SergV";
		//s = "ZurAA"; 
		//s = "SWK";
		//s = "Kondrat";
		//s = "AnTat";
		//s = "LenaVG";
		//s = "Wst";
		//s = "AWT";
		//s="SAG";//Шаго
		//s="ANTONS";//Черненков 
		//s="SAI";//Стреницкая
		//s="ALEXNL";
		//s="GVA"; 
		//s="SCHET";//Щетинин
		SessionUser = s;
		//получаем ФИО этого пользователя
		SessionUser = SessionUser.toUpperCase();
		FULLNAME = "";
		DEPARTMENT = "";
		sql.GetUserFioAndDepartmentFromLogin(SessionUser);
		while (sql.rs.next()) {
			FULLNAME = sql.rs.getString("FULLNAME");
			DEPARTMENT = sql.rs.getString("DEPARTMENT_ABB");
		}
		session.setAttribute("SessionUser", SessionUser);
		session.setAttribute("FULLNAME", FULLNAME);
		session.setAttribute("DEPARTMENT", DEPARTMENT);
		response.setStatus(response.SC_UNAUTHORIZED);
		response.setHeader("WWW-Authenticate", null);
 }
 //--------------------------------------------------------------------------------
 //                     ФОРМИРУЕМ МАССИВ ЛИЦ ИМЕЮЩИХ ДОСТУП
 //--------------------------------------------------------------------------------
 TrustedUsers.add(FULLNAME);
 sql.GetUsersHaveAcces(SessionUser);
 while(sql.rs.next()){
	 if(sql.rs.getString("FULLNAME") != null) TrustedUsers.add(sql.rs.getString("FULLNAME"));
 }
 //--------------------------------------------------------------------------------
 //                        ПОЛУЧАЕМ СТАТУСЫ И ИХ ЦВЕТА
 //--------------------------------------------------------------------------------
 sql.GetAllStatus();
	while(sql.rs.next()){
		//формируем таблицу статусов и цветов
    	Status.add(sql.rs.getString("STATUS"));
		StatusColors.add(sql.rs.getString("COLOR"));
	}
 //--------------------------------------------------------------------------------
%> 
			var oTable;

			/* Formating function for row details */
			function fnFormatDetails ( nTr )
			{
				var aData = oTable.fnGetData( nTr );
				var sOut = '<table cellpadding="0" cellspacing="0" border="0" style="padding-left:50px;">';
				//sOut += '<tr><td>Исполнитель:</td><td>'+aData[7]+'</td></tr>';
				sOut += '<tr><td>Разработчик чертежа:</td><td>'+aData[8]+'</td></tr>';
				sOut += '<tr><td>Материал:</td><td>'+aData[9]+'</td></tr>';
				sOut += '<tr><td>Количество в узле:</td><td>'+aData[10]+'</td></tr>';
				sOut += '<tr><td>Количество в машине:</td><td>'+aData[11]+'</td></tr>';
				sOut += '<tr><td>Масса:</td><td>'+aData[12]+'</td></tr>';
				sOut += '<tr><td>Формат:</td><td>'+aData[13]+'</td></tr>';
				sOut += '<tr><td>Количество А1:</td><td>'+aData[14]+'</td></tr>';
				sOut += '<tr><td>Количество А4:</td><td>'+aData[15]+'</td></tr>';
				sOut += '<tr><td>Модель CREO:</td><td>'+aData[16]+'</td></tr>';
				sOut += '<tr><td>Чертеж AutoCAD:</td><td>'+aData[17]+'</td></tr>';
				sOut += '<tr><td>Примечание:</td><td>'+aData[18]+'</td></tr>';
				
				sOut += '</table>';
				
				return sOut;
			}
			

			
			$(document).ready(function() {
				try{	
					/*
					 * Insert a 'details' column to the table
					 */				
					var nCloneTh = document.createElement( 'th' );
					var nCloneTd = document.createElement( 'td' );
					nCloneTd.innerHTML = '<img src="images/details_open.png">';
					nCloneTd.className = "center";
					
					$('#MainTableASM thead tr').each( function () {
						this.insertBefore( nCloneTh, this.childNodes[0] );
					} );
					
					$('#MainTableASM tbody tr').each( function () {
						this.insertBefore(  nCloneTd.cloneNode( true ), this.childNodes[0] );
					} );
					
					/*
					 * Initialse DataTables, with no sorting on the 'details' column
					 */
					oTable = $('#MainTableASM').dataTable( {
						"aoColumns": [
										{ "bSortable": false },
										null, 					 /* Обозначение */
										null, 					 /* Действия */
										null, 					 /* Наименование */
										null, 					 /* Тип */
										null, 					 /* Первичная применяемость */
										null,					 /* Исполнитель */  
										null,					 /* Статус */ 
										{ "bVisible":    true  },/* Разработчик чертежа */  
										{ "bVisible":    false },/* Материал */ 
										{ "bVisible":    false },/* Количество в узле */  
										{ "bVisible":    false },/* Количество в машине */ 
										{ "bVisible":    false },/* Масса */  
										{ "bVisible":    false },/* Формат */  
										{ "bVisible":    false },/* Количество А1 */  
										{ "bVisible":    false },/* Количество А4 */ 
										{ "bVisible":    false },/* Модель CREO */ 
										{ "bVisible":    false },/* Чертеж AutoCAD */ 
										{ "bVisible":    false } /* Примечание */ 
									],
						"oLanguage": {
							"sLengthMenu": "Показывать _MENU_ записей на странице",
							"sZeroRecords": "Извините, ничего не найдено",
							"sInfo": "Показано с _START_ по _END_ из _TOTAL_ записей",
							"sInfoEmtpy": "Показано с 0 по 0 из 0 записей",
							"sInfoFiltered": "(выбрано из _MAX_ записей)",
							"oPaginate": {
								"sFirst":    "Первая",
								"sPrevious": "Предыдущая",
								"sNext":     "Следующая",
								"sLast":     "Последняя",
							},
							"sSearch": "Поиск:",
							"sProcessing": "Ожидайте...",							
						},
						"sScrollY": "580px",
						"bPaginate": false,
					});
					
					/* Add event listener for opening and closing details
					 * Note that the indicator for showing which row is open is not controlled by DataTables,
					 * rather it is done here
					 */
					$('td img', oTable.fnGetNodes() ).each( function () {
						$(this).click( function () {
							var nTr = this.parentNode.parentNode;
							if ( this.src.match('images/details_close.png') )
							{
								/* This row is already open - close it */
								this.src = "images/details_open.png";
								oTable.fnClose( nTr );
							} else
							if ( this.src.match('images/details_open.png') )
							{
								/* Open this row */
								this.src = "images/details_close.png";
								oTable.fnOpen( nTr, fnFormatDetails(nTr), 'details' );
							}
						} );
					} );			
				
						
				}catch(e)
				{
					// Здесь обработана ошибка javascripta выводящего таблицу с оформлением.
					// При старте приложения параметры не заполнены и таблица не готова для отображения...
					// Принудительная обработка ошибки скрипта.
					$("#container").html("<center><h1>Добро пожаловать в прогрмму Нумератор!</h1></center>");
				}
			});
			


			
</script>
<script type="text/javascript" language="JavaScript">
 function changeImg1_1(source)
 {  document.pict1_1.src = source + '.png';
 };
 function changeImg1_2(source)
 {  document.pict1_2.src = source + '.png';
 };
 function changeImg1_3(source)
 {  document.pict1_3.src = source + '.png';
 };
 function changeImg1_4(source)
 {  document.pict1_4.src = source + '.png';
 };
 function changeImg1_5(source)
 {  document.pict1_5.src = source + '.png';
 };
 function changeImg1_6(source)
 {  document.pict1_6.src = source + '.png';
 };
 function changeImg1_7(source)
 {  document.pict1_7.src = source + '.png';
 };
 function changeImg2_1(source)
 {  document.pict2_1.src = source + '.png';
 };
 function changeImg2_2(source)
 {  document.pict2_2.src = source + '.png';
 };
 function changeImg2_3(source)
 {  document.pict2_3.src = source + '.png';
 };
 function changeImg2_4(source)
 {  document.pict2_4.src = source + '.png';
 };
 function changeImg3_1(source)
 {  document.pict3_1.src = source + '.png';
 };
 function changeImg3_2(source)
 {  document.pict3_2.src = source + '.png';
 };
 function changeImgPictInfo(source)
 {  document.PictInfo.src = source + '.png';
 };
 function changeImg4(source)
 {  document.Strelka.src = source + '.png';
 };
</script>
<script type="text/javascript"> 
function show_history(user){ 
	window.open("ShowHistory.jsp?SelectedItem="+user);
}
function StatusChange(oboz){
	var selElement = document.getElementById(oboz);
	var status = selElement.options[selElement.selectedIndex].text;
	var status_id = -1;
	if(status == 'Проработка') status_id = 1; 
	if(status == 'Выдано в ЭП') status_id = 2;
	if(status == 'Завод-калька') status_id = 3;
	if(status == 'Аннулирован') status_id = 4;
	if(status == 'Завод - разрешение') status_id = 6;
	if(status == 'Разрешено чертить') status_id = 7;
	if(status == 'Чертеж готов') status_id = 8;
	if(status == 'Корректировка') status_id = 9; 
	if(status == 'Завод - извещение') status_id = 10; 
	document.getElementById('changeStatusOboz').value = oboz;
	document.getElementById('changeStatusID').value = status_id;
	document.changeStatus.submit();
}
</script>
<title>Нумератор 2 (<%=FULLNAME%>)</title>
</head>
<body id="dt_example" background="images/background.png">
<table border=0 CELLPADDING=0 CELLSPACING=0>
	<tr>
		<td valign=top rowspan="2" width=175><img src="images/1.png" align="top"></img></td>
		<td >
			<table border=0 cellpadding=0 cellspacing=0 align="left" style="vertical-align: bottom;" width="100%">
				<tr>
					<td background="images/2.png" align=right valign=bottom width="100%" height="50" colspan=9></td>
				</tr>
				<tr>
					<td>
						<a href="you_product.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict2_1 src="images/2-1_.png" title="Ваши изделия" onMouseOver="changeImg2_1('images/2-1')" onMouseOut="changeImg2_1('images/2-1_')" border=0></img></a>
					</td>
					<td>
						<a href="you_assembly.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict2_2 src="images/2-2_.png" title="Ваши узлы" onMouseOver="changeImg2_2('images/2-2')" onMouseOut="changeImg2_2('images/2-2_')" border=0></img></a>
					</td>
					<td rowspan=4 width="100">
					</td>
					<td align="center">
						<a href="insert_product.jsp?SelectedItem="><img name=pict3_1 src="images/3-1_.png" onMouseOver="changeImg3_1('images/3-1')" onMouseOut="changeImg3_1('images/3-1_')" border=0 title="Создать новое изделие"></img></a>
					</td>
					<td rowspan=4 width="100">
					</td>
					<td align="center">
						<a href="AutoCAD.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1_1 src="images/1-1_.png" title="Автопростановка чертежей AutoCAD" onMouseOver="changeImg1_1('images/1-1')" onMouseOut="changeImg1_1('images/1-1_')"  border=0></img></a>
					</td>
					<td rowspan=4 width="100">
					</td>
					<td align="center">
						<a href="help.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1_5 src="images/1-5_.png" title="Справка" onMouseOver="changeImg1_5('images/1-5')" onMouseOut="changeImg1_5('images/1-5_')" border=0></img></a>
					</td>
					<td>
						<a href="search.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1_4 src="images/1-4.png" title="Поиск" onMouseOver="changeImg1_4('images/1-4_')" onMouseOut="changeImg1_4('images/1-4')" border=0></img></a>
					</td>
				</tr>
				<tr>
					<td colspan=2 align="center">
						<a href="other_product.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict2_4 src="images/2-4_.png" title="Изделия смежных разработчиков" onMouseOver="changeImg2_4('images/2-4')" onMouseOut="changeImg2_4('images/2-4_')" border=0></img></a>
					</td>
					<td>
						<%
							//получаем пользователя для текущего обозначения
							if(!SelectedItem.equals("")){
								sql.GetUserForOBOZ(SelectedItem);
								if(sql.rs.next())
									if(sql.rs.getString("FULLNAME") != null){
										if(TrustedUsers.contains(sql.rs.getString("FULLNAME"))) full_access = true;
										tempFULLNAME = sql.rs.getString("FULLNAME");
									}
									else tempFULLNAME = "Unknown";
							}
							if(TrustedUsers.contains(tempFULLNAME))
								out.println("<a href=\"insert.jsp?SelectedItem=" + URLEncoder.encode(SelectedItem,"windows-1251") + "\"><img name=pict3_2 src=\"images/3-2.png\" onMouseOver=\"changeImg3_2('images/3-2-')\" onMouseOut=\"changeImg3_2('images/3-2')\" border=0 title=\"Добавить деталь или сборку\"></img></a>");
							else
								out.println("<img src=\"images/3-2_.png\" border=0 title=\"Добавление детали или сборки не доступно\"></img>");
							%>
					</td>
					<td align="center">
						<a href="Creo.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1_2 src="images/1-2_.png" title="Автопростановка моделей CREO" onMouseOver="changeImg1_2('images/1-2')" onMouseOut="changeImg1_2('images/1-2_')" border=0></img></a>
					</td>
					<td>
						<a href="BugTracker.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1_6 src="images/1-6_.png" title="Замечания" onMouseOver="changeImg1_6('images/1-6')" onMouseOut="changeImg1_6('images/1-6_')" border=0></img></a>
					</td>
					<td>
						<a href="colors.jsp"><img name=pict1_7 src="images/1-7_.png" title="Цвета" onMouseOver="changeImg1_7('images/1-7')" onMouseOut="changeImg1_7('images/1-7_')" border=0></img></a>
					</td>
				</tr>
				<tr>
					<td colspan=2 align="center">
						<a href="you_users.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict2_3 src="images/2-3_.png" title="Ваши доверенные пользователи" onMouseOver="changeImg2_3('images/2-3')" onMouseOut="changeImg2_3('images/2-3_')" border=0></img></a>
					</td>
				</tr>
			</table>
		</td>
		<td valign=top rowspan="2" width=130><img src="images/3.png"></img></td>
	</tr>
	<tr>
	</tr>
</table>
<h1></h1>

<table border=0 CELLPADDING=0 CELLSPACING=0 align="center">
	<tr>
		<td valign=top><font size=3 color="#6495ED">Нумератор для:</font></td>
		<%
		if(SelectedItem.equals("")){
			//если ничего не выбрано показываем список изделий
			out.println("<td valign=top>");
			out.println("<script type=\"text/javascript\">");
			out.println("function selForm1_submit(){");
			out.println("	selForm1.submit();");
			out.println("}");
			out.println("</script>");
			out.println("<form name=selForm1>");
			out.println("<select size=\"1\" name=\"SelectedItem\" onchange=selForm1_submit()>");
			if(SelectedItem.equals("")) 
				out.println("<option selected>Выберите изделие</option>");
			sql.GetProductList();
			while(sql.rs.next()){
				if(!SelectedItem.equals(sql.rs.getString("OBOZNACHENIE")))
					out.println("<option>" + sql.rs.getString("OBOZNACHENIE") + "</option>");	
				else
					out.println("<option selected>" + sql.rs.getString("OBOZNACHENIE") + "</option>");
			}
			out.println("</select>");
			out.println("</form>");
			out.println("</td>");
		}else{
			//что-то выбрано
			//считываем дерево в обратную сторону (до выбранного элемента)
			sql.GetBackList(SelectedItem);
			while(sql.rs.next()){
				if(sql.rs.getInt("LEVEL") != 1){
					lSelectedTree.add(sql.rs.getString("OBOZNACHENIE"));
					lSelectedTreeCount++;
				}
			}
			//отображаем все предыдущие списки
			for(i=lSelectedTreeCount;i>0;i--){
				if(i != lSelectedTree.size()) out.println("<td valign=top>-</td>");
				out.println("<td valign=top>");
				out.println("<script type=\"text/javascript\">");
				out.println("function selFormPrev" + i + "_submit(){");
				out.println("	selFormPrev" + i + ".submit();");
				out.println("}");
				out.println("</script>");			
				out.println("<form name=selFormPrev" + i + ">");
				out.println("<select size=\"1\" name=\"SelectedItem\" onchange=selFormPrev" + i + "_submit()>");
				out.println("<option selected>" + lSelectedTree.get(i-1) + "</option>");
				//добавляем остальные варианты
				if(i==lSelectedTreeCount){
					//нужно добавить изделия
					sql.GetProductList();
					while(sql.rs.next()){
						out.println("<option>" + sql.rs.getString("OBOZNACHENIE") + "</option>");
					}
				} else{
					//нужно добавить подузлы (делаем запрос для предыдущего элемнета)
					sql.GetNextLevel(lSelectedTree.get(i));
					while(sql.rs.next()){
						if(!lSelectedTree.get(i-1).equals(sql.rs.getString("OBOZNACHENIE")))
							out.println("<option>" + sql.rs.getString("OBOZNACHENIE") + "</option>");
					}
					
				}
				out.println("</select>");
				out.println("</form>");
				out.println("</td>");
				
			}
			//отображаем текущий список
			if(lSelectedTreeCount > 0) out.println("<td valign=top>-</td>");
			out.println("<td valign=top>");
			out.println("<script type=\"text/javascript\">");
			out.println("function selFormCur_submit(){");
			out.println("	selFormCur.submit();");
			out.println("}");
			out.println("</script>");
			out.println("<form name=selFormCur>");
			out.println(" <select size=\"1\" name=\"SelectedItem\" onchange=selFormCur_submit()>");
			out.println("<option selected style=\"background-color: #CDECFE\">" + SelectedItem + "</option>");
			//добавляем остальные варианты
			if(lSelectedTreeCount==0){
				//нужно добавить изделия
				sql.GetProductList();
				while(sql.rs.next()){
					out.println("<option>" + sql.rs.getString("OBOZNACHENIE") + "</option>");
				}
			} else{
				//нужно добавить подузлы
				sql.GetNextLevel(lSelectedTree.get(0));
				while(sql.rs.next()){
					if(!SelectedItem.equals(sql.rs.getString("OBOZNACHENIE")))
						out.println("<option>" + sql.rs.getString("OBOZNACHENIE") + "</option>");
				}
			}
			out.println("</select>");
			out.println("</form>");
			out.println("</td>");
			//отображаем следующий список (если есть что отображать)
			sql.GetNextLevel(SelectedItem);
			while(sql.rs.next()){
				if(lbl == false){
					out.println("<td valign=top>-</td>");
					out.println("<td valign=top>");
					out.println("<script type=\"text/javascript\">");
					out.println("function selFormNext_submit(){");
					out.println("	selFormNext.submit();");
					out.println("}");
					out.println("</script>");
					out.println("<form name=selFormNext style=\"valign: middle\">");
					out.println("<select size=\"1\" name=\"SelectedItem\" onchange=selFormNext_submit()>");
					out.println("<option selected>Выберите подузел</option>");
					lbl = true;
				}
				out.println("<option>" + sql.rs.getString("OBOZNACHENIE") + "</option>");
			}
			if(lbl == true){
				out.println("</select>");
				out.println("</form>");
				out.println("</td>");
			}
			//отображаем кнопку назад если она нужна
			if(lSelectedTreeCount > 0){
				out.println("<td valign=top>");
				out.println("<a href=\"index.jsp?SelectedItem=" + lSelectedTree.get(0) + "\"><img src=\"images/back.png\" name=Strelka onMouseOver=\"changeImg4('images/back2')\" onMouseOut=\"changeImg4('images/back')\" border=0 title=\"Назад\" width=20 height=20></img></a>");
				out.println("</td>");
			}
			if(!SelectedItem.equals("")){
				out.println("<td valign=top>");
				out.println("&nbsp;&nbsp;");
				out.println("<a href=\"percent_info.jsp?SelectedItem=" + URLEncoder.encode(SelectedItem,"windows-1251") + "\"><img name=PictInfo width=20 height=20 src=\"images/percent.png\" onMouseOver=\"changeImgPictInfo('images/percent2')\" onMouseOut=\"changeImgPictInfo('images/percent')\" title=\"Подробная статистика по узлу\" border=0></img></a>");
				out.println("</td>");
			}
		}
		%>
			</tr>
	</table>
						
				<!-- Основное содержимое -->
				<!-- Сборочные единицы -->
				<%
				if(!SelectedItem.equals(""))
					out.println("<h1>Детали и Сборочные единицы для " + SelectedItem + "</h1>");
				else
					out.println("<h1>Детали и Сборочные единицы </h1>");
				%>
				
				
			
				
				<div id="container" style="width:95%">
					<%@ include file="/MVC/main_table/main_table.jsp" %>				
				</div>	
				<!-- Конец основного содержимого -->
				<form name=changeStatus action=index.jsp>
					<input type=hidden name=changeStatusOboz id=changeStatusOboz value="">
					<input type=hidden name=changeStatusID id=changeStatusID value="">
					<input type=hidden name=SelectedItem id=SelectedItem value="<%=SelectedItem%>">
					<input type=hidden name=Action id=action value="1">
				</form>
				
</body>
</html>