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
<title>�������</title>
<%
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
	<div class="full_width big" align=center>�������</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
	<br><br>
	<!-- �������� ���� -->
	<b>������� �������:</b><br>
	<a href="#��������">��������</a><br>
	<a href="#�������� �������">�������� �������</a><br>
	<a href="#�������� �����">�������� �����</a><br>
	<a href="#�������������� � �������� �����">�������������� � �������� �����</a><br>
	<a href="#���������� ������������">���������� ������������</a><br>
	<a href="#���������� �������������� �����">���������� �������������� �����</a><br>
	<a href="#�������������� ����������� AutoCAD">�������������� ����������� �������� AutoCAD</a><br>
	<a href="#�������������� ����������� ������� Pro/ENGINEER">�������������� ����������� ������� Pro/ENGINEER</a><br>
	<a href="#�������� �������� � �������">�������� �������� � �������</a><br>
	<a href="#�������">�������</a><br>
	<a href="#����� ���������� �������">����� ���������� �������</a><br>
	<!-- ������� -->
	<hr>
	<a name="#��������"></a><div class="full_width big" align=center>��������</div>
	<hr>
	��������� ���������� 2� ������������� ��� ������� �������� ����� �� ������������ �������. 
	�������� ���������� ��������� ��� ����������� ������ ��� ��������� ������� � ������ �� ��������, 
	���������� �� ������������� ����������� � ������������, � ��� �� ��������� ������������� � ���������� 
	������� ������������ �����������. ��������� ������� ��������� �������� ������������ ���������� ����� � 
	������� ����������� � ��������� �������� ���������� �������.
	<hr>
	<a name="#�������� �������"></a><div class="full_width big" align=center>�������� �������</div>
	<hr>
	����� ��������� ������ ���������� ������� ������������� �� ������ ������ ���� ������� �������, �� ������� ����� ����������� ���������. 
	� ������ ���������� �������� ������������ ������� ����� ���� ������� �������������, ������� ������ ���������. ������� ��������, 
	��� ����������� ��������� ����, ��������� ������ <img name=pict3_1 src="images/3-1_.png" onMouseOver="changeImg3_1('images/3-1')" 
	onMouseOut="changeImg3_1('images/3-1_')" border=0 title="������� ����� �������"></img>, ������ ��� � ����� ������ ���� ����� 
	� ������������ �������� (�.�. ����� ����� ���� �������� ���� ������ �����). ������ �������� ��������������� � �������� �������� �������:<br>
	1. ������� � ��������� �� ������: <a href="http://bl-04:8080/Numerator2/index.jsp">http://bl-04:8080/Numerator2/index.jsp</a>;<br>
	2. ������� �� ������ <img name=pict3_1 src="images/3-1_.png" onMouseOver="changeImg3_1('images/3-1')" 
	onMouseOut="changeImg3_1('images/3-1_')" border=0 title="������� ����� �������"></img>;<br>
	<div align=center><img src="images/help_create_product.JPG"></img></div><br>
	3. ������� ������������ � ����������� ������ ���� � ������� :
	<div align=center><img src="images/help_create_product2.JPG"></img></div><br>
	4. ���� ��� ��������� �����, ������� ������ �������� � ������� ���� �������.<br>
	<i>* ������� ��������, ��� �������, ��������� �� ����, ���������� � ������� ������� ������� �������������.</i>
	<hr>		
	<a name="#�������� �����"></a><div class="full_width big" align=center>�������� �����</div>
	<hr>
	���� � ��������� ������� ��������� �� ������� � ������. ������� ����� ��������� ���� 3 ��������� ����� ����������� �������� 
	�������� ������. ������� ���� ������ ������ ��������������� � ����� ���. ������ ����� ��������� ����, ������� ������ � ������� ����, 
	���� � ���� ������� � 3 ��������� ����� �������� �� �������� ������:<br>
	<div align=center><img src="images/help_uzel_types.JPG"></img></div><br>
	��� ������ ������� ���������� �� ���� ����������, ����� ������� �� ������ ����������� (���� ��� ���������� ����) ������(�) 
	��� ��� ���� ����. ��� �������� ���� ������� ������������� �� ������ ������� � �������� ����������� ������������ �������������� �� ����
	 - <img src="images/help_uzel_ispolnitel.JPG"></img>����� ���� ��� ��� ������� ��������� ������� ���� �������� � ������� ��������� 
	 <img name=pict2_2 src="images/2-2_.png" title="���� ����" onMouseOver="changeImg2_2('images/2-2')" onMouseOut="changeImg2_2('images/2-2_')" border=0></img>. 
	 ��� �������� ���� ���������� ��������� ��������� ��������:<br>
	 1. ������� �� ����������� ������� ������� ��� ����;<br>
	 <div align=center><img src="images/help_select_uzel.JPG"></img></div>
	 2. ������ ������ <img name=pict3_2 src="images/3-2.png" onMouseOver="changeImg3_2('images/3-2-')" onMouseOut="changeImg3_2('images/3-2')" border=0 title="�������� ������ ��� ������"></img><br>
	 <div align=center><img src="images/help_insert_uzel.JPG"></img></div><br>
	 3. ������ ����������� ������ (������������� ��������: <b>�����������</b>, <b>������������</b>, <b>��������� �������������</b>):<br>
	 <i>���� ������ ���� ��������� � ������������ �� ��������� ������� ����� ������� ��� ���������� ������ ��� ������� ����������.</i>
	 <div align=center><img src="images/help_insert_uzel_fields.JPG"></img></div><br>
	 4. ������ ������ <img src="images/BUTTON_ADD_SELECTED.PNG"></img>.<br>
	 5. ����� ���� ���� � ����� ������������ �� ���� ���������������� ����� �� �������� � ������.<br>
	<hr>
	<a name="#�������������� � �������� �����"></a><div class="full_width big" align=center>�������������� � �������� �����</div>
	<hr>
	��� �������������� ��� �������� ���� ������� ��������������� ������:<br>
	<div align=center><img src="images/help_actions.JPG"></img></div><br>
	������ ������ ����������, ���� �� ��������� �������� ����, ���� ���� ������ ���� ������� ��� � ���������� �������������.<br>
	<b>��� �������������� ����:</b><br>
	1. ������� �� ������ <img src="images/edit.png" border=0 width=24 height=24 title="��������������"></img>;<br>
	2. ������� ��������� � ���������� �� ����;<br>
	3. ������� ������ <img name=pict1 border=0 src="images/BUTTON_OK.PNG"></img>.<br>
	<b>��� �������� ����:</b><br>
	1. ������� ������ <img src="images/delete.png" border=0 width=24 height=24 title="��������"></img><br>
	2. ����������, ����� ������� ����� ������� (��������� ��� �� ��� ��������� �������);<br>
	3. ������� ������ <img name=pict2 border=0 src="images/BUTTON_DELETE.PNG"></img><br>
	<i>* ������� �������� ��������, ��� ������� �������� ������������� ��� �������� �������� ��������� ������. � ������ ������� �������� ������ �� ���������� ���������. 
	������������� �������� ��������� �������, �������� ������������.</i>	
	<hr>
	<a name="#���������� ������������"></a><div class="full_width big" align=center>���������� ������������</div>
	<hr>
	������ ����������� ������������ ���������� ��, ��� �� ��������� ���� ����� ����������/�������������� � �������� ���������� � ����� �����.
	1. ������� �� ������ <img name=pict2_3 src="images/2-3_.png" title="���� ���������� ������������" onMouseOver="changeImg2_3('images/2-3')" onMouseOut="changeImg2_3('images/2-3_')" border=0></img>;<br>
	2. �������� ������������ �� ������:<br>
	<div align=center><img src="images/help_select_trust_user.JPG"></img></div><br>
	3. ������� ������ <b>��������</b>;<br>
	4. ���������, ��� ������������ �������� � ������� ����� ���������� ������������:
	<div align=center><img src="images/help_trust_user_in_table.JPG"></img></div><br>
	<hr>
	<a name="#���������� �������������� �����"></a><div class="full_width big" align=center>���������� �������������� �����</div>
	<hr>
	��������, �������� �� �������� �� ��������� ����������, ��� ������� �� ������ ������ �� ����� ��������������.
	<hr>
	<a name="#�������������� ����������� �������� AutoCAD"></a><div class="full_width big" align=center>�������������� ����������� �������� AutoCAD</div>
	<hr>
	������ ����������� ���������� �������� �� ������: <img name=pict1_1 src="images/1-1_.png" title="��������������� �������� AutoCAD" onMouseOver="changeImg1_1('images/1-1')" onMouseOut="changeImg1_1('images/1-1_')"  border=0></img>
	����� ����� ������� �� ���� \\server3\GSKB\����������\���������� ����� ���������� ����� ��������, ����� ������� �������������  ��������� � ��������� ������� � �������: 
	<div align=center><img src="images/help_autocad.JPG"></img></div><br>
	����� ���������� ������ �� ������ <b>��������</b>, ����� ���� ��� � ��������� "���������" ����� ������������� ����������� ��������� ������� AutoCAD.
	���� ������ �� ����� �������, �� ��������� ��������� ������ �������.<br>
	<div align=center><img src="images/help_autocad_table_head.JPG"></img></div><br>
	��� ��������, ��� ��������� ������ ������. � ����� ������ ���������� ��������� � ��������� ����� <img src="images/BUTTON_LEFT_SELECTED.PNG"></img>.
	<hr>
	<a name="#�������������� ����������� ������� Pro/ENGINEER"></a><div class="full_width big" align=center>�������������� ����������� ������� Pro/ENGINEER</div>
	<hr>
	������ ����������� ���������� �������� �� ������: <img name=pict1_2 src="images/1-2_.png" title="��������������� ������� CREO" onMouseOver="changeImg1_2('images/1-2')" onMouseOut="changeImg1_2('images/1-2_')" border=0></img>. 
	����� ����� ������� �� ���� M:\ ����� ���������� ����� ��������, ����� ������� �������������  ��������� � ��������� ������� � �������: <br>
	<div align=center><img src="images/help_creo.JPG"></img></div><br>
	����� ���������� ������ �� ������  <b>��������</b>, ����� ���� ��� � ��������� "���������" ����� ������������� ����������� ��������� ������ Creo/Elements Pro.
	���� ������ �� ����� �������, �� ��������� ��������� ������ �������:<br>
	<div align=center><img src="images/help_creo_table_head.JPG"></img></div><br>
	��� ��������, ��� ��������� ������ ������. � ����� ������ ���������� ��������� � ��������� ����� <img src="images/BUTTON_LEFT_SELECTED.PNG"></img>.
	<hr>
	<a name="#�������� �������� � �������"></a><div class="full_width big" align=center>�������� �������� � �������</div>
	<hr>
	��� ��������� �������� ��� ������� ���������� ������ �� �������������� ������ � �������������� ���������� �������� �������.
	<hr>
	<a name="#�������"></a><div class="full_width big" align=center>�������</div>
	<hr>
	� ��������� ������� ����������� ����������� �������� ���������� ����� ������� � ������. ������� 
	������� ����������� ���� ����. ������� ������������� ������ � �������� �������� ��� ������� �� ������ 
	<img name=pict1_7 src="images/1-7_.png" title="�����" onMouseOver="changeImg1_7('images/1-7')" onMouseOut="changeImg1_7('images/1-7_')" border=0></img><br>
	<h4>������� ������������� �������� � ������</h4>
	<table border="1" id="table1" align=center>
		<tr bgColor="#c0c0c0">
			<td>������</td>
		</tr>
		<tr bgColor="#fffafa">
			<td>����������</td>
		</tr>
		<tr bgColor="#ffff00">
			<td>��������� �������</td>
		</tr>
		<tr bgColor="#66cdaa">
			<td>������ �����</td>
		</tr>
		<tr bgColor="#66cdaa">
			<td>������ � ��</td>
		</tr>
		<tr bgColor="#ab82ff">
			<td>�����-������</td>
		</tr>
		<tr bgColor="#ab82ff">
			<td>����� - ����������</td>
		</tr>
		<tr bgColor="#ff3030">
			<td>�������������</td>
		</tr>
		<tr bgColor="#6495ed">
			<td>�����������</td>
		</tr>
	</table>
	<hr>
	<a name="#����� ���������� �������"></a><div class="full_width big" align=center>����� ���������� �������</div>
	<hr>
	<b>������</b>: ���� �� � ������ ����� ��������� �� ������
	����, ���� ������� ����������� ��� ��� ���������� ���� �� ������ ���?<br>
	<b>�����</b>: ���, ��� ������
	������. � ������ ��������������� ������ ���� ����� ���� ������ �������
	��������� �������������.<br><br>
	 
	<b>������</b>: � ���������� ��� ����� ������� � ����, ���� ��
	� ������� ���� ���� ��� �������?<br>	 
	<b>�����</b>: ���, ��� ������
	������. � ������ ��������������� ������ ������� � ���� ����� ���� ������
	������� ��������� �������������.<br><br>
	 
	<b>������</b>: ����� �� ������� ���, ����� � ���
	������������� ��� ������ ������ ����?<br>	 
	<b>�����</b>: ���, ��� ������������
	�������� ������������. ������ ������ ����� �������� ����� ������������ ���
	����� �����, ������� ��� � ����������� ������������.<br><br>
	 
	<b>������</b>: ������� ����������� ������������ ���������
	������� � ����, ��� ������?<br>
	<b>�����</b>: ���������� � ����� ���
	�� ��� ����������� ���������������� ��������� � ����� ������� ���������.<br><br>
	 
	<b>������</b>: ��������� ��������� ������������, �����
	��������� ��� ������?<br> 
	<b>�����</b>: ���, ��������� �������
	��� ����� � ������ ������ �� ������ �������. ��������� ������ �������
	���������� � ����� ����, � ��������� ������������ �����������.<br><br>
	 
	<b>������</b>: ����� �� ����� ������ �� ���������� �
	���������� ����?<br> 
	<b>�����</b>: ��, ��������� ������ ����������������
	�������������.<br><br>
	 
	<b>������</b>: ����� �� ������ ���������� � ������ ���������?<br>
	<b>�����</b>: ������� ������� ������
	�������������, ������ ������ ���������� �������� ��������� � ������ ���������
	��� �������.<br><br>
	 
	<b>������</b>: ��� � ���� ������� ��������� ���� �����������
	�� ���������?<br>
	<b>�����</b>: �� ������ ���������
	��������� ������� � ����� ����� ���� ��������� � ������� ��������� �����. �
	������� ����������� ������������� ���� ��������� ��������������� � ���������.<br><br>
	 
	<b>������</b>: ��� �� ��������� ���� ���������.<br> 
	<b>�����</b>: �� ������ ����������
	������� �� ���������.<br><br>
	 
	<b>������</b>: ������������ ������� ���������� �����������
	������� ���������� � ������ ����� ��������� ����������� � �������. ��� ��� ��
	���������, ����� �� ������ �������?<br> 
	<b>�����</b>: ���.
</body>
</html>