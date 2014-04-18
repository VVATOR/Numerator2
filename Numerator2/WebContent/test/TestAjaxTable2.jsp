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
		$('#MainTableASM').dataTable( {
			"sAjaxSource": 'AJAXSelectedAssemblyData.jsp?OBOZNACHENIE=���-6025-0123000',
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