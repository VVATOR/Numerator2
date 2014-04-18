<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<%@page import="OracleConnect.SQLRequest" import="OracleConnect.SQLRequest_1" import="OracleConnect.OracleConnect"%>
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
<title>Справка</title>
<%
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
	<div class="full_width big" align=center>Справка</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<br><br>
	<!-- Основное меню -->
	<b>Разделы справки:</b><br>
	<a href="#Введение">Введение</a><br>
	<a href="#Создание изделия">Создание изделия</a><br>
	<a href="#Создание узлов">Создание узлов</a><br>
	<a href="#Редактирование и удаление узлов">Редактирование и удаление узлов</a><br>
	<a href="#Доверенные пользователи">Доверенные пользователи</a><br>
	<a href="#Добавление заимствованных узлов">Добавление заимствованных узлов</a><br>
	<a href="#Автоматическая простановка AutoCAD">Автоматическая простановка чертежей AutoCAD</a><br>
	<a href="#Автоматическая простановка моделей Pro/ENGINEER">Автоматическая простановка моделей Pro/ENGINEER</a><br>
	<a href="#Просмотр чертежей и моделей">Просмотр чертежей и моделей</a><br>
	<a href="#Статусы">Статусы</a><br>
	<a href="#Часто задаваемые вопросы">Часто задаваемые вопросы</a><br>
	<!-- Разделы -->
	<hr>
	<a name="#Введение"></a><div class="full_width big" align=center>Введение</div>
	<hr>
	Программа «Нумератор 2» предназначена для ведения номерной книги по оригинальным деталям. 
	Основное назначение программы это регистрация детали или сборочной единицы в момент ее создания, 
	присвоение им оригинального обозначения и наименования, а так же первичной применяемости и исключение 
	случаем дублирования обозначений. Вторичной задачей программы является отслеживание выполнения работ с 
	помощью простановки в программе статусов готовности моделей.
	<hr>
	<a name="#Создание изделия"></a><div class="full_width big" align=center>Создание изделия</div>
	<hr>
	Перед созданием любого нумератора ведущим конструктором по машине должно быть создано изделие, на которое будет создаваться нумератор. 
	В случае отсутствия ведущего конструктора изделие может быть создано программистом, ведущим данную программу. Следует отметить, 
	что запрещается создавать узлы, используя кнопку <img name=pict3_1 src="images/3-1_.png" onMouseOver="changeImg3_1('images/3-1')" 
	onMouseOut="changeImg3_1('images/3-1_')" border=0 title="Создать новое изделие"></img>, потому что у узлов должна быть связь 
	с родительским объектом (т.е. общим видом либо изделием либо другим узлом). Теперь перейдем непосредственно к описанию создания изделия:<br>
	1. Войдите в программу по адресу: <a href="http://bl-04:8080/Numerator2/index.jsp">http://bl-04:8080/Numerator2/index.jsp</a>;<br>
	2. Нажмите на кнопку <img name=pict3_1 src="images/3-1_.png" onMouseOver="changeImg3_1('images/3-1')" 
	onMouseOut="changeImg3_1('images/3-1_')" border=0 title="Создать новое изделие"></img>;<br>
	<div align=center><img src="images/help_create_product.JPG"></img></div><br>
	3. Введите наименование и обозначение общего вида и нажмите :
	<div align=center><img src="images/help_create_product2.JPG"></img></div><br>
	4. Если все выполнено верно, изделие должно появится в разделе Ваши изделия.<br>
	<i>* Следует отметить, что изделия, созданные не Вами, появляются в разделе Изделия смежных разработчиков.</i>
	<hr>		
	<a name="#Создание узлов"></a><div class="full_width big" align=center>Создание узлов</div>
	<hr>
	Узлы в программе условно разделены на крупные и мелкие. Крупным узлом считается узел 3 последних цифры обозначения которого 
	являются нулями. Крупные узлы всегда входят непосредственно в общий вид. Мелким узлом считается узел, который входит в крупный узел, 
	либо в само изделие и 3 последних цифры которого не являются нулями:<br>
	<div align=center><img src="images/help_uzel_types.JPG"></img></div><br>
	Для начала ведения нумератора по узлу необходимо, чтобы ведущий по машине конструктор (либо его доверенные лица) создал(и) 
	для Вас этот узел. При создании узла ведущим конструктором он должен указать в качестве исполнителя конструктора ответственного за узел
	 - <img src="images/help_uzel_ispolnitel.JPG"></img>После того как это сделано созданный крупный узел появится в разделе программы 
	 <img name=pict2_2 src="images/2-2_.png" title="Ваши узлы" onMouseOver="changeImg2_2('images/2-2')" onMouseOut="changeImg2_2('images/2-2_')" border=0></img>. 
	 Для создания узла необходимо выполнить следующий действия:<br>
	 1. Перейти на необходимый уровень изделия или узла;<br>
	 <div align=center><img src="images/help_select_uzel.JPG"></img></div>
	 2. Нажать кнопку <img name=pict3_2 src="images/3-2.png" onMouseOver="changeImg3_2('images/3-2-')" onMouseOut="changeImg3_2('images/3-2')" border=0 title="Добавить деталь или сборку"></img><br>
	 <div align=center><img src="images/help_insert_uzel.JPG"></img></div><br>
	 3. Ввести необходимые данные (обязательными являются: <b>Обозначение</b>, <b>Наименование</b>, <b>Первичная применяемость</b>):<br>
	 <i>Поле статус тоже относится к обязательным но программа сделана таким образом что добавление записи без статуса невозможно.</i>
	 <div align=center><img src="images/help_insert_uzel_fields.JPG"></img></div><br>
	 4. Нажать кнопку <img src="images/BUTTON_ADD_SELECTED.PNG"></img>.<br>
	 5. Далее если узла с таким обозначением не было зарегистрировано ранее он появится в списке.<br>
	<hr>
	<a name="#Редактирование и удаление узлов"></a><div class="full_width big" align=center>Редактирование и удаление узлов</div>
	<hr>
	Для редактирования или удаления узла имеются соответствующие кнопки:<br>
	<div align=center><img src="images/help_actions.JPG"></img></div><br>
	Данные кнопки появляются, если вы являетесь хозяином узла, либо если хозяин узла добавил Вас в доверенных пользователей.<br>
	<b>Для редактирования узла:</b><br>
	1. Нажмите на кнопку <img src="images/edit.png" border=0 width=24 height=24 title="Редактирование"></img>;<br>
	2. Внесите изменения в информацию об узле;<br>
	3. Нажмите кнопку <img name=pict1 border=0 src="images/BUTTON_OK.PNG"></img>.<br>
	<b>Для удаления узла:</b><br>
	1. Нажмите кнопку <img src="images/delete.png" border=0 width=24 height=24 title="Удаление"></img><br>
	2. Посмотрите, какие объекты будут удалены (удаляются так же все связанные объекты);<br>
	3. Нажмите кнопку <img name=pict2 border=0 src="images/BUTTON_DELETE.PNG"></img><br>
	<i>* Следует обратить внимания, что функция удаления предназначена для удаления ошибочно введенных данных. В других случаях удаление данных из нумератора запрещено. 
	Альтернативой является установка статуса, например «Анулировано».</i>	
	<hr>
	<a name="#Доверенные пользователи"></a><div class="full_width big" align=center>Доверенные пользователи</div>
	<hr>
	Термин «доверенные пользователи» обозначает то, что Вы доверяете этим лицам добавление/редактирование и удаление информации в Ваших узлах.
	1. Нажмите на кнопку <img name=pict2_3 src="images/2-3_.png" title="Ваши доверенные пользователи" onMouseOver="changeImg2_3('images/2-3')" onMouseOut="changeImg2_3('images/2-3_')" border=0></img>;<br>
	2. Выберите пользователя из списка:<br>
	<div align=center><img src="images/help_select_trust_user.JPG"></img></div><br>
	3. Нажмите кнопку <b>Добавить</b>;<br>
	4. Убедитесь, что пользователь появился в разделе «Ваши доверенные пользователи»:
	<div align=center><img src="images/help_trust_user_in_table.JPG"></img></div><br>
	<hr>
	<a name="#Добавление заимствованных узлов"></a><div class="full_width big" align=center>Добавление заимствованных узлов</div>
	<hr>
	Решением, принятым на собрании по программе «Нумератор», эта функция на данный момент не будет использоваться.
	<hr>
	<a name="#Автоматическая простановка чертежей AutoCAD"></a><div class="full_width big" align=center>Автоматическая простановка чертежей AutoCAD</div>
	<hr>
	Данная возможность вызывается нажатием на кнопку: <img name=pict1_1 src="images/1-1_.png" title="Автопростановка чертежей AutoCAD" onMouseOver="changeImg1_1('images/1-1')" onMouseOut="changeImg1_1('images/1-1_')"  border=0></img>
	Сразу после нажатия по пути \\server3\GSKB\Внутренние\Разработки будет произведен поиск чертежей, имена которых соответствуют  введенным в нумератор деталям и сборкам: 
	<div align=center><img src="images/help_autocad.JPG"></img></div><br>
	Далее необходимо нажать на кнопку <b>Заменить</b>, после чего все в программе "Нумератор" будут автоматически проставлены найденные чертежи AutoCAD.
	Если ничего не будет найдено, то программа отобразит пустую таблицу.<br>
	<div align=center><img src="images/help_autocad_table_head.JPG"></img></div><br>
	Это означает, что программе нечего менять. В таком случае необходимо вернуться к программе нажав <img src="images/BUTTON_LEFT_SELECTED.PNG"></img>.
	<hr>
	<a name="#Автоматическая простановка моделей Pro/ENGINEER"></a><div class="full_width big" align=center>Автоматическая простановка моделей Pro/ENGINEER</div>
	<hr>
	Данная возможность вызывается нажатием на кнопку: <img name=pict1_2 src="images/1-2_.png" title="Автопростановка моделей CREO" onMouseOver="changeImg1_2('images/1-2')" onMouseOut="changeImg1_2('images/1-2_')" border=0></img>. 
	Сразу после нажатия по пути M:\ будет произведен поиск чертежей, имена которых соответствуют  введенным в нумератор деталям и сборкам: <br>
	<div align=center><img src="images/help_creo.JPG"></img></div><br>
	Далее необходимо нажать на кнопку  <b>Заменить</b>, после чего все в программе "Нумератор" будут автоматически проставлены найденные модели Creo/Elements Pro.
	Если ничего не будет найдено, то программа отобразит пустую таблицу:<br>
	<div align=center><img src="images/help_creo_table_head.JPG"></img></div><br>
	Это означает, что программе нечего менять. В таком случае необходимо вернуться к программе нажав <img src="images/BUTTON_LEFT_SELECTED.PNG"></img>.
	<hr>
	<a name="#Просмотр чертежей и моделей"></a><div class="full_width big" align=center>Просмотр чертежей и моделей</div>
	<hr>
	Для просмотра чертежей или моделей необходимо нажать на соовтествующие ссылки в дополнительной информации основной таблицы.
	<hr>
	<a name="#Статусы"></a><div class="full_width big" align=center>Статусы</div>
	<hr>
	В программе имеется возможность простановки статусов жизненного цикла деталей и сборок. Каждому 
	статусу сопоставлен свой цвет. Таблица сопоставления цветов и статусов доступна при нажатии на кнопку 
	<img name=pict1_7 src="images/1-7_.png" title="Цвета" onMouseOver="changeImg1_7('images/1-7')" onMouseOut="changeImg1_7('images/1-7_')" border=0></img><br>
	<h4>Таблица сопоставления статусов и цветов</h4>
	<table border="1" id="table1" align=center>
		<tr bgColor="#c0c0c0">
			<td>Статус</td>
		</tr>
		<tr bgColor="#fffafa">
			<td>Проработка</td>
		</tr>
		<tr bgColor="#ffff00">
			<td>Разрешено чертить</td>
		</tr>
		<tr bgColor="#66cdaa">
			<td>Чертеж готов</td>
		</tr>
		<tr bgColor="#66cdaa">
			<td>Выдано в ЭП</td>
		</tr>
		<tr bgColor="#ab82ff">
			<td>Завод-калька</td>
		</tr>
		<tr bgColor="#ab82ff">
			<td>Завод - разрешение</td>
		</tr>
		<tr bgColor="#ff3030">
			<td>Корректировка</td>
		</tr>
		<tr bgColor="#6495ed">
			<td>Аннулирован</td>
		</tr>
	</table>
	<hr>
	<a name="#Часто задаваемые вопросы"></a><div class="full_width big" align=center>Часто задаваемые вопросы</div>
	<hr>
	<b>ВОПРОС</b>: Могу ли я начать вести нумератор по своему
	узлу, если ведущий конструктор или его доверенные лица не создал его?<br>
	<b>ОТВЕТ</b>: Нет, так делать
	нельзя. В случае категорического отказа узел может быть создан ведущим
	программу программистом.<br><br>
	 
	<b>ВОПРОС</b>: В нумераторе нет моего изделия и узла, могу ли
	я создать свой узел как изделие?<br>	 
	<b>ОТВЕТ</b>: Нет, так делать
	нельзя. В случае категорического отказа изделие и узел может быть создан
	ведущим программу программистом.<br><br>
	 
	<b>ВОПРОС</b>: Можно ли сделать так, чтобы я мог
	редактировать все внутри своего узла?<br>	 
	<b>ОТВЕТ</b>: Нет, это противоречит
	политике безопасности. Однако авторы Ваших подузлов могут предоставить Вам
	такое право, добавив Вас в «доверенные пользователи».<br><br>
	 
	<b>ВОПРОС</b>: Ведущий конструктор отказывается создавать
	изделие и узлы, что делать?<br>
	<b>ОТВЕТ</b>: Обратитесь в отдел КИО
	ВС для направления соответствующего документа в отдел данного работника».<br><br>
	 
	<b>ВОПРОС</b>: Нумератор придумали программисты, чтобы
	усложнить нам работу?<br> 
	<b>ОТВЕТ</b>: Нет, нумератор ведется
	уже давно в каждом отделе по своему шаблону. Программа сводит ведение
	нумератора к общей базе, и исключает дублирование обозначений.<br><br>
	 
	<b>ВОПРОС</b>: Будет ли связь данных из нумератора с
	программой ввод?<br> 
	<b>ОТВЕТ</b>: Да, написание данной функциональности
	запланировано.<br><br>
	 
	<b>ВОПРОС</b>: Будет ли старые нумераторы в данной программе?<br>
	<b>ОТВЕТ</b>: Функция импорта данных
	запланирована, однако старые нумераторы придется приводить в формат пригодный
	для импорта.<br><br>
	 
	<b>ВОПРОС</b>: Как я могу сделать замечание либо предложение
	по программе?<br>
	<b>ОТВЕТ</b>: Вы можете направить
	докладную записку в отдел КИОВС либо связаться с автором программы лично. В
	будущем планируется интегрировать учет замечаний непосредственно в программу.<br><br>
	 
	<b>ВОПРОС</b>: Мне не нравиться Ваша программа.<br> 
	<b>ОТВЕТ</b>: Вы можете предложить
	способы ее улучшения.<br><br>
	 
	<b>ВОПРОС</b>: Руководитель сектора заставляет проставлять
	статусы готовности и теперь видит насколько продуктивно я работаю. Мне это не
	нравиться, можно ли убрать статусы?<br> 
	<b>ОТВЕТ</b>: Нет.
</body>
</html>