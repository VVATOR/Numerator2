<%@ page language="java" contentType="text/html; charset=windows-1251" import="OracleConnect.SQLRequest"%>
 <%
  //получаем перемаддый параметр
  String QString = "";
  int i = 0;
  if(request.getParameter("q") != null){
		QString = new String (request.getParameter("q").getBytes("ISO-8859-1"));
  }
  //создаем объект для БД
  SQLRequest sql = new SQLRequest();
  //выполняем запрос
  sql.occupied(QString);
  //идем по записям
 
	  out.println(sql.occupied(QString).replaceAll("\"","'") + "\n");
	 
  sql.Disconnect();
 %>