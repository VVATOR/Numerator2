package OracleConnect;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ResourceBundle;

import NumGenerator.NumGenerate;

public class SQLRequest_1 {
	private int QUERY_TIMEOUT = 240;
	public ResultSet rs1 = null;
	private Statement stmt = null;
	//�����������
	private OracleConnect OC;
	
	public SQLRequest_1() throws Exception{
		ResourceBundle resource = ResourceBundle.getBundle("database");
		String name =resource.getString("name");
		String password =resource.getString("password");
		String serverip =resource.getString("serverip");
		String databasename =resource.getString("databasename");
		String port =resource.getString("port");
		
		OC = new OracleConnect(name,password,serverip,databasename,port);
	 //�������� ����� ����������� � ���� ������ Oracle
	 // OC = new OracleConnect("proeuser","proeuser","plm.gskbgomel.by","SEARCH");
	  //����������
	  OC.getConnection();
		//������� statment (��������) ��� ���������� SQL-�������
	  stmt = OC.getCon().createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
	}

	//��������� �������� �� ����� �����������
	public void GetOBOZRelationsCount(String OBOZ) throws Exception{
		//���������� ��� ���������� ������
		NumGenerate num = new NumGenerate();
	   	String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
		String delimiter = " ";
		String[] temp;
		//�������� �����������
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
		//���� ���� �������� �� ������ ���, ���� ��� �� ������ chr(0)
		if(!OBOZ_POSTFIX.equals(""))
		 sql = sql + "	OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		else 
		 sql = sql + "	OBOZ_POSTFIX = chr(0)";			  
		//��������� ������
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs1 = stmt.executeQuery(sql);
	}	
	//��������� �������� �� ����� �����������
	public void CheckOBOZ(String OBOZ) throws Exception{
		//���������� ��� ���������� ������
		NumGenerate num = new NumGenerate();
	   	String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
		String delimiter = " ";
		String[] temp;
		//�������� �����������
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
		//���� ���� �������� �� ������ ���, ���� ��� �� ������ chr(0)
		if(!OBOZ_POSTFIX.equals(""))
		 sql = sql + "		OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		else 
		 sql = sql + "		OBOZ_POSTFIX = chr(0)";			  
		//��������� ������
		stmt.setQueryTimeout(QUERY_TIMEOUT);
		rs1 = stmt.executeQuery(sql);
	}
	
	//�������� ��������� Id �� ������� Relations
	public void GetLOGINID(String LOGIN) throws Exception{
		  String sql = "SELECT ID FROM USERS WHERE LOGIN = UPPER('" + LOGIN + "')";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//�������� ��������� Id �� ������� Relations
	public void GetLastTRUST_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_TRUSTEES";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//�������� ��������� Id �� ������� Relations
	public void GetLastUpdate_Id() throws Exception{
	//	  String sql = "SELECT MAX(ID) FROM NUM_UPGRADE";
		String sql = "SELECT MAX(ID) FROM NOTE_REPORT";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//�������� ��������� Id �� ������� NUM_STATISTIC
	public void GetLastSTATISTIC_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_STATISTIC";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//�������� ��������� Id �� ������� Numbers
	public void GetLastId() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_NUMBERS";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//�������� ��������� Id �� ������� Naimenovanie
	public void GetLastNaim_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_NAIMENOVANIE";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//����� ������������ � ������� Naimenovanie
	public void GetNaimenovanieIDFromNumNumbers(String ID) throws Exception{
		  String sql = "SELECT NAIMENOVANIE_ID FROM NUM_NUMBERS WHERE ID = " + ID + "";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//����� ������������ � ������� Naimenovanie
	public void SearchNaim(String NAIM) throws Exception{
		  String sql = "SELECT ID FROM NUM_NAIMENOVANIE WHERE UPPER(NAIMENOVANIE) = UPPER('" + NAIM + "')";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//�������� ��������� Id �� ������� Mass
	public void GetLastMass_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_MASS";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//�������� ��������� Id �� ������� NUM_MATERIAL
	public void GetLastMaterial_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_MATERIAL";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//�������� ��������� Id �� ������� NUM_STATUS
	public void GetLastStatus_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_STATUS";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//����� ����� � ������� MASS
	public void SearchMass(String Mass) throws Exception{
		  String sql = "SELECT ID FROM NUM_MASS WHERE UPPER(MASS) =UPPER('" + Mass + "')";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//����� ���������� � ������� NUM_MATERIAL
	public void SearchMaterial(String Material) throws Exception{
		  String sql = "SELECT ID FROM NUM_MATERIAL WHERE UPPER(MATERIAL) =UPPER('" + Material + "')";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//����� ������� � ������� NUM_STATUS
	public void SearchStatus(String Status) throws Exception{
		  String sql = "SELECT ID FROM NUM_STATUS WHERE Upper(STATUS) =UPPER('" + Status + "')";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//�������� ��������� Id �� ������� Format
	public void GetLastFormat_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_FORMAT";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//����� ������� � ������� Format
	public void SearchFormat(String Format) throws Exception{
		  String sql = "SELECT ID FROM NUM_FORMAT WHERE UPPER(FORMAT) =UPPER('" + Format + "')";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//�������� ��������� Id �� ������� Relations
	public void GetLastRel_Id() throws Exception{
		  String sql = "SELECT MAX(ID) FROM NUM_RELATIONS";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	//����� �������,���� �� �����������
	public void SearchIzd(String OBOZ) throws Exception{
		  //���������� ��� ���������� ������
		  NumGenerate num = new NumGenerate();
	   	  String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ); 
		  String delimiter = " ";
		  String[] temp;
		  //�������� �����������
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
		  //���� ���� �������� �� ������ ���, ���� ��� �� ������ chr(0)
		  if(!OBOZ_POSTFIX.equals("")){
			  sql = sql + "		OBOZ_POSTFIX = '" + OBOZ_POSTFIX + "'";
		  } else {
			  sql = sql + "		OBOZ_POSTFIX = chr(0)";			  
		  }
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		  
		}
	
	//�������� ��������� Id �� ������� Relations
	public void GetUserID(String NEWFULLNAME) throws Exception{
		  String sql = "SELECT ID FROM USERS WHERE FULLNAME = '" + NEWFULLNAME + "'";
		  //��������� ������
		  stmt.setQueryTimeout(QUERY_TIMEOUT);
		  rs1 = stmt.executeQuery(sql);
		}
	
	//�������� ��������� Id �� ������� Relations
	public void SetProeByID(String ID, String PROE) throws Exception{
		  String sql = "UPDATE NUM_NUMBERS SET PROE = '" + PROE + "' WHERE ID = " + ID;
		  //��������� ������
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
	
	  //����������� �� ����
	public void Disconnect () throws Exception{
	  rs1.close();	
	  stmt.close();
	  OC.Disconnected();
	}
}
