<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<title>Insert title here</title>
</head>
<body>
<h3>mvc</h3>
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
							 
							out.println(
										sql.GetProductFirstLevelSTRING(SelectedItem, TrustedUsers, full_access, OBOZ_PREFIX,OBOZ_FIRST_NUM,OBOZ_SECOND_NUM,OBOZ_THERD_NUM,OBOZ_POSTFIX,Type)
				 						);
				 		
				 		};
				%>
<h3>end_mvc</h3>
</body>
</html>