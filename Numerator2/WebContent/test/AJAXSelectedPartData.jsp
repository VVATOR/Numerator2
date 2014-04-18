<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<%@page import="OracleConnect.SQLRequest" import="NumGenerator.NumGenerate" import="java.util.*"%>
<%@page import="java.util.ArrayList" %>
<%
SQLRequest sql = new SQLRequest();
String SessionUser="";
boolean first = true;
if(request.getParameter("SessionUser") != null)
	SessionUser = new String (request.getParameter("SessionUser").getBytes("ISO-8859-1"));
out.println("{ \"aaData\": [");
if(!SessionUser.equals("")){
	sql.GetUzListFromLogin(SessionUser);
	while(sql.rs.next()){
		if(first==false) out.println(",");
		out.println("[");
		out.println("\"<A HREF = \\\"index.jsp?SelectedItem=" + sql.rs.getString("OBOZNACHENIE") + "\\\">" + sql.rs.getString("OBOZNACHENIE") + "</a>\",");		
		out.println("\"" + sql.rs.getString("NAIMENOVANIE") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\"");
		out.println("]");
		first = false;
	}
}
out.println("] }");
%>