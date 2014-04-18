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
			"sAjaxSource": 'AJAXSelectedAssemblyData.jsp?OBOZNACHENIE=КСК-6025-0123000',
			"sScrollY": "700px",
			"bPaginate": false,
			"bScrollCollapse": true,
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
					"sLast":     "Последняя"
				},
				"sSearch": "Поиск:",
				"sProcessing": "Ожидайте..."
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
						<th>Обозначение</th>
						<th>Наименование</th>
						<th>Первичная применяемость</th>
						<th>Статус</th>
						<th>Разработчик в Creo</th>
						<th>Разработчик чертежа</th>
						<th>Материал</th>
						<th>Количество в узле</th>
						<th>Количество в машине</th>
						<th>Масса</th>
						<th>Формат</th>
						<th>Количество А1</th>
						<th>Количество А4</th>
						<th>Модель CREO</th>
						<th>Чертеж AutoCAD</th>
						<th>Примечание</th>  
					</tr>
					</thead>
					<tbody>
					
					</tbody>
					</table>
</body>
</html>