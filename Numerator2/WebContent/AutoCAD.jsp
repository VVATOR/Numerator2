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
<title>��������������� �������� AutoCAD</title>
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
String NAIM = "";
if(request.getParameter("NAIM")!=null) //������������ �������
	NAIM = new String(request.getParameter("NAIM").getBytes("ISO-8859-1"));
String OBOZ = "";
if(request.getParameter("OBOZ")!=null) //����������� �������
	OBOZ = new String(request.getParameter("OBOZ").getBytes("ISO-8859-1"));
String URL = "AutoCAD.jsp?SelectedItem=" + URLEncoder.encode(SelectedItem,"windows-1251") + "&OBOZ=" + URLEncoder.encode(OBOZ,"windows-1251") + "&NAIM=" + URLEncoder.encode(NAIM,"windows-1251") ;
%>
</head>
<body id="dt_example"  background="images/background.png">
	<div class="full_width big" align=center>��������������� �������� AutoCAD</div>
	<a href="index.jsp?SelectedItem=<%=URLEncoder.encode(SelectedItem,"windows-1251")%>"><img name=pict1 border=0 src="images/BUTTON_LEFT.PNG" onMouseOver="changeImg1('images/BUTTON_LEFT_SELECTED')" onMouseOut="changeImg1('images/BUTTON_LEFT')"></a>
<%
	String chr0=""+(char)0;	//��� ����������� ���������	
	SQLRequest count_files = new SQLRequest();	
	sql.GetUserFiles(FULLNAME);
	int i;
	int num_updates=0;
	if(request.getParameter("count_updates")!=null){  //�������� ���������� ����������
		String n=request.getParameter("count_updates");
		num_updates=Integer.parseInt(n);
	}
	count_files.GetCountUserFiles(FULLNAME);
	count_files.rs.next();	
	int id_upd[];
	id_upd=new int[count_files.rs.getInt("result")];//������ id �����, ������� ���� ��������
	String new_path_upd[];//������ ���������� �����, �� ������� ��������
	new_path_upd=new String[count_files.rs.getInt("result")];
	for(i=0; i<num_updates; i++){
		if(request.getParameter("id"+i)!=null){  //�������� id ����� ��� ����������
			String n=request.getParameter("id"+i);
			id_upd[i]=Integer.parseInt(n);
		}
		
		if(request.getParameter("path"+i)!=null){ //�������� ���� ��� ����������
			String p=new String(request.getParameter("path"+i).getBytes("ISO-8859-1"));
			new_path_upd[i]=p.replaceAll("!"," ");
			new_path_upd[i]=new_path_upd[i].replaceAll("@",chr0);
		}
		
	}
	
	for(i=0; i<num_updates; i++)
		sql.UpdateNumNumbersPath(id_upd[i],new_path_upd[i]);
%>
<h4><font color="#336699"> ���������� ����� �������� �� ���� "\\server3\GSKB\����������\����������". �������: </font></h4>	
<%
	int count=0;
	out.println("<form action=\"AutoCAD.jsp\" method=\"GET\">");
	out.println("<input type=hidden name=NAIM value="+NAIM+">");
	out.println("<input type=hidden name=OBOZ value="+OBOZ+">");
	out.println("<input type=hidden name=FULLNAME value="+FULLNAME.replaceAll(" ","%20")+">");
	out.println("<input type=hidden name=DEPARTMENT value="+DEPARTMENT.replaceAll(" ","%20")+">");
	if(num_updates==0){
		SQLRequest acad = new SQLRequest();
		out.println("<input type=\"hidden\" id=\"count_updates\" name=\"count_updates\">");
		
		out.println("<table align=\"center\" border=1>");
		out.println("<thead>");
	
		out.println("<tr bgcolor=\"#C0C0C0\" align=center>");
		out.println("<td width=\"200 px\">������������</td>");
		out.println("<td width=\"300 px\">�����������</td>");
		out.println("<td width=\"400 px\">AUTOCAD</td>");
		out.println("<td width=\"400 px\">������ � �������</td>");
			
		out.println("</tr>");
		out.println("</thead>");
		out.println("<tbody>");

		int id[];
		id=new int[count_files.rs.getInt("result")];//������ id �����, ������� ���� ��������
		String new_path[];//������ ���������� �����, �� ������� ��������
		new_path=new String[count_files.rs.getInt("result")];
		if(sql.rs!=null){//���� � �������� ������������ ���� �����
			int num=0;
			i=0;
			while(sql.rs.next()){
				acad.GetAutocadPath(sql.rs.getString("OBOZ"));
				
				if(acad.rs.next()){//���� � ������� AUTOCAD ���� ���� � ����� �����, �� ������� ������ � �������
					String acad_path="",num_path="";
					acad_path=acad.rs.getString("FILEPATH").trim() +"\\"+sql.rs.getString("OBOZ").trim() +
								sql.rs.getString("OBOZ_POSTFIX").trim()+".dwg";//���� �� autocad+��� �����
					num_path=sql.rs.getString("AUTOCAD").trim();//���� �� num_numbers
								
					if(num_path.equals(acad_path)== false){
						out.println("<tr>");
						out.println("<td>"+sql.rs.getString("NAIMENOVANIE")+"</td>");	
						out.println("<td>"+sql.rs.getString("OBOZ")+sql.rs.getString("OBOZ_POSTFIX")+"</td>");
						if(num_path.equals("-1")== false)
							out.println("<td><strike>"+num_path+"</strike></td>");//����������� �����
						else
							out.println("<td><strike></strike></td>");
						id[i]=sql.rs.getInt("ID");
						new_path[i]=acad_path;
						
						out.println("<input type=hidden name=id"+i+" value="+id[i]+">");//���������� � ��������� ������� id ��� ���������
						out.println("<input type=hidden name=path"+i+" value='"+new_path[i].replaceAll(" ","!").replaceAll(chr0,"@") + "'" +">");//���������� � ��������� ������� path ��� ���������
						URL += "&id" + i + "=" + id[i];
						URL += "&path" + i + "=" + URLEncoder.encode(new_path[i],"windows-1251");
						i++;
						num++;//���������� ��������� � �������� id � new_path
						out.println("<td>"+acad_path+"</td>");
					}			
				}
				out.println("</tr>");
			}
			count=num;
			URL += "&count_updates=" + count;
			out.println("<script>document.getElementById('count_updates').value="+count+";</script>");
		}
		else{
			out.println("<script>alert('� ���� ������ ��� �������');</script>");
		}				
		out.println("</tbody>");
		out.println("</table>");		
		out.println("<br>");
		out.println("<br>");
		out.println("<input type=\"submit\" value=\"��������\">");
		}
	else
			out.println("<div align=center><h3>��� ������ ���� ������� ��������</h3></div>");
	out.println("</form>");
	sql.Disconnect();
%>	
</body>
</html>