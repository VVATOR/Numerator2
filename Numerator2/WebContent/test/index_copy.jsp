<%@page import="OracleConnect.SQLRequest" import="NumGenerator.NumGenerate" import="java.util.*"%>
<%@page import="java.util.ArrayList" %>
<%
//----------------------------------------------------------------------------------------
//									���������� ����������
//----------------------------------------------------------------------------------------
 //������� ���������� ��������� �� ����� �����������
 NumGenerate num = new NumGenerate();
 //���������� ��� ���������� ������
 String delimiter = " ";
 String[] temp;
 String ExplodedOBOZ="";
 //�������� �����������
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
 int i=0;
 boolean lbl = false;
 ArrayList<String> lSelectedTree;
 lSelectedTree = new ArrayList<String>(); 
 int lSelectedTreeCount=0;

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
		//s = "VladIK";
		//s = "ZurAA";
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

%>
<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
<script type="text/javascript" charset="utf-8">
	$(document).ready(function() {
		$('#YouAssembly').dataTable( {
			"sAjaxSource": 'AJAXMyAssemblyData.jsp?SessionUser=<%=SessionUser%>',
			"sScrollY": "700px",
			"bPaginate": false,
			"bScrollCollapse": true,
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
		} );
	});
</script>
<script type="text/javascript" charset="windows-1251">
			var oTable;
			
			/* Formating function for row details */
			function fnFormatDetails ( nTr )
			{
				var aData = oTable.fnGetData( nTr );
				var sOut = '<table cellpadding="0" cellspacing="0" border="0" style="padding-left:50px;">';
				sOut += '<tr><td>����������� � CREO:</td><td>'+aData[5]+'</td></tr>';
				sOut += '<tr><td>����������� �������:</td><td>'+aData[6]+'</td></tr>';
				sOut += '<tr><td>��������:</td><td>'+aData[7]+'</td></tr>';
				sOut += '<tr><td>���������� � ����:</td><td>'+aData[8]+'</td></tr>';
				sOut += '<tr><td>���������� � ������:</td><td>'+aData[9]+'</td></tr>';
				sOut += '<tr><td>�����:</td><td>'+aData[10]+'</td></tr>';
				sOut += '<tr><td>������:</td><td>'+aData[11]+'</td></tr>';
				sOut += '<tr><td>���������� �1:</td><td>'+aData[12]+'</td></tr>';
				sOut += '<tr><td>���������� �4:</td><td>'+aData[13]+'</td></tr>';
				sOut += '<tr><td>������ CREO:</td><td>'+aData[14]+'</td></tr>';
				sOut += '<tr><td>������ AutoCAD:</td><td>'+aData[15]+'</td></tr>';
				sOut += '<tr><td>����������:</td><td>'+aData[16]+'</td></tr>';
				
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
									null, 					 /* � ����������� */
									null, 					 /* � ������������ */
									null, 					 /* ��� */
									null, 					 /* � ��������� ������������� */
									null,					 /* � ������ */ 
									{ "bVisible":    false },/* � ����������� � Creo */  
									{ "bVisible":    false },/* � ����������� ������� */  
									{ "bVisible":    false },/* � �������� */ 
									{ "bVisible":    false },/* � ���������� � ���� */  
									{ "bVisible":    false },/* � ���������� � ������ */ 
									{ "bVisible":    false },/* � ����� */  
									{ "bVisible":    false },/* � ������ */  
									{ "bVisible":    false },/* � ���������� �1 */  
									{ "bVisible":    false },/* � ���������� �4 */ 
									{ "bVisible":    false },/* � ������ CREO */ 
									{ "bVisible":    false },/* � ������ AutoCAD */ 
									{ "bVisible":    false }/* � ���������� */ 
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
					"sScrollY": "600px",
					"bPaginate": false
				});
				
				/* Add event listener for opening and closing details
				 * Note that the indicator for showing which row is open is not controlled by DataTables,
				 * rather it is done here
				 */
				$('td img', oTable.fnGetNodes() ).each( function () {
					$(this).click( function () {
						var nTr = this.parentNode.parentNode;
						if ( this.src.match('details_close') )
						{
							/* This row is already open - close it */
							this.src = "images/details_open.png";
							oTable.fnClose( nTr );
						}
						else
						{
							/* Open this row */
							this.src = "images/details_close.png";
							oTable.fnOpen( nTr, fnFormatDetails(nTr), 'details' );
						}
					} );
				} );
			} );
</script>
<script type="text/javascript" charset="windows-1251">
			var oTable1;
			
			/* Formating function for row details */
			function fnFormatDetails1 ( nTr )
			{
				var aData = oTable1.fnGetData( nTr );
				var sOut = '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">';
				sOut += '<tr><td>����������� � CREO:</td><td>'+aData[5]+'</td></tr>';
				sOut += '<tr><td>����������� �������:</td><td>'+aData[6]+'</td></tr>';
				sOut += '<tr><td>��������:</td><td>'+aData[7]+'</td></tr>';
				sOut += '<tr><td>���������� � ����:</td><td>'+aData[8]+'</td></tr>';
				sOut += '<tr><td>���������� � ������:</td><td>'+aData[9]+'</td></tr>';
				sOut += '<tr><td>�����:</td><td>'+aData[10]+'</td></tr>';
				sOut += '<tr><td>������:</td><td>'+aData[11]+'</td></tr>';
				sOut += '<tr><td>���������� �1:</td><td>'+aData[12]+'</td></tr>';
				sOut += '<tr><td>���������� �4:</td><td>'+aData[13]+'</td></tr>';
				sOut += '<tr><td>������ CREO:</td><td>'+aData[14]+'</td></tr>';
				sOut += '<tr><td>������ AutoCAD:</td><td>'+aData[15]+'</td></tr>';
				sOut += '<tr><td>����������:</td><td>'+aData[16]+'</td></tr>';
				
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
				
				$('#MainTablePRT thead tr').each( function () {
					this.insertBefore( nCloneTh, this.childNodes[0] );
				} );
				
				$('#MainTablePRT tbody tr').each( function () {
					this.insertBefore(  nCloneTd.cloneNode( true ), this.childNodes[0] );
				} );
				
				/*
				 * Initialse DataTables, with no sorting on the 'details' column
				 */
				oTable1 = $('#MainTablePRT').dataTable( {
					"aoColumns": [
									{ "bSortable": false },
									null, 					 /* � ����������� */
									null, 					 /* � ������������ */
									null, 					 /* � ��������� ������������� */
									null,					 /* � ������ */ 
									{ "bVisible":    false },/* � ����������� � Creo */  
									{ "bVisible":    false },/* � ����������� ������� */  
									{ "bVisible":    false },/* � �������� */ 
									{ "bVisible":    false },/* � ���������� � ���� */  
									{ "bVisible":    false },/* � ���������� � ������ */ 
									{ "bVisible":    false },/* � ����� */  
									{ "bVisible":    false },/* � ������ */  
									{ "bVisible":    false },/* � ���������� �1 */  
									{ "bVisible":    false },/* � ���������� �4 */ 
									{ "bVisible":    false },/* � ������ CREO */ 
									{ "bVisible":    false },/* � ������ AutoCAD */ 
									{ "bVisible":    false } /* � ���������� */ 
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
					"sScrollY": "270px",
					"bPaginate": false
				});
				
				/* Add event listener for opening and closing details
				 * Note that the indicator for showing which row is open is not controlled by DataTables,
				 * rather it is done here
				 */
				$('td img', oTable1.fnGetNodes() ).each( function () {
					$(this).click( function () {
						var nTr = this.parentNode.parentNode;
						if ( this.src.match('details_close') )
						{
							/* This row is already open - close it */
							this.src = "images/details_open.png";
							oTable1.fnClose( nTr );
						}
						else
						{
							/* Open this row */
							this.src = "images/details_close.png";
							oTable1.fnOpen( nTr, fnFormatDetails1(nTr), 'details' );
						}
					} );
				} );
			} );
</script>
<title>��������� 2 (<%=FULLNAME%>)</title>
</head>
<body id="dt_example">
	<table border=0 CELLPADDING=0 CELLSPACING=0>
		<tr>
			<td width=580><img src="images/1.png"></img></td>
			<td width=40 background="images/2.png"></td>
			<td width=100% background="images/2.png" valign=bottom>
					<table border=0>
					<tr>
					<td valign=bottom><font size=3 color="#6495ED">��������� ���:</font></td>
					<%
					if(SelectedItem.equals("")){
						//��� ������ �� ������� ���������� ������ �������
						out.println("<td valign=bottom>");
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
							out.println("<td valign=bottom>");
							if(i != lSelectedTree.size()) out.println("-");
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
						out.println("<td valign=bottom>");
						out.println("<script type=\"text/javascript\">");
						out.println("function selFormCur_submit(){");
						out.println("	selFormCur.submit();");
						out.println("}");
						out.println("</script>");
						out.println("<form name=selFormCur>");
						out.println(" - <select size=\"1\" name=\"SelectedItem\" onchange=selFormCur_submit()>");
						out.println("<option selected style=\"background-color: #6495ED\">" + SelectedItem + "</option>");
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
								out.println("<td valign=bottom>");
								out.println("<script type=\"text/javascript\">");
								out.println("function selFormNext_submit(){");
								out.println("	selFormNext.submit();");
								out.println("}");
								out.println("</script>");
								out.println("<form name=selFormNext>");
								out.println(" - <select size=\"1\" name=\"SelectedItem\" onchange=selFormNext_submit()>");
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
					}
					%>
					</tr>
					</table>
			</td>
			<td width=40><img src="images/3.png"></img></td>
		</tr>	
		<tr>
			<td valign=top>
				<div class="full_width big" align=center>
				</div>
				<!-- ����� ���� -->
				<h1>���� ����</h1>
				<table cellpadding="0" cellspacing="0" border="0" class="display" id="YouAssembly">
				<thead>
					<tr>
						<th>�����������</th>
						<th>������������</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
				</table>
				<!-- ����� ������ ���� -->
			</td>
			<td><img src="images/2_2.PNG"></img></td>
			<td colspan="2" valign=top>
				<!-- �������� ���������� -->
				<!-- ��������� ������� -->
				<h1>������ � ��������� �������</h1>
				<div id="container" align=center>
					<table cellpadding="0" cellspacing="0" border="0" class="display" id="MainTableASM">
					<thead>
					<tr>
						<th>�����������</th>
						<th>������������</th>
						<th>���</th>
						<th>��������� �������������</th>
						<th>������</th>
						<th>����������� � Creo</th>
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
							out.println("<tr>");
							if((sql.rs.getString("OBOZ_THERD_NUM").charAt(sql.rs.getString("OBOZ_THERD_NUM").length()-1) == '0') &&
							   (sql.rs.getString("OBOZ_THERD_NUM").charAt(sql.rs.getString("OBOZ_THERD_NUM").length()-2) == '0') &&	
							   (sql.rs.getString("OBOZ_THERD_NUM").charAt(sql.rs.getString("OBOZ_THERD_NUM").length()-3) == '0'))
								out.println("<td><A HREF = \"index.jsp?SelectedItem=" + sql.rs.getString("OBOZNACHENIE") + "\">" + sql.rs.getString("OBOZNACHENIE") + "</a></td>");
							else
								out.println("<td>" + sql.rs.getString("OBOZNACHENIE") + "</td>");
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
							out.println("<td>" + sql.rs.getString("STATUS") + "</td>");
							out.println("<td>" + sql.rs.getString("FULLNAME") + "</td>");
							out.println("<td>" + sql.rs.getString("FULLNAME") + "</td>");
							out.println("<td>" + sql.rs.getString("MATERIAL") + "</td>");
							out.println("<td>" + sql.rs.getString("UZ_COUNT") + "</td>");
							out.println("<td>" + sql.rs.getString("M_COUNT") + "</td>");
							out.println("<td>" + sql.rs.getString("MASS") + "</td>");
							out.println("<td>" + sql.rs.getString("FORMAT") + "</td>");
							out.println("<td>" + sql.rs.getString("A1_COUNT") + "</td>");
							out.println("<td>" + sql.rs.getString("A4_COUNT") + "</td>");
							out.println("<td>" + sql.rs.getString("PROE") + "</td>");
							out.println("<td>" + sql.rs.getString("AUTOCAD") + "</td>");
							out.println("<td>" + sql.rs.getString("NOTE") + "</td>");
							out.println("</tr>");
						}
					}
					%>					
					</tbody>
					</table>
					</div>
				<!-- ����� ��������� ����������� -->
			</td>
		</tr>
	</table>
</body>
</html>