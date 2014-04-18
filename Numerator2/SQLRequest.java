package OracleConnect;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import NumGenerator.NumGenerate;

public class SQLRequest {
	private int QUERY_TIMEOUT = 240;
	public ResultSet rs = null;
	private PreparedStatement prstmt = null;
	// конструктор
	private OracleConnect OC;

	public SQLRequest() throws Exception {
		// вызываем метод подключения к базе данных Oracle
		OC = new OracleConnect("proeuser", "proeuser", "plm.gskbgomel.by",
				"SEARCH");
		// подключить
		OC.getConnection();
		// System.out.println("INFO: Constructor succes");
	}

	// Получить пользователя и его отдел по выбранному логину
	public void Disconnect() throws Exception {
		rs.close();
		prstmt.close();
		OC.Disconnected();
	}

	// Получить все статусы
	public void UpdateStatus(String STATUS_ID, String OBOZ) throws Exception {
		String sql = "UPDATE NUM_NUMBERS SET STATUS_ID= ? WHERE REPLACE((NUM_NUMBERS.OBOZ_PREFIX || NUM_NUMBERS.OBOZ_FIRST_NUM|| NUM_NUMBERS.OBOZ_SECOND_NUM || NUM_NUMBERS.OBOZ_THERD_NUM || NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') = ?";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, STATUS_ID);
		prstmt.setString(2, OBOZ);
		// Выполняем запрос
		// System.out.println("INFO: UpdateStatus - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		prstmt.executeUpdate();
	}

	// Получить все статусы
	public void GetAllStatus() throws Exception {
		String sql = "SELECT STATUS,COLOR FROM NUM_STATUS ORDER BY LIFE_CYCLE";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		// Выполняем запрос
		// System.out.println("INFO: GetAllStatus - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// Получить все статусы
	public void GetAllUpgrade() throws Exception {
		String sql = "SELECT TYPE,TEXT,FULLNAME,ANSWER,FINISH FROM NUM_UPGRADE ORDER BY ID";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		// Выполняем запрос
		// System.out.println("INFO: GetAllUpgrade - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// Получить все статусы
	public void GetStatisticByOboz(String SelectedItem) throws Exception {
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
		sql += "NUM_STATISTIC.OBOZ = ?";
		sql += "ORDER BY NUM_STATISTIC.DATE_OF_ACTION ";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, SelectedItem);
		// Выполняем запрос
		// System.out.println("INFO: GetStatisticByOboz - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// Получить все материалы
	public void GetAllMaterial(String PartOfMaterial) throws Exception {
		String sql = "SELECT MATERIAL FROM NUM_MATERIAL WHERE UPPER(MATERIAL) LIKE UPPER(?)";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, PartOfMaterial + "%");
		// Выполняем запрос
		// //System.out.println("INFO: GetAllMaterial - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить тип по обозначению
	public void GetTypeForOBOZ(String OBOZ) throws Exception {
		// переменные для разбиаения строки
		NumGenerate num = new NumGenerate();
		String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ);
		String delimiter = " ";
		String[] temp;
		// разбитое обозначение
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
		if (temp.length == 5)
			OBOZ_POSTFIX = temp[4];
		else
			OBOZ_POSTFIX = "";
		String sql = "SELECT TYPE FROM NUM_RELATIONS,NUM_NUMBERS WHERE ";
		sql = sql + "		NUM_NUMBERS.ID= NUM_RELATIONS.CHILD_ID AND ";
		sql = sql + "		OBOZ_PREFIX = ? AND ";
		sql = sql + "		OBOZ_FIRST_NUM = ? AND ";
		sql = sql + "		OBOZ_SECOND_NUM = ? AND ";
		sql = sql + "		OBOZ_THERD_NUM = ? ";
		// если есть постфикс то ставим его, если нет то ставим chr(0)
		if (!"".equals(OBOZ_POSTFIX)) {
			sql = sql + "	AND	OBOZ_POSTFIX = ? ";
		} else {
			sql = sql + "	AND	OBOZ_POSTFIX = chr(0)";
		}
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, OBOZ_PREFIX);
		prstmt.setString(2, OBOZ_FIRST_NUM);
		prstmt.setString(3, OBOZ_SECOND_NUM);
		prstmt.setString(4, OBOZ_THERD_NUM);
		if (!"".equals(OBOZ_POSTFIX)) {
			prstmt.setString(5, OBOZ_POSTFIX);
		}
		// Выполняем запрос
		// System.out.println("INFO: GetTypeForOBOZ - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить все дерево по обозначению
	public void GetTreeForOBOZ(String OBOZ) throws Exception {
		// переменные для разбиаения строки
		NumGenerate num = new NumGenerate();
		String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ);
		String delimiter = " ";
		String[] temp;
		// разбитое обозначение
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
		if (temp.length == 5)
			OBOZ_POSTFIX = temp[4];
		else
			OBOZ_POSTFIX = "";
		String sql = " SELECT ";
		sql = sql
				+ "   OBOZ_PREFIX || OBOZ_FIRST_NUM || OBOZ_SECOND_NUM || OBOZ_THERD_NUM || OBOZ_POSTFIX AS TREE, ";
		sql = sql + "   OBOZ_PREFIX, ";
		sql = sql + "   OBOZ_FIRST_NUM, ";
		sql = sql + "   OBOZ_SECOND_NUM, ";
		sql = sql + "   OBOZ_THERD_NUM, ";
		sql = sql + "   OBOZ_POSTFIX, ";
		sql = sql + "	  LEVEL,";
		sql = sql + "	  NUM_NAIMENOVANIE.NAIMENOVANIE, ";
		sql = sql + "	  NUM_NUMBERS.OBOZ_THERD_NUM, 	";
		sql = sql
				+ "	  REPLACE((NUM_NUMBERS.OBOZ_PREFIX || 		NUM_NUMBERS.OBOZ_FIRST_NUM|| 		NUM_NUMBERS.OBOZ_SECOND_NUM || 		NUM_NUMBERS.OBOZ_THERD_NUM || 		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE, ";
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
		sql = sql
				+ " INNER JOIN NUM_NUMBERS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
		sql = sql + " INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID ";
		sql = sql
				+ "INNER JOIN USERS USERS_1 ON NUM_NUMBERS.AUTOCAD_USER_ID=USERS_1.ID ";
		sql = sql
				+ " LEFT JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID ";
		sql = sql
				+ " LEFT JOIN  NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID ";
		sql = sql
				+ " LEFT JOIN  NUM_MASS ON NUM_NUMBERS.MASS_ID = NUM_MASS.ID ";
		sql = sql
				+ " LEFT JOIN  NUM_FORMAT ON NUM_NUMBERS.FORMAT_ID = NUM_FORMAT.ID ";
		sql = sql
				+ " LEFT JOIN  NUM_MATERIAL ON NUM_NUMBERS.MATERIAL_ID = NUM_MATERIAL.ID ";
		sql = sql
				+ " CONNECT BY NOCYCLE PRIOR NUM_RELATIONS.CHILD_ID = NUM_RELATIONS.PARENT_ID ";
		sql = sql + " START WITH NUM_RELATIONS.CHILD_ID = ";
		sql = sql
				+ "  (SELECT ID FROM NUM_NUMBERS WHERE OBOZ_PREFIX = ? AND OBOZ_FIRST_NUM = ? AND OBOZ_SECOND_NUM = ? AND OBOZ_THERD_NUM = ? ";
		// если есть постфикс то ставим его, если нет то ставим chr(0)
		if (!"".equals(OBOZ_POSTFIX)) {
			sql = sql + "	AND	OBOZ_POSTFIX = ?)";
		} else {
			sql = sql + "	AND	OBOZ_POSTFIX = chr(0))";
		}
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, OBOZ_PREFIX);
		prstmt.setString(2, OBOZ_FIRST_NUM);
		prstmt.setString(3, OBOZ_SECOND_NUM);
		prstmt.setString(4, OBOZ_THERD_NUM);
		if (!"".equals(OBOZ_POSTFIX)) {
			prstmt.setString(5, OBOZ_POSTFIX);
		}
		// Выполняем запрос
		// System.out.println("INFO: " + sql);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить пользователя для выбранного обозначения
	public void GetUserForOBOZ(String OBOZ) throws Exception {
		// переменные для разбиаения строки
		NumGenerate num = new NumGenerate();
		String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ);
		String delimiter = " ";
		String[] temp;
		// разбитое обозначение
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
		if (temp.length == 5)
			OBOZ_POSTFIX = temp[4];
		else
			OBOZ_POSTFIX = "";
		String sql = "SELECT USERS.FULLNAME ";
		sql = sql + " FROM ";
		sql = sql + " 	NUM_NUMBERS, ";
		sql = sql + " 	USERS ";
		sql = sql + "	WHERE ";
		sql = sql + "		USERS.ID = NUM_NUMBERS.USER_ID AND";
		sql = sql + "		OBOZ_PREFIX = ? AND ";
		sql = sql + "		OBOZ_FIRST_NUM = ? AND ";
		sql = sql + "		OBOZ_SECOND_NUM = ? AND ";
		sql = sql + "		OBOZ_THERD_NUM = ? AND ";
		// если есть постфикс то ставим его, если нет то ставим chr(0)
		if (!OBOZ_POSTFIX.equals("")) {
			sql = sql + "		OBOZ_POSTFIX = ? ";
		} else {
			sql = sql + "		OBOZ_POSTFIX = chr(0)";
		}
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, OBOZ_PREFIX);
		prstmt.setString(2, OBOZ_FIRST_NUM);
		prstmt.setString(3, OBOZ_SECOND_NUM);
		prstmt.setString(4, OBOZ_THERD_NUM);
		if (!"".equals(OBOZ_POSTFIX)) {
			prstmt.setString(5, OBOZ_POSTFIX);
		}
		// Выполняем запрос
		// System.out.println("INFO: GetUserForOBOZ - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить пользователя для выбранного обозначения
	public void GetA1_A4_Count(String OBOZ) throws Exception {
		// переменные для разбиаения строки
		NumGenerate num = new NumGenerate();
		String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ);
		String delimiter = " ";
		String[] temp;
		// разбитое обозначение
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
		if (temp.length == 5)
			OBOZ_POSTFIX = temp[4];
		else
			OBOZ_POSTFIX = "";
		String sql = "SELECT NUM_NUMBERS.A1_COUNT,NUM_NUMBERS.A4_COUNT ";
		sql = sql + " FROM ";
		sql = sql + " 	NUM_NUMBERS ";
		sql = sql + "	WHERE ";
		sql = sql + "		OBOZ_PREFIX = ? AND ";
		sql = sql + "		OBOZ_FIRST_NUM = ? AND ";
		sql = sql + "		OBOZ_SECOND_NUM = ? AND ";
		sql = sql + "		OBOZ_THERD_NUM = ? AND ";
		// если есть постфикс то ставим его, если нет то ставим chr(0)
		if (!OBOZ_POSTFIX.equals("")) {
			sql = sql + "		OBOZ_POSTFIX = ?";
		} else {
			sql = sql + "		OBOZ_POSTFIX = chr(0)";
		}
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, OBOZ_PREFIX);
		prstmt.setString(2, OBOZ_FIRST_NUM);
		prstmt.setString(3, OBOZ_SECOND_NUM);
		prstmt.setString(4, OBOZ_THERD_NUM);
		if (!"".equals(OBOZ_POSTFIX)) {
			prstmt.setString(5, OBOZ_POSTFIX);
		}
		// Выполняем запрос
		// System.out.println("INFO: GetA1_A4_Count - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// добавить доверенные лица для указанного пользователя
	public void AddTrustesUsers(String GrantedUserLogin,
			String NEWTRUSTEDFULLNAME) throws Exception {
		String GRANT_USER_ID = ""; // ID пользователя добавляющего доверенного
		String TRUSTEES_USER_ID = ""; // ID добавляемого пользователя
		String SQL_INSERT = "";
		// получаем ID пользователя добавляющего доверенного
		SQLRequest_1 sql_1 = new SQLRequest_1();
		sql_1.GetLOGINID(GrantedUserLogin);
		if (sql_1.rs1.next()) {
			if (sql_1.rs1.getString("ID") != null)
				GRANT_USER_ID = sql_1.rs1.getString("ID");
			else
				GRANT_USER_ID = "-1";
		} else
			GRANT_USER_ID = "-1";
		// получаем ID добавляемого пользователя
		sql_1.GetUserID(NEWTRUSTEDFULLNAME);
		if (sql_1.rs1.next()) {
			if (sql_1.rs1.getString("ID") != null)
				TRUSTEES_USER_ID = sql_1.rs1.getString("ID");
			else
				TRUSTEES_USER_ID = "-1";
		} else
			TRUSTEES_USER_ID = "-1";
		// --------------------------
		// смотрим последний ID в таблице NUM_TRUSTEES
		sql_1.GetLastTRUST_Id();
		int ID_int = 0;
		String ID_str = "";
		if (sql_1.rs1.next()) {
			// если есть последний ID, то увеличиваем не 1
			if (sql_1.rs1.getString("MAX(ID)") != null)
				ID_int = Integer.parseInt(sql_1.rs1.getString("MAX(ID)")) + 1;
			else
				ID_int = 0;
			ID_str = Integer.toString(ID_int);
		} else
			ID_str = "0";
		// формируем строку добавления записи
		SQL_INSERT = "INSERT INTO NUM_TRUSTEES (ID,GRANT_USER_ID,TRUSTEES_USER_ID) VALUES ('"
				+ ID_str
				+ "','"
				+ GRANT_USER_ID
				+ "','"
				+ TRUSTEES_USER_ID
				+ "')";
		// выполняем запрос
		OC.getCon().setAutoCommit(false);
		Statement st = OC.getCon().createStatement();
		boolean error = false;
		try {
			// Выполняем запрос
			st.setQueryTimeout(QUERY_TIMEOUT);
			st.executeUpdate(SQL_INSERT);
			// System.out.println("INFO: AddTrustesUsers - Execute SQL");
			st.close();
		} catch (Exception e) {
			e.printStackTrace();
			error = true;
		}
		if (!error)
			OC.getCon().commit();
		else {
			// System.out.println("ERROR: AddTrustesUsers - Error execute SQL");
			OC.getCon().rollback();
		}
	}

	// добавить доверенные лица для указанного пользователя
	public void DeleteTrustesUsers(String GrantedUserLogin,
			String NEWTRUSTEDFULLNAME) throws Exception {
		String GRANT_USER_ID = ""; // ID пользователя добавляющего доверенного
		String TRUSTEES_USER_ID = ""; // ID добавляемого пользователя
		String SQL_DELETE = "";
		// получаем ID пользователя удаляющего доверенного
		SQLRequest_1 sql_1 = new SQLRequest_1();
		sql_1.GetLOGINID(GrantedUserLogin);
		if (sql_1.rs1.next()) {
			if (sql_1.rs1.getString("ID") != null)
				GRANT_USER_ID = sql_1.rs1.getString("ID");
			else
				GRANT_USER_ID = "-1";
		} else
			GRANT_USER_ID = "-1";
		// получаем ID удаляемого пользователя
		sql_1.GetUserID(NEWTRUSTEDFULLNAME);
		if (sql_1.rs1.next()) {
			if (sql_1.rs1.getString("ID") != null)
				TRUSTEES_USER_ID = sql_1.rs1.getString("ID");
			else
				TRUSTEES_USER_ID = "-1";
		} else
			TRUSTEES_USER_ID = "-1";
		// формируем строку удаления записи
		SQL_DELETE = "DELETE FROM NUM_TRUSTEES WHERE GRANT_USER_ID = "
				+ GRANT_USER_ID + " AND TRUSTEES_USER_ID = " + TRUSTEES_USER_ID;
		// выполняем запрос
		OC.getCon().setAutoCommit(false);
		Statement st = OC.getCon().createStatement();
		boolean error = false;
		try {
			// Выполняем запрос
			// System.out.println("INFO: DeleteTrustesUsers - Execute SQL");
			st.setQueryTimeout(QUERY_TIMEOUT);
			st.executeUpdate(SQL_DELETE);
			st.close();
		} catch (Exception e) {
			e.printStackTrace();
			error = true;
		}
		if (!error)
			OC.getCon().commit();
		else {
			// System.out.println("ERROR: DeleteTrustesUsers - Error execute SQL");
			OC.getCon().rollback();
		}
	}

	// получить доверенные лица указанного пользователя
	public void GetAllTrustesUsers(String Login) throws Exception {
		String sql = "SELECT ";
		sql = sql + "  USERS_1.FULLNAME, ";
		sql = sql + "  DEPARTMENT.DEPARTMENT ";
		sql = sql + "FROM ";
		sql = sql + "  PROEUSER.NUM_TRUSTEES, ";
		sql = sql + "  PROEUSER.USERS, ";
		sql = sql + "  PROEUSER.USERS USERS_1, ";
		sql = sql + "  PROEUSER.DEPARTMENT ";
		sql = sql + "WHERE ";
		sql = sql
				+ "  PROEUSER.NUM_TRUSTEES.GRANT_USER_ID = PROEUSER.USERS.ID  AND ";
		sql = sql
				+ "  PROEUSER.NUM_TRUSTEES.TRUSTEES_USER_ID = USERS_1.ID  AND ";
		sql = sql + "  USERS_1.DEPARTMENT_ID = PROEUSER.DEPARTMENT.ID AND ";
		sql = sql + "  USERS.LOGIN = UPPER(?) ";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, Login);
		// Выполняем запрос
		// System.out.println("INFO: GetAllTrustesUsers - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить пользователей доверивших юзеру изменение
	public void GetUsersHaveAcces(String Login) throws Exception {
		String sql = "SELECT ";
		sql = sql + "  USERS_1.FULLNAME, ";
		sql = sql + "  DEPARTMENT.DEPARTMENT ";
		sql = sql + "FROM ";
		sql = sql + "  PROEUSER.NUM_TRUSTEES, ";
		sql = sql + "  PROEUSER.USERS, ";
		sql = sql + "  PROEUSER.USERS USERS_1, ";
		sql = sql + "  PROEUSER.DEPARTMENT ";
		sql = sql + "WHERE ";
		sql = sql
				+ "  PROEUSER.NUM_TRUSTEES.TRUSTEES_USER_ID = PROEUSER.USERS.ID  AND ";
		sql = sql + "  PROEUSER.NUM_TRUSTEES.GRANT_USER_ID = USERS_1.ID AND ";
		sql = sql + "  USERS_1.DEPARTMENT_ID = PROEUSER.DEPARTMENT.ID AND ";
		sql = sql + "  USERS.LOGIN = UPPER(?) ";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, Login);
		// Выполняем запрос
		// System.out.println("INFO: GetUsersHaveAcces - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить все массы
	public void GetAllMass(String PartOfMass) throws Exception {
		String sql = "SELECT MASS FROM NUM_MASS WHERE UPPER(MASS) LIKE UPPER(?) ORDER BY MASS";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, PartOfMass + "%");
		// Выполняем запрос
		// //System.out.println("INFO: GetAllMass - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить все форматы
	public void GetAllFormats(String PartOfFormat) throws Exception {
		String sql = "SELECT DISTINCT NUM_FORMAT.FORMAT FROM NUM_FORMAT WHERE UPPER(FORMAT) LIKE UPPER(?) ORDER BY FORMAT";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, PartOfFormat + "%");
		// Выполняем запрос
		// //System.out.println("INFO: GetAllFormats - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить все ФИО пользователей
	public void GetAllFio(String PartOfFullname) throws Exception {
		String sql = "SELECT DISTINCT USERS.LOGIN, USERS.FULLNAME FROM USERS WHERE UPPER(FULLNAME) LIKE UPPER(?) and USER_STATUS=1 ORDER BY FULLNAME";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, PartOfFullname + "%");

		// Выполняем запрос
		// //System.out.println("INFO: GetAllFio - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить все наименования
	public void GetAllNaimenovanie(String ParnOfNaimenovanie) throws Exception {
		String sql = "SELECT DISTINCT NUM_NAIMENOVANIE.NAIMENOVANIE FROM NUM_NAIMENOVANIE WHERE UPPER(NAIMENOVANIE) LIKE UPPER(?) ORDER BY NAIMENOVANIE ";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, ParnOfNaimenovanie + "%");

		// Выполняем запрос
		// //System.out.println("INFO: GetAllNaimenovanie - Execute SQL");
		// //System.out.println("INFO: " + sql);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить наименование для AJAX
	public void GetNaimenovanieForAjax(String strSearch) throws Exception {
		String sql = "SELECT DISTINCT NUM_NAIMENOVANIE.NAIMENOVANIE FROM NUM_NAIMENOVANIE WHERE UPPER(NUM_NAIMENOVANIE.NAIMENOVANIE) LIKE UPPER(?) ORDER BY NAIMENOVANIE";
		// //System.out.println("INFO: GetAllNaimenovanie - Execute SQL");
		// //System.out.println(sql);
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, strSearch + "%");
		// Выполняем запрос
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить все обозначения
	public void GetAllOboznachenie() throws Exception {
		String sql = "SELECT ";
		sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE ";
		sql = sql + " FROM NUM_NUMBERS";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		// Выполняем запрос
		// System.out.println("INFO: GetAllOboznachenie - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить все обозначения
	public void Search(String SEARCH_OBOZ) throws Exception {
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
		sql = sql
				+ "	  PROEUSER.USERS.DEPARTMENT_ID = PROEUSER.DEPARTMENT.ID  AND ";
		sql = sql + "	  PROEUSER.NUM_NUMBERS.USER_ID = PROEUSER.USERS.ID  AND ";
		sql = sql
				+ "	  PROEUSER.NUM_NUMBERS.NAIMENOVANIE_ID = PROEUSER.NUM_NAIMENOVANIE.ID  AND ";
		sql = sql
				+ "	  PROEUSER.NUM_NUMBERS.STATUS_ID = PROEUSER.NUM_STATUS.ID)";
		sql = sql + "	WHERE FULLOBOZ LIKE ?";
		sql = sql + " ORDER BY FULLOBOZ ";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, "%" + SEARCH_OBOZ.toUpperCase() + "%");
		// Выполняем запрос
		// System.out.println("INFO: Search - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить все обозначения в диапазоне данного обозначения
	public void GetAllOboznachenieFromCurrentOboznachenie(String OBOZ_PREFIX,
			String OBOZ_FIRST_NUM) throws Exception {
		String sql = "SELECT ";
		sql = sql + "		NUM_NUMBERS.OBOZ_PREFIX, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX ";
		sql = sql + " FROM NUM_NUMBERS";
		sql = sql + " WHERE ";
		sql = sql + " NUM_NUMBERS.OBOZ_PREFIX = ? AND";
		sql = sql + " NUM_NUMBERS.OBOZ_FIRST_NUM = ?";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, OBOZ_PREFIX);
		prstmt.setString(2, OBOZ_FIRST_NUM);
		// Выполняем запрос
		// System.out.println("INFO: GetAllOboznachenieFromCurrentOboznachenie - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить ФИО и отдел пользователя по логину
	public void GetUserFioAndDepartmentFromLogin(String Login) throws Exception {
		String sql = "SELECT USERS.LOGIN,USERS.FULLNAME,DEPARTMENT.DEPARTMENT,DEPARTMENT.DEPARTMENT_ABB,";
		sql = sql + " DEPARTMENT.DEPARTMENT_CHIEF FROM USERS,DEPARTMENT";
		sql = sql + " WHERE USERS.DEPARTMENT_ID = DEPARTMENT.ID";
		sql = sql + " AND (UPPER(TRIM(USERS.LOGIN)) = UPPER(?))";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, Login);
		// Выполняем запрос
		// System.out.println("INFO: GetUserFioAndDepartmentFromLogin - Execute SQL");
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить список изделий выбранного пользователя
	public void GetProductList() throws Exception {
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
		sql = sql
				+ "INNER JOIN NUM_RELATIONS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
		sql = sql
				+ "LEFT JOIN NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID ";
		sql = sql + "WHERE ";
		sql = sql + "		NUM_RELATIONS.TYPE = 1 ";
		sql = sql + "ORDER BY ";
		sql = sql + "		NUM_NUMBERS.OBOZ_PREFIX, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX ";
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		// Выполняем запрос
		// System.out.println("INFO: " + sql);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить список узлов выбранного пользователя
	public void GetBigUzList() throws Exception {
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
		sql = sql
				+ " INNER JOIN NUM_RELATIONS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
		sql = sql
				+ " INNER JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID ";
		sql = sql
				+ " INNER JOIN NUM_NUMBERS NUM_NUMBERS_1 ON NUM_NUMBERS_1.ID = NUM_RELATIONS.CHILD_ID ";
		sql = sql
				+ " LEFT JOIN  NUM_MATERIAL ON NUM_NUMBERS.MATERIAL_ID = NUM_MATERIAL.ID ";
		sql = sql
				+ " LEFT JOIN NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID ";
		sql = sql
				+ "	LEFT JOIN  NUM_MASS ON NUM_NUMBERS.MASS_ID = NUM_MASS.ID ";
		sql = sql
				+ "	LEFT JOIN  NUM_FORMAT ON NUM_NUMBERS.FORMAT_ID = NUM_FORMAT.ID ";
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
		// Создаем statment (оператор) для выполнения SQL-запроса
				prstmt = OC.getCon().prepareStatement(sql,
						ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		// Выполняем запрос
		// System.out.println("INFO: GetUzListFromLogin - Execute SQL");
		// System.out.println("INFO: " + sql);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить список узлов выбранного пользователя
	public void GetUzListFromLogin(String Login) throws Exception {
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
		sql = sql
				+ " INNER JOIN NUM_RELATIONS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
		sql = sql
				+ " INNER JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID ";
		sql = sql
				+ " INNER JOIN NUM_NUMBERS NUM_NUMBERS_1 ON NUM_NUMBERS_1.ID = NUM_RELATIONS.CHILD_ID ";
		sql = sql
				+ " LEFT JOIN  NUM_MATERIAL ON NUM_NUMBERS.MATERIAL_ID = NUM_MATERIAL.ID ";
		sql = sql
				+ " LEFT JOIN NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID ";
		sql = sql
				+ "	LEFT JOIN  NUM_MASS ON NUM_NUMBERS.MASS_ID = NUM_MASS.ID ";
		sql = sql
				+ "	LEFT JOIN  NUM_FORMAT ON NUM_NUMBERS.FORMAT_ID = NUM_FORMAT.ID ";
		sql = sql + "WHERE ";
		sql = sql + "		USERS.LOGIN = UPPER(?) AND ";
		sql = sql + "		NUM_RELATIONS.PARENT_ID <> -1 AND ";
		sql = sql + "		NUM_RELATIONS.TYPE = 3 AND ";
		sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM = '000' ";
		sql = sql + "ORDER BY ";
		sql = sql + "		NUM_NUMBERS.OBOZ_PREFIX, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM, ";
		sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX ";
		// Создаем statment (оператор) для выполнения SQL-запроса
				prstmt = OC.getCon().prepareStatement(sql,
						ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				prstmt.setString(1, Login);
		// Выполняем запрос
		// System.out.println("INFO: GetUzListFromLogin - Execute SQL");
		// System.out.println("INFO: " + sql);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить полную информацию по узлам выбранного изделия
	public void GetProductFirstLevel(String OBOZ_PREFIX, String OBOZ_FIRST_NUM,
			String OBOZ_SECOND_NUM, String OBOZ_THERD_NUM, String OBOZ_POSTFIX,
			String TYPE) throws Exception {
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
		sql = sql
				+ "		MATERIAL, NUM_NUMBERS.NOTE,USERS_1.FULLNAME as acad_fullname ";
		sql = sql + "	FROM ";
		sql = sql + "		NUM_NUMBERS ";
		sql = sql
				+ "	INNER JOIN  NUM_RELATIONS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
		sql = sql
				+ "	INNER JOIN  NUM_NUMBERS NUM_NUMBERS_1 ON NUM_RELATIONS.PARENT_ID = NUM_NUMBERS_1.ID ";
		sql = sql + "	INNER JOIN USERS ON  NUM_NUMBERS.USER_ID = USERS.ID ";
		sql = sql
				+ " INNER JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID ";
		sql = sql
				+ " LEFT JOIN  NUM_MATERIAL ON NUM_NUMBERS.MATERIAL_ID = NUM_MATERIAL.ID ";
		sql = sql
				+ "	LEFT JOIN  NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID ";
		sql = sql
				+ "	LEFT JOIN  NUM_MASS ON NUM_NUMBERS.MASS_ID = NUM_MASS.ID ";
		sql = sql
				+ "	LEFT JOIN  NUM_FORMAT ON NUM_NUMBERS.FORMAT_ID = NUM_FORMAT.ID ";
		sql = sql
				+ "INNER JOIN USERS USERS_1 ON NUM_NUMBERS.AUTOCAD_USER_ID=USERS_1.ID ";
		sql = sql + "	WHERE ";
		// sql = sql + "		NUM_RELATIONS.TYPE = " + TYPE + " AND ";
		// sql=sql+" NUM_NUMBERS.AUTOCAD_USER_ID=USERS.ID and ";
		sql = sql + "		NUM_NUMBERS_1.OBOZ_PREFIX = ? AND ";
		sql = sql + "		NUM_NUMBERS_1.OBOZ_FIRST_NUM = ? AND ";
		sql = sql + "		NUM_NUMBERS_1.OBOZ_SECOND_NUM = ? AND ";
		sql = sql + "		NUM_NUMBERS_1.OBOZ_THERD_NUM = ? AND ";
		// если есть постфикс то ставим его, если нет то ставим chr(0)
		if (!OBOZ_POSTFIX.equals("")) {
			sql = sql + "		NUM_NUMBERS_1.OBOZ_POSTFIX = ?";
		} else {
			sql = sql + "		NUM_NUMBERS_1.OBOZ_POSTFIX = chr(0)";
		}
		sql = sql + "		ORDER BY OBOZNACHENIE ";
		// Создаем statment (оператор) для выполнения SQL-запроса
				prstmt = OC.getCon().prepareStatement(sql,
						ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				prstmt.setString(1, OBOZ_PREFIX);
				prstmt.setString(2, OBOZ_FIRST_NUM);
				prstmt.setString(3, OBOZ_SECOND_NUM);
				prstmt.setString(4, OBOZ_THERD_NUM);
				if (!"".equals(OBOZ_POSTFIX)) {
					prstmt.setString(5, OBOZ_POSTFIX);
				}
		// Выполняем запрос
		// System.out.println("INFO: " + sql);
		// System.out.println("GetProductFirstLevel "+sql);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// Поиск изделия,узла по обозначению
	// public void SearchIzd(String OBOZ_PREFIX, String OBOZ_FIRST_NUM, String
	// OBOZ_SECOND_NUM, String OBOZ_THERD_NUM, String OBOZ_POSTFIX) throws
	// Exception{
	public void SearchIzd(String OBOZ) throws Exception {
		// переменные для разбиаения строки
		NumGenerate num = new NumGenerate();
		String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ);
		String delimiter = " ";
		String[] temp;
		// разбитое обозначение
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
		if (temp.length == 5)
			OBOZ_POSTFIX = temp[4];
		else
			OBOZ_POSTFIX = "";
		String sql = "SELECT ID,OBOZ_PREFIX,OBOZ_FIRST_NUM,OBOZ_SECOND_NUM,OBOZ_THERD_NUM,OBOZ_POSTFIX,USER_ID FROM NUM_NUMBERS ";
		sql = sql + "	WHERE ";
		sql = sql + "		OBOZ_PREFIX = ? AND ";
		sql = sql + "		OBOZ_FIRST_NUM =? AND ";
		sql = sql + "		OBOZ_SECOND_NUM = ? AND ";
		sql = sql + "		OBOZ_THERD_NUM = ? AND ";
		// если есть постфикс то ставим его, если нет то ставим chr(0)
		if (!OBOZ_POSTFIX.equals("")) {
			sql = sql + "		OBOZ_POSTFIX = ?";
		} else {
			sql = sql + "		OBOZ_POSTFIX = chr(0)";
		}
		// Создаем statment (оператор) для выполнения SQL-запроса
				prstmt = OC.getCon().prepareStatement(sql,
						ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				prstmt.setString(1, OBOZ_PREFIX);
				prstmt.setString(2, OBOZ_FIRST_NUM);
				prstmt.setString(3, OBOZ_SECOND_NUM);
				prstmt.setString(4, OBOZ_THERD_NUM);
				if (!"".equals(OBOZ_POSTFIX)) {
					prstmt.setString(5, OBOZ_POSTFIX);
				}
		// Выполняем запрос
		// System.out.println("INFO: " + sql);
		System.out.println("SearchIzd " + sql);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// Редактировать изделие
	public void EditProduct(String OLDOBOZ, String NEWOBOZ, String NAIM,
			String ID, String USER) throws Exception {
		boolean ObozIsFree = false;
		String OBOZ_FOR_CHECK = "";
		SQLRequest_1 sql_1 = new SQLRequest_1();
		sql_1.CheckOBOZ(NEWOBOZ);
		if (sql_1.rs1.next()) {
			if (sql_1.rs1.getString("OBOZ_PREFIX") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_PREFIX");
			if (sql_1.rs1.getString("OBOZ_FIRST_NUM") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_FIRST_NUM");
			if (sql_1.rs1.getString("OBOZ_SECOND_NUM") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_SECOND_NUM");
			if (sql_1.rs1.getString("OBOZ_THERD_NUM") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_THERD_NUM");
			if (sql_1.rs1.getString("OBOZ_POSTFIX") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_POSTFIX");
			OBOZ_FOR_CHECK = OBOZ_FOR_CHECK.trim();
			if (OBOZ_FOR_CHECK.equals(""))
				ObozIsFree = true;
		} else
			ObozIsFree = true;// если такого обозначения в базе нет
		// если обозначение не занято
		if (OLDOBOZ.equals(NEWOBOZ))
			ObozIsFree = true;// ? почему true?
		if (ObozIsFree) {
			// если наименование и обозначение н пустые
			if ((!NAIM.equals("")) & (!NEWOBOZ.equals(""))) {
				String NAIMENOVANIE_ID = "";
				String OBOZ_PREFIX = "";
				String OBOZ_FIRST_NUM = "";
				String OBOZ_SECOND_NUM = "";
				String OBOZ_THERD_NUM = "";
				String OBOZ_POSTFIX = "";
				// проверяем наименование по справочнику, если его там нет то
				// доабвляем
				sql_1.SearchNaim(NAIM);
				String NAIM_ID = "";
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("ID") != null) {
						NAIM_ID = sql_1.rs1.getString("ID");
						System.out.println("EditProduct NAIM_ID=" + NAIM_ID);
					}
					/*
					 * else { //такого наименования еще нет, добавляем его
					 * String SQL_INSERT_NAIMENOVANIE =
					 * "INSERT INTO NUM_NAIMENOVANIE (ID,NAIMENOVANIE) VALUES ((SELECT MAX(ID)+1 FROM NUM_NAIMENOVANIE),'"
					 * + NAIM + "')"; /* OC.getCon().setAutoCommit(false);
					 * Statement st = OC.getCon().createStatement(); boolean
					 * error=false; try { //Выполняем запрос
					 * //System.out.println("INFO: EditProduct - Execute SQL");
					 * st.setQueryTimeout(QUERY_TIMEOUT);
					 * st.executeUpdate(SQL_INSERT_NAIMENOVANIE); //NUM_NUMBERS
					 * st.close(); } catch (Exception e){ e.printStackTrace();
					 * error=true; } if (!error) OC.getCon().commit(); else{
					 * OC.getCon().rollback(); }
					 */

					/*
					 * System.out.println("EditProduct sql="+SQL_INSERT_NAIMENOVANIE
					 * ); stmt.setQueryTimeout(QUERY_TIMEOUT);
					 * stmt.executeUpdate(SQL_INSERT_NAIMENOVANIE); }
					 */
				} else {
					// такого наименования еще нет, добавляем его
					String SQL_INSERT_NAIMENOVANIE = "INSERT INTO NUM_NAIMENOVANIE (ID,NAIMENOVANIE) VALUES ((SELECT MAX(ID)+1 FROM NUM_NAIMENOVANIE),'"
							+ NAIM + "')";
					System.out.println("EditProduct sql="
							+ SQL_INSERT_NAIMENOVANIE);
					// Создаем statment (оператор) для выполнения SQL-запроса
					prstmt = OC.getCon().prepareStatement(SQL_INSERT_NAIMENOVANIE,
							ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
					prstmt.setQueryTimeout(QUERY_TIMEOUT);
					prstmt.executeUpdate();
				}
				// переменные для разбиаения строки
				NumGenerate num = new NumGenerate();
				String ExplodedOBOZ = num.ExplodeOBOZ(NEWOBOZ);
				String delimiter = " ";
				String[] temp;
				// разбитое обозначение
				temp = ExplodedOBOZ.split(delimiter);
				OBOZ_PREFIX = temp[0];
				OBOZ_FIRST_NUM = temp[1];
				OBOZ_SECOND_NUM = temp[2];
				OBOZ_THERD_NUM = temp[3];
				if (temp.length == 5) {
					OBOZ_POSTFIX = temp[4];
				} else {
					OBOZ_POSTFIX = "";
				}
				String SQL_UPDATE_NUM_NUMBERS = "UPDATE NUM_NUMBERS SET ";
				SQL_UPDATE_NUM_NUMBERS += " OBOZ_PREFIX = '" + OBOZ_PREFIX
						+ "',";
				SQL_UPDATE_NUM_NUMBERS += " OBOZ_FIRST_NUM = '"
						+ OBOZ_FIRST_NUM + "',";
				SQL_UPDATE_NUM_NUMBERS += " OBOZ_SECOND_NUM = '"
						+ OBOZ_SECOND_NUM + "',";
				SQL_UPDATE_NUM_NUMBERS += " OBOZ_THERD_NUM = '"
						+ OBOZ_THERD_NUM + "'";
				if (OBOZ_POSTFIX != "")
					SQL_UPDATE_NUM_NUMBERS += ", OBOZ_POSTFIX = '"
							+ OBOZ_POSTFIX + "'";
				else
					SQL_UPDATE_NUM_NUMBERS += ", OBOZ_POSTFIX = chr(0) ";
				SQL_UPDATE_NUM_NUMBERS += ", NAIMENOVANIE_ID = (SELECT ID FROM NUM_NAIMENOVANIE WHERE NAIMENOVANIE='"
						+ NAIM + "')";
				SQL_UPDATE_NUM_NUMBERS += ", USER_ID = (SELECT ID FROM USERS WHERE UPPER(FULLNAME)=UPPER('"
						+ USER + "'))";
				SQL_UPDATE_NUM_NUMBERS += " WHERE ID = " + ID;
				// System.out.println("INFO: " + SQL_UPDATE_NUM_NUMBERS);
				/*
				 * OC.getCon().setAutoCommit(false); Statement st =
				 * OC.getCon().createStatement(); boolean error=false; try {
				 * //Выполняем запрос
				 * //System.out.println("INFO: EditProduct - Execute SQL");
				 * st.setQueryTimeout(QUERY_TIMEOUT);
				 * st.executeUpdate(SQL_UPDATE_NUM_NUMBERS); //NUM_NUMBERS
				 * st.close(); } catch (Exception e){ e.printStackTrace();
				 * error=true; } if (!error) OC.getCon().commit(); else{
				 * //System
				 * .out.println("ERROR: EditProduct - Error execute SQL");
				 * OC.getCon().rollback(); }
				 */
				System.out.println("EditProduct sql=" + SQL_UPDATE_NUM_NUMBERS);
				prstmt = OC.getCon().prepareStatement(SQL_UPDATE_NUM_NUMBERS,
						ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
				prstmt.setQueryTimeout(QUERY_TIMEOUT);
				prstmt.executeUpdate();
			}
		}
	}

	// Ввести новое изделие
	public void InsertIzdelie(String OBOZ, String NAIM, String Login)
			throws Exception {
		boolean ObozIsFree = false;
		String OBOZ_FOR_CHECK = "";
		SQLRequest_1 sql_1 = new SQLRequest_1();
		sql_1.CheckOBOZ(OBOZ);
		if (sql_1.rs1.next()) {
			if (sql_1.rs1.getString("OBOZ_PREFIX") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_PREFIX");
			if (sql_1.rs1.getString("OBOZ_FIRST_NUM") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_FIRST_NUM");
			if (sql_1.rs1.getString("OBOZ_SECOND_NUM") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_SECOND_NUM");
			if (sql_1.rs1.getString("OBOZ_THERD_NUM") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_THERD_NUM");
			if (sql_1.rs1.getString("OBOZ_POSTFIX") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_POSTFIX");
			OBOZ_FOR_CHECK = OBOZ_FOR_CHECK.trim();
			if (OBOZ_FOR_CHECK.equals(""))
				ObozIsFree = true;
		} else
			ObozIsFree = true;
		// если обозначение не занято
		if (ObozIsFree) {
			// если наименование и обозначение н пустые
			if ((!NAIM.equals("")) & (!OBOZ.equals(""))) {
				// переменные для разбиаения строки
				NumGenerate num = new NumGenerate();
				String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ);
				String delimiter = " ";
				String[] temp;
				// разбитое обозначение
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
				if (temp.length == 5)
					OBOZ_POSTFIX = temp[4];
				else
					OBOZ_POSTFIX = "";
				// смотрим последний ID в таблице Numbers
				sql_1.GetLastId();
				int ID_int = 0;
				String ID_str = "";
				// проверяем считаны ли данные
				if (sql_1.rs1.next()) {
					// если есть последний ID, то увеличиваем на 1
					if (sql_1.rs1.getString("MAX(ID)") != null)
						ID_int = Integer.parseInt(sql_1.rs1
								.getString("MAX(ID)")) + 1;
					else
						ID_int = 0;
					ID_str = Integer.toString(ID_int);
				} else
					ID_str = "0";
				// смотрим есть ли уже такое наименование
				boolean find = true;
				sql_1.SearchNaim(NAIM);
				String NAIM_ID = "";
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("ID") != null)
						NAIM_ID = sql_1.rs1.getString("ID");
					else
						NAIM_ID = "0";
					find = false;
				} else {
					// если наименование новое, то ищем последний ID
					sql_1.GetLastNaim_Id();
					int NID_int = 0;
					String name;
					if (sql_1.rs1.next()) {
						if (sql_1.rs1.getString("MAX(ID)") != null)
							name = sql_1.rs1.getString("MAX(ID)");
						else
							name = "0";
					} else
						name = "0";
					NID_int = Integer.parseInt(name) + 1;
					NAIM_ID = Integer.toString(NID_int);
				}
				// ищем последний id по таблице relation
				sql_1.GetLastRel_Id();
				int RID_int = 0;
				String RID_str = "";
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("MAX(ID)") != null)
						RID_int = Integer.parseInt(sql_1.rs1
								.getString("MAX(ID)")) + 1;
					else
						RID_int = 0;
					RID_str = Integer.toString(RID_int);
				} else
					RID_str = "0";
				sql_1.GetUserID(Login);
				String UserID = "";
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("ID") != null)
						UserID = sql_1.rs1.getString("ID");
					else
						UserID = "-1";
				} else
					UserID = "-1";
				// запрос для таблицы NUMBERS
				String sql = "INSERT INTO NUM_NUMBERS (ID,OBOZ_PREFIX,OBOZ_FIRST_NUM,OBOZ_SECOND_NUM,OBOZ_THERD_NUM,OBOZ_POSTFIX,NAIMENOVANIE_ID,USER_ID,";
				sql = sql
						+ " M_COUNT,MASS_ID,FORMAT_ID,A1_COUNT,A4_COUNT,AUTOCAD,PROE,PRIMENAETSA,MATERIAL_ID,STATUS_ID,NOTE) VALUES (";
				sql = sql + "'" + ID_str.toUpperCase() + "','";
				sql = sql + OBOZ_PREFIX.toUpperCase() + "','";
				sql = sql + OBOZ_FIRST_NUM.toUpperCase() + "','";
				sql = sql + OBOZ_SECOND_NUM.toUpperCase() + "','";
				sql = sql + OBOZ_THERD_NUM.toUpperCase() + "',";
				if (!OBOZ_POSTFIX.equals("")) {
					sql = sql + "'" + OBOZ_POSTFIX.toUpperCase() + "','";
				} else
					sql = sql + "chr(0),'";
				sql = sql
						+ NAIM_ID.toUpperCase()
						+ "','"
						+ UserID.toUpperCase()
						+ "','-1','-1','-1','-1','-1','-1','-1','-1','-1','-1','')";
				// запрос для таблицы NAIMENOVANIE
				String sql1 = "INSERT INTO NUM_NAIMENOVANIE (ID,NAIMENOVANIE) VALUES (";
				sql1 = sql1 + "'" + NAIM_ID.toUpperCase() + "','" + NAIM + "')";
				// запрос для таблицы RELATIONS
				String sql2 = "INSERT INTO NUM_RELATIONS (ID,PARENT_ID,CHILD_ID,UZ_COUNT,TYPE,PRIM_FOR_ZAIM) VALUES (";
				sql2 = sql2 + "'" + RID_str.toUpperCase() + "','-1','"
						+ ID_str.toUpperCase() + "','-1',1,'-1')";
				OC.getCon().setAutoCommit(false);
				Statement st = OC.getCon().createStatement();
				boolean error = true;
				try {
					// System.out.println("INFO: " + sql);
					// Выполняем запрос
					st.setQueryTimeout(QUERY_TIMEOUT);
					st.executeUpdate(sql); // numbers
					if (find)
						st.executeUpdate(sql1); // наименование новое
					st.executeUpdate(sql2); // relations
					st.close();
				} catch (Exception e) {
					e.printStackTrace();
					error = false;
				}
				if (error)
					OC.getCon().commit();
				else {
					// System.out.println("ERROR: InsertIzdelie - Error execute SQL");
					OC.getCon().rollback();
				}
			}
		}
	}

	// Ввести новый узел
	public void InsertUzel(String OBOZ, String NAIM, String NEWFULLNAME,
			String IzdelID, String UZ_COUNT, String M_COUNT, String MASS,
			String FORMAT, String A1_COUNT, String A4_COUNT, String AUTOCAD,
			String PROE, String TYPE, String VHODIMOST, String STATUS,
			String MATERIAL, String Note, String ACADNEWFULLNAME)
			throws Exception {
		SQLRequest_1 sql_1 = new SQLRequest_1();
		// переменные для разбиаения строки
		NumGenerate num = new NumGenerate();
		String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ);
		String delimiter = " ";
		String[] temp;
		// разбитое обозначение
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
		if (sql_1.rs1.next()) {
			if (sql_1.rs1.getString("OBOZ_PREFIX") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_PREFIX");
			if (sql_1.rs1.getString("OBOZ_FIRST_NUM") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_FIRST_NUM");
			if (sql_1.rs1.getString("OBOZ_SECOND_NUM") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_SECOND_NUM");
			if (sql_1.rs1.getString("OBOZ_THERD_NUM") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_THERD_NUM");
			if (sql_1.rs1.getString("OBOZ_POSTFIX") != null)
				OBOZ_FOR_CHECK += sql_1.rs1.getString("OBOZ_POSTFIX");
			OBOZ_FOR_CHECK = OBOZ_FOR_CHECK.trim();
			if (OBOZ_FOR_CHECK.equals(""))
				ObozIsFree = true;
		} else
			ObozIsFree = true;
		// если обозначение не занято
		if (ObozIsFree) {
			// если наименование и обозначение не пустые
			if ((!NAIM.equals("")) & (!OBOZ.equals(""))
					& (!VHODIMOST.equals(""))) {
				// разбитое обозначение
				temp = ExplodedOBOZ.split(delimiter);
				OBOZ_PREFIX = temp[0];
				OBOZ_FIRST_NUM = temp[1];
				OBOZ_SECOND_NUM = temp[2];
				OBOZ_THERD_NUM = temp[3];
				if (temp.length == 5)
					OBOZ_POSTFIX = temp[4];
				else
					OBOZ_POSTFIX = "";
				// смотрим последний ID в таблице Numbers
				sql_1.GetLastId();
				int ID_int = 0;
				String ID_str = "";
				if (sql_1.rs1.next()) {
					// если есть последний ID, то увеличиваем не 1
					if (sql_1.rs1.getString("MAX(ID)") != null)
						ID_int = Integer.parseInt(sql_1.rs1
								.getString("MAX(ID)")) + 1;
					else
						ID_int = 0;
					ID_str = Integer.toString(ID_int);
				} else
					ID_str = "0";
				// смотрим есть ли уже такое наименование
				boolean find = true;
				sql_1.SearchNaim(NAIM);
				String NAIM_ID = "";
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("ID") != null)
						NAIM_ID = sql_1.rs1.getString("ID");
					else
						NAIM_ID = "0";
					find = false;
				} else {
					// если наименование новое, то ищем последний ID
					sql_1.GetLastNaim_Id();
					int NID_int = 0;
					if (sql_1.rs1.next()) {
						if (sql_1.rs1.getString("MAX(ID)") != null)
							name = sql_1.rs1.getString("MAX(ID)");
						else
							name = "0";
					} else
						name = "0";
					NID_int = Integer.parseInt(name) + 1;
					NAIM_ID = Integer.toString(NID_int);
				}
				// ищем последний id по таблице relation
				sql_1.GetLastRel_Id();
				int RID_int = 0;
				String RID_str = "";
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("MAX(ID)") != null)
						RID_int = Integer.parseInt(sql_1.rs1
								.getString("MAX(ID)")) + 1;
					else
						RID_int = 0;
					RID_str = Integer.toString(RID_int);
				} else
					RID_str = "0";
				// получаем ID пользователя по лонину
				sql_1.GetUserID(NEWFULLNAME);
				String UserID = "";
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("ID") != null)
						UserID = sql_1.rs1.getString("ID");
					else
						UserID = "-1";
				} else
					UserID = "-1";
				// смотрим есть ли уже такое значение массы
				boolean findM = false;
				String MASS_ID = "-1";
				if (!MASS.equals("")) {
					sql_1.SearchMass(MASS);
					MASS_ID = "-1";
					if (sql_1.rs1.next()) {
						if (sql_1.rs1.getString("ID") != null)
							MASS_ID = sql_1.rs1.getString("ID");
						else
							MASS_ID = "-1";
					}
					if (MASS_ID.equals("-1")) {
						findM = true;
						// если значение новое, то ищем последний ID
						sql_1.GetLastMass_Id();
						int MASSID_int = -1;
						name = "-1";
						if (sql_1.rs1.next()) {
							if (sql_1.rs1.getString("MAX(ID)") != null)
								name = sql_1.rs1.getString("MAX(ID)");
							else
								name = "-1";
						} else
							MASS_ID = "-1";
						MASSID_int = Integer.parseInt(name) + 1;
						MASS_ID = Integer.toString(MASSID_int);
					}
				}
				// смотрим есть ли уже такое значение материала
				boolean findMATERIAL = false;
				String MATERIAL_ID = "-1";
				if (!MATERIAL.equals("")) {
					sql_1.SearchMaterial(MATERIAL);
					MATERIAL_ID = "-1";
					if (sql_1.rs1.next()) {
						if (sql_1.rs1.getString("ID") != null)
							MATERIAL_ID = sql_1.rs1.getString("ID");
						else
							MATERIAL_ID = "-1";
					}
					if (MATERIAL_ID.equals("-1")) {
						findMATERIAL = true;
						// если значение новое, то ищем последний ID
						sql_1.GetLastMaterial_Id();
						int MATERIALID_int = -1;
						name = "-1";
						if (sql_1.rs1.next()) {
							if (sql_1.rs1.getString("MAX(ID)") != null)
								name = sql_1.rs1.getString("MAX(ID)");
							else
								name = "-1";
						} else
							MATERIAL_ID = "-1";
						MATERIALID_int = Integer.parseInt(name) + 1;
						MATERIAL_ID = Integer.toString(MATERIALID_int);
					}
				}
				// смотрим есть ли уже такое значение статуса
				boolean findSTATUS = false;
				String STATUS_ID = "-1";
				if (!STATUS.equals("")) {
					sql_1.SearchStatus(STATUS);
					STATUS_ID = "-1";
					if (sql_1.rs1.next()) {
						if (sql_1.rs1.getString("ID") != null)
							STATUS_ID = sql_1.rs1.getString("ID");
						else
							STATUS_ID = "-1";
					}
					if (STATUS_ID.equals("-1")) {
						findSTATUS = true;
						// если значение новое, то ищем последний ID
						sql_1.GetLastStatus_Id();
						int STATUSID_int = -1;
						name = "-1";
						if (sql_1.rs1.next()) {
							if (sql_1.rs1.getString("MAX(ID)") != null)
								name = sql_1.rs1.getString("MAX(ID)");
							else
								name = "-1";
						} else
							STATUS_ID = "-1";
						STATUSID_int = Integer.parseInt(name) + 1;
						STATUS_ID = Integer.toString(STATUSID_int);
					}
				}
				// смотрим есть ли уже такое значение формата
				boolean findF = false;
				String FORMAT_ID = "-1";
				if (!FORMAT.equals("")) {
					sql_1.SearchFormat(FORMAT);
					if (sql_1.rs1.next()) {
						if (sql_1.rs1.getString("ID") != null)
							FORMAT_ID = sql_1.rs1.getString("ID");
						else
							FORMAT_ID = "-1";
					} else {
						findF = true;
						// если значение новое, то ищем последний ID
						sql_1.GetLastFormat_Id();
						int FORMATID_int = -1;
						name = "-1";
						if (sql_1.rs1.next()) {
							if (sql_1.rs1.getString("MAX(ID)") != null)
								name = sql_1.rs1.getString("MAX(ID)");
							else
								name = "-1";
						} else
							FORMAT_ID = "-1";
						FORMATID_int = Integer.parseInt(name) + 1;
						FORMAT_ID = Integer.toString(FORMATID_int);
					}
				}
				String AcadUserID = "-1";
				sql_1.GetUserID(ACADNEWFULLNAME);
				if (sql_1.rs1.next()) {
					AcadUserID = sql_1.rs1.getString("ID");
				}
				// запрос для таблицы NUMBERS
				String sql = "INSERT INTO NUM_NUMBERS (ID,OBOZ_PREFIX,OBOZ_FIRST_NUM,OBOZ_SECOND_NUM,OBOZ_THERD_NUM,OBOZ_POSTFIX,NAIMENOVANIE_ID,USER_ID,STATUS_ID,MATERIAL_ID,";
				sql = sql
						+ " M_COUNT,MASS_ID,FORMAT_ID,A1_COUNT,A4_COUNT,AUTOCAD,PROE,PRIMENAETSA,NOTE,AUTOCAD_USER_ID) VALUES (";
				sql = sql + "'" + ID_str.toUpperCase() + "','";
				sql = sql + OBOZ_PREFIX.toUpperCase() + "','";
				sql = sql + OBOZ_FIRST_NUM.toUpperCase() + "','";
				sql = sql + OBOZ_SECOND_NUM.toUpperCase() + "','";
				sql = sql + OBOZ_THERD_NUM.toUpperCase() + "',";
				if (!OBOZ_POSTFIX.equals("")) {
					sql = sql + "'" + OBOZ_POSTFIX.toUpperCase() + "','";
				} else
					sql = sql + "chr(0),'";
				sql = sql + NAIM_ID.toUpperCase() + "','"
						+ UserID.toUpperCase() + "',";
				sql = sql + STATUS_ID.toUpperCase() + ",";
				sql = sql + MATERIAL_ID.toUpperCase() + ",";
				sql = sql + M_COUNT.toUpperCase() + ",";
				sql = sql + MASS_ID.toUpperCase() + ","
						+ FORMAT_ID.toUpperCase() + ",'";
				sql = sql + A1_COUNT.toUpperCase() + "','"
						+ A4_COUNT.toUpperCase() + "','";
				sql = sql + AUTOCAD + "','" + PROE + "','"
						+ VHODIMOST.toUpperCase() + "','" + Note + "',"
						+ AcadUserID + ")";
				// запрос для таблицы NAIMENOVANIE
				String sql1 = "INSERT INTO NUM_NAIMENOVANIE (ID,NAIMENOVANIE) VALUES (";
				sql1 = sql1 + "'" + NAIM_ID.toUpperCase() + "','" + NAIM + "')";
				// запрос для таблицы RELATIONS
				String sql2 = "INSERT INTO NUM_RELATIONS (ID,PARENT_ID,CHILD_ID,UZ_COUNT,TYPE,PRIM_FOR_ZAIM) VALUES (";
				sql2 = sql2 + "'" + RID_str.toUpperCase() + "','"
						+ IzdelID.toUpperCase() + "','" + ID_str.toUpperCase()
						+ "','" + UZ_COUNT.toUpperCase() + "','"
						+ TYPE.toUpperCase() + "','-1')";
				// запрос для таблицы MASS
				String sql3 = "INSERT INTO NUM_MASS (ID,MASS) VALUES (";
				sql3 = sql3 + "'" + MASS_ID.toUpperCase() + "','"
						+ MASS.toUpperCase() + "')";
				// запрос для таблицы NUM_MATERIAL
				String sql5 = "INSERT INTO NUM_MATERIAL (ID,MATERIAL) VALUES (";
				sql5 = sql5 + "'" + MATERIAL_ID.toUpperCase() + "','"
						+ MATERIAL + "')";
				// запрос для таблицы FORMAT
				String sql4 = "INSERT INTO NUM_FORMAT (ID,FORMAT) VALUES (";
				sql4 = sql4 + "'" + FORMAT_ID.toUpperCase() + "','"
						+ FORMAT.toUpperCase() + "')";
				// System.out.println("INFO: " + sql);
				// System.out.println("INFO: " + sql1);
				// System.out.println("INFO: " + sql2);
				// System.out.println("INFO: " + sql3);
				// System.out.println("INFO: " + sql4);
				// System.out.println("INFO: " + sql5);
				// создаем переменный для выполнения запросов
				OC.getCon().setAutoCommit(false);
				Statement st = OC.getCon().createStatement();
				boolean error = true;
				try {
					// System.out.println("INFO: InsertUzel - Execute SQL");
					// Выполняем запрос
					st.setQueryTimeout(QUERY_TIMEOUT);
					st.executeUpdate(sql);// NUMBERS

					st.executeUpdate(sql2); // RELATIONS
					if (find)
						st.executeUpdate(sql1); // наименование новое
					if (findM)
						st.executeUpdate(sql3); // масса новая
					if (findMATERIAL)
						st.executeUpdate(sql5); // материал новый
					if (findF)
						st.executeUpdate(sql4); // формат новый
					st.close();
				} catch (Exception e) {
					e.printStackTrace();
					error = false;
				}
				if (error) {
					// System.out.println("ERROR: InsertUzel - Error execute SQL");
					OC.getCon().commit();
				} else
					OC.getCon().rollback();
			}
		}
	}

	// изменение узла
	public void EditRecord(String ID, String OBOZ, String NAIM,
			String NEWFULLNAME, String IzdelID, String UZ_COUNT,
			String M_COUNT, String MASS, String FORMAT, String A1_COUNT,
			String A4_COUNT, String AUTOCAD, String PROE, String TYPE,
			String VHODIMOST, String PRIM_FOR_ZAIM, String STATUS,
			String MATERIAL, String Note, String ACADNEWFULLNAME)
			throws Exception {
		// boolean ObozIsFree = false;
		// String OBOZ_FOR_CHECK = "";
		String name;
		SQLRequest_1 sql_1 = new SQLRequest_1();
		if ((!NAIM.equals("")) & (!OBOZ.equals("")) & (!VHODIMOST.equals(""))) {
			// переменные для разбиаения строки
			NumGenerate num = new NumGenerate();
			String ExplodedOBOZ = num.ExplodeOBOZ(OBOZ);
			String delimiter = " ";
			String[] temp;
			// разбитое обозначение
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
			if (temp.length == 5)
				OBOZ_POSTFIX = temp[4];
			else
				OBOZ_POSTFIX = "";
			// смотрим есть ли уже такое наименование
			boolean find = true;
			sql_1.SearchNaim(NAIM);
			String NAIM_ID = "";
			if (sql_1.rs1.next()) {
				if (sql_1.rs1.getString("ID") != null)
					NAIM_ID = sql_1.rs1.getString("ID");
				else
					NAIM_ID = "0";
				find = false;
			} else {
				// если наименование новое, то ищем последний ID
				sql_1.GetLastNaim_Id();
				int NID_int = 0;
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("MAX(ID)") != null)
						name = sql_1.rs1.getString("MAX(ID)");
					else
						name = "0";
				} else
					name = "0";
				NID_int = Integer.parseInt(name) + 1;
				NAIM_ID = Integer.toString(NID_int);
			}
			// смотрим есть ли уже такое значение массы
			boolean findM = false;
			String MASS_ID = "-1";
			if (!MASS.equals("")) {
				sql_1.SearchMass(MASS);
				MASS_ID = "-1";
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("ID") != null)
						MASS_ID = sql_1.rs1.getString("ID");
					else
						MASS_ID = "-1";
				}
				if (MASS_ID.equals("-1")) {
					findM = true;
					// если значение новое, то ищем последний ID
					sql_1.GetLastMass_Id();
					int MASSID_int = -1;
					name = "-1";
					if (sql_1.rs1.next()) {
						if (sql_1.rs1.getString("MAX(ID)") != null)
							name = sql_1.rs1.getString("MAX(ID)");
						else
							name = "-1";
					} else
						MASS_ID = "-1";
					MASSID_int = Integer.parseInt(name) + 1;
					MASS_ID = Integer.toString(MASSID_int);
				}
			}
			// смотрим есть ли уже такое значение материала
			boolean findMATERIAL = false;
			String MATERIAL_ID = "-1";
			if (!MATERIAL.equals("")) {
				sql_1.SearchMaterial(MATERIAL);
				MATERIAL_ID = "-1";
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("ID") != null)
						MATERIAL_ID = sql_1.rs1.getString("ID");
					else
						MATERIAL_ID = "-1";
				}
				if (MATERIAL_ID.equals("-1")) {
					findMATERIAL = true;
					// если значение новое, то ищем последний ID
					sql_1.GetLastMaterial_Id();
					int MATERIALID_int = -1;
					name = "-1";
					if (sql_1.rs1.next()) {
						if (sql_1.rs1.getString("MAX(ID)") != null)
							name = sql_1.rs1.getString("MAX(ID)");
						else
							name = "-1";
					} else
						MATERIAL_ID = "-1";
					MATERIALID_int = Integer.parseInt(name) + 1;
					MATERIAL_ID = Integer.toString(MATERIALID_int);
				}
			}
			// смотрим есть ли уже такое значение статуса
			boolean findSTATUS = false;
			String STATUS_ID = "-1";
			if (!STATUS.equals("")) {
				sql_1.SearchStatus(STATUS);
				STATUS_ID = "-1";
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("ID") != null)
						STATUS_ID = sql_1.rs1.getString("ID");
					else
						STATUS_ID = "-1";
				}
				if (STATUS_ID.equals("-1")) {
					findSTATUS = true;
					// если значение новое, то ищем последний ID
					sql_1.GetLastStatus_Id();
					int STATUSID_int = -1;
					name = "-1";
					if (sql_1.rs1.next()) {
						if (sql_1.rs1.getString("MAX(ID)") != null)
							name = sql_1.rs1.getString("MAX(ID)");
						else
							name = "-1";
					} else
						STATUS_ID = "-1";
					STATUSID_int = Integer.parseInt(name) + 1;
					STATUS_ID = Integer.toString(STATUSID_int);
				}
			}
			// смотрим есть ли уже такое значение формата
			boolean findF = false;
			String FORMAT_ID = "-1";
			if (!FORMAT.equals("")) {
				sql_1.SearchFormat(FORMAT);
				if (sql_1.rs1.next()) {
					if (sql_1.rs1.getString("ID") != null)
						FORMAT_ID = sql_1.rs1.getString("ID");
					else
						FORMAT_ID = "-1";
				} else {
					findF = true;
					// если значение новое, то ищем последний ID
					sql_1.GetLastFormat_Id();
					int FORMATID_int = -1;
					name = "-1";
					if (sql_1.rs1.next()) {
						if (sql_1.rs1.getString("MAX(ID)") != null)
							name = sql_1.rs1.getString("MAX(ID)");
						else
							name = "-1";
					} else
						FORMAT_ID = "-1";
					FORMATID_int = Integer.parseInt(name) + 1;
					FORMAT_ID = Integer.toString(FORMATID_int);
				}
			}
			// получаем ID пользователя по лонину
			sql_1.GetUserID(NEWFULLNAME);
			String UserID = "-1";
			String AcadUserID = "-1";
			if (sql_1.rs1.next()) {
				if (sql_1.rs1.getString("ID") != null) {
					UserID = sql_1.rs1.getString("ID");
				}
			}
			sql_1.GetUserID(ACADNEWFULLNAME);
			if (sql_1.rs1.next()) {
				AcadUserID = sql_1.rs1.getString("ID");
			}
			// запрос для изменения записи узла
			String sql = "UPDATE NUM_NUMBERS SET ";
			sql = sql + "OBOZ_PREFIX = '" + OBOZ_PREFIX.toUpperCase() + "',";
			sql = sql + "OBOZ_FIRST_NUM = '" + OBOZ_FIRST_NUM.toUpperCase()
					+ "',";
			sql = sql + "OBOZ_SECOND_NUM = '" + OBOZ_SECOND_NUM.toUpperCase()
					+ "',";
			sql = sql + "OBOZ_THERD_NUM = '" + OBOZ_THERD_NUM.toUpperCase()
					+ "',";
			if (!OBOZ_POSTFIX.equals("")) {
				sql = sql + "OBOZ_POSTFIX = '" + OBOZ_POSTFIX.toUpperCase()
						+ "',";
			} else
				sql = sql + "OBOZ_POSTFIX = chr(0),";
			sql = sql + "NAIMENOVANIE_ID = " + NAIM_ID.toUpperCase() + ",";
			sql = sql + "USER_ID = " + UserID.toUpperCase() + ",";
			sql = sql + " M_COUNT = " + M_COUNT.toUpperCase() + ",";
			sql = sql + " MASS_ID = " + MASS_ID.toUpperCase() + ",";
			sql = sql + " STATUS_ID = " + STATUS_ID.toUpperCase() + ",";
			sql = sql + " MATERIAL_ID = " + MATERIAL_ID.toUpperCase() + ",";
			sql = sql + " FORMAT_ID = " + FORMAT_ID.toUpperCase() + ",";
			sql = sql + " A1_COUNT = " + A1_COUNT.toUpperCase() + ",";
			sql = sql + " A4_COUNT = " + A4_COUNT.toUpperCase() + ",";
			sql = sql + " AUTOCAD = '" + AUTOCAD + "',";
			sql = sql + " PROE = '" + PROE + "',";
			sql = sql + " PRIMENAETSA = '" + VHODIMOST + "',";
			sql = sql + " NOTE = '" + Note + "', ";
			sql = sql + " AUTOCAD_USER_ID=" + AcadUserID;
			sql = sql + " WHERE ID = " + ID;
			String sql1 = "INSERT INTO NUM_NAIMENOVANIE (ID,NAIMENOVANIE) VALUES (";
			sql1 = sql1 + "'" + NAIM_ID.toUpperCase() + "','" + NAIM + "')";
			// запрос для таблицы RELATIONS
			String sql2 = "UPDATE NUM_RELATIONS SET ";
			sql2 = sql2 + " UZ_COUNT = '" + UZ_COUNT.toUpperCase() + "',";
			sql2 = sql2 + " TYPE = '" + TYPE + "'";
			sql2 = sql2 + " WHERE CHILD_ID = " + ID + " AND PARENT_ID = "
					+ IzdelID;
			// запрос для таблицы MASS
			String sql3 = "INSERT INTO NUM_MASS (ID,MASS) VALUES (";
			sql3 = sql3 + "'" + MASS_ID.toUpperCase() + "','"
					+ MASS.toUpperCase() + "')";
			// запрос для таблицы MASS
			String sql5 = "INSERT INTO NUM_MATERIAL (ID,MATERIAL) VALUES (";
			sql5 = sql5 + "'" + MATERIAL_ID.toUpperCase() + "','" + MATERIAL
					+ "')";
			// запрос для таблицы FORMAT
			String sql4 = "INSERT INTO NUM_FORMAT (ID,FORMAT) VALUES (";
			sql4 = sql4 + "'" + FORMAT_ID.toUpperCase() + "','"
					+ FORMAT.toUpperCase() + "')";
			OC.getCon().setAutoCommit(false);
			Statement st = OC.getCon().createStatement();
			boolean error = true;
			try {
				// System.out.println("sql update "+sql);
				// System.out.println("INFO: EditRecord - Execute SQL");
				// Выполняем запрос
				st.setQueryTimeout(QUERY_TIMEOUT);
				st.executeUpdate(sql);// NUMBERS
				st.executeUpdate(sql2); // RELATIONS
				if (find) {
					// System.out.println(sql1);
					st.executeUpdate(sql1); // наименование новое
				}
				if (findM) {
					// System.out.println(sql3);
					st.executeUpdate(sql3); // масса новая
				}
				if (findMATERIAL) {
					// System.out.println(sql5);
					st.executeUpdate(sql5); // материал новый
				}
				if (findF) {
					// System.out.println(sql4);
					st.executeUpdate(sql4); // формат новый
				}
				st.close();
			} catch (Exception e) {
				e.printStackTrace();
				error = false;
			}
			if (error)
				OC.getCon().commit();
			else {
				// System.out.println("ERROR: EditRecord - Error execute SQL");
				OC.getCon().rollback();
			}
		}
	}

	public void DeleteRecord(String DEL_TYPE, String DEL_OBOZ,
			String DEL_PARENT_OBOZ) throws Exception {
		String sql = "";
		String sql_num = "";
		SQLRequest_1 sql_1 = new SQLRequest_1();
		sql_1.SearchIzd(DEL_OBOZ);
		sql_1.rs1.next();
		String UzelID = sql_1.rs1.getString("ID");
		sql_1.SearchIzd(DEL_PARENT_OBOZ);
		sql_1.rs1.next();
		String ParentID = sql_1.rs1.getString("ID");
		sql = "DELETE FROM NUM_RELATIONS WHERE CHILD_ID = " + UzelID
				+ " AND PARENT_ID = " + ParentID;
		sql_num = "DELETE FROM  NUM_NUMBERS WHERE ID = " + UzelID;
		OC.getCon().setAutoCommit(false);
		Statement st = OC.getCon().createStatement();
		boolean error = true;
		try {
			// System.out.println("INFO: DeleteRecord - Execute SQL");
			// Выполняем запрос
			st.setQueryTimeout(QUERY_TIMEOUT);
			if (DEL_TYPE.equals("0")) {
				st.executeUpdate(sql);
				st.close();
			}
			if (DEL_TYPE.equals("1")) {
				st.executeUpdate(sql);
				st.executeUpdate(sql_num);
			}

		} catch (Exception e) {
			e.printStackTrace();
			error = false;
		}
		if (error)
			OC.getCon().commit();
		else {
			// System.out.println("ERROR: DeleteRecord - Error execute SQL");
			OC.getCon().rollback();
		}
	}

	public void InsertStatistic(String Action, String Username, String Naim,
			String Oboz) throws Exception {
		SQLRequest_1 sql_1 = new SQLRequest_1();
		String ID;
		String sql;
		int iID;
		// берем последний ID
		sql_1.GetLastSTATISTIC_Id();
		if (sql_1.rs1.next()) {
			if (sql_1.rs1.getString("MAX(ID)") != null) {
				ID = sql_1.rs1.getString("MAX(ID)");
				// если ID не первый увеличиваем его на 1
				iID = Integer.parseInt(ID);
				iID++;
				ID = String.valueOf(iID).toString();
			} else
				ID = "0";
		} else
			ID = "0";
		sql = "INSERT INTO NUM_STATISTIC (ID,ACTION,DATE_OF_ACTION,USERNAME,NAIM,OBOZ) VALUES ";
		sql += "(" + ID + "," + Action + ",SYSDATE,'" + Username + "','" + Naim
				+ "','" + Oboz + "')";
		// добавляем запись
		OC.getCon().setAutoCommit(false);
		Statement st = OC.getCon().createStatement();
		boolean error = true;
		try {
			// System.out.println("INFO: InsertStatistic - Execute SQL");
			st.setQueryTimeout(QUERY_TIMEOUT);
			// //System.out.println("TEST: " + sql);
			st.executeUpdate(sql);
		} catch (Exception e) {
			e.printStackTrace();
			error = false;
		}
		if (error)
			OC.getCon().commit();
		else {
			// System.out.println("ERROR: InsertStatistic - Error execute SQL");
			OC.getCon().rollback();
		}
	}

	public void InsertUpdate(String FULLNAME, String TYPE, String TEXT)
			throws Exception {
		SQLRequest_1 sql_1 = new SQLRequest_1();
		String ID = "0";
		int iID = 0;
		// получаем последний ID
		sql_1.GetLastUpdate_Id();
		if (sql_1.rs1.next()) {
			if (sql_1.rs1.getString("MAX(ID)") != null) {
				ID = sql_1.rs1.getString("MAX(ID)");
				// если ID не первый увеличиваем его на 1
				iID = Integer.parseInt(ID);
				iID++;
				ID = String.valueOf(iID).toString();
			} else
				ID = "0";
		} else
			ID = "0";
		String sql = "INSERT INTO NUM_UPGRADE (ID,TYPE,TEXT,FULLNAME,ANSWER,FINISH) VALUES (";
		sql = sql + ID + ",'" + TYPE + "','" + TEXT + "','" + FULLNAME
				+ "','',0)";
		// выполняем запрос
		OC.getCon().setAutoCommit(false);
		Statement st = OC.getCon().createStatement();
		// //System.out.println("TESTING SQL: " + sql);
		boolean error = true;
		try {
			// System.out.println("INFO: InsertUpdate - Execute SQL");
			st.setQueryTimeout(QUERY_TIMEOUT);
			// //System.out.println("TEST: " + sql);
			st.executeUpdate(sql);
		} catch (Exception e) {
			e.printStackTrace();
			error = false;
		}
		if (error)
			OC.getCon().commit();
		else {
			// System.out.println("ERROR: InsertUpdate - Error execute SQL");
			OC.getCon().rollback();
		}

	}

	// получить данные о файлах пользователя
	public void GetUserFiles(String user) throws Exception {
		String sql = "SELECT NUM_NUMBERS.ID, NAIMENOVANIE, "
				+ "OBOZ_PREFIX || OBOZ_FIRST_NUM || OBOZ_SECOND_NUM || OBOZ_THERD_NUM AS "
				+ "OBOZ, OBOZ_POSTFIX, LOGIN, FULLNAME, AUTOCAD "
				+ "FROM NUM_NUMBERS "
				+ "INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID "
				+ "LEFT JOIN NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID "
				+ "WHERE USERS.FULLNAME= ?"
				+ " AND (PRIMENAETSA <> '-1')";
		// System.out.println("INFO: GetUserFiles - Execute SQL");//выполняем
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, user);
		// запрос
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить количество файлов пользователя
	public void GetCountUserFiles(String user) throws Exception {
		String sql = "SELECT COUNT(AUTOCAD) AS RESULT FROM NUM_NUMBERS";
		// System.out.println("INFO: GetCountUserFiles - Execute SQL");//выполняем
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		// запрос
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// обновить путь в num_numbers
	public void UpdateNumNumbersPath(int id, String path) throws Exception {
		String sql = "UPDATE NUM_NUMBERS SET AUTOCAD=?"
				+ "WHERE ID= ?";
		// System.out.println("INFO: UpdateNumNumbersPath - Execute SQL");//выполняем
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, path);
		prstmt.setInt(2,id);
		// запрос
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		prstmt.executeUpdate();// executeQuery(sql);
	}

	// получить путь к autocad файлу
	public void GetAutocadPath(String file_name) throws Exception {
		String sql = "SELECT FILEPATH " + "FROM PATCH,AUTOCAD "
				+ "WHERE AUTOCAD.FILEPATH_ID=PATCH.ID AND "
				+ "AUTOCAD.FILENAME=?";
		// System.out.println("INFO: GetAutocadPath - Execute SQL");//выполняем
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, file_name);
		// запрос
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить модели Pro/ENGINEER по логину
	public void GetProeModelsByLogin(String Login) throws Exception {
		String sql = "SELECT ";
		sql = sql + "		MODELS.FILENAME,";
		sql = sql
				+ "		PATCH.FILEPATH || '\' || MODELS.FILENAME || '.' || MODELS.FILEEXT AS PROE,";
		sql = sql
				+ "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX ||  NUM_NUMBERS.OBOZ_FIRST_NUM ||  NUM_NUMBERS.OBOZ_SECOND_NUM ||  NUM_NUMBERS.OBOZ_THERD_NUM ||  NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS REPOBOZNACHENIE,";
		sql = sql + "		USERS.FULLNAME,";
		sql = sql + "		NUM_NAIMENOVANIE.NAIMENOVANIE,";
		sql = sql + "		NUM_NUMBERS.ID AS UNIQIDENTIFIER, ";
		sql = sql + "		NUM_NUMBERS.PROE AS PROENGINEER ";
		sql = sql + "		FROM";
		sql = sql + "		MODELS";
		sql = sql + "		INNER JOIN PATCH ON PATCH.ID = MODELS.FILEPATH_ID";
		sql = sql
				+ "		INNER JOIN NUM_NUMBERS ON MODELS.RUSNAME = REPLACE((NUM_NUMBERS.OBOZ_PREFIX ||  NUM_NUMBERS.OBOZ_FIRST_NUM ||  NUM_NUMBERS.OBOZ_SECOND_NUM ||  NUM_NUMBERS.OBOZ_THERD_NUM ||  NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'')";
		sql = sql
				+ "		INNER JOIN NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID";
		sql = sql + "		INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID";
		sql = sql + "		WHERE";
		sql = sql + "		NUM_NUMBERS.PRIMENAETSA <> '-1' AND ";
		sql = sql + "		USERS.LOGIN = UPPER(?)";
		// System.out.println("INFO: " + sql);//выполняем запрос
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, Login);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить ерево в обратную сторону
	public void GetBackList(String OBOZNACHENIE) throws Exception {
		String sql = " SELECT ";
		sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE, ";
		sql = sql + "		LEVEL ";
		sql = sql + "		FROM NUM_RELATIONS ";
		sql = sql
				+ "		INNER JOIN NUM_NUMBERS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
		sql = sql + "		WHERE NUM_NUMBERS.OBOZ_THERD_NUM = '000'";
		sql = sql
				+ "		CONNECT BY NOCYCLE PRIOR NUM_RELATIONS.PARENT_ID = NUM_RELATIONS.CHILD_ID ";
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
		sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') = ?";
		sql = sql + "		) ";
		// Выполняем запрос
		// System.out.println("INFO: " + sql);
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, OBOZNACHENIE);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить слежующий уровень крупных сборок
	public void GetNextLevel(String OBOZNACHENIE) throws Exception {
		String sql = " SELECT ";
		sql = sql + "		REPLACE((NUM_NUMBERS.OBOZ_PREFIX || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_FIRST_NUM || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_SECOND_NUM || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_THERD_NUM || ";
		sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') AS OBOZNACHENIE ";
		sql = sql + "		FROM NUM_RELATIONS ";
		sql = sql
				+ "		INNER JOIN NUM_NUMBERS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID ";
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
		sql = sql + "		NUM_NUMBERS.OBOZ_POSTFIX),CHR(0),'') = ?";
		sql = sql + "		) ";
		sql = sql + "		ORDER BY OBOZNACHENIE ";

		// Выполняем запрос
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, OBOZNACHENIE);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить модели Pro/ENGINEER по логину
	public void GetTopLevelStatistic(String OBOZ_PREFIX, String OBOZ_FIRST_NUM,
			String OBOZ_SECOND_NUM, String OBOZ_THERD_NUM, String OBOZ_POSTFIX)
			throws Exception {
		String sql = " SELECT ";
		sql = sql
				+ "REPLACE(LPAD(' ', (LEVEL - 1) * 4) || OBOZ_PREFIX || OBOZ_FIRST_NUM || OBOZ_SECOND_NUM || OBOZ_THERD_NUM || OBOZ_POSTFIX,CHR(0),'') AS TREE, ";
		sql = sql + "NUM_NAIMENOVANIE.NAIMENOVANIE, ";
		sql = sql + "NUM_STATUS.STATUS, ";
		sql = sql + "NUM_STATUS.COLOR, ";
		sql = sql + "USERS.FULLNAME, ";
		sql = sql + "DEPARTMENT.DEPARTMENT_ABB, ";
		sql = sql + "LEVEL ";
		sql = sql + "FROM NUM_RELATIONS ";
		sql = sql
				+ "INNER JOIN NUM_NUMBERS ON NUM_NUMBERS.ID = NUM_RELATIONS.CHILD_ID  ";
		sql = sql
				+ "INNER JOIN NUM_STATUS ON NUM_NUMBERS.STATUS_ID = NUM_STATUS.ID  ";
		sql = sql + "INNER JOIN USERS ON NUM_NUMBERS.USER_ID = USERS.ID  ";
		sql = sql
				+ "INNER JOIN DEPARTMENT ON USERS.DEPARTMENT_ID = DEPARTMENT.ID  ";
		sql = sql
				+ "LEFT JOIN  NUM_NAIMENOVANIE ON NUM_NUMBERS.NAIMENOVANIE_ID = NUM_NAIMENOVANIE.ID  ";
		sql = sql
				+ "CONNECT BY NOCYCLE PRIOR NUM_RELATIONS.CHILD_ID = NUM_RELATIONS.PARENT_ID  ";
		sql = sql + "START WITH NUM_RELATIONS.PARENT_ID =  ";
		sql = sql + "(SELECT ID FROM NUM_NUMBERS WHERE OBOZ_PREFIX = ? AND OBOZ_FIRST_NUM = ? AND OBOZ_SECOND_NUM = ? AND OBOZ_THERD_NUM = ?";
		if (OBOZ_POSTFIX.isEmpty())
			sql = sql + " AND OBOZ_POSTFIX=chr(0)) ";
		else
			sql = sql + " AND OBOZ_POSTFIX=? ) ";
		// //System.out.println("INFO: " + sql);//тест
		// System.out.println("INFO: GetTopLevelStatistic - Execute SQL");//выполняем
		// Создаем statment (оператор) для выполнения SQL-запроса
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		prstmt.setString(1, OBOZ_PREFIX);
		prstmt.setString(2, OBOZ_FIRST_NUM);
		prstmt.setString(3, OBOZ_SECOND_NUM);
		prstmt.setString(4, OBOZ_THERD_NUM);
		if (!OBOZ_POSTFIX.isEmpty()) {
			prstmt.setString(5, OBOZ_POSTFIX);
		}
		// запрос
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить все отделы
	public void GetAllDepartmentSmall() throws Exception {
		String sql = "SELECT DEPARTMENT.DEPARTMENT_ABB FROM DEPARTMENT";
		// System.out.println("INFO: GetAllDepartmentSmall - Execute SQL");//выполняем
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		// запрос
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	// получить левые файлы
	public void GetGOSTorDINoutLib(String type, String fio, String department,
			String instance) throws Exception {
		String sql = " SELECT ";
		sql += "  PATCH.FILEPATH, ";
		sql += "  MODELS.FILENAME, ";
		sql += "  MODELS.FILEEXT, ";
		sql += "  USERS.FULLNAME, ";
		sql += "  DEPARTMENT.DEPARTMENT_ABB ";
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
		if (!instance.equals("on"))
			sql += " AND MODELS.FAMILYTABLE <> 1 ";
		if (!fio.equals("Все"))
			sql += " AND FULLNAME = '" + fio + "' ";
		if (!department.equals("Все"))
			sql += " AND DEPARTMENT_ABB = '" + department + "' ";
		sql += "  ORDER BY FILEPATH ";
		prstmt = OC.getCon().prepareStatement(sql,
				ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
		// System.out.println("INFO: GetGOSTorDINoutLib - Execute SQL");//выполняем
		// запрос
		// System.out.println("INFO: " + sql);
		prstmt.setQueryTimeout(QUERY_TIMEOUT);
		rs = prstmt.executeQuery();
	}

	/*
	 * private String DecodeUTF(String str) throws Exception{ int i=0; String
	 * str1=""; while(i<str.length()){ str1 += str.charAt(i); i=i+2; } return
	 * str1;
	 * 
	 * }
	 */
}
