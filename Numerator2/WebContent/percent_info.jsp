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
<title>��������� ���������� �� ����</title>
<%
//���������� ��� ���������� ������
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
if(session.getAttribute("SessionUser") != null) SessionUser = session.getAttribute("SessionUser").toString();			//������������ ������
String FULLNAME = "";
if(session.getAttribute("FULLNAME") != null) FULLNAME = session.getAttribute("FULLNAME").toString();					//���
String DEPARTMENT = "";
if(session.getAttribute("DEPARTMENT") != null) DEPARTMENT = session.getAttribute("DEPARTMENT").toString();				//�����
String SelectedItem="";
if(request.getParameter("SelectedItem") != null)
	 SelectedItem = new String (request.getParameter("SelectedItem").getBytes("ISO-8859-1"));
%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>��������� ���������� �� ����</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<%
	//���������� ��� ������
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
								//                        ������
								//--------------------------------------------------
								//����� ������
								VSEGO_ASM++;
								//����� ������ �4
								try{
									VSEGO_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 	
									ERROR_ASM_A4++;
								}
								//--------------------------------------------------
								//           � ����������� �� �������
								//--------------------------------------------------
								switch(sql.rs.getInt("STATUS_ID")){
								case 1:
									//������ �������
									OSTALOS_ASM++;
									//������ �������� �4
									try{
										OSTALOS_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 2: 
									//������ �����������
									RAZRAB_ASM++;
									//������ ����������� �4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 3:  
									//������ �����������
									RAZRAB_ASM++;
									//������ ����������� �4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 4:  
									//������ �����������
									RAZRAB_ASM++;
									//������ ����������� �4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 6:  
									//������ �����������
									RAZRAB_ASM++;
									//������ ����������� �4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 7: 
									//������ ��������
									OSTALOS_ASM++;
									//������ �������� �4
									try{
										OSTALOS_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 8:  
									//������ �����������
									RAZRAB_ASM++;
									//������ ����������� �4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 9:  
									//������ �����������
									RAZRAB_ASM++;
									//������ ����������� �4
									try{
										RAZRAB_ASM_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 10:  
									//������ �����������
									RAZRAB_ASM++;
									//������ ����������� �4
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
								//                        ������
								//--------------------------------------------------
								//����� �������
								VSEGO_PRT++;
								//����� ������� �4
								try{
									VSEGO_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 
									ERROR_PRT_A4++;
								}
								//--------------------------------------------------
								//           � ����������� �� �������
								//--------------------------------------------------
								switch(sql.rs.getInt("STATUS_ID")){
								case 1:
									//��������������
									OSTALOS_PRT++;
									//��������������� �4
									try{
										OSTALOS_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 2: 
									//������������������
									RAZRAB_PRT++;
									//������������������ �4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 3:  
									//������������������
									RAZRAB_PRT++;
									//������������������ �4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 4:  
									//������������������
									RAZRAB_PRT++;
									//������������������ �4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 6:  
									//������������������
									RAZRAB_PRT++;
									//������������������ �4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 7: 
									//���������������
									OSTALOS_PRT++;
									//��������������� �4
									try{
										OSTALOS_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 8:  
									//������������������
									RAZRAB_PRT++;
									//������������������ �4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 9:  
									//������������������
									RAZRAB_PRT++;
									//������������������ �4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								case 10:  
									//������������������
									RAZRAB_PRT++;
									//������������������ �4
									try{
										RAZRAB_PRT_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
									}	
									catch (Exception e){ 		
									}
									break;
								}
								//--------------------------------------------------
							}
							//�����
							VSEGO++;
							//����� �4
							try{
								VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
							}	
							catch (Exception e){ 		
							}
							//--------------------------------------------------
							//           � ����������� �� �������
							//--------------------------------------------------
							switch(sql.rs.getInt("STATUS_ID")){
							case 1:
								//����� �������
								OSTALOS_VSEGO++;
								//����� �������� �4
								try{
									OSTALOS_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 2: 
								//����� �����������
								RAZRAB_VSEGO++;
								//����� ����������� �4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 3:  
								//����� �����������
								RAZRAB_VSEGO++;
								//����� ����������� �4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 4:  
								//����� �����������
								RAZRAB_VSEGO++;
								//����� ����������� �4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 6:  
								//����� �����������
								RAZRAB_VSEGO++;
								//����� ����������� �4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 7: 
								//����� ��������
								OSTALOS_VSEGO++;
								//����� �������� �4
								try{
									OSTALOS_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 8:  
								//����� �����������
								RAZRAB_VSEGO++;
								//����� ����������� �4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 9:  
								//����� �����������
								RAZRAB_VSEGO++;
								//����� ����������� �4
								try{
									RAZRAB_VSEGO_A4 += Integer.parseInt(sql.rs.getString("A4_COUNT"));
								}	
								catch (Exception e){ 		
								}
								break;
							case 10:  
								//����� �����������
								RAZRAB_VSEGO++;
								//����� ����������� �4
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
	<h1>�����</h1>
	<br><font color="#6495ED">������: </font><%=VSEGO_ASM%> <font color="#6495ED"> �� </font><%=VSEGO%> 
	<% 
		if(VSEGO != 0) {
			out.println("<font color=\"#6495ED\">(" + VSEGO_ASM*100/VSEGO + "%)</font>");
		}
	%>
	<br><font color="#6495ED">�������: </font><%=VSEGO_PRT%> <font color="#6495ED"> �� </font><%=VSEGO%>
	<% 
		if(VSEGO != 0) {
			out.println("<font color=\"#6495ED\">(" + VSEGO_PRT*100/VSEGO + "%)</font>");
		}
	%>
	<br><font color="#6495ED">�����: </font><%=VSEGO%>
	<br>
	<br><font color="#6495ED">������ � �4:</font><%=VSEGO_ASM_A4%><font color="#6495ED"> �� </font><%=VSEGO_A4%>
	<% 
		if(VSEGO_ASM_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + VSEGO_ASM_A4*100/VSEGO_A4 + "%)</font>");
		}
		if(ERROR_ASM_A4 > 0){
			out.println("<font color=\"#FF0000\"> ! " + ERROR_ASM_A4 + " �� " + VSEGO_ASM_A4 + " ��������� �������� �4 ��� ������ �� ������� ����������. ����������� ��������: " + ERROR_ASM_A4*100/VSEGO_ASM_A4 + "%</font>");
		}
	%>
	<br><font color="#6495ED">������� � �4:</font><%=VSEGO_PRT_A4%><font color="#6495ED"> �� </font><%=VSEGO_A4%>
	<% 
		if(VSEGO_PRT_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + VSEGO_PRT_A4*100/VSEGO_A4 + "%)</font>");
		}
		if(ERROR_PRT_A4 > 0){
			out.println("<font color=\"#FF0000\"> ! " + ERROR_PRT_A4 + " �� " + VSEGO_PRT_A4 + " ��������� �������� �4 ��� ������� �� ������� ����������. ����������� ��������: " + ERROR_PRT_A4*100/VSEGO_PRT_A4 + "%</font>");
		}
	%>
	<br><font color="#6495ED">����� � �4:</font><%=VSEGO_A4%>
	<h1>�����������</h1>
	<br><font color="#6495ED">����������� �������� ������:</font><%=RAZRAB_ASM%> <font color="#6495ED"> �� </font><%=VSEGO_ASM%>
	<% 
		if(VSEGO_ASM != 0) {
			out.println("<font color=\"#6495ED\">(" + RAZRAB_ASM*100/VSEGO_ASM + "%)</font>");
			if((RAZRAB_ASM*100/VSEGO_ASM) == 100)
				out.println("<font color=\"#008080\"> - ���������</font>");
			else
				out.println("<font color=\"#FF0000\"> - �� ���������</font>");
		}
	%>
	<br><font color="#6495ED">����������� �������� �������:</font><%=RAZRAB_PRT%> <font color="#6495ED"> �� </font><%=VSEGO_PRT%>
	<% 
		if(VSEGO_PRT != 0) {
			out.println("<font color=\"#6495ED\">(" + RAZRAB_PRT*100/VSEGO_PRT + "%)</font>");
			if((RAZRAB_PRT*100/VSEGO_PRT) == 100)
				out.println("<font color=\"#008080\"> - ���������</font>");
			else
				out.println("<font color=\"#FF0000\"> - �� ���������</font>");
		}
	%>
	<br><font color="#6495ED">����������� �������� �����:</font><%=RAZRAB_VSEGO%>
	<br>
	<br><font color="#6495ED">����������� �������� ������ � �4:</font><%=RAZRAB_ASM_A4%><font color="#6495ED"> �� </font><%=VSEGO_ASM_A4%>
	<% 
		if(VSEGO_ASM_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + RAZRAB_ASM_A4*100/VSEGO_ASM_A4 + "%)</font>");
		}
	%>
	<br><font color="#6495ED">����������� �������� ������� � �4:</font><%=RAZRAB_PRT_A4%><font color="#6495ED"> �� </font><%=VSEGO_PRT_A4%>
	<% 
		if(VSEGO_PRT_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + RAZRAB_PRT_A4*100/VSEGO_PRT_A4 + "%)</font>");
		}
	%>
	<br><font color="#6495ED">����������� �������� ����� � �4:</font><%=RAZRAB_VSEGO_A4%>
	<h1>��������</h1>
	<br><font color="#6495ED">�������� ������:</font><%=OSTALOS_ASM%><font color="#6495ED"> �� </font><%=VSEGO_ASM%>
	<% 
		if(VSEGO_ASM != 0) {
			out.println("<font color=\"#6495ED\">(" + OSTALOS_ASM*100/VSEGO_ASM + "%)</font>");
		}
	%>
	<br><font color="#6495ED">�������� �������:</font><%=OSTALOS_PRT%><font color="#6495ED"> �� </font><%=VSEGO_PRT%>
	<% 
		if(VSEGO_PRT != 0) {
			out.println("<font color=\"#6495ED\">(" + OSTALOS_PRT*100/VSEGO_PRT + "%)</font>");
		}
	%>
	<br><font color="#6495ED">�������� �����:</font><%=OSTALOS_VSEGO%>
	<br>
	<br><font color="#6495ED">�������� ������ � �4:</font><%=OSTALOS_ASM_A4%><font color="#6495ED"> �� </font><%=VSEGO_ASM_A4%>
	<% 
		if(VSEGO_ASM_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + OSTALOS_ASM_A4*100/VSEGO_ASM_A4 + "%)</font>");
		}
	%>
	<br><font color="#6495ED">�������� ������� � �4:</font><%=OSTALOS_PRT_A4%><font color="#6495ED"> �� </font><%=VSEGO_PRT_A4%>
	<% 
		if(VSEGO_ASM_A4 != 0) {
			out.println("<font color=\"#6495ED\">(" + OSTALOS_PRT_A4*100/VSEGO_ASM_A4 + "%)</font>");
		}
	sql.Disconnect();
	%>
	<br><font color="#6495ED">�������� ����� � �4:</font><%=OSTALOS_VSEGO_A4%>
	<h1>����� �������</h1>
	<br><font color="#6495ED">�� ������ (�� �����):</font><%=VSEGO_ASM*30/8*0.7*0.4%>
	<br><font color="#6495ED">�� ������ (�� ������):</font><%=(30/8*0.3*VSEGO_ASM + (VSEGO_ASM*30/8*0.7*0.4))%>
	<br><font color="#6495ED">�� ������ (�� �����):</font><%=VSEGO_PRT*30/8*0.7*0.4%>
	<br><font color="#6495ED">�� ������ (�� ������):</font><%=(30/8*0.3*VSEGO_PRT + (VSEGO_PRT*30/8*0.7*0.4))%>
	<br><font color="#6495ED">�� ������ �� ����� �� ������:</font><%=(30/8*0.3*VSEGO_ASM + (VSEGO_ASM*30/8*0.7*0.4)) - VSEGO_ASM*30/8*0.7*0.4%>
	<br><font color="#6495ED">�� ������ �� ����� �� ������:</font><%=(30/8*0.3*VSEGO_PRT + (VSEGO_PRT*30/8*0.7*0.4)) - VSEGO_PRT*30/8*0.7*0.4%>
</body>
</html>