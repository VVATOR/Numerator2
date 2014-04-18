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
  sql.GetAllFormats(QString);
  //идем по записям
  while(sql.rs.next()){
	  //выводим запись
	  out.println(sql.rs.getString("FORMAT") + "\n");
	  i++;
	  //сли больше 10 записей, то дальше не выводим
	  //if(i>10) break;
  }
  sql.Disconnect();
 %>