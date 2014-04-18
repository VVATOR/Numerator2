<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Insert title here</title>
</head>
<body>
	<table border=1>
		<tr>
			<td><a href="insert_product.jsp?SelectedItem="><img
								name=pict3_1 src="images/3-1_.png"
								onMouseOver="changeImg3_1('images/3-1')"
								onMouseOut="changeImg3_1('images/3-1_')" border=0
								title="Создать новое изделие"></img></a></td>
			<td valign="middle">
				<br>
				<form name=selForm1 style="vertical-align: middle">
					<select name="SelectedItem">
						<option selected>Выберите изделие</option>
					</select>
				</form>
			</td>
		</tr>
	</table>
</body>
</html>