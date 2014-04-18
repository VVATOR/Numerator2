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
									null, 					 /* № Обозначение */
									null, 					 /* № Наименование */
									null, 					 /* № Первичная применяемость */
									null,					 /* № Статус */ 
									{ "bVisible":    false },/* № Разработчик в Creo */  
									{ "bVisible":    false },/* № Разработчик чертежа */  
									{ "bVisible":    false },/* № Материал */ 
									{ "bVisible":    false },/* № Количество в узле */  
									{ "bVisible":    false },/* № Количество в машине */ 
									{ "bVisible":    false },/* № Масса */  
									{ "bVisible":    false },/* № Формат */  
									{ "bVisible":    false },/* № Количество А1 */  
									{ "bVisible":    false },/* № Количество А4 */ 
									{ "bVisible":    false },/* № Модель CREO */ 
									{ "bVisible":    false },/* № Чертеж AutoCAD */ 
									{ "bVisible":    false }/* № Примечание */ 
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
							"sLast":     "Последняя"
						},
						"sSearch": "Поиск:",
						"sProcessing": "Ожидайте..."
						
					},
					"sAjaxSource": 'AJAXSelectedAssemblyData.jsp?OBOZNACHENIE=КЗК-14-0126000',
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
					sOut += '<tr><td>Разработчик в CREO:</td><td>'+aData[5]+'</td></tr>';
					sOut += '<tr><td>Разработчик чертежа:</td><td>'+aData[6]+'</td></tr>';
					sOut += '<tr><td>Материал:</td><td>'+aData[7]+'</td></tr>';
					sOut += '<tr><td>Количество в узле:</td><td>'+aData[8]+'</td></tr>';
					sOut += '<tr><td>Количество в машине:</td><td>'+aData[9]+'</td></tr>';
					sOut += '<tr><td>Масса:</td><td>'+aData[10]+'</td></tr>';
					sOut += '<tr><td>Формат:</td><td>'+aData[11]+'</td></tr>';
					sOut += '<tr><td>Количество А1:</td><td>'+aData[12]+'</td></tr>';
					sOut += '<tr><td>Количество А4:</td><td>'+aData[13]+'</td></tr>';
					sOut += '<tr><td>Модель CREO:</td><td>'+aData[14]+'</td></tr>';
					sOut += '<tr><td>Чертеж AutoCAD:</td><td>'+aData[15]+'</td></tr>';
					sOut += '<tr><td>Примечание:</td><td>'+aData[16]+'</td></tr>';
					
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