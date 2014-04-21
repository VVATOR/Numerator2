package OracleConnect;

import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Formatter;
import java.util.ResourceBundle;
import java.util.regex.Pattern;

import NumGenerator.NumGenerate;

public class SQLRequest {
	private int QUERY_TIMEOUT = 640;
	public ResultSet rs = null;
	private Statement stmt = null;
	//конструктор
	private OracleConnect OC;
	
	
	
	public static String notNull(String text,String replacement){
		
		if(text.equals(null))
		return text;
		
		return replacement;
		
	}
	
	public SQLRequest() throws Exception{
		ResourceBundle resource = ResourceBundle.getBundle("database");
		String name =resource.getString("name");
		String password =resource.getString("password");
		String serverip =resource.getString("serverip");
		String databasename =resource.getString("databasename");
		String port =resource.getString("port");		
		OC = new OracleConnect(name,password,serverip,databasename,port);
	 //вызываем метод подключения к базе данных Oracle
	  //OC = new OracleConnect("proeuser","proeuser","bl-02.gskb.local","SEARCH");
	  //подключить
	  OC.getConnection();
		//Создаем statment (оператор) для выполнения SQL-запроса
	  stmt = OC.getCon().createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	}
	
	//Получить пользователя и его отдел по выбранному логину
	public void Disconnect () throws Exception{
		if(rs!=null){
			rs.close();
		}
		if(stmt!=null){
			stmt.close();
		}
		if(OC!=null){
			OC.Disconnected();
		}
	}
	
	//Получить все статусы
	public void UpdateStatus(String STATUS_ID, String OBOZ) throws Exception{
		  String sql = "UPDATE NUM_NUMBERS SET STATUS_ID=" + STATUS_ID + " WHERE REPLACE((NUM_NUMBERS.OBOZ_PREFIX || NUM_NUMBERS.OBOZ_FIRST_NUM|| NUM_NUMBERS.OBOZ_SECOND_NUM || NUM_NUMBERS.OBOZ_THERD_NUM || NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') = '" + OBOZ + "'";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  stmt.executeUpdate(sql);
		}
	
	//Получить все статусы
	public void GetAllStatus() throws Exception{
		  String sql = "SELECT STATUS,COLOR FROM NUM_STATUS ORDER BY LIFE_CYCLE";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//Получить все замечания
	public void GetAllUpgrade() throws Exception{
		String sql="Select NOTE_REPORT.ID,TYPE,QUESTION as TEXT,FULLNAME,ANSWER,STATUS_ID as FINISH "+
					"from NOTE_REPORT,NOTE_TYPE,USERS,NOTE_PROGRAM "+
					"where NOTE_TYPE.ID=NOTE_REPORT.TYPE_ID and NOTE_REPORT.QUESTION_AUTHOR_ID=USERS.ID and "+
					"NOTE_REPORT.PROGRAM_ID=NOTE_PROGRAM.ID and NOTE_PROGRAM.PROGRAM_NAME like 'Нумератор' "+
					"Order by NOTE_REPORT.ID";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
	}
	
	//Получить все статусы
	public void GetStatisticByOboz(String SelectedItem) throws Exception{
		  String sql = " SELECT ";
		  sql += " NUM_STATISTIC.DATE_OF_ACTION, "; 
		  sql += "NUM_ACTIONS.ACTION,  ";
		  sql += "NUM_STATISTIC.USERNAME,  ";
		  sql += "NUM_STATISTIC.NAIM,  ";
		  sql += "NUM_STATISTIC.OBOZ ";
		  sql += "FROM ";
		  sql += "PROEUSER.NUM_ACTIONS,  ";
		  sql += "PROEUSER.NUM_STATISTIC ";
		  sql += "WHERE ";
		  sql += "PROEUSER.NUM_STATISTIC.ACTION = PROEUSER.NUM_ACTIONS.ID AND ";
		  sql += "NUM_STATISTIC.OBOZ = '" + SelectedItem + "' ";
		  sql += "ORDER BY NUM_STATISTIC.DATE_OF_ACTION ";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	
	//Получить все материалы
	public void GetAllMaterial(String PartOfMaterial) throws Exception{
		  String sql = "SELECT MATERIAL FROM NUM_MATERIAL WHERE UPPER(MATERIAL) LIKE UPPER('" + PartOfMaterial + "%')";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
		
	//получить тип по обозначению
	public void GetTypeForOBOZ (String OBOZ) throws Exception{
		  //переменные для разбиаения строки
		  NumGenerate num = new NumGenerate();
	   	  String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
		  String delimiter = " ";
		  String[] temp;
		  //разбитое обозначение
		  String OBOZ_PREFIX = "";
		  String OBOZ_FIRST_NUM = "";
		  String OBOZ_SECOND_NUM = "";
		  String OBOZ_THERD_NUM = "";
		  String OBOZ_POSTFIX = "";
		  temp = ExplodedOBOZ.split(delimiter);
	   	  OBOZ_PREFIX = temp[0];
	   	  OBOZ_FIRST_NUM = temp[1];
	   	  OBOZ_SECOND_NUM = temp[2];
	   	  OBOZ_THERD_NUM = temp[3];
	   	  if(temp.length == 5) OBOZ_POSTFIX = temp[4];
	   	  else OBOZ_POSTFIX = "";
		  String sql = "SELECT TYPE FROM NUM_RELATIONS,NUM_NUMBERS WHERE ";
		  sql = sql + "		NUM_NUMBERS.ID= NUM_RELATIONS.CHILD_ID AND ";
		  sql = sql + "		OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND ";
		  sql = sql + "		OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "' AND ";
		  sql = sql + "		OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "' AND ";
		  sql = sql + "		OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "' ";
		  //если есть постфикс то ставим его, если нет то ставим chr(0)
		  if(!OBOZ_POSTFIX.equals("")){
			  sql = sql + "	AND	OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		  } else {
			  sql = sql + "	AND	OBOZ_POSTFIX = chr(0)";			  
		  }
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}

	//получить все дерево по обозначению
	public void GetTreeForOBOZ (String OBOZ) throws Exception{
		  //переменные для разбиаения строки
		  NumGenerate num = new NumGenerate();
	   	  String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
		  String delimiter = " ";
		  String[] temp;
		  //разбитое обозначение
		  String OBOZ_PREFIX = "";
		  String OBOZ_FIRST_NUM = "";
		  String OBOZ_SECOND_NUM = "";
		  String OBOZ_THERD_NUM = "";
		  String OBOZ_POSTFIX = "";
		  temp = ExplodedOBOZ.split(delimiter);
	   	  OBOZ_PREFIX = temp[0];
	   	  OBOZ_FIRST_NUM = temp[1];
	   	  OBOZ_SECOND_NUM = temp[2];
	   	  OBOZ_THERD_NUM = temp[3];
	   	  if(temp.length == 5) OBOZ_POSTFIX = temp[4];
	   	  else OBOZ_POSTFIX = "";
	      String sql = " SELECT ";
	      sql = sql + "   OBOZ_PREFIX || OBOZ_FIRST_NUM || OBOZ_SECOND_NUM || OBOZ_THERD_NUM || OBOZ_POSTFIX AS TREE, ";
	      sql = sql + "   OBOZ_PREFIX, ";
	      sql = sql + "   OBOZ_FIRST_NUM, ";
	      sql = sql + "   OBOZ_SECOND_NUM, ";
	      sql = sql + "   OBOZ_THERD_NUM, ";
	      sql = sql + "   OBOZ_POSTFIX, ";
	      sql = sql + "	  LEVEL,";
	      sql = sql + "	  NUM_NAIMENOVANIE.NAIMENOVANIE, ";	
	      sql = sql + "	  NUM_NUMBERS.OBOZ_THERD_NUM, 	";
	      sql = sql + "	  REPLACE((NUM_NUMBERS.OBOZ_PREFIX || 		NUM_NUMBERS.OBOZ_FIRST_NUM|| 		NUM_NUMBERS.OBOZ_SECOND_NUM || 		NUM_NUMBERS.OBOZ_THERD_NUM || 		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE, "; 		
	   	  sql = sql + "	  NUM_RELATIONS.TYPE, ";	
	   	  sql = sql + "	  NUM_NUMBERS.PRIMENAETSA, ";	
	   	  sql = sql + "	  NUM_RELATIONS.UZ_COUNT, ";	
	      sql = sql + "	  NUM_RELATIONS.PRIM_FOR_ZAIM, ";	
	   	  sql = sql + "	  NUM_NUMBERS.M_COUNT, ";	
	      sql = sql + "	  NUM_MASS.MASS, ";
	      sql = sql + "	  NUM_FORMAT.FORMAT, ";	
	      sql = sql + "	  NUM_NUMBERS.A1_COUNT, ";		
	      sql = sql + "	  NUM_NUMBERS.A4_COUNT, ";		
	      sql = sql + "	  USERS.FULLNAME, ";
	      sql = sql + "	  NUM_NUMBERS.AUTOCAD, ";	
	      sql = sql + "	  NUM_NUMBERS.PROE, ";	
	      sql = sql + "	  NUM_STATUS.ID AS STATUS_ID, ";	
	      sql = sql + "	  STATUS, ";	
	      sql = sql + "	  COLOR, ";	
	      sql = sql + "	  LIFE_CYCLE, ";	
	      sql = sql + "	  MATERIAL, ";
	      sql = sql + "	  NUM_NUMBERS.NOTE, USERS_1.FULLNAME as acad_fullname	";
	      sql = sql + " FROM NUM_RELATIONS ";
	      sql = sql + " INNER JOIN NUM_NUMBERS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
	      sql = sql + " INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID ";
	      sql=sql+"INNER JOIN USERS USERS_1 ON NUM_NUMBERS.AUTOCAD_USER_ID=USERS_1.ID ";
	      sql = sql + " LEFT JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID ";
	      sql = sql + " LEFT JOIN  NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID ";
	      sql = sql + " LEFT JOIN  NUM_MASS ON NUM_NUMBERS.MASS_ID = NUM_MASS.ID ";
	      sql = sql + " LEFT JOIN  NUM_FORMAT ON NUM_NUMBERS.FORMAT_ID = NUM_FORMAT.ID ";
	      sql = sql + " LEFT JOIN  NUM_MATERIAL ON NUM_NUMBERS.MATERIAL_ID = NUM_MATERIAL.ID ";
	      sql = sql + " CONNECT BY NOCYCLE PRIOR NUM_RELATIONS.CHILD_ID = NUM_RELATIONS.PARENT_ID ";
	      sql = sql + " START WITH NUM_RELATIONS.CHILD_ID = ";
	      sql = sql + "  (SELECT ID FROM NUM_NUMBERS WHERE OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "' AND OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "' AND OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "' ";
		  //если есть постфикс то ставим его, если нет то ставим chr(0)
		  if(!OBOZ_POSTFIX.equals("")){
			  sql = sql + "	AND	OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "')";
		  } else {
			  sql = sql + "	AND	OBOZ_POSTFIX = chr(0))";			  
		  }
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить пользователя для выбранного обозначения
	public void GetUserForOBOZ (String OBOZ) throws Exception{
		  //переменные для разбиаения строки
		  NumGenerate num = new NumGenerate();
	   	  String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
		  String delimiter = " ";
		  String[] temp;
		  //разбитое обозначение
		  String OBOZ_PREFIX = "";
		  String OBOZ_FIRST_NUM = "";
		  String OBOZ_SECOND_NUM = "";
		  String OBOZ_THERD_NUM = "";
		  String OBOZ_POSTFIX = "";
		  temp = ExplodedOBOZ.split(delimiter);
	   	  OBOZ_PREFIX = temp[0];
	   	  OBOZ_FIRST_NUM = temp[1];
	   	  OBOZ_SECOND_NUM = temp[2];
	   	  OBOZ_THERD_NUM = temp[3];
	   	  if(temp.length == 5) OBOZ_POSTFIX = temp[4];
	   	  else OBOZ_POSTFIX = "";
	      String sql = "SELECT USERS.FULLNAME ";
	      sql = sql + " FROM ";
	      sql = sql + " 	NUM_NUMBERS, ";
	      sql = sql + " 	USERS ";
		  sql = sql + "	WHERE ";
		  sql = sql + "		USERS.ID = NUM_NUMBERS.USER_ID AND";
		  sql = sql + "		OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND ";
		  sql = sql + "		OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "' AND ";
		  sql = sql + "		OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "' AND ";
		  sql = sql + "		OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "' AND ";
		  //если есть постфикс то ставим его, если нет то ставим chr(0)
		  if(!OBOZ_POSTFIX.equals("")){
			  sql = sql + "		OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		  } else {
			  sql = sql + "		OBOZ_POSTFIX = chr(0)";			  
		  }
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить пользователя для выбранного обозначения
	public void GetA1_A4_Count (String OBOZ) throws Exception{
		  //переменные для разбиаения строки
		  NumGenerate num = new NumGenerate();
	   	  String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
		  String delimiter = " ";
		  String[] temp;
		  //разбитое обозначение
		  String OBOZ_PREFIX = "";
		  String OBOZ_FIRST_NUM = "";
		  String OBOZ_SECOND_NUM = "";
		  String OBOZ_THERD_NUM = "";
		  String OBOZ_POSTFIX = "";
		  temp = ExplodedOBOZ.split(delimiter);
	   	  OBOZ_PREFIX = temp[0];
	   	  OBOZ_FIRST_NUM = temp[1];
	   	  OBOZ_SECOND_NUM = temp[2];
	   	  OBOZ_THERD_NUM = temp[3];
	   	  if(temp.length == 5) OBOZ_POSTFIX = temp[4];
	   	  else OBOZ_POSTFIX = "";
	      String sql = "SELECT NUM_NUMBERS.A1_COUNT,NUM_NUMBERS.A4_COUNT ";
	      sql = sql + " FROM ";
	      sql = sql + " 	NUM_NUMBERS ";
		  sql = sql + "	WHERE ";
		  sql = sql + "		OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND ";
		  sql = sql + "		OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "' AND ";
		  sql = sql + "		OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "' AND ";
		  sql = sql + "		OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "' AND ";
		  //если есть постфикс то ставим его, если нет то ставим chr(0)
		  if(!OBOZ_POSTFIX.equals("")){
			  sql = sql + "		OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		  } else {
			  sql = sql + "		OBOZ_POSTFIX = chr(0)";			  
		  }
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//добавить доверенные лица для указанного пользователя
	public void AddTrustesUsers (String GrantedUserLogin,String NEWTRUSTEDFULLNAME) throws Exception{
		String GRANT_USER_ID = "";     //ID пользователя добавляющего доверенного
		String TRUSTEES_USER_ID = "";  //ID добавляемого пользователя
		String SQL_INSERT = "";
		//получаем ID пользователя добавляющего доверенного
		SQLRequest_1 sql_1 = new SQLRequest_1();
		sql_1.GetLOGINID(GrantedUserLogin);
		if(sql_1.rs1.next()){
		  if(sql_1.rs1.getString("ID") != null) GRANT_USER_ID = sql_1.rs1.getString("ID");
		  else GRANT_USER_ID = "-1";
		}
		else 
		GRANT_USER_ID = "-1";
		//получаем ID добавляемого пользователя
		sql_1.GetUserID(NEWTRUSTEDFULLNAME);
		if(sql_1.rs1.next()){
		  if(sql_1.rs1.getString("ID") != null) TRUSTEES_USER_ID = sql_1.rs1.getString("ID");
		  else TRUSTEES_USER_ID = "-1";
		}
		else 
		TRUSTEES_USER_ID = "-1";
		//--------------------------
		//смотрим последний ID в таблице NUM_TRUSTEES
		sql_1.GetLastTRUST_Id();
		int  ID_int = 0;
		String ID_str="";
		if (sql_1.rs1.next()){
		  //если есть последний ID, то увеличиваем не 1
		  if(sql_1.rs1.getString("MAX(ID)") != null) ID_int =Integer.parseInt(sql_1.rs1.getString("MAX(ID)")) + 1;
		  else ID_int = 0;
		   ID_str =  Integer.toString(ID_int);
		}
		else ID_str = "0";
		//формируем строку добавления записи
		SQL_INSERT = "INSERT INTO NUM_TRUSTEES (ID,GRANT_USER_ID,TRUSTEES_USER_ID) VALUES ('"+ ID_str + "','" + GRANT_USER_ID + "','" + TRUSTEES_USER_ID + "')";
		//выполняем запрос
		OC.getCon().setAutoCommit(false);
	    Statement st = OC.getCon().createStatement();
		boolean error=false;
	    try {
	    	 //Выполняем запрос
	    	 st.setQueryTimeout(QUERY_TIMEOUT);
	    	 st.executeUpdate(SQL_INSERT);
	    	 st.close(); 
			}
		catch (Exception e){ 
			  e.printStackTrace(); 
			  error=true;
			}
		if (!error) OC.getCon().commit();
		else{
			OC.getCon().rollback();
		}
	}
	
	//добавить доверенные лица для указанного пользователя
	public void DeleteTrustesUsers (String GrantedUserLogin,String NEWTRUSTEDFULLNAME) throws Exception{
		String GRANT_USER_ID = "";     //ID пользователя добавляющего доверенного
		String TRUSTEES_USER_ID = "";  //ID добавляемого пользователя
		String SQL_DELETE = "";
		//получаем ID пользователя удаляющего доверенного
		SQLRequest_1 sql_1 = new SQLRequest_1();
		sql_1.GetLOGINID(GrantedUserLogin);
		if(sql_1.rs1.next()){
		  if(sql_1.rs1.getString("ID") != null) GRANT_USER_ID = sql_1.rs1.getString("ID");
		  else GRANT_USER_ID = "-1";
		}
		else 
		GRANT_USER_ID = "-1";
		//получаем ID удаляемого пользователя
		sql_1.GetUserID(NEWTRUSTEDFULLNAME);
		if(sql_1.rs1.next()){
		  if(sql_1.rs1.getString("ID") != null) TRUSTEES_USER_ID = sql_1.rs1.getString("ID");
		  else TRUSTEES_USER_ID = "-1";
		}
		else 
		TRUSTEES_USER_ID = "-1";
		//формируем строку удаления записи
		SQL_DELETE = "DELETE FROM NUM_TRUSTEES WHERE GRANT_USER_ID = " + GRANT_USER_ID + " AND TRUSTEES_USER_ID = " + TRUSTEES_USER_ID;
		//выполняем запрос
		OC.getCon().setAutoCommit(false);
	    Statement st = OC.getCon().createStatement();
		boolean error=false;
	    try {
	    	 //Выполняем запрос
	    	 st.setQueryTimeout(QUERY_TIMEOUT);
	    	 st.executeUpdate(SQL_DELETE);
	    	 st.close(); 
			}
		catch (Exception e){ 
			  e.printStackTrace(); 
			  error=true;
			}
		if (!error) OC.getCon().commit();
		else {
			OC.getCon().rollback();
		}
	}
	
	//получить доверенные лица указанного пользователя
	public void GetAllTrustesUsers (String Login) throws Exception{
		  String sql = "SELECT ";
		  sql = sql + "  USERS_1.FULLNAME, "; 
		  sql = sql + "  DEPARTMENT.DEPARTMENT ";
		  sql = sql + "FROM ";
		  sql = sql + "  PROEUSER.NUM_TRUSTEES, ";
		  sql = sql + "  PROEUSER.USERS, ";
		  sql = sql + "  PROEUSER.USERS USERS_1, ";
		  sql = sql + "  PROEUSER.DEPARTMENT ";
		  sql = sql + "WHERE ";
		  sql = sql + "  PROEUSER.NUM_TRUSTEES.GRANT_USER_ID = PROEUSER.USERS.ID  AND ";
		  sql = sql + "  PROEUSER.NUM_TRUSTEES.TRUSTEES_USER_ID = USERS_1.ID  AND ";
		  sql = sql + "  USERS_1.DEPARTMENT_ID = PROEUSER.DEPARTMENT.ID AND ";
		  sql = sql + "  USERS.LOGIN = UPPER('" + Login + "') ";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить пользователей доверивших юзеру изменение
	public void GetUsersHaveAcces (String Login) throws Exception{
		  String sql = "SELECT ";
		  sql = sql + "  USERS_1.FULLNAME, "; 
		  sql = sql + "  DEPARTMENT.DEPARTMENT ";
		  sql = sql + "FROM ";
		  sql = sql + "  PROEUSER.NUM_TRUSTEES, ";
		  sql = sql + "  PROEUSER.USERS, ";
		  sql = sql + "  PROEUSER.USERS USERS_1, ";
		  sql = sql + "  PROEUSER.DEPARTMENT ";
		  sql = sql + "WHERE ";
		  sql = sql + "  PROEUSER.NUM_TRUSTEES.TRUSTEES_USER_ID = PROEUSER.USERS.ID  AND ";
		  sql = sql + "  PROEUSER.NUM_TRUSTEES.GRANT_USER_ID = USERS_1.ID AND ";
		  sql = sql + "  USERS_1.DEPARTMENT_ID = PROEUSER.DEPARTMENT.ID AND ";
		  sql = sql + "  USERS.LOGIN = UPPER('" + Login + "') ";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить все массы
	public void GetAllMass (String PartOfMass) throws Exception{
		  String sql = "SELECT MASS FROM NUM_MASS WHERE UPPER(MASS) LIKE UPPER('" + PartOfMass + "%') ORDER BY MASS";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить все форматы
	public void GetAllFormats (String PartOfFormat) throws Exception{
		  String sql = "SELECT DISTINCT NUM_FORMAT.FORMAT FROM NUM_FORMAT WHERE UPPER(FORMAT) LIKE UPPER('" + PartOfFormat + "%') ORDER BY FORMAT";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить все ФИО пользователей
	public void GetAllFio (String PartOfFullname) throws Exception{
		  String sql = "SELECT DISTINCT USERS.LOGIN, USERS.FULLNAME FROM USERS WHERE UPPER(FULLNAME) LIKE UPPER('" + PartOfFullname  + "%') and USER_STATUS=1 ORDER BY FULLNAME";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить все наименования
	public void GetAllNaimenovanie (String ParnOfNaimenovanie) throws Exception{
		  String sql = "SELECT DISTINCT NUM_NAIMENOVANIE.NAIMENOVANIE FROM NUM_NAIMENOVANIE WHERE UPPER(NAIMENOVANIE) LIKE UPPER('" + ParnOfNaimenovanie + "%') ORDER BY NAIMENOVANIE ";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	//получить наименование для AJAX
	public void GetNaimenovanieForAjax(String strSearch) throws Exception
	{
		String sql = "SELECT DISTINCT NUM_NAIMENOVANIE.NAIMENOVANIE FROM NUM_NAIMENOVANIE WHERE UPPER(NUM_NAIMENOVANIE.NAIMENOVANIE) LIKE UPPER('"+strSearch+"%') ORDER BY NAIMENOVANIE";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = stmt.executeQuery(sql);
	}
	
	//получить все обозначения
	public void GetAllOboznachenie () throws Exception{
		  String sql = "SELECT ";
		  sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE ";  
		  sql = sql + " FROM NUM_NUMBERS";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить все обозначения
	public void Search(String SEARCH_OBOZ) throws Exception{
		  String sql = "SELECT * FROM (SELECT"; 
		  sql = sql + "	  NUM_NUMBERS.OBOZ_PREFIX || ";
		  sql = sql + "	  NUM_NUMBERS.OBOZ_FIRST_NUM || ";
		  sql = sql + "	  NUM_NUMBERS.OBOZ_SECOND_NUM || ";
		  sql = sql + "	  NUM_NUMBERS.OBOZ_THERD_NUM || ";
		  sql = sql + "	  NUM_NUMBERS.OBOZ_POSTFIX AS FULLOBOZ, ";
		  sql = sql + "	  NUM_NAIMENOVANIE.NAIMENOVANIE, ";
		  sql = sql + "	  USERS.FULLNAME, ";
		  sql = sql + "	  DEPARTMENT.DEPARTMENT, ";
		  sql = sql + "	  NUM_NUMBERS.PRIMENAETSA, ";
		  sql = sql + "	  NUM_STATUS.STATUS,";
		  sql = sql + "	  NUM_STATUS.COLOR";
		  sql = sql + "	FROM";
		  sql = sql + "	  PROEUSER.NUM_NUMBERS, ";
		  sql = sql + "	  PROEUSER.USERS, ";
		  sql = sql + "	  PROEUSER.NUM_NAIMENOVANIE, ";
		  sql = sql + "	  PROEUSER.DEPARTMENT, ";
		  sql = sql + "	  PROEUSER.NUM_STATUS";
		  sql = sql + "	WHERE";
		  sql = sql + "	  PROEUSER.USERS.DEPARTMENT_ID = PROEUSER.DEPARTMENT.ID  AND ";
		  sql = sql + "	  PROEUSER.NUM_NUMBERS.USER_ID = PROEUSER.USERS.ID  AND ";
		  sql = sql + "	  PROEUSER.NUM_NUMBERS.NAIMENOVANIE_ID = PROEUSER.NUM_NAIMENOVANIE.ID  AND ";
		  sql = sql + "	  PROEUSER.NUM_NUMBERS.STATUS_ID = PROEUSER.NUM_STATUS.ID)";
		  sql = sql + "	WHERE FULLOBOZ LIKE '%" + SEARCH_OBOZ.toUpperCase() + "%'";
		  sql = sql + " ORDER BY FULLOBOZ ";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить все обозначения в диапазоне данного обозначения
	public void GetAllOboznachenieFromCurrentOboznachenie (String OBOZ_PREFIX, String OBOZ_FIRST_NUM) throws Exception{
		  String sql = "SELECT ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_PREFIX, ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM, ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM, ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM, ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX ";  
		  sql = sql + " FROM NUM_NUMBERS";
		  sql = sql + " WHERE ";
		  sql = sql + " NUM_NUMBERS.OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND";
		  sql = sql + " NUM_NUMBERS.OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "'";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить ФИО и отдел пользователя по логину
	public void GetUserFioAndDepartmentFromLogin (String Login) throws Exception{
		  String sql = "SELECT USERS.LOGIN,USERS.FULLNAME,DEPARTMENT.DEPARTMENT,DEPARTMENT.DEPARTMENT_ABB,";
		  sql = sql + " DEPARTMENT.DEPARTMENT_CHIEF FROM USERS,DEPARTMENT";
		  sql = sql + " WHERE USERS.DEPARTMENT_ID = DEPARTMENT.ID";
		  sql = sql + " AND (UPPER(TRIM(USERS.LOGIN)) = UPPER('" + Login + "'))";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить список изделий выбранного пользователя
	public void GetProductList () throws Exception{
		  String sql = " SELECT ";
		  sql = sql + "		NUM_NAIMENOVANIE.NAIMENOVANIE, "; 
		  sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE, ";  
		  sql = sql + "		USERS.FULLNAME "; 
		  sql = sql + " FROM "; 
		  sql = sql + "		NUM_NUMBERS "; 
		  sql = sql + "INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID ";
		  sql = sql + "INNER JOIN NUM_RELATIONS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
		  sql = sql + "LEFT JOIN NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID "; 
		  sql = sql + "WHERE "; 
		  sql = sql + "		NUM_RELATIONS.TYPE = 1 ";
		  sql = sql + "ORDER BY ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_PREFIX, "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM, "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM, "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM, "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX ";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить список узлов выбранного пользователя
		public void GetBigUzList () throws Exception{
			  String sql = " SELECT ";   
			  sql = sql + "		NUM_NUMBERS.ID AS GENERAL_ID, "; 
			  sql = sql + "		NUM_NAIMENOVANIE.NAIMENOVANIE, "; 
			  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM, ";
			  sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX || ";
			  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM|| ";
			  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM || ";
			  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM || ";
			  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE, ";
			  sql = sql + "		NUM_RELATIONS.TYPE, "; 
			  sql = sql + "		NUM_NUMBERS.PRIMENAETSA, ";
			  sql = sql + "		NUM_RELATIONS.UZ_COUNT, ";
			  sql = sql + "		NUM_RELATIONS.PRIM_FOR_ZAIM, ";
			  sql = sql + "		NUM_NUMBERS.M_COUNT, ";
			  sql = sql + "		NUM_MASS.MASS, ";
			  sql = sql + "		NUM_FORMAT.FORMAT, ";
			  sql = sql + "		NUM_NUMBERS.A1_COUNT, ";
			  sql = sql + "		NUM_NUMBERS.A4_COUNT, ";
			  sql = sql + "		USERS.FULLNAME, ";
			  sql = sql + "		NUM_NUMBERS.AUTOCAD, ";
			  sql = sql + "		NUM_NUMBERS.PROE, ";
			  sql = sql + "		NUM_STATUS.ID AS STATUS_ID, ";
			  sql = sql + "		STATUS, ";
			  sql = sql + "		COLOR, ";
			  sql = sql + "		LIFE_CYCLE, ";
			  sql = sql + "		MATERIAL, NUM_NUMBERS.NOTE ";
			  sql = sql + "FROM ";
			  sql = sql + "		NUM_NUMBERS ";
			  sql = sql + " INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID ";
			  sql = sql + " INNER JOIN NUM_RELATIONS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
		      sql = sql + " INNER JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID ";
		      sql = sql + " INNER JOIN NUM_NUMBERS NUM_NUMBERS_1 ON NUM_NUMBERS_1.ID = NUM_RELATIONS.CHILD_ID ";
		      sql = sql + " LEFT JOIN  NUM_MATERIAL ON NUM_NUMBERS.MATERIAL_ID = NUM_MATERIAL.ID ";
			  sql = sql + " LEFT JOIN NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID ";
			  sql = sql + "	LEFT JOIN  NUM_MASS ON NUM_NUMBERS.MASS_ID = NUM_MASS.ID ";
			  sql = sql + "	LEFT JOIN  NUM_FORMAT ON NUM_NUMBERS.FORMAT_ID = NUM_FORMAT.ID ";
			  sql = sql + "WHERE ";
			  sql = sql + "		NUM_RELATIONS.PARENT_ID <> -1 AND ";
			  sql = sql + "		NUM_RELATIONS.TYPE = 3 AND ";
			  sql = sql + "		NUM_RELATIONS.TYPE <> 1 AND ";
			  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM = '000' ";
			  sql = sql + "ORDER BY ";
			  sql = sql + "		NUM_NUMBERS.OBOZ_PREFIX, ";
			  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM, "; 
			  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM, ";
			  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM, ";
			  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX ";
			  //Выполняем запрос
			  stmt.setQueryTimeout(QUERY_TIMEOUT);
			  rs = stmt.executeQuery(sql);
			}
	
	//получить список узлов выбранного пользователя
	public void GetUzListFromLogin (String Login) throws Exception{
		  String sql = " SELECT ";   
		  sql = sql + "		NUM_NAIMENOVANIE.NAIMENOVANIE, ";
		  sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE, "; 
		  sql = sql + "		REPLACE((NUM_NUMBERS_1.OBOZ_PREFIX || "; 
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_FIRST_NUM || "; 
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_SECOND_NUM || ";
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_THERD_NUM ||  ";
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_POSTFIX),CHR(0),'') AS VHODIT,  ";
		  sql = sql + "		NUM_RELATIONS.TYPE, "; 
		  sql = sql + "		NUM_RELATIONS.UZ_COUNT, ";
		  sql = sql + "		NUM_MASS.MASS, ";
		  sql = sql + "		NUM_FORMAT.FORMAT, ";		  
		  sql = sql + "		NUM_NUMBERS.M_COUNT, ";
		  sql = sql + "		NUM_NUMBERS.A1_COUNT, ";
		  sql = sql + "		NUM_NUMBERS.A4_COUNT, ";
		  sql = sql + "		NUM_NUMBERS.AUTOCAD, ";
		  sql = sql + "		NUM_NUMBERS.PROE, ";
		  sql = sql + "		USERS.FULLNAME, ";
		  sql = sql + "		NUM_NUMBERS.PRIMENAETSA, ";
		  sql = sql + "		STATUS, ";
		  sql = sql + "		MATERIAL, NUM_NUMBERS.NOTE ";
		  sql = sql + "FROM ";
		  sql = sql + "		NUM_NUMBERS ";
		  sql = sql + " INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID ";
		  sql = sql + " INNER JOIN NUM_RELATIONS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
	      sql = sql + " INNER JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID ";
	      sql = sql + " INNER JOIN NUM_NUMBERS NUM_NUMBERS_1 ON NUM_NUMBERS_1.ID = NUM_RELATIONS.CHILD_ID ";
	      sql = sql + " LEFT JOIN  NUM_MATERIAL ON NUM_NUMBERS.MATERIAL_ID = NUM_MATERIAL.ID ";
		  sql = sql + " LEFT JOIN NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID ";
		  sql = sql + "	LEFT JOIN  NUM_MASS ON NUM_NUMBERS.MASS_ID = NUM_MASS.ID ";
		  sql = sql + "	LEFT JOIN  NUM_FORMAT ON NUM_NUMBERS.FORMAT_ID = NUM_FORMAT.ID ";
		  sql = sql + "WHERE ";
		  sql = sql + "		USERS.LOGIN = UPPER('" + Login + "') AND ";
		  sql = sql + "		NUM_RELATIONS.PARENT_ID <> -1 AND ";
		  sql = sql + "		NUM_RELATIONS.TYPE = 3 AND ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM = '000' ";
		  sql = sql + "ORDER BY ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_PREFIX, ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM, "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM, ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM, ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX ";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить полную информацию по узлам выбранного изделия
	public void GetProductFirstLevel (String OBOZ_PREFIX, String OBOZ_FIRST_NUM, String OBOZ_SECOND_NUM, String OBOZ_THERD_NUM, String OBOZ_POSTFIX, String TYPE) throws Exception{
		 		  String sql = " SELECT distinct "
		  		+ "		  		NUM_NUMBERS.ID AS GENERAL_ID,   "
		  		+ " 	  		NUM_NAIMENOVANIE.NAIMENOVANIE,"
		  		+ "		  		NUM_NUMBERS.OBOZ_THERD_NUM,"
		  		+ "		  		REPLACE((NUM_NUMBERS.OBOZ_PREFIX ||"
		  		+ "		  		NUM_NUMBERS.OBOZ_FIRST_NUM||"
		  		+ "		  		NUM_NUMBERS.OBOZ_SECOND_NUM ||"
		  		+ " 	  		NUM_NUMBERS.OBOZ_THERD_NUM ||"
		  		+ "		  		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE,"
		  		+ "		  		NUM_RELATIONS.TYPE,"
		  		+ "		  		NUM_NUMBERS.PRIMENAETSA,"
		  		+ "		  		NUM_RELATIONS.UZ_COUNT,"
		  		+ "		  		NUM_RELATIONS.PRIM_FOR_ZAIM,"
		  		+ "		  		NUM_NUMBERS.M_COUNT,"
		  		+ "		  		NUM_MASS.MASS,"
		  		+ "		  		NUM_FORMAT.FORMAT,"
		  		+ "		  		NUM_NUMBERS.A1_COUNT,"
		  		+ "		  		NUM_NUMBERS.A4_COUNT,"
		  		+ "		  		USERS.FULLNAME,"
		  		+ "		  		NUM_NUMBERS.AUTOCAD,"
		  		+ "		  		NUM_NUMBERS.PROE,"
		  		+ "		  		NUM_STATUS.ID AS STATUS_ID,"
		  		+ "		  		STATUS,"
		  		+ "		  		COLOR,"
		  		+ "		  		LIFE_CYCLE"
		  		+ ""
		  		+ "		  		,MATERIAL"
		  		+ "             ,NUM_NUMBERS.NOTE,"
		  		+ "             USERS_1.FULLNAME as acad_fullname ";
		  
		  sql = sql + "	FROM ";
		  sql = sql + "		NUM_NUMBERS ";
		  sql = sql + "	INNER JOIN  NUM_RELATIONS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
		  sql = sql + "	INNER JOIN  NUM_NUMBERS NUM_NUMBERS_1 ON NUM_RELATIONS.PARENT_ID = NUM_NUMBERS_1.ID ";
		  sql = sql + "	INNER JOIN USERS ON  NUM_NUMBERS.USER_ID = USERS.ID ";
	      sql = sql + " INNER JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID ";
	      sql = sql + " LEFT JOIN  NUM_MATERIAL ON NUM_NUMBERS.MATERIAL_ID = NUM_MATERIAL.ID ";
		  sql = sql + "	LEFT JOIN  NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID ";
		  sql = sql + "	LEFT JOIN  NUM_MASS ON NUM_NUMBERS.MASS_ID = NUM_MASS.ID ";
		  sql = sql + "	LEFT JOIN  NUM_FORMAT ON NUM_NUMBERS.FORMAT_ID = NUM_FORMAT.ID ";
		  sql=sql+" inner JOIN USERS USERS_1 ON NUM_NUMBERS.AUTOCAD_USER_ID=USERS_1.ID ";
		  sql = sql + "	WHERE ";
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND ";
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "' AND ";
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "' AND ";
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "' AND ";
		  //если есть постфикс то ставим его, если нет то ставим chr(0)
		  if(!OBOZ_POSTFIX.equals("")){
			  sql = sql + "		NUM_NUMBERS_1.OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		  } else {
			  sql = sql + "		NUM_NUMBERS_1.OBOZ_POSTFIX = chr(0)";			  
		  }
		  sql = sql + "		ORDER BY OBOZNACHENIE ";
		  
		  
		  System.out.println(OBOZ_PREFIX+""+OBOZ_FIRST_NUM+""+OBOZ_SECOND_NUM+""+OBOZ_THERD_NUM+""+OBOZ_POSTFIX+"TYPE:    "+TYPE);
		  //Выполняем запрос
		  
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);

		}
	
	public String GetProductFirstLevelSTRING(String SelectedItem,ArrayList<String> TrustedUsers,boolean full_access,  String OBOZ_PREFIX, String OBOZ_FIRST_NUM, String OBOZ_SECOND_NUM, String OBOZ_THERD_NUM, String OBOZ_POSTFIX, String TYPE) throws Exception{
		/*OBOZ_PREFIX     = "КЗК-5-";
		OBOZ_FIRST_NUM  = "01";
		OBOZ_SECOND_NUM = "20";
		OBOZ_THERD_NUM  = "000";
		*/
		String out="";
		  String sql = " SELECT distinct "
		  		+ "		  		NUM_NUMBERS.ID AS GENERAL_ID,   "
		  		+ " 	  		NUM_NAIMENOVANIE.NAIMENOVANIE,"
		  		+ "		  		NUM_NUMBERS.OBOZ_THERD_NUM,"
		  		+ "		  		REPLACE((NUM_NUMBERS.OBOZ_PREFIX ||"
		  		+ "		  		NUM_NUMBERS.OBOZ_FIRST_NUM||"
		  		+ "		  		NUM_NUMBERS.OBOZ_SECOND_NUM ||"
		  		+ " 	  		NUM_NUMBERS.OBOZ_THERD_NUM ||"
		  		+ "		  		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'')  AS OBOZNACHENIE,"
		  		+ "		  		NUM_RELATIONS.TYPE,"
		  		+ "		  		NUM_NUMBERS.PRIMENAETSA ,"
		  		+ "		  		NUM_RELATIONS.UZ_COUNT,"
		  		+ "		  		NUM_RELATIONS.PRIM_FOR_ZAIM ,"
		  		+ "		  		NUM_NUMBERS.M_COUNT ,"
		  		+ "		  		NUM_MASS.MASS,"
		  		+ "		  		NUM_FORMAT.FORMAT,"
		  		+ "		  		NUM_NUMBERS.A1_COUNT,"
		  		+ "		  		NUM_NUMBERS.A4_COUNT,"
		  		+ "		  		USERS.FULLNAME,"
		  		+ "		  		NUM_NUMBERS.AUTOCAD,"
		  		+ "		  		NUM_NUMBERS.PROE,"
		  		+ "		  		NUM_STATUS.ID AS STATUS_ID,"
		  		+ "		  		STATUS,"
		  		+ "		  		COLOR,"
		  		+ "		  		LIFE_CYCLE"
		  		+ ""
		  		+ "		  		,MATERIAL"
		  		+ "             ,NUM_NUMBERS.NOTE,"
		  		+ "             USERS_1.FULLNAME as acad_fullname ";
		  
		  sql = sql + "	FROM ";
		  sql = sql + "		NUM_NUMBERS ";
		  sql = sql + "	INNER JOIN  NUM_RELATIONS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
		  sql = sql + "	INNER JOIN  NUM_NUMBERS NUM_NUMBERS_1 ON NUM_RELATIONS.PARENT_ID = NUM_NUMBERS_1.ID ";
		  sql = sql + "	INNER JOIN USERS ON  NUM_NUMBERS.USER_ID = USERS.ID ";
	      sql = sql + " INNER JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID ";
	      sql = sql + " LEFT JOIN  NUM_MATERIAL ON NUM_NUMBERS.MATERIAL_ID = NUM_MATERIAL.ID ";
		  sql = sql + "	LEFT JOIN  NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID ";
		  sql = sql + "	LEFT JOIN  NUM_MASS ON NUM_NUMBERS.MASS_ID = NUM_MASS.ID ";
		  sql = sql + "	LEFT JOIN  NUM_FORMAT ON NUM_NUMBERS.FORMAT_ID = NUM_FORMAT.ID ";
		  sql=sql+" left JOIN USERS USERS_1 ON NUM_NUMBERS.AUTOCAD_USER_ID=USERS_1.ID ";
		  sql = sql + "	WHERE ";
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND ";
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "' AND ";
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "' AND ";
		  sql = sql + "		NUM_NUMBERS_1.OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "' AND ";
		  //если есть постфикс то ставим его, если нет то ставим chr(0)
		  if(!OBOZ_POSTFIX.equals("")){
			  sql = sql + "		NUM_NUMBERS_1.OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		  } else {
			  sql = sql + "		NUM_NUMBERS_1.OBOZ_POSTFIX = chr(0)";			  
		  }
		  sql = sql + "		ORDER BY OBOZNACHENIE ";
		  
		  
		  System.out.println(OBOZ_PREFIX+""+OBOZ_FIRST_NUM+""+OBOZ_SECOND_NUM+""+OBOZ_THERD_NUM+""+OBOZ_POSTFIX+"TYPE:    "+TYPE);
		  //Выполняем запрос
		  
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		  
		  
out+=("<table id='MainTableASM'  class='display' width='100%'>");  
out+=("<thead>");  
	out+=("<tr>");   
		out+=("<th>Обозначение</th>");  
		out+=("<th>Действия</th>");  
		out+=("<th>Наименование</th>");  
		out+=("<th>Тип</th>");  
		out+=("<th>Первичная применяемость</th>");  
		out+=("<th>Исполнитель</th>");  
		out+=("<th>Статус</th>");  
		out+=("<th>Разработчик чертежа</th>");  
		out+=("<th>Материал</th>");  
		out+=("<th>Количество в узле</th>");  
		out+=("<th>Количество в машине</th>");  
		out+=("<th>Масса</th>");  
		out+=("<th>Формат</th>");  
		out+=("<th>Количество А1</th>");  
		out+=("<th>Количество А4</th>");  
		out+=("<th>Модель CREO</th>");  
		out+=("<th>Чертеж AutoCAD</th>");  
		out+=("<th>Примечание</th>  ");  
	out+=("</tr>");  
out+=("</thead>");  
out+=("<tbody>");  
while(rs.next()){
	 // out+=("<tr>");
	
	//цвет в зависимости от статуса
	switch(rs.getInt("STATUS_ID")){
	case 1: out+=("<tr class=\"grade1\">"); break;
	case 2: out+=("<tr class=\"grade2\">"); break;
	case 3: out+=("<tr class=\"grade3\">"); break;
	case 4: out+=("<tr class=\"grade4\">"); break;
	case 6: out+=("<tr class=\"grade6\">"); break;
	case 7: out+=("<tr class=\"grade7\">"); break;
	case 8: out+=("<tr class=\"grade8\">"); break;
	case 9: out+=("<tr class=\"grade9\">"); break;
	case 10: out+=("<tr class=\"grade10\">"); break;
	}

	//иконка деталь/сборка
	  out+=("<td>");
			if(rs.getString("OBOZ_THERD_NUM").charAt(rs.getString("OBOZ_THERD_NUM").length()-1) == '0')
			out+=("<img src=\"images/Assembly_litle1.png\"></img>");
			else
			out+=("<img src=\"images/Part_litle1.png\"></img>");		
		    //обозначение
		    if(
		    (rs.getString("OBOZ_THERD_NUM").charAt(rs.getString("OBOZ_THERD_NUM").length()-1) == '0') &&
		    (rs.getString("OBOZ_THERD_NUM").charAt(rs.getString("OBOZ_THERD_NUM").length()-2) == '0') &&	
		    (rs.getString("OBOZ_THERD_NUM").charAt(rs.getString("OBOZ_THERD_NUM").length()-3) == '0'))
				out+=("<A HREF = \"index.jsp?SelectedItem=" + rs.getString("OBOZNACHENIE") + "\">" + rs.getString("OBOZNACHENIE") + "</a>");
		    else
				out+=(rs.getString("OBOZNACHENIE"));		
	  out+=("</td>");	
  //  out+=("<td>" +(rs.getString(1) ==null? "__" : rs.getString(1)) +"</td>");

	  out+=("<td>");		  
	  String URL="";
		if(TrustedUsers.contains(rs.getString("FULLNAME")) | full_access == true){
			URL = "edit.jsp?";			
			//??? косячил ??? ??? OBOZNACHENIE & SelectedItem ???
			if(rs.getString("OBOZNACHENIE") != null && !rs.getString("OBOZNACHENIE").equals(null))
			URL += "SelectedItem=" + URLEncoder.encode(SelectedItem,"windows-1251");			
			if(rs.getString("GENERAL_ID") != null || !rs.getString("GENERAL_ID").equals(null) )
			URL += "&ID=" + URLEncoder.encode(new String(rs.getString("GENERAL_ID").getBytes("windows-1251")),"windows-1251");			
			if(rs.getString("OBOZNACHENIE") != null && !rs.getString("OBOZNACHENIE").equals(null))
			URL += "&NEWOBOZ=" + URLEncoder.encode(new String(rs.getString("OBOZNACHENIE").getBytes("windows-1251")),"windows-1251");			
			if(rs.getString("NAIMENOVANIE") != null && !rs.getString("NAIMENOVANIE").equals(null))
			URL += "&NAIM=" + URLEncoder.encode(new String(rs.getString("NAIMENOVANIE").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("PRIMENAETSA") != null && !rs.getString("PRIMENAETSA").equals(null))
			URL += "&VHODIMOST=" + URLEncoder.encode(new String(rs.getString("PRIMENAETSA").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("UZ_COUNT") != null && !rs.getString("UZ_COUNT").equals(null))
			URL += "&UZ_COUNT=" + URLEncoder.encode(new String(rs.getString("UZ_COUNT").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("M_COUNT") != null && !rs.getString("M_COUNT").equals(null))
			URL += "&M_COUNT=" + URLEncoder.encode(new String(rs.getString("M_COUNT").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("STATUS") != null && !rs.getString("STATUS").equals(null))
			URL += "&STATUS=" + URLEncoder.encode(new String(rs.getString("STATUS").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("FULLNAME") != null && !rs.getString("FULLNAME").equals(null))
			URL += "&NEWFULLNAME=" + URLEncoder.encode(new String(rs.getString("FULLNAME").getBytes("windows-1251")),"windows-1251");			
			if(rs.getString("acad_fullname") != null && !rs.getString("acad_fullname").equals(null))
			URL += "&ACADNEWFULLNAME=" + URLEncoder.encode(new String(rs.getString("acad_fullname").getBytes("windows-1251")),"windows-1251");			
			if(rs.getString("MASS") != null && !rs.getString("MASS").equals(null))
			URL += "&MASS=" + URLEncoder.encode(new String(rs.getString("MASS").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("FORMAT") != null && !rs.getString("FORMAT").equals(null))
			URL += "&FORMAT=" + URLEncoder.encode(new String(rs.getString("FORMAT").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("MATERIAL") != null && !rs.getString("MATERIAL").equals(null))
			URL += "&MATERIAL=" + URLEncoder.encode(new String(rs.getString("MATERIAL").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("A1_COUNT") != null && !rs.getString("A1_COUNT").equals(null))
			URL += "&A1_COUNT=" + URLEncoder.encode(new String(rs.getString("A1_COUNT").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("A4_COUNT") != null && !rs.getString("A4_COUNT").equals(null))
			URL += "&A4_COUNT=" + URLEncoder.encode(new String(rs.getString("A4_COUNT").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("AUTOCAD") != null && !rs.getString("AUTOCAD").equals(null))
			URL += "&AUTOCAD=" + URLEncoder.encode(new String(rs.getString("AUTOCAD").getBytes("windows-1251")),"windows-1251");			
			//??? косячил ???
			if(rs.getString("PROE") != null && !rs.getString("PROE").equals(null))
			URL += "&PROE=" + URLEncoder.encode(new String (rs.getString("PROE").getBytes("windows-1251")),"windows-1251");
			if(rs.getString("NOTE") != null && !rs.getString("NOTE").equals(null))
			URL += "&Note=" + URLEncoder.encode(new String(rs.getString("NOTE").getBytes("windows-1251")),"windows-1251");
			System.out.println("ERROR vvator");
			out+=("<a href='" + URL + "'><img src='images/edit.png' border='0' width='24' height='24' title='Редактирование'></a>");
			out+=("<a href='Delete.jsp?SelectedItem=" + SelectedItem + "&OBOZ=" + rs.getString("OBOZNACHENIE") + "'><img src='images/delete.png' border='0' width='24' height='24' title='Удаление'></a>");
			out+=("<img onClick=\"show_history('" + rs.getString("OBOZNACHENIE") + "')\" style='cursor: help;' src='images/history.png' border='0' width='24' height='24' title='История изменений'>");
		}else{
		}
	  out+=("</td>");	  
	  //out+=("<td>" +(rs.getString(2) ==null? "__" : rs.getString(2)) +"</td>");
	  
	  out+=("<td>" +(rs.getString(3) ==null? "__" : rs.getString(3)) +"</td>");
	  out+=("<td>" +(rs.getString(4) ==null? "__" : rs.getString(4)) +"</td>");
	  out+=("<td>" +(rs.getString(5) ==null? "__" : rs.getString(5)) +"</td>");
	  out+=("<td>" +(rs.getString(6) ==null? "__" : rs.getString(6)) +"</td>");
	  out+=("<td>" +(rs.getString(7) ==null? "__" : rs.getString(7)) +"</td>");
	  out+=("<td>" +(rs.getString(8) ==null? "__" : rs.getString(8)) +"</td>");
	  out+=("<td>" +(rs.getString(9) ==null? "__" : rs.getString(9)) +"</td>");
	  out+=("<td>"+(rs.getString(10)==null? "__" : rs.getString(10))+"</td>");
	  out+=("<td>"+(rs.getString(11)==null? "__" : rs.getString(11))+"</td>");
	  out+=("<td>"+(rs.getString(12)==null? "__" : rs.getString(12))+"</td>");
	  out+=("<td>"+(rs.getString(13)==null? "__" : rs.getString(13))+"</td>");
	  out+=("<td>"+(rs.getString(14)==null? "__" : rs.getString(14))+"</td>");
	  out+=("<td>"+(rs.getString(15)==null? "__" : rs.getString(15))+"</td>");
	  out+=("<td>"+(rs.getString(16)==null? "__" : rs.getString(16))+"</td>");
	  out+=("<td>"+(rs.getString(17)==null? "__" : rs.getString(17))+"</td>");
	  out+=("<td>"+(rs.getString(18)==null? "__" : rs.getString(18))+"</td>");
	  /*out+=("<td>19"+(rs.getString(19)==null? "__" : rs.getString(19))+"</td>");
	  out+=("<td>20"+(rs.getString(20)==null? "__" : rs.getString(20))+"</td>");
	  out+=("<td>21"+(rs.getString(21)==null? "__" : rs.getString(21))+"</td>");
	  out+=("<td>22"+(rs.getString(22)==null? "__" : rs.getString(22))+"</td>");
	  out+=("<td>23"+(rs.getString(23)==null? "__" : rs.getString(23))+"</td>");
 */
	  out+=("</tr>");
}
out+=("</tbody>");		  
out+=("</table>");
		 
		  rs.first();
		  return out;
		}
	
	
	
	//Поиск изделия,узла по обозначению
	public void SearchIzd(String OBOZ) throws Exception{
		  //переменные для разбиаения строки
		  NumGenerate num = new NumGenerate();
	   	  String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
		  String delimiter = " ";
		  String[] temp;
		  //разбитое обозначение
		  String OBOZ_PREFIX = "";
		  String OBOZ_FIRST_NUM = "";
		  String OBOZ_SECOND_NUM = "";
		  String OBOZ_THERD_NUM = "";
		  String OBOZ_POSTFIX = "";
		  temp = ExplodedOBOZ.split(delimiter);
	   	  OBOZ_PREFIX = temp[0];
	   	  OBOZ_FIRST_NUM = temp[1];
	   	  OBOZ_SECOND_NUM = temp[2];
	   	  OBOZ_THERD_NUM = temp[3];
	   	  if(temp.length == 5) OBOZ_POSTFIX = temp[4];
	   	  else OBOZ_POSTFIX = "";
	      	  String sql = "SELECT ID,OBOZ_PREFIX,OBOZ_FIRST_NUM,OBOZ_SECOND_NUM,OBOZ_THERD_NUM,OBOZ_POSTFIX,USER_ID FROM NUM_NUMBERS ";
		  sql = sql + "	WHERE ";
		  sql = sql + "		OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND ";
		  sql = sql + "		OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "' AND ";
		  sql = sql + "		OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "' AND ";
		  sql = sql + "		OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "' AND ";
		  //если есть постфикс то ставим его, если нет то ставим chr(0)
		  if(!OBOZ_POSTFIX.equals("")){
			  sql = sql + "		OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		  } else {
			  sql = sql + "		OBOZ_POSTFIX = chr(0)";			  
		  }
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//Редактировать изделие
	public void EditProduct(String OLDOBOZ, String NEWOBOZ, String NAIM, String ID, String USER) throws Exception{
	  boolean ObozIsFree = false;
	  String OBOZ_FOR_CHECK = "";
	  SQLRequest_1 sql_1 = new SQLRequest_1();
	  sql_1.CheckOBOZ(NEWOBOZ);
	  if(sql_1.rs1.next()){
	    if(sql_1.rs1.getString("OBOZ_PREFIX") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_PREFIX");
	    if(sql_1.rs1.getString("OBOZ_FIRST_NUM") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_FIRST_NUM");
		if(sql_1.rs1.getString("OBOZ_SECOND_NUM") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_SECOND_NUM");
		if(sql_1.rs1.getString("OBOZ_THERD_NUM") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_THERD_NUM");
		if(sql_1.rs1.getString("OBOZ_POSTFIX") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_POSTFIX");
		OBOZ_FOR_CHECK = OBOZ_FOR_CHECK.trim();
		if(OBOZ_FOR_CHECK.equals("")) ObozIsFree = true;
	  }
	  else ObozIsFree = true;//если такого обозначения в базе нет
	  //если обозначение не занято
	  if(OLDOBOZ.equals(NEWOBOZ)) ObozIsFree = true;//? почему true?
	  if(ObozIsFree){	
		//если наименование и обозначение н пустые
		if((!NAIM.equals("")) & (!NEWOBOZ.equals(""))){
		String NAIMENOVANIE_ID = "";
		String OBOZ_PREFIX = "";
		String OBOZ_FIRST_NUM = "";
		String OBOZ_SECOND_NUM = "";
		String OBOZ_THERD_NUM = "";
		String OBOZ_POSTFIX = "";
		//проверяем наименование по справочнику, если его там нет то доабвляем
		sql_1.SearchNaim(NAIM);
		String NAIM_ID= "";
		if (sql_1.rs1.next()){
			 if(sql_1.rs1.getString("ID") != null){
				 NAIM_ID =sql_1.rs1.getString("ID");
			 }
		}
		else {
			 //такого наименования еще нет, добавляем его 
			 String SQL_INSERT_NAIMENOVANIE = "INSERT INTO NUM_NAIMENOVANIE (ID,NAIMENOVANIE) VALUES ((SELECT MAX(ID)+1 FROM NUM_NAIMENOVANIE),'" + NAIM + "')";
			 stmt.setQueryTimeout(QUERY_TIMEOUT);
			 stmt.executeUpdate(SQL_INSERT_NAIMENOVANIE);
		 }
		//переменные для разбиаения строки
	    NumGenerate num = new NumGenerate();
	    String ExplodedOBOZ = num.ExplodeOBOZ(NEWOBOZ); 
	    String delimiter = " ";
		String[] temp;
		//разбитое обозначение
		temp = ExplodedOBOZ.split(delimiter);
	   	OBOZ_PREFIX = temp[0];
	   	OBOZ_FIRST_NUM = temp[1];
	   	OBOZ_SECOND_NUM = temp[2];
	   	OBOZ_THERD_NUM = temp[3];
     	if(temp.length == 5){
     		OBOZ_POSTFIX = temp[4];
     	}
	   	else{
	   		OBOZ_POSTFIX = "";
	   	}
     	String SQL_UPDATE_NUM_NUMBERS = "UPDATE NUM_NUMBERS SET ";
     	SQL_UPDATE_NUM_NUMBERS += " OBOZ_PREFIX = '" + OBOZ_PREFIX + "',";
     	SQL_UPDATE_NUM_NUMBERS += " OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "',";
     	SQL_UPDATE_NUM_NUMBERS += " OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "',";
     	SQL_UPDATE_NUM_NUMBERS += " OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "'";
     	if(OBOZ_POSTFIX != "")
     	 SQL_UPDATE_NUM_NUMBERS += ", OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
     	else
     	 SQL_UPDATE_NUM_NUMBERS += ", OBOZ_POSTFIX = chr(0) ";
     	SQL_UPDATE_NUM_NUMBERS += ", NAIMENOVANIE_ID = (SELECT ID FROM NUM_NAIMENOVANIE WHERE NAIMENOVANIE='" + NAIM + "')";
     	SQL_UPDATE_NUM_NUMBERS += ", USER_ID = (SELECT ID FROM USERS WHERE UPPER(FULLNAME)=UPPER('" + USER + "'))";
     	SQL_UPDATE_NUM_NUMBERS += " WHERE ID = " + ID;
     	stmt.setQueryTimeout(QUERY_TIMEOUT);
     	stmt.executeUpdate(SQL_UPDATE_NUM_NUMBERS);
	   }
	  }
	}
	
	//Ввести новое изделие
	public void InsertIzdelie(String OBOZ, String NAIM, String Login) throws Exception{
	  boolean ObozIsFree = false;
	  String OBOZ_FOR_CHECK = "";
	  SQLRequest_1 sql_1 = new SQLRequest_1();
  	  sql_1.CheckOBOZ(OBOZ);
	  if(sql_1.rs1.next()){
	    if(sql_1.rs1.getString("OBOZ_PREFIX") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_PREFIX");
	    if(sql_1.rs1.getString("OBOZ_FIRST_NUM") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_FIRST_NUM");
		if(sql_1.rs1.getString("OBOZ_SECOND_NUM") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_SECOND_NUM");
		if(sql_1.rs1.getString("OBOZ_THERD_NUM") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_THERD_NUM");
		if(sql_1.rs1.getString("OBOZ_POSTFIX") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_POSTFIX");
		OBOZ_FOR_CHECK = OBOZ_FOR_CHECK.trim();
		if(OBOZ_FOR_CHECK.equals("")) ObozIsFree = true;
 	  }
	  else ObozIsFree = true;
	  //если обозначение не занято
	  if(ObozIsFree){	
		//если наименование и обозначение н пустые
		if((!NAIM.equals("")) & (!OBOZ.equals(""))){
		  //переменные для разбиаения строки
	      NumGenerate num = new NumGenerate();
	   	  String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
	      String delimiter = " ";
		  String[] temp;
		  //разбитое обозначение
		  String OBOZ_PREFIX = "";
		  String OBOZ_FIRST_NUM = "";
		  String OBOZ_SECOND_NUM = "";
		  String OBOZ_THERD_NUM = "";
		  String OBOZ_POSTFIX = "";
		  temp = ExplodedOBOZ.split(delimiter);
	   	  OBOZ_PREFIX = temp[0];
	   	  OBOZ_FIRST_NUM = temp[1];
	   	  OBOZ_SECOND_NUM = temp[2];
	   	  OBOZ_THERD_NUM = temp[3];
	   	  if(temp.length == 5) OBOZ_POSTFIX = temp[4];
	   	  else OBOZ_POSTFIX = "";
		  //смотрим последний ID в таблице Numbers		
		  sql_1.GetLastId();
		  int  ID_int = 0;
		  String ID_str="";
		  //проверяем считаны ли данные
		  if(sql_1.rs1.next()){
			  //если есть последний ID, то увеличиваем на 1
			  if(sql_1.rs1.getString("MAX(ID)") != null)
				 ID_int = Integer.parseInt(sql_1.rs1.getString("MAX(ID)")) + 1;
			  else
				 ID_int = 0;	  
			  ID_str = Integer.toString(ID_int);
		  }
		  else ID_str = "0";
		  //смотрим есть ли уже такое наименование
		  boolean find = true;
		  sql_1.SearchNaim(NAIM);
		  String NAIM_ID= "";
		  if (sql_1.rs1.next()){
			 if(sql_1.rs1.getString("ID") != null) NAIM_ID =sql_1.rs1.getString("ID");
			 else NAIM_ID = "0";
			 find = false;
		  }
		  else {
			 //если наименование новое, то ищем последний ID
			 sql_1.GetLastNaim_Id();
			 int  NID_int = 0;
			 String name;
			 if (sql_1.rs1.next()){
				 if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
				 else name = "0";
			 }
			 else
				 name = "0";
			 NID_int = Integer.parseInt(name)+ 1;
			 NAIM_ID = Integer.toString(NID_int);
		  }
		  //ищем последний id по таблице relation
		  sql_1.GetLastRel_Id();
		  int  RID_int = 0;
		  String RID_str="";
		  if(sql_1.rs1.next()){
			 if(sql_1.rs1.getString("MAX(ID)") != null) RID_int =Integer.parseInt(sql_1.rs1.getString("MAX(ID)")) + 1;
			 else RID_int = 0;
			 RID_str =  Integer.toString( RID_int);
		  }
		  else 
		 	 RID_str = "0";
		  sql_1.GetUserID(Login);
		  String UserID = "";
		  if(sql_1.rs1.next()){
			  if(sql_1.rs1.getString("ID") != null) UserID = sql_1.rs1.getString("ID");
			  else UserID = "-1";
		  }
		  else 
			UserID = "-1";
		  // запрос для таблицы NUMBERS
		  String sql = "INSERT INTO NUM_NUMBERS (ID,OBOZ_PREFIX,OBOZ_FIRST_NUM,OBOZ_SECOND_NUM,OBOZ_THERD_NUM,OBOZ_POSTFIX,NAIMENOVANIE_ID,USER_ID,";
		  sql = sql + " M_COUNT,MASS_ID,FORMAT_ID,A1_COUNT,A4_COUNT,AUTOCAD,PROE,PRIMENAETSA,MATERIAL_ID,STATUS_ID,NOTE) VALUES (";
		  sql = sql + "'" + ID_str.toUpperCase() + "','";
		  sql = sql + OBOZ_PREFIX.toUpperCase() +  "','";
		  sql = sql + OBOZ_FIRST_NUM.toUpperCase() +  "','";
		  sql = sql + OBOZ_SECOND_NUM.toUpperCase() +  "','";
		  sql = sql + OBOZ_THERD_NUM.toUpperCase() +  "',";
		  if(!OBOZ_POSTFIX.equals("")){
			  sql = sql + "'" + OBOZ_POSTFIX.toUpperCase() +  "','";
		  }
		  else sql = sql + "chr(0),'";			  
		  sql = sql +  NAIM_ID.toUpperCase() + "','" + UserID.toUpperCase() + "','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','')" ; 
		  // запрос для таблицы NAIMENOVANIE
		  String sql1 ="INSERT INTO NUM_NAIMENOVANIE (ID,NAIMENOVANIE) VALUES (";
		  sql1 = sql1 + "'" + NAIM_ID.toUpperCase() + "','" + NAIM + "')";
		  // запрос для таблицы RELATIONS
		  String sql2 ="INSERT INTO NUM_RELATIONS (ID,PARENT_ID,CHILD_ID,UZ_COUNT,TYPE,PRIM_FOR_ZAIM) VALUES (";
		  sql2 = sql2 + "'" + RID_str.toUpperCase() + "','-1','" + ID_str.toUpperCase() + "','-1',1,'-1')";
		  OC.getCon().setAutoCommit(false);
	      Statement st = OC.getCon().createStatement();
		  boolean error=true;
	      try {
	    	  //Выполняем запрос
	    	  st.setQueryTimeout(QUERY_TIMEOUT);
			  st.executeUpdate(sql); //numbers
			  if (find)st.executeUpdate(sql1); //наименование новое
			  st.executeUpdate(sql2); //relations
			  st.close(); 
		  }
		  catch (Exception e){ 
			  e.printStackTrace(); 
			  error=false;
		  }
		  if (error) OC.getCon().commit();
		  else {
			  OC.getCon().rollback();
		  }
 		}
	  }
	}
	
	//Ввести новый узел
	public void InsertUzel(String OBOZ, String NAIM, String NEWFULLNAME,String IzdelID,
			String UZ_COUNT,String M_COUNT,String MASS,String FORMAT,
			String A1_COUNT,String A4_COUNT,String AUTOCAD,String PROE, String TYPE, String VHODIMOST,String STATUS, String MATERIAL,String Note,String ACADNEWFULLNAME) throws Exception{
		SQLRequest_1 sql_1 = new SQLRequest_1();
		//переменные для разбиаения строки
	    NumGenerate num = new NumGenerate();
	   	String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
	    String delimiter = " ";
		String[] temp;
		//разбитое обозначение
		String OBOZ_PREFIX = "";
		String OBOZ_FIRST_NUM = "";
		String OBOZ_SECOND_NUM = "";
		String OBOZ_THERD_NUM = "";
		String OBOZ_POSTFIX = "";
		String name = "";		
		// вводим деталь либо сборку
	    boolean ObozIsFree = false;
	    String OBOZ_FOR_CHECK = "";   
	    sql_1.CheckOBOZ(OBOZ);
	    if(sql_1.rs1.next()){
		    if(sql_1.rs1.getString("OBOZ_PREFIX") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_PREFIX");
		    if(sql_1.rs1.getString("OBOZ_FIRST_NUM") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_FIRST_NUM");
		    if(sql_1.rs1.getString("OBOZ_SECOND_NUM") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_SECOND_NUM");
		    if(sql_1.rs1.getString("OBOZ_THERD_NUM") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_THERD_NUM");
		    if(sql_1.rs1.getString("OBOZ_POSTFIX") != null) OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_POSTFIX");
		    OBOZ_FOR_CHECK = OBOZ_FOR_CHECK.trim();
		    if(OBOZ_FOR_CHECK.equals("")) ObozIsFree = true;
	    }
	    else ObozIsFree = true;
	    //если обозначение не занято
	    if(ObozIsFree){	
	    	//если наименование и обозначение не пустые
	    	if((!NAIM.equals("")) & (!OBOZ.equals("")) & (!VHODIMOST.equals(""))){	 
	    		//разбитое обозначение
	    		temp = ExplodedOBOZ.split(delimiter);
	    		OBOZ_PREFIX = temp[0];
	    		OBOZ_FIRST_NUM = temp[1];
	    		OBOZ_SECOND_NUM = temp[2];
	    		OBOZ_THERD_NUM = temp[3];
	    		if(temp.length == 5) OBOZ_POSTFIX = temp[4];
	    		else OBOZ_POSTFIX = "";
	    		//смотрим последний ID в таблице Numbers
	    		sql_1.GetLastId();
	    		int  ID_int = 0;
	    		String ID_str="";
	    		if (sql_1.rs1.next()){
	    			//если есть последний ID, то увеличиваем не 1
	    			if(sql_1.rs1.getString("MAX(ID)") != null) ID_int =Integer.parseInt(sql_1.rs1.getString("MAX(ID)")) + 1;
	    			else ID_int = 0;
	    			ID_str =  Integer.toString(ID_int);
	    		}
	    		else ID_str = "0";
	    		//смотрим есть ли уже такое наименование
	    		boolean find = true;
	    		sql_1.SearchNaim(NAIM);
	    		String NAIM_ID= "";
	    		if (sql_1.rs1.next()){
	    			if(sql_1.rs1.getString("ID") != null) NAIM_ID =sql_1.rs1.getString("ID");
	    			else NAIM_ID = "0";
	    			find = false;
	    		}
	    		else {
	    			//если наименование новое, то ищем последний ID
	    			sql_1.GetLastNaim_Id();
	    			int  NID_int = 0;
	    			if (sql_1.rs1.next()){
	    				if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
	    				else name = "0";
	    			}
			 else
				 name = "0";
			 NID_int = Integer.parseInt(name)+ 1;
			 NAIM_ID = Integer.toString(NID_int);
		  }
		 //ищем последний id по таблице relation
		 sql_1.GetLastRel_Id();
		 int  RID_int = 0;
		 String RID_str="";
		 if (sql_1.rs1.next()){
			 if(sql_1.rs1.getString("MAX(ID)") != null) RID_int =Integer.parseInt(sql_1.rs1.getString("MAX(ID)")) + 1;
			 else RID_int = 0;
			 RID_str =  Integer.toString( RID_int);
		}else 
			RID_str = "0";
		 //получаем ID пользователя по лонину
		 sql_1.GetUserID(NEWFULLNAME);
		 String UserID = "";
		 if (sql_1.rs1.next()){
			 if(sql_1.rs1.getString("ID") != null) UserID = sql_1.rs1.getString("ID");
			 else UserID = "-1";
		}else 
			UserID = "-1";
		 //смотрим есть ли уже такое значение массы
		 boolean findM = false;
		 String MASS_ID = "-1";
		 if(!MASS.equals("")){
		  sql_1.SearchMass(MASS);
		  MASS_ID= "-1";
		  if (sql_1.rs1.next()){
			 if(sql_1.rs1.getString("ID") != null) MASS_ID = sql_1.rs1.getString("ID");
			 else MASS_ID = "-1";
		  }
		  if(MASS_ID.equals("-1")) {
			findM = true;
			//если значение новое, то ищем последний ID
			sql_1.GetLastMass_Id();
			int MASSID_int = -1;
			name= "-1";
			if(sql_1.rs1.next()){
			 if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
			 else name = "-1";
			}
			else MASS_ID = "-1";
			MASSID_int =Integer.parseInt(name) + 1;
		 	MASS_ID =  Integer.toString(MASSID_int);
		  }
		 }
		 //смотрим есть ли уже такое значение материала
		 boolean findMATERIAL = false;
		 String MATERIAL_ID = "-1";
		 if(!MATERIAL.equals("")){
		  sql_1.SearchMaterial(MATERIAL);
		  MATERIAL_ID= "-1";
		  if (sql_1.rs1.next()){
			 if(sql_1.rs1.getString("ID") != null) MATERIAL_ID = sql_1.rs1.getString("ID");
			 else MATERIAL_ID = "-1";
		  }
		  if(MATERIAL_ID.equals("-1")) {
			findMATERIAL = true;
			//если значение новое, то ищем последний ID
			sql_1.GetLastMaterial_Id();
			int MATERIALID_int = -1;
			name= "-1";
			if(sql_1.rs1.next()){
			 if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
			 else name = "-1";
			}
			else MATERIAL_ID = "-1";
			MATERIALID_int =Integer.parseInt(name) + 1;
		 	MATERIAL_ID =  Integer.toString(MATERIALID_int);
		  }
		 }
		 //смотрим есть ли уже такое значение статуса
		 boolean findSTATUS = false;
		 String STATUS_ID = "-1";
		 if(!STATUS.equals("")){
		  sql_1.SearchStatus(STATUS);
		  STATUS_ID= "-1";
		  if (sql_1.rs1.next()){
			 if(sql_1.rs1.getString("ID") != null) STATUS_ID = sql_1.rs1.getString("ID");
			 else STATUS_ID = "-1";
		  }
		  if(STATUS_ID.equals("-1")) {
			findSTATUS = true;
			//если значение новое, то ищем последний ID
			sql_1.GetLastStatus_Id();
			int STATUSID_int = -1;
			name= "-1";
			if(sql_1.rs1.next()){
			 if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
			 else name = "-1";
			}
			else STATUS_ID = "-1";
			STATUSID_int =Integer.parseInt(name) + 1;
		 	STATUS_ID =  Integer.toString(STATUSID_int);
		  }
		 }
		 //смотрим есть ли уже такое значение формата
		 boolean findF = false;
		 String FORMAT_ID= "-1";
		 if(!FORMAT.equals("")){
		  sql_1.SearchFormat(FORMAT);
		  if (sql_1.rs1.next()){
			 if(sql_1.rs1.getString("ID") != null) FORMAT_ID = sql_1.rs1.getString("ID");
			 else FORMAT_ID = "-1";
		  }
		  else {
			findF = true;
			//если значение новое, то ищем последний ID
			sql_1.GetLastFormat_Id();
			int  FORMATID_int = -1;
			name = "-1";
			if(sql_1.rs1.next()){
			  if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
			  else name = "-1";
			}
			else FORMAT_ID = "-1";
			FORMATID_int =Integer.parseInt(name) + 1;
			FORMAT_ID =  Integer.toString(FORMATID_int);	
		  }
		 }
		 String AcadUserID="-1"; 
		 sql_1.GetUserID(ACADNEWFULLNAME);
			if(sql_1.rs1.next()){
				AcadUserID=sql_1.rs1.getString("ID");
			}
		 // запрос для таблицы NUMBERS
		 String sql = "INSERT INTO NUM_NUMBERS (ID,OBOZ_PREFIX,OBOZ_FIRST_NUM,OBOZ_SECOND_NUM,OBOZ_THERD_NUM,OBOZ_POSTFIX,NAIMENOVANIE_ID,USER_ID,STATUS_ID,MATERIAL_ID,";
		 sql = sql + " M_COUNT,MASS_ID,FORMAT_ID,A1_COUNT,A4_COUNT,AUTOCAD,PROE,PRIMENAETSA,NOTE,AUTOCAD_USER_ID) VALUES (";
		 sql = sql + "'" + ID_str.toUpperCase() + "','";
		 sql = sql + OBOZ_PREFIX.toUpperCase() +  "','";
		 sql = sql + OBOZ_FIRST_NUM.toUpperCase() +  "','";
		 sql = sql + OBOZ_SECOND_NUM.toUpperCase() +  "','";
		 sql = sql + OBOZ_THERD_NUM.toUpperCase() +  "',";
		 if(!OBOZ_POSTFIX.equals("")){
			  sql = sql + "'" + OBOZ_POSTFIX.toUpperCase() +  "','";
		 }
		 else sql = sql + "chr(0),'";		
		 sql = sql + NAIM_ID.toUpperCase() + "','" + UserID.toUpperCase() + "',";
		 sql = sql + STATUS_ID.toUpperCase() + ",";
		 sql = sql + MATERIAL_ID.toUpperCase() + ",";
		 sql = sql + M_COUNT.toUpperCase() + ",";
		 sql = sql + MASS_ID.toUpperCase() + "," + FORMAT_ID.toUpperCase() + ",'";
		 sql = sql + A1_COUNT.toUpperCase() + "','" + A4_COUNT.toUpperCase() + "','";
		 sql = sql + AUTOCAD + "','" + PROE + "','" + VHODIMOST.toUpperCase() + "','" + Note + "',"+AcadUserID+")";
		 // запрос для таблицы NAIMENOVANIE
		 String sql1 ="INSERT INTO NUM_NAIMENOVANIE (ID,NAIMENOVANIE) VALUES (";
		 sql1 = sql1 + "'" + NAIM_ID.toUpperCase() + "','" + NAIM + "')";
		 // запрос для таблицы RELATIONS
		 String sql2 ="INSERT INTO NUM_RELATIONS (ID,PARENT_ID,CHILD_ID,UZ_COUNT,TYPE,PRIM_FOR_ZAIM) VALUES (";
		 sql2 = sql2 + "'" + RID_str.toUpperCase() + "','" +IzdelID.toUpperCase() + "','" + ID_str.toUpperCase() + "','" + UZ_COUNT.toUpperCase()+ "','" + TYPE.toUpperCase() + "','-1')";
		 //запрос для таблицы MASS
		 String sql3 ="INSERT INTO NUM_MASS (ID,MASS) VALUES (";
		 sql3 = sql3 + "'" + MASS_ID.toUpperCase() + "','" + MASS.toUpperCase() + "')";
		 //запрос для таблицы NUM_MATERIAL
		 String sql5 ="INSERT INTO NUM_MATERIAL (ID,MATERIAL) VALUES (";
		 sql5 = sql5 + "'" + MATERIAL_ID.toUpperCase() + "','" + MATERIAL + "')";
		 //запрос для таблицы FORMAT
		 String sql4 ="INSERT INTO NUM_FORMAT (ID,FORMAT) VALUES (";
		 sql4 = sql4 + "'" + FORMAT_ID.toUpperCase() + "','" + FORMAT.toUpperCase() + "')";
		 //создаем переменный для выполнения запросов
		 OC.getCon().setAutoCommit(false);
	     Statement st = OC.getCon().createStatement();
		 boolean error=true;
	     try {
	    	  //Выполняем запрос
	    	  st.setQueryTimeout(QUERY_TIMEOUT);
	    	  st.executeUpdate(sql);//NUMBERS
			  
			  st.executeUpdate(sql2); //RELATIONS
			  if (find)  st.executeUpdate(sql1); //наименование новое
			  if (findM) st.executeUpdate(sql3); //масса новая
			  if (findMATERIAL) st.executeUpdate(sql5); //материал новый
			  if (findF) st.executeUpdate(sql4); //формат новый	  
			  st.close(); 
		 }
		 catch (Exception e){ 
			  e.printStackTrace(); 
			  error=false;
		 }
		 if (error){
			 OC.getCon().commit();
		 }
		 else OC.getCon().rollback();
		}
	   } 
	}
	
	//изменение узла
	public void EditRecord(String ID,String OBOZ, String NAIM, String NEWFULLNAME,String IzdelID,
			String UZ_COUNT,String M_COUNT,String MASS,String FORMAT,
			String A1_COUNT,String A4_COUNT,String AUTOCAD,String PROE, String TYPE,String VHODIMOST,String PRIM_FOR_ZAIM,
			String STATUS,String MATERIAL,String Note,String ACADNEWFULLNAME) throws Exception{
		String name;
		SQLRequest_1 sql_1 = new SQLRequest_1();
		if((!NAIM.equals("")) & (!OBOZ.equals("")) & (!VHODIMOST.equals(""))){
		  //переменные для разбиаения строки
		  NumGenerate num = new NumGenerate();
		  String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
		  String delimiter = " ";
		  String[] temp;
		  //разбитое обозначение
		  String OBOZ_PREFIX = "";
		  String OBOZ_FIRST_NUM = "";
		  String OBOZ_SECOND_NUM = "";
		  String OBOZ_THERD_NUM = "";
		  String OBOZ_POSTFIX = "";
		  temp = ExplodedOBOZ.split(delimiter);
		  OBOZ_PREFIX = temp[0];
		  OBOZ_FIRST_NUM = temp[1];
		  OBOZ_SECOND_NUM = temp[2];
		  OBOZ_THERD_NUM = temp[3];
		  if(temp.length == 5) OBOZ_POSTFIX = temp[4];
		  else OBOZ_POSTFIX = "";
		  //смотрим есть ли уже такое наименование
		  boolean find = true;
		  sql_1.SearchNaim(NAIM);
		  String NAIM_ID= "";
		  if (sql_1.rs1.next()){
		 	 if(sql_1.rs1.getString("ID") != null) NAIM_ID =sql_1.rs1.getString("ID");
			 else NAIM_ID = "0";
			 find = false;
		  }
		  else {
		     //если наименование новое, то ищем последний ID
			 sql_1.GetLastNaim_Id();
			 int  NID_int = 0;
			 if (sql_1.rs1.next()){
				 if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
				 else name = "0";
			 }
			 else
				 name = "0";
			 NID_int = Integer.parseInt(name)+ 1;
			 NAIM_ID = Integer.toString(NID_int);
		   }
		   //смотрим есть ли уже такое значение массы
		   boolean findM = false;
		   String MASS_ID = "-1";
		   if(!MASS.equals("")){
			  sql_1.SearchMass(MASS);
			  MASS_ID= "-1";
			  if (sql_1.rs1.next()){
				 if(sql_1.rs1.getString("ID") != null) MASS_ID = sql_1.rs1.getString("ID");
				 else MASS_ID = "-1";
			  }
			  if(MASS_ID.equals("-1")) {
				findM = true;
				//если значение новое, то ищем последний ID
				sql_1.GetLastMass_Id();
				int MASSID_int = -1;
				name= "-1";
				if(sql_1.rs1.next()){
				 if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
				 else name = "-1";
				}
				else MASS_ID = "-1";
				MASSID_int =Integer.parseInt(name) + 1;
			 	MASS_ID =  Integer.toString(MASSID_int);
			  }
			}
			 //смотрим есть ли уже такое значение материала
			 boolean findMATERIAL = false;
			 String MATERIAL_ID = "-1";
			 if(!MATERIAL.equals("")){
			  sql_1.SearchMaterial(MATERIAL);
			  MATERIAL_ID= "-1";
			  if (sql_1.rs1.next()){
				 if(sql_1.rs1.getString("ID") != null) MATERIAL_ID = sql_1.rs1.getString("ID");
				 else MATERIAL_ID = "-1";
			  }
			  if(MATERIAL_ID.equals("-1")) {
				findMATERIAL = true;
				//если значение новое, то ищем последний ID
				sql_1.GetLastMaterial_Id();
				int MATERIALID_int = -1;
				name= "-1";
				if(sql_1.rs1.next()){
				 if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
				 else name = "-1";
				}
				else MATERIAL_ID = "-1";
				MATERIALID_int =Integer.parseInt(name) + 1;
			 	MATERIAL_ID =  Integer.toString(MATERIALID_int);
			  }
			 }
			 //смотрим есть ли уже такое значение статуса
			 boolean findSTATUS = false;
			 String STATUS_ID = "-1";
			 if(!STATUS.equals("")){
			  sql_1.SearchStatus(STATUS);
			  STATUS_ID= "-1";
			  if (sql_1.rs1.next()){
				 if(sql_1.rs1.getString("ID") != null) STATUS_ID = sql_1.rs1.getString("ID");
				 else STATUS_ID = "-1";
			  }
			  if(STATUS_ID.equals("-1")) {
				findSTATUS = true;
				//если значение новое, то ищем последний ID
				sql_1.GetLastStatus_Id();
				int STATUSID_int = -1;
				name= "-1";
				if(sql_1.rs1.next()){
				 if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
				 else name = "-1";
				}
				else STATUS_ID = "-1";
				STATUSID_int =Integer.parseInt(name) + 1;
			 	STATUS_ID =  Integer.toString(STATUSID_int);
			  }
			 }
			//смотрим есть ли уже такое значение формата
			boolean findF = false;
			String FORMAT_ID= "-1";
			if(!FORMAT.equals("")){
			  sql_1.SearchFormat(FORMAT);
			  if (sql_1.rs1.next()){
				 if(sql_1.rs1.getString("ID") != null) FORMAT_ID = sql_1.rs1.getString("ID");
				 else FORMAT_ID = "-1";
			  }
			  else {
				findF = true;
				//если значение новое, то ищем последний ID
				sql_1.GetLastFormat_Id();
				int  FORMATID_int = -1;
				name = "-1";
				if(sql_1.rs1.next()){
				  if(sql_1.rs1.getString("MAX(ID)") != null) name = sql_1.rs1.getString("MAX(ID)");
				  else name = "-1";
				}
				else FORMAT_ID = "-1";
				FORMATID_int =Integer.parseInt(name) + 1;
				FORMAT_ID =  Integer.toString(FORMATID_int);	
			  }
			}
			//получаем ID пользователя по лонину
			sql_1.GetUserID(NEWFULLNAME);
			String UserID = "-1";
			String AcadUserID="-1";
			if(sql_1.rs1.next()){
				 if(sql_1.rs1.getString("ID") != null){ 
					 UserID = sql_1.rs1.getString("ID");
				 }
			}
			sql_1.GetUserID(ACADNEWFULLNAME);
			if(sql_1.rs1.next()){
				AcadUserID=sql_1.rs1.getString("ID");
			}
			//запрос для изменения записи узла
		    String sql = "UPDATE NUM_NUMBERS SET ";		    
		    sql = sql + "OBOZ_PREFIX = '" + OBOZ_PREFIX.toUpperCase() +  "',";
			sql = sql + "OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM.toUpperCase() +  "',";
			sql = sql + "OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM.toUpperCase() +  "',";
			sql = sql + "OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM.toUpperCase() +  "',";
			 if(!OBOZ_POSTFIX.equals("")){
				 sql = sql + "OBOZ_POSTFIX = '" + OBOZ_POSTFIX.toUpperCase() +  "',";
			  } else sql = sql + "OBOZ_POSTFIX = chr(0),";		
		    sql = sql + "NAIMENOVANIE_ID = " + NAIM_ID.toUpperCase() + "," ;
		    sql = sql + "USER_ID = " + UserID.toUpperCase() + "," ;
		    sql = sql + " M_COUNT = " +  M_COUNT.toUpperCase() + "," ;
		    sql = sql + " MASS_ID = " +  MASS_ID.toUpperCase() + "," ;
		    sql = sql + " STATUS_ID = " +  STATUS_ID.toUpperCase() + "," ;
		    sql = sql + " MATERIAL_ID = " +  MATERIAL_ID.toUpperCase() + "," ;
		    sql = sql + " FORMAT_ID = " +  FORMAT_ID.toUpperCase() + "," ;
		    sql = sql + " A1_COUNT = " +  A1_COUNT.toUpperCase() + "," ;
		    sql = sql + " A4_COUNT = " +  A4_COUNT.toUpperCase() + "," ;
		    sql = sql + " AUTOCAD = '" +  AUTOCAD + "'," ;
		    sql = sql + " PROE = '" +  PROE + "'," ;
		    sql = sql + " PRIMENAETSA = '" +  VHODIMOST + "'," ;
		    sql = sql + " NOTE = '" +  Note + "', " ;
		    sql=sql+" AUTOCAD_USER_ID="+AcadUserID;
		    sql = sql + " WHERE ID = " + ID;
		    String sql1 ="INSERT INTO NUM_NAIMENOVANIE (ID,NAIMENOVANIE) VALUES (";
			sql1 = sql1 + "'" + NAIM_ID.toUpperCase() + "','" + NAIM + "')";
			// запрос для таблицы RELATIONS
			String sql2 ="UPDATE NUM_RELATIONS SET ";
			sql2 = sql2 + " UZ_COUNT = '" + UZ_COUNT.toUpperCase() +  "',";
			sql2 = sql2 + " TYPE = '" +  TYPE + "'" ;
			sql2 = sql2 + " WHERE CHILD_ID = " + ID + " AND PARENT_ID = " + IzdelID;
			//запрос для таблицы MASS
			String sql3 ="INSERT INTO NUM_MASS (ID,MASS) VALUES (";
			sql3 = sql3 + "'" + MASS_ID.toUpperCase() + "','" + MASS.toUpperCase() + "')";
			//запрос для таблицы MASS
			String sql5 ="INSERT INTO NUM_MATERIAL (ID,MATERIAL) VALUES (";
			sql5 = sql5 + "'" + MATERIAL_ID.toUpperCase() + "','" + MATERIAL + "')";
			//запрос для таблицы FORMAT
			String sql4 ="INSERT INTO NUM_FORMAT (ID,FORMAT) VALUES (";
			sql4 = sql4 + "'" + FORMAT_ID.toUpperCase() + "','" + FORMAT.toUpperCase() + "')";
			OC.getCon().setAutoCommit(false);
		    Statement st = OC.getCon().createStatement();
			boolean error=true;
		    try {
		    	  //Выполняем запрос
		    	  st.setQueryTimeout(QUERY_TIMEOUT);
				  st.executeUpdate(sql);//NUMBERS
				  st.executeUpdate(sql2); //RELATIONS
				  if (find){
					  st.executeUpdate(sql1); //наименование новое
				  }
				  if (findM){
					  st.executeUpdate(sql3); //масса новая
				  }
				  if (findMATERIAL){
					  st.executeUpdate(sql5); //материал новый
				  }
				  if (findF){
					  st.executeUpdate(sql4); //формат новый
				  }									  
				  st.close(); 
				  }
			catch (Exception e){ 
				  e.printStackTrace(); 
				  error=false;
				}
				 if (error)
					 OC.getCon().commit();
				 else{
					 OC.getCon().rollback();
				 }
  	  }
	}
	
	
	public void DeleteRecord(String DEL_TYPE, String DEL_OBOZ, String DEL_PARENT_OBOZ) throws Exception{
	 String sql="";
	 String sql_num="";
	 SQLRequest_1 sql_1 = new SQLRequest_1();
	 sql_1.SearchIzd(DEL_OBOZ);
	 sql_1.rs1.next();
	 String UzelID = sql_1.rs1.getString("ID");
	 sql_1.SearchIzd(DEL_PARENT_OBOZ);
	 sql_1.rs1.next();
	 String ParentID = sql_1.rs1.getString("ID");
	 sql= "DELETE FROM NUM_RELATIONS WHERE CHILD_ID = " + UzelID + " AND PARENT_ID = " + ParentID;
	 sql_num = "DELETE FROM  NUM_NUMBERS WHERE ID = " + UzelID;
	 OC.getCon().setAutoCommit(false);
	 Statement st = OC.getCon().createStatement();
	 boolean error=true;
	 try {
	   //Выполняем запрос
	   st.setQueryTimeout(QUERY_TIMEOUT);
	   if (DEL_TYPE.equals("0")){
		   st.executeUpdate(sql);						  
		   st.close(); 
	   }
	   if (DEL_TYPE.equals("1")){
		   st.executeUpdate(sql); 
		   st.executeUpdate(sql_num);  
	   }
		   
	 }
	 catch (Exception e){ 
	   e.printStackTrace(); 
	   error=false;
	 }
	 if (error)
	  OC.getCon().commit();
	 else{
	  OC.getCon().rollback();
	 }
	}
	
	public void InsertStatistic(String Action, String Username, String Naim, String Oboz) throws Exception{
		SQLRequest_1 sql_1 = new SQLRequest_1();
		String ID;
		String sql;
		int iID;
		//берем последний ID
		sql_1.GetLastSTATISTIC_Id();
		if(sql_1.rs1.next()){
			 if(sql_1.rs1.getString("MAX(ID)") != null){
				 ID = sql_1.rs1.getString("MAX(ID)");
				 //если ID не первый увеличиваем его на 1
				 iID = Integer.parseInt(ID);
				 iID++;
				 ID = String.valueOf(iID).toString();
			 }
			 else ID = "0";
		}else 
			ID = "0";
		sql = "INSERT INTO NUM_STATISTIC (ID,ACTION,DATE_OF_ACTION,USERNAME,NAIM,OBOZ) VALUES ";
		sql += "(" + ID + "," + Action + ",SYSDATE,'" + Username + "','" + Naim + "','" + Oboz + "')";
		//добавляем запись
		OC.getCon().setAutoCommit(false);
		Statement st = OC.getCon().createStatement();
		boolean error=true;
		try {
			st.setQueryTimeout(QUERY_TIMEOUT);
			st.executeUpdate(sql);
		}
		catch (Exception e){ 
		   e.printStackTrace(); 
		   error=false;
		}
	    if (error)
		  OC.getCon().commit();
		else{
		  OC.getCon().rollback();
		}
	}
	
	
	
	public String occupied(String oboznachenie) throws SQLException{
		if(Pattern.matches(".*[0-9]{7}.*", oboznachenie)!=true){
			return "<span class='status-nomera'>заполните обозначение...</span>";
		}
			
		String sql="SELECT  Upper(u.fullname) "
				+ " FROM "
				+ "      proeuser.NUM_NUMBERS n "
				+ "       inner join "
				+ "      proeuser.users u "
				+ "       on (n.user_id=u.ID)"
				+ "      where (	trim(n.OBOZ_PREFIX||"
				+ " 		  		n.OBOZ_FIRST_NUM|| "
				+ "   		  		n.OBOZ_SECOND_NUM||"
				+ "   		  		n.OBOZ_THERD_NUM|| "
				+ "    		  		n.OBOZ_POSTFIX)"
				+ "            ) like '"+oboznachenie+"%' ";
			System.out.println(" oboznachenie: "+oboznachenie);
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs=stmt.executeQuery(sql);
		if(rs.next()){
			System.out.println(" Номер уже был использован пользователем: "+rs.getString(1));
			return "<span class='status-nomera-occupaied'>Номер уже был использован пользователем: "+rs.getString(1)+"</span>";
		}
		return "<span class='status-nomera-free'>Номер свободен</span>";
	}
	
	
	
	
	public void InsertUpdate(String FULLNAME, String TYPE, String TEXT) throws Exception{
		SQLRequest_1 sql_1 = new SQLRequest_1();
		String ID = "0";
		int iID = 0;
		//получаем последний ID
		sql_1.GetLastUpdate_Id();
		if(sql_1.rs1.next()){
			 if(sql_1.rs1.getString("MAX(ID)") != null){
				 ID = sql_1.rs1.getString("MAX(ID)");
				 //если ID не первый увеличиваем его на 1
				 iID = Integer.parseInt(ID);
				 iID++;
				 ID = String.valueOf(iID).toString();
			 }
			 else ID = "0";
		}else 
			ID = "0";
		
		Calendar today=Calendar.getInstance();
		Formatter f=new Formatter();
		
		String sql="Insert into NOTE_REPORT(ID,PROGRAM_ID,QUESTION,QUESTION_AUTHOR_ID,QUESTION_DATE,"+
											"ANSWER,ANSWER_AUTHOR_ID,ANSWER_DATE,STATUS_ID,TYPE_ID) "+ 
					"values("+ID+",(Select ID from NOTE_PROGRAM where PROGRAM_NAME like 'Нумератор'), '"+TEXT+"', "+
								  "(Select ID from USERS where FULLNAME like '"+FULLNAME+"'), '"+f.format("%td.%tm.%tY", today,today,today)+"',"+
					"null,null,null,(Select ID from NOTE_STATUS where STATUS like 'Ожидает'),(Select ID from NOTE_TYPE where type LIKE '"+TYPE+"'))";
		
		//выполняем запрос
		OC.getCon().setAutoCommit(false);
		Statement st = OC.getCon().createStatement();
		boolean error=true;
		try {
			st.setQueryTimeout(QUERY_TIMEOUT);
			st.executeUpdate(sql);
		}
		catch (Exception e){ 
		   e.printStackTrace(); 
		   error=false;
		}
	    if (error)
		  OC.getCon().commit();
		else{
		  OC.getCon().rollback();
		}
	    
	}

	//получить данные о файлах пользователя
	public void GetUserFiles(String user) throws Exception{
		String sql="SELECT NUM_NUMBERS.ID, NAIMENOVANIE, "+ 
					"OBOZ_PREFIX || OBOZ_FIRST_NUM || OBOZ_SECOND_NUM || OBOZ_THERD_NUM AS "+ 
					"OBOZ, OBOZ_POSTFIX, LOGIN, FULLNAME, AUTOCAD "+ 
					"FROM NUM_NUMBERS "+
					"INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID "+ 
					"LEFT JOIN NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID "+
					"WHERE USERS.FULLNAME='"+user+"'" +" AND (PRIMENAETSA <> '-1')";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = stmt.executeQuery(sql);
	}
	
	//получить количество файлов пользователя
	public void GetCountUserFiles(String user) throws Exception{
		String sql="SELECT COUNT(AUTOCAD) AS RESULT FROM NUM_NUMBERS";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = stmt.executeQuery(sql);
	}
	
	//обновить путь в num_numbers
	public void UpdateNumNumbersPath(int id, String path) throws Exception{
		String sql="UPDATE NUM_NUMBERS SET AUTOCAD='"+path+"'"+
					"WHERE ID="+id;
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		stmt.executeUpdate(sql);//executeQuery(sql);
	}
	
	//получить путь к autocad файлу
	public void GetAutocadPath(String file_name) throws Exception{
		String sql="SELECT FILEPATH "+
					"FROM PATCH,AUTOCAD "+
					"WHERE AUTOCAD.FILEPATH_ID=PATCH.ID AND "+ 
					"AUTOCAD.FILENAME='"+file_name+"'";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = stmt.executeQuery(sql);
	}

	//получить модели Pro/ENGINEER по логину
	public void GetProeModelsByLogin(String Login) throws Exception{
		String sql="SELECT ";
		sql = sql + "		MODELS.FILENAME,";
		sql = sql + "		PATCH.FILEPATH || '\' || MODELS.FILENAME || '.' || MODELS.FILEEXT AS PROE,";
		sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX ||  NUM_NUMBERS.OBOZ_FIRST_NUM ||  NUM_NUMBERS.OBOZ_SECOND_NUM ||  NUM_NUMBERS.OBOZ_THERD_NUM ||  NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS REPOBOZNACHENIE,"; 
		sql = sql + "		USERS.FULLNAME,";
		sql = sql + "		NUM_NAIMENOVANIE.NAIMENOVANIE,";
		sql = sql + "		NUM_NUMBERS.ID AS UNIQIDENTIFIER, ";
		sql = sql + "		NUM_NUMBERS.PROE AS PROENGINEER ";
		sql = sql + "		FROM";
		sql = sql + "		MODELS";
		sql = sql + "		INNER JOIN PATCH ON PATCH.ID = MODELS.FILEPATH_ID";
		sql = sql + "		INNER JOIN NUM_NUMBERS ON MODELS.RUSNAME = REPLACE((NUM_NUMBERS.OBOZ_PREFIX ||  NUM_NUMBERS.OBOZ_FIRST_NUM ||  NUM_NUMBERS.OBOZ_SECOND_NUM ||  NUM_NUMBERS.OBOZ_THERD_NUM ||  NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'')";
		sql = sql + "		INNER JOIN NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID";
		sql = sql + "		INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID";
		sql = sql + "		WHERE";
		sql = sql + "		NUM_NUMBERS.PRIMENAETSA <> '-1' AND ";
		sql = sql + "		USERS.LOGIN = UPPER('" + Login + "')";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = stmt.executeQuery(sql);
	}

	//получить ерево в обратную сторону
	public void GetBackList (String OBOZNACHENIE) throws Exception{
		  String sql = " SELECT ";
		  sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE, ";  
		  sql = sql + "		LEVEL "; 
		  sql = sql + "		FROM NUM_RELATIONS "; 
		  sql = sql + "		INNER JOIN NUM_NUMBERS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID "; 
		  sql = sql + "		WHERE NUM_NUMBERS.OBOZ_THERD_NUM = '000'";
		  sql = sql + "		CONNECT BY NOCYCLE PRIOR NUM_RELATIONS.PARENT_ID = NUM_RELATIONS.CHILD_ID "; 
		  sql = sql + "		START WITH NUM_RELATIONS.CHILD_ID = ";  
		  sql = sql + "		(SELECT  "; 
		  sql = sql + "		ID  "; 
		  sql = sql + "		FROM  "; 
		  sql = sql + "		NUM_NUMBERS  "; 
		  sql = sql + "		WHERE "; 
		  sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX ||  "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM ||  "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM ||  "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM ||  "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') = '" + OBOZNACHENIE+ "' "; 
		  sql = sql + "		) "; 
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить слежующий уровень крупных сборок
	public void GetNextLevel (String OBOZNACHENIE) throws Exception{
		  String sql = " SELECT ";
		  sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM || ";
		  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE ";  
		  sql = sql + "		FROM NUM_RELATIONS "; 
		  sql = sql + "		INNER JOIN NUM_NUMBERS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID "; 
		  sql = sql + "		WHERE NUM_NUMBERS.OBOZ_THERD_NUM = '000' AND ";
		  sql = sql + "		NUM_RELATIONS.PARENT_ID =  "; 
		  sql = sql + "		(SELECT  "; 
		  sql = sql + "		ID  "; 
		  sql = sql + "		FROM  "; 
		  sql = sql + "		NUM_NUMBERS  "; 
		  sql = sql + "		WHERE "; 
		  sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX ||  "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM ||  "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM ||  "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM ||  "; 
		  sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') = '" + OBOZNACHENIE + "' "; 
		  sql = sql + "		) "; 
		  sql = sql + "		ORDER BY OBOZNACHENIE "; 

		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs = stmt.executeQuery(sql);
		}
	
	//получить модели Pro/ENGINEER по логину
	public void GetTopLevelStatistic(String OBOZ_PREFIX, String OBOZ_FIRST_NUM, String OBOZ_SECOND_NUM, String OBOZ_THERD_NUM, String OBOZ_POSTFIX) throws Exception{
		String sql=" SELECT ";
		sql = sql + "REPLACE(LPAD(' ', (LEVEL - 1) * 4) || OBOZ_PREFIX || OBOZ_FIRST_NUM || OBOZ_SECOND_NUM || OBOZ_THERD_NUM || OBOZ_POSTFIX,CHR(0),'') AS TREE, ";
		sql = sql + "NUM_NAIMENOVANIE.NAIMENOVANIE, ";
		sql = sql + "NUM_STATUS.STATUS, ";
		sql = sql + "NUM_STATUS.COLOR, ";
		sql = sql + "USERS.FULLNAME, ";
		sql = sql + "DEPARTMENT.DEPARTMENT_ABB, ";
		sql = sql + "LEVEL ";
		sql = sql + "FROM NUM_RELATIONS ";
		sql = sql + "INNER JOIN NUM_NUMBERS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID  ";
		sql = sql + "INNER JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID  ";
		sql = sql + "INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID  ";
		sql = sql + "INNER JOIN DEPARTMENT ON USERS.DEPARTMENT_ID = DEPARTMENT.ID  ";
		sql = sql + "LEFT JOIN  NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID  ";
		sql = sql + "CONNECT BY NOCYCLE PRIOR NUM_RELATIONS.CHILD_ID = NUM_RELATIONS.PARENT_ID  ";
		sql = sql + "START WITH NUM_RELATIONS.PARENT_ID =  ";
		sql = sql + "(SELECT ID FROM NUM_NUMBERS WHERE OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "' AND OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "' AND OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "'";
		if(OBOZ_POSTFIX.isEmpty())
			sql = sql +  " AND OBOZ_POSTFIX=chr(0)) ";
		else
			sql = sql +  " AND OBOZ_POSTFIX='" + OBOZ_POSTFIX  + "') ";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = stmt.executeQuery(sql);
	}
	
	//получить все отделы
	public void GetAllDepartmentSmall() throws Exception{
		String sql="SELECT DEPARTMENT.DEPARTMENT_ABB FROM DEPARTMENT";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = stmt.executeQuery(sql);
	}
	
	//получить левые файлы
	public void GetGOSTorDINoutLib(String type, String fio, String department, String instance) throws Exception{
		String sql=" SELECT ";
		sql += "  PATCH.FILEPATH, ";
		sql += "  MODELS.FILENAME, ";
		sql += "  MODELS.FILEEXT, ";
		sql += "  USERS.FULLNAME, ";
		sql += "  DEPARTMENT.DEPARTMENT_ABB " ;
		sql += "FROM";
		sql += "  MODELS, ";
		sql += "  PATCH, ";
		sql += "  USERS, ";
		sql += "  DEPARTMENT ";
		sql += "WHERE ";
		sql += "  MODELS.FILEPATH_ID = PATCH.ID  AND ";
		sql += "  MODELS.USER_ID = USERS.ID  AND ";
		sql += "  USERS.DEPARTMENT_ID = DEPARTMENT.ID AND";
		sql += "  UPPER(FILENAME) LIKE '%" + type + "%' AND ";
		sql += "  PATCH.FILEPATH NOT LIKE 'M:\\Z_GSKB_Lib\\%' ";
		if(!instance.equals("on"))
			sql += " AND MODELS.FAMILYTABLE <> 1 ";
		if(!fio.equals("Все"))
			sql += " AND FULLNAME = '" + fio + "' ";
		if(!department.equals("Все"))
			sql += " AND DEPARTMENT_ABB = '" + department + "' ";
		sql += "  ORDER BY FILEPATH ";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = stmt.executeQuery(sql);
	}

//-----------------------------------------------------------------------------------------------------------------------------
	public boolean CheckAdmin(String login) throws SQLException{
		String sql="Select ID from USERS,NUM_PERMISSION where USERS.ID=NUM_PERMISSION and USERS.LOGIN like upper('"+login+"')";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs=stmt.executeQuery(sql);
		if(rs.next()){
			return true;
		}
		else{
			return false;
		}
	}
	
	public void GetAllUsers() throws SQLException{
		String sql="Select ID,FULLNAME from USERS where USER_STATUS=1 Order by FULLNAME";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs=stmt.executeQuery(sql);
	}
	
	public void getOboznOwner(String obozn) throws SQLException{
		String sql="Select FULLNAME from USERS,NUM_NUMBERS where USERS.ID=USER_ID and "+
					"OBOZ_PREFIX||OBOZ_FIRST_NUM||OBOZ_SECOND_NUM||OBOZ_THERD_NUM||OBOZ_POSTFIX like upper('"+obozn+"') or "+
					"OBOZ_PREFIX||OBOZ_FIRST_NUM||OBOZ_SECOND_NUM||OBOZ_THERD_NUM||OBOZ_POSTFIX like upper('"+obozn+"')||chr(0)";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs=stmt.executeQuery(sql);
	}
	
	public void addTrustee(int grant_id,int trusted_id) throws SQLException{
		String sql="Insert into NUM_TRUSTEES Select max(ID)+1,"+grant_id+","+trusted_id+" from NUM_TRUSTEES";
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		stmt.executeUpdate(sql);
	}
}
