<%@ page language="java" contentType="text/html; charset=windows-1251" import="OracleConnect.SQLRequest"%>
 <%
  //�������� ���������� ��������
  String QString = "";
  int i = 0;
  if(request.getParameter("q") != null){
		QString = new String (request.getParameter("q").getBytes("ISO-8859-1"));
  }
  //������� ������ ��� ��
  SQLRequest sql = new SQLRequest();
  //��������� ������
  sql.GetAllFormats(QString);
  //���� �� �������
  while(sql.rs.next()){
	  //������� ������
	  out.println(sql.rs.getString("FORMAT") + "\n");
	  i++;
	  //��� ������ 10 �������, �� ������ �� �������
	  //if(i>10) break;
  }
  sql.Disconnect();
 %>