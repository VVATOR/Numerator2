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
//									���������� ����������
//----------------------------------------------------------------------------------------
 //������� ���������� ��������� �� ����� �����������
 NumGenerate num = new NumGenerate();
 //������ ���������� ���
 ArrayList<String> TrustedUsers = new ArrayList<String>();
 //������ ��������
 ArrayList<String> Status = new ArrayList<String>();
 //������ ������ ��������
 ArrayList<String> StatusColors = new ArrayList<String>();
 //���������� ��� ���������� ������
 String delimiter = " ";
 String[] temp;
 String ExplodedOBOZ="";
 //�������� �����������
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
 if(session.getAttribute("SessionUser") != null) SessionUser = session.getAttribute("SessionUser").toString();			//������������ ������
 String FULLNAME = "";
 if(session.getAttribute("FULLNAME") != null) FULLNAME = session.getAttribute("FULLNAME").toString();					//���
 String DEPARTMENT = "";
 if(session.getAttribute("DEPARTMENT") != null) DEPARTMENT = session.getAttribute("DEPARTMENT").toString();				//�����
 String SelectedItem="";
 if(request.getParameter("SelectedItem") != null)
 	 SelectedItem = new String (request.getParameter("SelectedItem").getBytes("ISO-8859-1"));
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
 //                        ��������� ���������� �������� ��������
 //----------------------------------------------------------------------------------------
 if(Action.equals("1")){
	 //��������� �������
	 String changeStatusOboz = "";
	 String changeStatusID = "";
	 if(request.getParameter("changeStatusOboz") != null)
		 changeStatusOboz = new String (request.getParameter("changeStatusOboz").getBytes("ISO-8859-1"));
	 if(request.getParameter("changeStatusID") != null)
		 changeStatusID = new String (request.getParameter("changeStatusID").getBytes("ISO-8859-1"));
	 sql.InsertStatistic("5",FULLNAME,"����������� ������������ ���������",changeStatusOboz);
	 sql.UpdateStatus(changeStatusID, changeStatusOboz);
	 //System.out.println(changeStatusOboz + " " + changeStatusID);
 }
 //----------------------------------------------------------------------------------------
 //                          ��������� �������� ������������
 //         �����������, ���� �������� �� ���� �������� ������ � ������������
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
			//������� ������ �������
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
		//s="SAG";//����
		//s="ANTONS";//���������
		//s="SAI";//����������
		SessionUser = s;
		//�������� ��� ����� ������������
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
 //                     ��������� ������ ��� ������� ������
 //--------------------------------------------------------------------------------
 TrustedUsers.add(FULLNAME);
 sql.GetUsersHaveAcces(SessionUser);
 while(sql.rs.next()){
	 if(sql.rs.getString("FULLNAME") != null) TrustedUsers.add(sql.rs.getString("FULLNAME"));
 }
 //--------------------------------------------------------------------------------
 //                        �������� ������� � �� �����
 //--------------------------------------------------------------------------------
 sql.GetAllStatus();
	while(sql.rs.next()){
		//��������� ������� �������� � ������
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
				//sOut += '<tr><td>�����������:</td><td>'+aData[7]+'</td></tr>';
				sOut += '<tr><td>����������� �������:</td><td>'+aData[8]+'</td></tr>';
				sOut += '<tr><td>��������:</td><td>'+aData[9]+'</td></tr>';
				sOut += '<tr><td>���������� � ����:</td><td>'+aData[10]+'</td></tr>';
				sOut += '<tr><td>���������� � ������:</td><td>'+aData[11]+'</td></tr>';
				sOut += '<tr><td>�����:</td><td>'+aData[12]+'</td></tr>';
				sOut += '<tr><td>������:</td><td>'+aData[13]+'</td></tr>';
				sOut += '<tr><td>���������� �1:</td><td>'+aData[14]+'</td></tr>';
				sOut += '<tr><td>���������� �4:</td><td>'+aData[15]+'</td></tr>';
				sOut += '<tr><td>������ CREO:</td><td>'+aData[16]+'</td></tr>';
				sOut += '<tr><td>������ AutoCAD:</td><td>'+aData[17]+'</td></tr>';
				sOut += '<tr><td>����������:</td><td>'+aData[18]+'</td></tr>';
				
				sOut += '</table>';
				
				return sOut;
			}
			
			$(document).ready(function() {
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
									null, 					 /* ����������� */
									null, 					 /* �������� */
									null, 					 /* ������������ */
									null, 					 /* ��� */
									null, 					 /* ��������� ������������� */
									null,					 /* ����������� */  
									null,					 /* ������ */ 
									{ "bVisible":    true },/* ����������� ������� */  
									{ "bVisible":    false },/* �������� */ 
									{ "bVisible":    false },/* ���������� � ���� */  
									{ "bVisible":    false },/* ���������� � ������ */ 
									{ "bVisible":    false },/* ����� */  
									{ "bVisible":    false },/* ������ */  
									{ "bVisible":    false },/* ���������� �1 */  
									{ "bVisible":    false },/* ���������� �4 */ 
									{ "bVisible":    false },/* ������ CREO */ 
									{ "bVisible":    false },/* ������ AutoCAD */ 
									{ "bVisible":    false } /* ���������� */ 
								],
					"oLanguage": {
						"sLengthMenu": "���������� _MENU_ ������� �� ��������",
						"sZeroRecords": "��������, ������ �� �������",
						"sInfo": "�������� � _START_ �� _END_ �� _TOTAL_ �������",
						"sInfoEmtpy": "�������� � 0 �� 0 �� 0 �������",
						"sInfoFiltered": "(������� �� _MAX_ �������)",
						"oPaginate": {
							"sFirst":    "������",
							"sPrevious": "����������",
							"sNext":     "���������",
							"sLast":     "���������"
						},
						"sSearch": "�����:",
						"sProcessing": "��������..."
						
					},
					//"bLengthChange": false,
					//"bFilter": true,
					//"bSort": false,
					//"bInfo": false,
					"sScrollY": "580px",
					"bPaginate": false
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
			} );
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
	if(status == '����������') status_id = 1; 
	if(status == '������ � ��') status_id = 2;
	if(status == '�����-������') status_id = 3;
	if(status == '�����������') status_id = 4;
	if(status == '����� - ����������') status_id = 6;
	if(status == '��������� �������') status_id = 7;
	if(status == '������ �����') status_id = 8;
	if(status == '�������������') status_id = 9; 
	if(status == '����� - ���������') status_id = 10; 
	document.getElementById('changeStatusOboz').value = oboz;
	document.getElementById('changeStatusID').value = status_id;
	document.changeStatus.submit();
	//var url = 'ajaxChangeStatus.jsp?OBOZ=' + oboz + '&status_id=' + status_id;
	//$('#metadata').loading().load(url);
	//alert(url);
}
</script>
<title>��������� 2 (<%=FULLNAME%>)</title>
</head>
<body id="dt_example" background="images/background.png">
	<table border=3 CELLPADDING=0 CELLSPACING=0 width=100%>
		<tr>
			<td valign=top rowspan="2" width=175><img src="images/1.png"></img></td>
		</tr>
		<tr>
	<!-- 	<td background="images/2.png" valign=bottom height=80> -->
					
				
	<!-- 		</td> -->
		 	<td background="images/2.png" align=right valign=bottom>  
		 	<a href="you_product.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict2_1 src="images/2-1_.png" title="���� �������" onMouseOver="changeImg2_1('images/2-1')" onMouseOut="changeImg2_1('images/2-1_')" border=0></img></a>
					<a href="you_assembly.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict2_2 src="images/2-2_.png" title="���� ����" onMouseOver="changeImg2_2('images/2-2')" onMouseOut="changeImg2_2('images/2-2_')" border=0></img></a>
					<a href="AutoCAD.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict1_1 src="images/1-1_.png" title="��������������� �������� AutoCAD" onMouseOver="changeImg1_1('images/1-1')" onMouseOut="changeImg1_1('images/1-1_')"  border=0></img></a>
					<a href="Creo.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict1_2 src="images/1-2_.png" title="��������������� ������� CREO" onMouseOver="changeImg1_2('images/1-2')" onMouseOut="changeImg1_2('images/1-2_')" border=0></img></a>
					<a href="MaterialFromSearch.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict1_3 src="images/1-3_.png" title="��������������� ���������� SEARCH" onMouseOver="changeImg1_3('images/1-3')" onMouseOut="changeImg1_3('images/1-3_')" border=0></img></a>
					<a href="search.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict1_4 src="images/1-4_.png" title="�����" onMouseOver="changeImg1_4('images/1-4')" onMouseOut="changeImg1_4('images/1-4_')" border=0></img></a>
					<a href="you_users.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict2_3 src="images/2-3_.png" title="���� ���������� ������������" onMouseOver="changeImg2_3('images/2-3')" onMouseOut="changeImg2_3('images/2-3_')" border=0></img></a>
									<a href="other_product.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict2_4 src="images/2-4_.png" title="������� ������� �������������" onMouseOver="changeImg2_4('images/2-4')" onMouseOut="changeImg2_4('images/2-4_')" border=0></img></a>
					<a href="help.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict1_5 src="images/1-5_.png" title="�������" onMouseOver="changeImg1_5('images/1-5')" onMouseOut="changeImg1_5('images/1-5_')" border=0></img></a>
					<a href="BugTracker.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict1_6 src="images/1-6_.png" title="���������" onMouseOver="changeImg1_6('images/1-6')" onMouseOut="changeImg1_6('images/1-6_')" border=0></img></a>
					<a href="colors.jsp"><img name=pict1_7 src="images/1-7_.png" title="�����" onMouseOver="changeImg1_7('images/1-7')" onMouseOut="changeImg1_7('images/1-7_')" border=0></img></a>
					
			</td>
			<td valign=top rowspan="2" width=130><img src="images/3.png"></img></td>
		</tr>
<!-- 	<tr>
			<td valign=top rowspan="2" width=130><img src="images/3.png"></img></td>
		</tr> -->	
		<tr>
			<td valign=bottom colspan="2">
							<table border=0>
					<!-- 		<tr>
								<td>
									<a href="you_users.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict2_3 src="images/2-3_.png" title="���� ���������� ������������" onMouseOver="changeImg2_3('images/2-3')" onMouseOut="changeImg2_3('images/2-3_')" border=0></img></a>
									<a href="other_product.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem)%>"><img name=pict2_4 src="images/2-4_.png" title="������� ������� �������������" onMouseOver="changeImg2_4('images/2-4')" onMouseOut="changeImg2_4('images/2-4_')" border=0></img></a>
								</td>
							</tr>
							<tr>
							<td valign=top>
							<%
							//�������� ������������ ��� �������� �����������
							if(!SelectedItem.equals("")){
								sql.GetUserForOBOZ(SelectedItem);
								if(sql.rs.next())
									if(sql.rs.getString("FULLNAME") != null){
										if(TrustedUsers.contains(sql.rs.getString("FULLNAME"))) full_access = true;
										tempFULLNAME = sql.rs.getString("FULLNAME");
									}
									else tempFULLNAME = "Unknown";
							}
							out.println("<a href=\"insert_product.jsp?SelectedItem=" + URLEncoder.encode(SelectedItem) + "\"><img name=pict3_1 src=\"images/3-1_.png\" onMouseOver=\"changeImg3_1('images/3-1')\" onMouseOut=\"changeImg3_1('images/3-1_')\" border=0 title=\"������� ����� �������\"></img></a>");
							out.println("</td>");
							out.println("<td valign=top>");
							if(TrustedUsers.contains(tempFULLNAME))
								out.println("<a href=\"insert.jsp?SelectedItem=" + URLEncoder.encode(SelectedItem) + "\"><img name=pict3_2 src=\"images/3-2.png\" onMouseOver=\"changeImg3_2('images/3-2-')\" onMouseOut=\"changeImg3_2('images/3-2')\" border=0 title=\"�������� ������ ��� ������\"></img></a>");
							else
								out.println("<img src=\"images/3-2_.png\" border=0 title=\"���������� ������ ��� ������ �� ��������\"></img>");
							%>
							</td>
							<td valign=top><font size=3 color="#6495ED">��������� ���:</font></td>
							<%
							if(SelectedItem.equals("")){
								//���� ������ �� ������� ���������� ������ �������
								out.println("<td valign=top>");
								out.println("<script type=\"text/javascript\">");
								out.println("function selForm1_submit(){");
								out.println("	selForm1.submit();");
								out.println("}");
								out.println("</script>");
								out.println("<form name=selForm1>");
								out.println("<select size=\"1\" name=\"SelectedItem\" onchange=selForm1_submit()>");
								if(SelectedItem.equals("")) 
									out.println("<option selected>�������� �������</option>");
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
								//���-�� �������
								//��������� ������ � �������� ������� (�� ���������� ��������)
								sql.GetBackList(SelectedItem);
								while(sql.rs.next()){
									if(sql.rs.getInt("LEVEL") != 1){
										lSelectedTree.add(sql.rs.getString("OBOZNACHENIE"));
										lSelectedTreeCount++;
									}
								}
								//���������� ��� ���������� ������
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
									//��������� ��������� ��������
									if(i==lSelectedTreeCount){
										//����� �������� �������
										sql.GetProductList();
										while(sql.rs.next()){
											out.println("<option>" + sql.rs.getString("OBOZNACHENIE") + "</option>");
										}
									} else{
										//����� �������� ������� (������ ������ ��� ����������� ��������)
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
								//���������� ������� ������
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
								//��������� ��������� ��������
								if(lSelectedTreeCount==0){
									//����� �������� �������
									sql.GetProductList();
									while(sql.rs.next()){
										out.println("<option>" + sql.rs.getString("OBOZNACHENIE") + "</option>");
									}
								} else{
									//����� �������� �������
									sql.GetNextLevel(lSelectedTree.get(0));
									while(sql.rs.next()){
										if(!SelectedItem.equals(sql.rs.getString("OBOZNACHENIE")))
											out.println("<option>" + sql.rs.getString("OBOZNACHENIE") + "</option>");
									}
								}
								out.println("</select>");
								out.println("</form>");
								out.println("</td>");
								//���������� ��������� ������ (���� ���� ��� ����������)
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
										out.println("<option selected>�������� �������</option>");
										lbl = true;
									}
									out.println("<option>" + sql.rs.getString("OBOZNACHENIE") + "</option>");
								}
								if(lbl == true){
									out.println("</select>");
									out.println("</form>");
									out.println("</td>");
								}
								//���������� ������ ����� ���� ��� �����
								if(lSelectedTreeCount > 0){
									out.println("<td valign=top>");
									out.println("<a href=\"index.jsp?SelectedItem=" + lSelectedTree.get(0) + "\"><img src=\"images/back.png\" name=Strelka onMouseOver=\"changeImg4('images/back2')\" onMouseOut=\"changeImg4('images/back')\" border=0 title=\"�����\" width=20 height=20></img></a>");
									out.println("</td>");
								}
								if(!SelectedItem.equals("")){
									out.println("<td valign=top>");
									out.println("&nbsp;&nbsp;");
									out.println("<a href=\"percent_info.jsp?SelectedItem=" + URLEncoder.encode(SelectedItem) + "\"><img name=PictInfo width=20 height=20 src=\"images/percent.png\" onMouseOver=\"changeImgPictInfo('images/percent2')\" onMouseOut=\"changeImgPictInfo('images/percent')\" title=\"��������� ���������� �� ����\" border=0></img></a>");
									out.println("</td>");
								}
							}
							%>
							</tr>
						</table>
			</td>
		</tr>
	</table>
				<!-- �������� ���������� -->
				<!-- ��������� ������� -->
				<%
				if(!SelectedItem.equals(""))
					out.println("<h1>������ � ��������� ������� ��� " + SelectedItem + "</h1>");
				else
					out.println("<h1>������ � ��������� ������� </h1>");
				%>
				
				<div id="container" style="width:95%">
					<table width=60% cellpadding="0" cellspacing="0" border="0" id="MainTableASM"  class="display" width="100%">
					<thead>
					<tr>
						<th>�����������</th>
						<th>��������</th>
						<th>������������</th>
						<th>���</th>
						<th>��������� �������������</th>
						<th>�����������</th>
						<th>������</th>
						<th>����������� �������</th>
						<th>��������</th>
						<th>���������� � ����</th>
						<th>���������� � ������</th>
						<th>�����</th>
						<th>������</th>
						<th>���������� �1</th>
						<th>���������� �4</th>
						<th>������ CREO</th>
						<th>������ AutoCAD</th>
						<th>����������</th>  
					</tr>
					</thead>
					<tbody>
					<%
					if(!SelectedItem.equals("")){
						ExplodedOBOZ = num.ExplodeOBOZ(SelectedItem);
						temp = ExplodedOBOZ.split(delimiter);
						OBOZ_PREFIX = temp[0];
						OBOZ_FIRST_NUM = temp[1];
						OBOZ_SECOND_NUM = temp[2];
						OBOZ_THERD_NUM = temp[3];
						if(temp.length == 5) OBOZ_POSTFIX = temp[4];
						 else OBOZ_POSTFIX = "";
						Type = "3";
						sql.GetProductFirstLevel(OBOZ_PREFIX,OBOZ_FIRST_NUM,OBOZ_SECOND_NUM,OBOZ_THERD_NUM,OBOZ_POSTFIX,Type);
						while(sql.rs.next()){
							//���� � ����������� �� �������
							switch(sql.rs.getInt("STATUS_ID")){
							case 1: out.println("<tr class=\"grade1\">"); break;
							case 2: out.println("<tr class=\"grade2\">"); break;
							case 3: out.println("<tr class=\"grade3\">"); break;
							case 4: out.println("<tr class=\"grade4\">"); break;
							case 6: out.println("<tr class=\"grade6\">"); break;
							case 7: out.println("<tr class=\"grade7\">"); break;
							case 8: out.println("<tr class=\"grade8\">"); break;
							case 9: out.println("<tr class=\"grade9\">"); break;
							case 10: out.println("<tr class=\"grade10\">"); break;
							}
							out.println("<td>");
							//������ ������/������
							if(sql.rs.getString("OBOZ_THERD_NUM").charAt(sql.rs.getString("OBOZ_THERD_NUM").length()-1) == '0')
								out.println("<img src=\"images/Assembly_litle1.png\"></img>");
							else
								out.println("<img src=\"images/Part_litle1.png\"></img>");
							//�����������
							if((sql.rs.getString("OBOZ_THERD_NUM").charAt(sql.rs.getString("OBOZ_THERD_NUM").length()-1) == '0') &&
							   (sql.rs.getString("OBOZ_THERD_NUM").charAt(sql.rs.getString("OBOZ_THERD_NUM").length()-2) == '0') &&	
							   (sql.rs.getString("OBOZ_THERD_NUM").charAt(sql.rs.getString("OBOZ_THERD_NUM").length()-3) == '0'))
								out.println("<A HREF = \"index.jsp?SelectedItem=" + sql.rs.getString("OBOZNACHENIE") + "\">" + sql.rs.getString("OBOZNACHENIE") + "</a>");
							else
								out.println(sql.rs.getString("OBOZNACHENIE"));
							out.println("</td>");
							out.println("<td align=center>");
							if(TrustedUsers.contains(sql.rs.getString("FULLNAME")) | full_access == true){
								URL = "edit.jsp?";
								if(sql.rs.getString("OBOZNACHENIE") != null)
								URL += "SelectedItem=" + URLEncoder.encode(SelectedItem);
								if(sql.rs.getString("GENERAL_ID") != null)
								URL += "&ID=" + URLEncoder.encode(sql.rs.getString("GENERAL_ID"));
								if(sql.rs.getString("OBOZNACHENIE") != null)
								URL += "&NEWOBOZ=" + URLEncoder.encode(sql.rs.getString("OBOZNACHENIE"));
								if(sql.rs.getString("NAIMENOVANIE") != null)
								URL += "&NAIM=" + URLEncoder.encode(sql.rs.getString("NAIMENOVANIE"));
								if(sql.rs.getString("PRIMENAETSA") != null)
								URL += "&VHODIMOST=" + URLEncoder.encode(sql.rs.getString("PRIMENAETSA"));
								if(sql.rs.getString("UZ_COUNT") != null)
								URL += "&UZ_COUNT=" + URLEncoder.encode(sql.rs.getString("UZ_COUNT"));
								if(sql.rs.getString("M_COUNT") != null)
								URL += "&M_COUNT=" + URLEncoder.encode(sql.rs.getString("M_COUNT"));
								if(sql.rs.getString("STATUS") != null)
								URL += "&STATUS=" + URLEncoder.encode(sql.rs.getString("STATUS"));
								if(sql.rs.getString("FULLNAME") != null)
								URL += "&NEWFULLNAME=" + URLEncoder.encode(sql.rs.getString("FULLNAME"));
								if(sql.rs.getString("FULLNAME") != null)
								URL += "&ACADNEWFULLNAME=" + URLEncoder.encode(sql.rs.getString("acad_fullname"));
								if(sql.rs.getString("MASS") != null)
								URL += "&MASS=" + URLEncoder.encode(sql.rs.getString("MASS"));
								if(sql.rs.getString("FORMAT") != null)
								URL += "&FORMAT=" + URLEncoder.encode(sql.rs.getString("FORMAT"));
								if(sql.rs.getString("MATERIAL") != null)
								URL += "&MATERIAL=" + URLEncoder.encode(sql.rs.getString("MATERIAL"));
								if(sql.rs.getString("A1_COUNT") != null)
								URL += "&A1_COUNT=" + URLEncoder.encode(sql.rs.getString("A1_COUNT"));
								if(sql.rs.getString("A4_COUNT") != null)
								URL += "&A4_COUNT=" + URLEncoder.encode(sql.rs.getString("A4_COUNT"));
								if(sql.rs.getString("AUTOCAD") != null)
								URL += "&AUTOCAD=" + URLEncoder.encode(sql.rs.getString("AUTOCAD"));
								if(sql.rs.getString("PROE") != null)
								URL += "&PROE=" + URLEncoder.encode(sql.rs.getString("PROE"));
								if(sql.rs.getString("NOTE") != null)
								URL += "&Note=" + URLEncoder.encode(sql.rs.getString("NOTE"));
								out.println("<a href=\"" + URL + "\"><img src=\"images/edit.png\" border=0 width=24 height=24 title=\"��������������\"></img></a>");
								out.println("<a href=\"Delete.jsp?SelectedItem=" + SelectedItem + "&OBOZ=" + sql.rs.getString("OBOZNACHENIE") + "\"><img src=\"images/delete.png\" border=0 width=24 height=24 title=\"��������\"></img></a>");
								out.println("<img onClick=show_history('" + sql.rs.getString("OBOZNACHENIE") + "') style=\"cursor: help;\" src=\"images/history.png\" border=0 width=24 height=24 title=\"������� ���������\"></img>");
							}else{
								//out.println("<img src=\"images/edit_disable.png\" width=24 height=24 title=\"�������������� �� ��������\"></img>");
								//out.println("<img src=\"images/delete_disable.png\" width=24 height=24 title=\"�������� �� ��������\"></img>");								
							}
							out.println("</td>");
							out.println("<td>" + sql.rs.getString("NAIMENOVANIE") + "</td>");
							if(sql.rs.getString("OBOZ_THERD_NUM").charAt(sql.rs.getString("OBOZ_THERD_NUM").length()-1) == '0')
								out.println("<td>������</td>");
							else{
								if(sql.rs.getString("OBOZ_THERD_NUM").charAt(0) == '0') out.println("<td>������ (�� �������������)</td>");
								if(sql.rs.getString("OBOZ_THERD_NUM").charAt(0) == '1') out.println("<td>������ (����� �����)</td>");
								if(sql.rs.getString("OBOZ_THERD_NUM").charAt(0) == '2') out.println("<td>������ (������������� �����)</td>");
								if(sql.rs.getString("OBOZ_THERD_NUM").charAt(0) == '3') out.println("<td>������ (�������� �����)</td>");
								if(sql.rs.getString("OBOZ_THERD_NUM").charAt(0) == '4') out.println("<td>������ (��������)</td>");
								if(sql.rs.getString("OBOZ_THERD_NUM").charAt(0) == '5') out.println("<td>������ (�������)</td>");
								if(sql.rs.getString("OBOZ_THERD_NUM").charAt(0) == '6') out.println("<td>������ (����, �������)</td>");
								if(sql.rs.getString("OBOZ_THERD_NUM").charAt(0) == '7') out.println("<td>������ (������, �������)</td>");
								if(sql.rs.getString("OBOZ_THERD_NUM").charAt(0) == '8') out.println("<td>������ (�����)</td>");
							}
							out.println("<td>" + sql.rs.getString("PRIMENAETSA") + "</td>");
							out.println("<td>" + sql.rs.getString("FULLNAME") + "</td>");
							out.println("<td class=\"center\">");
							/*switch(sql.rs.getInt("STATUS_ID")){
							case 1: out.println("<img src=\"images/life_cyle1.png\" border=0></img>"); break;
							case 2: out.println("<img src=\"images/life_cyle4.png\" border=0></img>"); break;
							case 3: out.println("<img src=\"images/life_cyle5.png\" border=0></img>"); break;
							case 4: out.println("<img src=\"images/life_cyle7.png\" border=0></img>"); break;
							case 6: out.println("<img src=\"images/life_cyle5.png\" border=0></img>"); break;
							case 7: out.println("<img src=\"images/life_cyle2.png\" border=0></img>"); break;
							case 8: out.println("<img src=\"images/life_cyle3.png\" border=0></img>"); break;
							case 9: out.println("<img src=\"images/life_cyle8.png\" border=0></img>"); break;
							case 10: out.println("<img src=\"images/life_cyle6.png\" border=0></img>"); break;
							}
							out.println("<br>");*/
							if(TrustedUsers.contains(sql.rs.getString("FULLNAME")) | full_access == true){
								//����� ������ ������
								out.println("<select name='" + sql.rs.getString("OBOZNACHENIE") + "' id='" + sql.rs.getString("OBOZNACHENIE") + "' onChange=StatusChange('" + sql.rs.getString("OBOZNACHENIE") + "')>");
								for(i=0;i<Status.size();i++){
									if(Status.get(i).equals(sql.rs.getString("STATUS")))
										out.println("<option selected style=\"background-color: " + StatusColors.get(i) + "\" >" + Status.get(i) + "</option>");
									else
										out.println("<option style=\"background-color: " + StatusColors.get(i) + "\" >" + Status.get(i) + "</option>");
								}
								out.println(sql.rs.getString("STATUS"));
								out.println("</select>");
							} else{
								//�� ����� ������ ������
								out.println(sql.rs.getString("STATUS"));
							}
							out.println("</td>");
					//		out.println("<td>��������������� ��� ���������� � ��������� �������</td>");
							out.println("<td>"+sql.rs.getString("acad_fullname")+"</td>");
							//��������
							if(sql.rs.getString("MATERIAL") != null)
								out.println("<td>" + sql.rs.getString("MATERIAL") + "</td>");
							else
								out.println("<td></td>");
							//���������� � ����
							if(sql.rs.getString("UZ_COUNT") != null)
								out.println("<td>" + sql.rs.getString("UZ_COUNT") + "</td>");
							else
								out.println("<td></td>");
							//���������� � ������
							if(sql.rs.getString("M_COUNT") != null)
								out.println("<td>" + sql.rs.getString("M_COUNT") + "</td>");
							else
								out.println("<td></td>");
							//�����
							if(sql.rs.getString("MASS") != null)
								out.println("<td>" + sql.rs.getString("MASS") + "</td>");
							else
								out.println("<td></td>");
							//������
							if(sql.rs.getString("FORMAT") != null)
								out.println("<td>" + sql.rs.getString("FORMAT") + "</td>");
							else
								out.println("<td></td>");
							//���������� �1
							if(sql.rs.getString("A1_COUNT") != null)
								out.println("<td>" + sql.rs.getString("A1_COUNT") + "</td>");
							else
								out.println("<td></td>");
							//���������� �4
							if(sql.rs.getString("A4_COUNT") != null)
								out.println("<td>" + sql.rs.getString("A4_COUNT") + "</td>");
							else
								out.println("<td></td>");
							//����
							if(sql.rs.getString("PROE") != null)
								out.println("<td><a href=\"Preview.jsp?SelectedItem=" + SelectedItem + "&FILENAME=" + sql.rs.getString("PROE") + "\">" + sql.rs.getString("PROE") + "</a></td>");
							else
								out.println("<td></td>");
							//�������
							if(sql.rs.getString("AUTOCAD") != null)
								out.println("<td><a href=\"file:" + sql.rs.getString("AUTOCAD").replace('\\', '/') + "\">" + sql.rs.getString("AUTOCAD") + "</a></td>");
							else
								out.println("<td></td>");
							//����������
							if(sql.rs.getString("NOTE") != null)
								out.println("<td>" + sql.rs.getString("NOTE") + "</td>");
							else
								out.println("<td></td>");
							out.println("</tr>");
						}
					}
					%>					
					</tbody>
					</table>
				</div>	
				<!-- ����� ��������� ����������� -->
				<form name=changeStatus action=index.jsp>
					<input type=hidden name=changeStatusOboz id=changeStatusOboz value="">
					<input type=hidden name=changeStatusID id=changeStatusID value="">
					<input type=hidden name=SelectedItem id=SelectedItem value="<%=SelectedItem%>">
					<input type=hidden name=Action id=action value="1">
				</form>
				
</body>
</html>