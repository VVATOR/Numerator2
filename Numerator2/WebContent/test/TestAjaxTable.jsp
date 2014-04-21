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
<script type="text/javascript" charset="windows-1251">
					
			$(document).ready(function() {
				
				/*
				 * Initialse DataTables, with no sorting on the 'details' column
				 */
				oTable = $('#MainTableASM').dataTable( {
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
					"sAjaxSource": 'AJAXSelectedAssemblyData.jsp?OBOZNACHENIE=���-14-0126000',
					//"bLengthChange": false,
					//"bFilter": true,
					//"bSort": false,
					//"bInfo": false,
					"sScrollY": "300px",
					"bPaginate": false,
					"bScrollCollapse": true
				});
				
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
<title>Insert title here</title>
</head>
<body id="dt_example">
<table cellpadding="0" cellspacing="0" border="0" class="display" id="MainTableASM">
					<thead>
					<tr>
						<th>�����������</th>
						<th>������������</th>
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
					
					</tbody>
					</table>
</body>
</html>