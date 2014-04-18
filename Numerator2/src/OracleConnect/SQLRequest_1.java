package OracleConnect;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ResourceBundle;

import NumGenerator.NumGenerate;

public class SQLRequest_1 {
	private int QUERY_TIMEOUT = 240;
	public ResultSet rs1 = null;
	private Statement stmt = null;
	//конструктор
	private OracleConnect OC;
	
	public SQLRequest_1() throws Exception{
		ResourceBundle resource = ResourceBundle.getBundle("database");
		String name =resource.getString("name");
		String password =resource.getString("password");
		String serverip =resource.getString("serverip");
		String databasename =resource.getString("databasename");
		String port =resource.getString("port");
		
		OC = new OracleConnect(name,password,serverip,databasename,port);
	 //вызываем метод подключения к базе данных Oracle
	 // OC = new OracleConnect("proeuser","proeuser","plm.gskbgomel.by","SEARCH");
	  //подключить
	  OC.getConnection();
		//Создаем statment (оператор) для выполнения SQL-запроса
	  stmt = OC.getCon().createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	}

	//проверить вернется ли такое обозначение
	public void GetOBOZRelationsCount(String OBOZ) throws Exception{
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
		String sql = "SELECT ";
		sql = sql + "  COUNT(NUM_NUMBERS.ID) AS CNT";
		sql = sql + " FROM";
		sql = sql + "  NUM_RELATIONS, ";
		sql = sql + "  NUM_NUMBERS";
		sql = sql + " WHERE";
		sql = sql + "  NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID AND";
		sql = sql + "  NUM_NUMBERS.OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND";
		sql = sql + "  NUM_NUMBERS.OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "' AND";
		sql = sql + "  NUM_NUMBERS.OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "' AND";
		sql = sql + "  NUM_NUMBERS.OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "' AND";
		//если есть постфикс то ставим его, если нет то ставим chr(0)
		if(!OBOZ_POSTFIX.equals(""))
		 sql = sql + "	OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		else 
		 sql = sql + "	OBOZ_POSTFIX = chr(0)";			  
		//Выполняем запрос
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs1 = stmt.executeQuery(sql);
	}	
	//проверить вернется ли такое обозначение
	public void CheckOBOZ(String OBOZ) throws Exception{
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
		String sql = "SELECT ";
		sql = sql + "		NUM_NUMBERS.OBOZ_PREFIX, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX ";  
		sql = sql + " FROM NUM_NUMBERS ";
		sql = sql + " WHERE ";
		sql = sql + "		OBOZ_PREFIX = '" + OBOZ_PREFIX + "' AND ";
		sql = sql + "		OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM + "' AND ";
		sql = sql + "		OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM + "' AND ";
		sql = sql + "		OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM + "' AND ";
		//если есть постфикс то ставим его, если нет то ставим chr(0)
		if(!OBOZ_POSTFIX.equals(""))
		 sql = sql + "		OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		else 
		 sql = sql + "		OBOZ_POSTFIX = chr(0)";			  
		//Выполняем запрос
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs1 = stmt.executeQuery(sql);
	}
	
	//Получить последний Id из таблицы Relations
	public void GetLOGINID(String LOGIN) throws Exception{
		  String sql = "SELECT ID FROM USERS WHERE LOGIN = UPPER('" + LOGIN + "')";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//Получить последний Id из таблицы Relations
	public void GetLastTRUST_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_TRUSTEES";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//Получить последний Id из таблицы Relations
	public void GetLastUpdate_Id() throws Exception{
	//	  String sql = "SELECT MAX(ID) FROM NUM_UPGRADE";
		String sql = "SELECT MAX(ID) FROM NOTE_REPORT";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//Получить последний Id из таблицы NUM_STATISTIC
	public void GetLastSTATISTIC_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_STATISTIC";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//Получить последний Id из таблицы Numbers
	public void GetLastId() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_NUMBERS";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Получить последний Id из таблицы Naimenovanie
	public void GetLastNaim_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_NAIMENOVANIE";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Поиск наименования в таблице Naimenovanie
	public void GetNaimenovanieIDFromNumNumbers(String ID) throws Exception{
		  String sql = "SELECT NAIMENOVANIE_ID FROM NUM_NUMBERS WHERE ID = " + ID + "";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Поиск наименования в таблице Naimenovanie
	public void SearchNaim(String NAIM) throws Exception{
		  String sql = "SELECT ID FROM NUM_NAIMENOVANIE WHERE UPPER(NAIMENOVANIE) = UPPER('" + NAIM + "')";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Получить последний Id из таблицы Mass
	public void GetLastMass_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_MASS";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Получить последний Id из таблицы NUM_MATERIAL
	public void GetLastMaterial_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_MATERIAL";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Получить последний Id из таблицы NUM_STATUS
	public void GetLastStatus_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_STATUS";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Поиск массы в таблице MASS
	public void SearchMass(String Mass) throws Exception{
		  String sql = "SELECT ID FROM NUM_MASS WHERE UPPER(MASS) =UPPER('" + Mass + "')";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Поиск материалла в таблице NUM_MATERIAL
	public void SearchMaterial(String Material) throws Exception{
		  String sql = "SELECT ID FROM NUM_MATERIAL WHERE UPPER(MATERIAL) =UPPER('" + Material + "')";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//Поиск статуса в таблице NUM_STATUS
	public void SearchStatus(String Status) throws Exception{
		  String sql = "SELECT ID FROM NUM_STATUS WHERE Upper(STATUS) =UPPER('" + Status + "')";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Получить последний Id из таблицы Format
	public void GetLastFormat_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_FORMAT";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Поиск формата в таблице Format
	public void SearchFormat(String Format) throws Exception{
		  String sql = "SELECT ID FROM NUM_FORMAT WHERE UPPER(FORMAT) =UPPER('" + Format + "')";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//Получить последний Id из таблицы Relations
	public void GetLastRel_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_RELATIONS";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
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
		  rs1 = stmt.executeQuery(sql);
		  
		}
	
	//Получить последний Id из таблицы Relations
	public void GetUserID(String NEWFULLNAME) throws Exception{
		  String sql = "SELECT ID FROM USERS WHERE FULLNAME = '" + NEWFULLNAME + "'";
		  //Выполняем запрос
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//Получить последний Id из таблицы Relations
	public void SetProeByID(String ID, String PROE) throws Exception{
		  String sql = "UPDATE NUM_NUMBERS SET PROE = '" + PROE + "' WHERE ID = " + ID;
		  //Выполняем запрос
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
	
	  //отключиться от базы
	public void Disconnect () throws Exception{
	  rs1.close();	
	  stmt.close();
	  OC.Disconnected();
	}
}
