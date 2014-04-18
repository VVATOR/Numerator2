<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<%@page import="OracleConnect.SQLRequest" import="NumGenerator.NumGenerate" import="java.util.*"%>
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
<title>Подробная статистика по узлу</title>
<%
//переменные для разбиаения строки
String delimiter = " ";
String[] temp;
String ExplodedOBOZ="";
NumGenerate num = new NumGenerate();
//---------------------------------
String OBOZ_PREFIX = "";
String OBOZ_FIRST_NUM = "";
String OBOZ_SECOND_NUM = "";
String OBOZ_THERD_NUM = "";
String OBOZ_POSTFIX = "";
String Type = "";
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
%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>Подробная статистика по узлу</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<%
	//ПЕРЕМЕННЫЕ ДЛЯ ОТЧЕТА
	int VSEGO_ASM = 0;
	int VSEGO_PRT= 0;
	int VSEGO = 0;
	int VSEGO_ASM_A4 = 0;
	int VSEGO_PRT_A4= 0;
	int VSEGO_A4 = 0;
	//------
	int RAZRAB_ASM = 0;
	int RAZRAB_PRT = 0;
	int RAZRAB_VSEGO = 0;
	int RAZRAB_ASM_A4 = 0;
	int RAZRAB_PRT_A4 = 0;
	int RAZRAB_VSEGO_A4 = 0;
	//------
	int OSTALOS_ASM = 0;
	int OSTALOS_PRT = 0;
	int OSTALOS_VSEGO = 0;
	int OSTALOS_ASM_A4 = 0;
	int OSTALOS_PRT_A4 = 0;
	int OSTALOS_VSEGO_A4 = 0;
	//------
	int ERROR_ASM_A4 = 0;
	int ERROR_PRT_A4 = 0;
	if(!SelectedItem.equals("")){
						sql.GetTreeForOBOZ(SelectedItem);
						while(sql.rs.next()){
							if(sql.rs.getString("OBOZ_THERD_NUM").charAt(sql.rs.getString("OBOZ_THERD_NUM").length()-1) == '0'){
								//--------------------------------------------------
								//                        СБОРКИ
								//--------------------------------------------------
								//ВСЕГО СБОРОК
								VSEGO_ASM++;
								//ВСЕГО СБОРОК А4
								try{
									VSEGO_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 	
									ERROR_ASM_A4++;
								}
								//--------------------------------------------------
								//           В ЗАВИСИМОСТИ ОТ СТАТУСА
								//--------------------------------------------------
								switch(sql.rs.getInt("STATUS_ID")){
								case 1:
									//СБОРОК СТАЛОСЬ
									OSTALOS_ASM++;
									//СБОРОК ОСТАЛОСЬ А4
									try{
										OSTALOS_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 2: 
									//СБОРОК РАЗРАБОТАНО
									RAZRAB_ASM++;
									//СБОРОК РАЗРАБОТАНО А4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 3:  
									//СБОРОК РАЗРАБОТАНО
									RAZRAB_ASM++;
									//СБОРОК РАЗРАБОТАНО А4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 4:  
									//СБОРОК РАЗРАБОТАНО
									RAZRAB_ASM++;
									//СБОРОК РАЗРАБОТАНО А4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 6:  
									//СБОРОК РАЗРАБОТАНО
									RAZRAB_ASM++;
									//СБОРОК РАЗРАБОТАНО А4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 7: 
									//СБОРОК ОСТАЛОСЬ
									OSTALOS_ASM++;
									//СБОРОК ОСТАЛОСЬ А4
									try{
										OSTALOS_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 8:  
									//СБОРОК РАЗРАБОТАНО
									RAZRAB_ASM++;
									//СБОРОК РАЗРАБОТАНО А4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 9:  
									//СБОРОК РАЗРАБОТАНО
									RAZRAB_ASM++;
									//СБОРОК РАЗРАБОТАНО А4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 10:  
									//СБОРОК РАЗРАБОТАНО
									RAZRAB_ASM++;
									//СБОРОК РАЗРАБОТАНО А4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								}
								//--------------------------------------------------
							}
							else{
								//--------------------------------------------------
								//                        ДЕТАЛИ
								//--------------------------------------------------
								//ВСЕГО ДЕТАЛЕЙ
								VSEGO_PRT++;
								//ВСЕГО ДЕТАЛЕЙ А4
								try{
									VSEGO_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 
									ERROR_PRT_A4++;
								}
								//--------------------------------------------------
								//           В ЗАВИСИМОСТИ ОТ СТАТУСА
								//--------------------------------------------------
								switch(sql.rs.getInt("STATUS_ID")){
								case 1:
									//ДЕТАЛЕЙСТАЛОСЬ
									OSTALOS_PRT++;
									//ДЕТАЛЕЙОСТАЛОСЬ А4
									try{
										OSTALOS_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 2: 
									//ДЕТАЛЕЙРАЗРАБОТАНО
									RAZRAB_PRT++;
									//ДЕТАЛЕЙРАЗРАБОТАНО А4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 3:  
									//ДЕТАЛЕЙРАЗРАБОТАНО
									RAZRAB_PRT++;
									//ДЕТАЛЕЙРАЗРАБОТАНО А4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 4:  
									//ДЕТАЛЕЙРАЗРАБОТАНО
									RAZRAB_PRT++;
									//ДЕТАЛЕЙРАЗРАБОТАНО А4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 6:  
									//ДЕТАЛЕЙРАЗРАБОТАНО
									RAZRAB_PRT++;
									//ДЕТАЛЕЙРАЗРАБОТАНО А4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 7: 
									//ДЕТАЛЕЙОСТАЛОСЬ
									OSTALOS_PRT++;
									//ДЕТАЛЕЙОСТАЛОСЬ А4
									try{
										OSTALOS_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 8:  
									//ДЕТАЛЕЙРАЗРАБОТАНО
									RAZRAB_PRT++;
									//ДЕТАЛЕЙРАЗРАБОТАНО А4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 9:  
									//ДЕТАЛЕЙРАЗРАБОТАНО
									RAZRAB_PRT++;
									//ДЕТАЛЕЙРАЗРАБОТАНО А4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 10:  
									//ДЕТАЛЕЙРАЗРАБОТАНО
									RAZRAB_PRT++;
									//ДЕТАЛЕЙРАЗРАБОТАНО А4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								}
								//--------------------------------------------------
							}
							//ВСЕГО
							VSEGO++;
							//ВСЕГО А4
							try{
								VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
							}	
							catch (Exception e){ 		
							}
							//--------------------------------------------------
							//           В ЗАВИСИМОСТИ ОТ СТАТУСА
							//--------------------------------------------------
							switch(sql.rs.getInt("STATUS_ID")){
							case 1:
								//ВСЕГО СТАЛОСЬ
								OSTALOS_VSEGO++;
								//ВСЕГО ОСТАЛОСЬ А4
								try{
									OSTALOS_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 2: 
								//ВСЕГО РАЗРАБОТАНО
								RAZRAB_VSEGO++;
								//ВСЕГО РАЗРАБОТАНО А4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 3:  
								//ВСЕГО РАЗРАБОТАНО
								RAZRAB_VSEGO++;
								//ВСЕГО РАЗРАБОТАНО А4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 4:  
								//ВСЕГО РАЗРАБОТАНО
								RAZRAB_VSEGO++;
								//ВСЕГО РАЗРАБОТАНО А4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 6:  
								//ВСЕГО РАЗРАБОТАНО
								RAZRAB_VSEGO++;
								//ВСЕГО РАЗРАБОТАНО А4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 7: 
								//ВСЕГО ОСТАЛОСЬ
								OSTALOS_VSEGO++;
								//ВСЕГО ОСТАЛОСЬ А4
								try{
									OSTALOS_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 8:  
								//ВСЕГО РАЗРАБОТАНО
								RAZRAB_VSEGO++;
								//ВСЕГО РАЗРАБОТАНО А4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 9:  
								//ВСЕГО РАЗРАБОТАНО
								RAZRAB_VSEGO++;
								//ВСЕГО РАЗРАБОТАНО А4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 10:  
								//ВСЕГО РАЗРАБОТАНО
								RAZRAB_VSEGO++;
								//ВСЕГО РАЗРАБОТАНО А4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							}
							//--------------------------------------------------
						}
	}
	%>
	<h1>Всего</h1>
	<br><font color="#6495ED">Сборок: </font><%=VSEGO_ASM%> <font color="#6495ED"> из </font><%=VSEGO%> 
	<% 
		if(VSEGO != 0) {
			out.println("<font color=\"#6495ED\">(" + VSEGO_ASM*100/VSEGO + "%)</font>");
		}
	%>
	<br><font color="#6495ED">Деталей: </font><%=VSEGO_PRT%> <font color="#6495ED"> из </font><%=VSEGO%>
	<% 
		if(VSEGO != 0) {
			out.println("<font color=\"#6495ED\">(" + VSEGO_PRT*100/VSEGO + "%)</font>");
		}
	%>
	<br><font color="#6495ED">Всего: </font><%=VSEGO%>
	<br>
	<br><font color="#6495ED">Сборок в А4:</font><%=VSEGO_ASM_A4%><font color="#6495ED"> из </font><%=VSEGO_A4%>
	<% 
		if(VSEGO_ASM_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + VSEGO_ASM_A4*100/VSEGO_A4 + "%)</font>");
		}
		if(ERROR_ASM_A4 > 0){
			out.println("<font color=\"#FF0000\"> ! " + ERROR_ASM_A4 + " из " + VSEGO_ASM_A4 + " количесво форматов А4 для сборок не удалось определить. Погрешность составит: " + ERROR_ASM_A4*100/VSEGO_ASM_A4 + "%</font>");
		}
	%>
	<br><font color="#6495ED">Деталей в А4:</font><%=VSEGO_PRT_A4%><font color="#6495ED"> из </font><%=VSEGO_A4%>
	<% 
		if(VSEGO_PRT_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + VSEGO_PRT_A4*100/VSEGO_A4 + "%)</font>");
		}
		if(ERROR_PRT_A4 > 0){
			out.println("<font color=\"#FF0000\"> ! " + ERROR_PRT_A4 + " из " + VSEGO_PRT_A4 + " количесво форматов А4 для деталей не удалось определить. Погрешность составит: " + ERROR_PRT_A4*100/VSEGO_PRT_A4 + "%</font>");
		}
	%>
	<br><font color="#6495ED">Всего в А4:</font><%=VSEGO_A4%>
	<h1>Разработано</h1>
	<br><font color="#6495ED">Разработано чертежей сборок:</font><%=RAZRAB_ASM%> <font color="#6495ED"> из </font><%=VSEGO_ASM%>
	<% 
		if(VSEGO_ASM != 0) {
			out.println("<font color=\"#6495ED\">(" + RAZRAB_ASM*100/VSEGO_ASM + "%)</font>");
			if((RAZRAB_ASM*100/VSEGO_ASM) == 100)
				out.println("<font color=\"#008080\"> - завершено</font>");
			else
				out.println("<font color=\"#FF0000\"> - не завершено</font>");
		}
	%>
	<br><font color="#6495ED">Разработано чертежей деталей:</font><%=RAZRAB_PRT%> <font color="#6495ED"> из </font><%=VSEGO_PRT%>
	<% 
		if(VSEGO_PRT != 0) {
			out.println("<font color=\"#6495ED\">(" + RAZRAB_PRT*100/VSEGO_PRT + "%)</font>");
			if((RAZRAB_PRT*100/VSEGO_PRT) == 100)
				out.println("<font color=\"#008080\"> - завершено</font>");
			else
				out.println("<font color=\"#FF0000\"> - не завершено</font>");
		}
	%>
	<br><font color="#6495ED">Разработано чертежей всего:</font><%=RAZRAB_VSEGO%>
	<br>
	<br><font color="#6495ED">Разработано чертежей сборок в А4:</font><%=RAZRAB_ASM_A4%><font color="#6495ED"> из </font><%=VSEGO_ASM_A4%>
	<% 
		if(VSEGO_ASM_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + RAZRAB_ASM_A4*100/VSEGO_ASM_A4 + "%)</font>");
		}
	%>
	<br><font color="#6495ED">Разработано чертежей деталей в А4:</font><%=RAZRAB_PRT_A4%><font color="#6495ED"> из </font><%=VSEGO_PRT_A4%>
	<% 
		if(VSEGO_PRT_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + RAZRAB_PRT_A4*100/VSEGO_PRT_A4 + "%)</font>");
		}
	%>
	<br><font color="#6495ED">Разработано чертежей всего в А4:</font><%=RAZRAB_VSEGO_A4%>
	<h1>Осталось</h1>
	<br><font color="#6495ED">Осталось сборок:</font><%=OSTALOS_ASM%><font color="#6495ED"> из </font><%=VSEGO_ASM%>
	<% 
		if(VSEGO_ASM != 0) {
			out.println("<font color=\"#6495ED\">(" + OSTALOS_ASM*100/VSEGO_ASM + "%)</font>");
		}
	%>
	<br><font color="#6495ED">Осталось деталей:</font><%=OSTALOS_PRT%><font color="#6495ED"> из </font><%=VSEGO_PRT%>
	<% 
		if(VSEGO_PRT != 0) {
			out.println("<font color=\"#6495ED\">(" + OSTALOS_PRT*100/VSEGO_PRT + "%)</font>");
		}
	%>
	<br><font color="#6495ED">Осталось всего:</font><%=OSTALOS_VSEGO%>
	<br>
	<br><font color="#6495ED">Осталось сборок в А4:</font><%=OSTALOS_ASM_A4%><font color="#6495ED"> из </font><%=VSEGO_ASM_A4%>
	<% 
		if(VSEGO_ASM_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + OSTALOS_ASM_A4*100/VSEGO_ASM_A4 + "%)</font>");
		}
	%>
	<br><font color="#6495ED">Осталось деталей в А4:</font><%=OSTALOS_PRT_A4%><font color="#6495ED"> из </font><%=VSEGO_PRT_A4%>
	<% 
		if(VSEGO_ASM_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + OSTALOS_PRT_A4*100/VSEGO_ASM_A4 + "%)</font>");
		}
	sql.Disconnect();
	%>
	<br><font color="#6495ED">Осталось всего в А4:</font><%=OSTALOS_VSEGO_A4%>
	<h1>Итого времени</h1>
	<br><font color="#6495ED">На сборки (на белок):</font><%=VSEGO_ASM*30/8*0.7*0.4%>
	<br><font color="#6495ED">На сборки (на кальку):</font><%=(30/8*0.3*VSEGO_ASM + (VSEGO_ASM*30/8*0.7*0.4))%>
	<br><font color="#6495ED">На детали (на белок):</font><%=VSEGO_PRT*30/8*0.7*0.4%>
	<br><font color="#6495ED">На детали (на кальку):</font><%=(30/8*0.3*VSEGO_PRT + (VSEGO_PRT*30/8*0.7*0.4))%>
	<br><font color="#6495ED">На сборки от белка до кальки:</font><%=(30/8*0.3*VSEGO_ASM + (VSEGO_ASM*30/8*0.7*0.4)) - VSEGO_ASM*30/8*0.7*0.4%>
	<br><font color="#6495ED">На сборки от белка до кальки:</font><%=(30/8*0.3*VSEGO_PRT + (VSEGO_PRT*30/8*0.7*0.4)) - VSEGO_PRT*30/8*0.7*0.4%>
</body>
</html>