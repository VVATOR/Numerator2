<%@ page language="java" contentType="text/html; charset=windows-1251"
    pageEncoding="windows-1251"%>
<%@page import="OracleConnect.SQLRequest" import="NumGenerator.NumGenerate" import="java.util.*"%>
<%@page import="java.util.ArrayList" %>
<%
//создаем переменную разбиения на части обозначения
NumGenerate num = new NumGenerate();
//переменные для разбиаения строки
String delimiter = " ";
String[] temp;
String ExplodedOBOZ="";
//разбитое обозначение
String OBOZ_PREFIX = "";
String OBOZ_FIRST_NUM = "";
String OBOZ_SECOND_NUM = "";
String OBOZ_THERD_NUM = "";
String OBOZ_POSTFIX = "";
String Type = "";
SQLRequest sql = new SQLRequest();
String OBOZNACHENIE="";
boolean first = true;
if(request.getParameter("OBOZNACHENIE") != null)
	OBOZNACHENIE = new String (request.getParameter("OBOZNACHENIE").getBytes("ISO-8859-1"));
out.println("{ \"aaData\": [");
if(!OBOZNACHENIE.equals("")){
	ExplodedOBOZ = num.ExplodeOBOZ(OBOZNACHENIE);
	temp = ExplodedOBOZ.split(delimiter);
	OBOZ_PREFIX = temp[0];
	OBOZ_FIRST_NUM = temp[1];
	OBOZ_SECOND_NUM = temp[2];
	OBOZ_THERD_NUM = temp[3];
	if(temp.length == 5) OBOZ_POSTFIX = temp[4];
	 else OBOZ_POSTFIX = "";
	Type = "2";
	sql.GetProductFirstLevel(OBOZ_PREFIX,OBOZ_FIRST_NUM,OBOZ_SECOND_NUM,OBOZ_THERD_NUM,OBOZ_POSTFIX,Type);
	while(sql.rs.next()){
		if(first==false) out.println(",");
		out.println("[");
		out.println("\"\",");
		out.println("\"<A HREF = \\\"index.jsp?SelectedItem=" + sql.rs.getString("OBOZNACHENIE") + "\\\">" + sql.rs.getString("OBOZNACHENIE") + "</a>\",");		
		out.println("\"" + sql.rs.getString("NAIMENOVANIE") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\",");
		out.println("\"" + sql.rs.getString("PRIMENAETSA") + "\"");
		out.println("]");
		first = false;
	}
}
out.println("] }");
%>