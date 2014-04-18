<%@page import="OracleConnect.SQLRequest"%>
<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<%@page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<link rel="stylesheet" href="css/AutocompleteStyle.css" >
<style type="text/css" title="currentStyle">
	@import "css/demo_page.css";
	@import "css/demo_table.css";
</style>
<title>Администрирование</title>
<script type="text/javascript">
	function setAction(action){
		document.adminForm.action.value=action;
		document.adminForm.submit();
	}
</script>
</head>
<%
	int action=-1;										//действие по администрированию
	String SessionUser="";									//переданный пользователь
	String findObozn="";									//обозначение, владельца которого нужно найти
	String oboznOwner="";									//владелец обозначения	
	String grantUser="";									//кому добавить
	String trustedUser="";									//кого добавить
	String[] formsVisibility={"hidden","hidden","hidden","hidden"};
	SQLRequest proeuser=new SQLRequest();
	
	
	//----------------------------------------------------------------------------------------------------------------------
	//													ПЕРЕДАЧА ПАРАМЕТРОВ
	//----------------------------------------------------------------------------------------------------------------------
	if(request.getParameter("action")!=null){
		action=Integer.parseInt(request.getParameter("action"));
		formsVisibility[action]="visible";
		session.setAttribute("action", action);
	}
	else{
		if(session.getAttribute("action")!=null){
			action=(Integer)session.getAttribute("action");
			formsVisibility[action]="visible";
		}
	}
	if(request.getParameter("findObozn")!=null){
		findObozn=new String(request.getParameter("findObozn").getBytes("ISO-8859-1"));
	}
	if(request.getParameter("grantUser")!=null){
		grantUser=new String(request.getParameter("grantUser").getBytes("ISO-8859-1"));
	}
	if(request.getParameter("trustedUser")!=null){
		trustedUser=new String(request.getParameter("trustedUser").getBytes("ISO-8859-1"));
	}
%>
<body id="dt_example" background="images/background.png">
	<div class="full_width big" align="center">Администрирование</div>
	<hr>
	<form name="adminForm" action="">
		<table>
			<tr>
				<td onclick="setAction(0)">
					Добавить доверенных пользователей
				</td>
			</tr>
			<tr>
				<td onclick="setAction(1)">
					Переместить узел
				</td>
			</tr>
			<tr>
				<td onclick="setAction(2)">
					Удалить изделие
				</td>
			</tr>
			<tr>
				<td onclick="setAction(3)">
					Определить создателя обозначения
				</td>
			</tr>
		</table>
		<hr>
		<input type="hidden" name="action" value="<%=action%>">
	</form>
	<form name="trustiesForm" action="" style="visibility: <%=formsVisibility[0]%>;">
		<%
			if(formsVisibility[0].equals("visible") && !grantUser.equals("") && !trustedUser.equals("")){
				proeuser.addTrustee(Integer.parseInt(grantUser), Integer.parseInt(trustedUser));
				out.println("<div>Добавление выполнено</div>");
			}
			proeuser.GetAllUsers();
		%>
		<table>
			<tr>
				<td>
					Кому добавить
				</td>
					<td>
						<select name="grantUser">
							<%
								if(formsVisibility[0].equals("visible")){
									while(proeuser.rs.next()){
										out.println("<option value=\""+proeuser.rs.getString("ID")+"\">"+proeuser.rs.getString("FULLNAME")+"</option>");
									}
								}
							%>
						</select>
					</td>
					<td rowspan="2" align="center">
						<input type="submit" name=trustiesButton value="Добавить">
					</td>
			</tr>
			<tr>
				<td>
					Кого добавить
				</td>
				<td>
					<select name="trustedUser">
						<%
							if(formsVisibility[0].equals("visible")){
								proeuser.rs.beforeFirst();
								while(proeuser.rs.next()){
									out.println("<option value=\""+proeuser.rs.getString("ID")+"\">"+proeuser.rs.getString("FULLNAME")+"</option>");
								}
							}
						%>
					</select>
				</td>
			</tr>
		</table>
	</form>
	<form name="moveForm" action="" style="visibility: <%=formsVisibility[1]%>;">
		456
	</form>
	<form name="delForm" action="" style="visibility: <%=formsVisibility[2]%>;">
		789
	</form>
	<form name="ownerForm" action="" style="visibility: <%=formsVisibility[3]%>;">
		<%
			if(formsVisibility[3].equals("visible")){
				proeuser.getOboznOwner(findObozn);
				if(proeuser.rs.next()){
					oboznOwner=proeuser.rs.getString("FULLNAME");
				}
			}
		%>
		<table>
			<tr>
				<td>
					Обозначение
				</td>
				<td>
					<input type="text" name="findObozn" value="<%=findObozn%>">
				</td>
				<td>
					<input type="submit" name="ownerButton" value="Найти">
				</td>
			</tr>
			<tr>
				<td>
				</td>
				<td>
					<%=oboznOwner %>
				</td>
				<td>
				</td>
			</tr>
		</table>
	</form>
	<%
		proeuser.Disconnect();
	%>
</body>
</html>