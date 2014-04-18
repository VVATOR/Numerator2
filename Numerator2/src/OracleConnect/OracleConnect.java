package OracleConnect;

import java.sql.Connection;
import java.sql.DriverManager;

public class OracleConnect {
private static Connection con;
private static String Url;
private static String Name;
private static String Password;
private String ServerIP;
private String DatabaseName;
private String Port;


//конструктор
public OracleConnect(String NAME,String PASSWORD,String SERVERIP, String DATABASENAME, String PORT) {
	setName(NAME);
	setPassword(PASSWORD);
	setServerIP(SERVERIP);
	setDatabaseName(DATABASENAME);
	setPort(PORT);
	setUrl("jdbc:oracle:thin:@" + ServerIP + ":1521:" + DatabaseName);
}
//подключение
public Connection getConnection() throws Exception {
	    Class.forName("oracle.jdbc.driver.OracleDriver");
        setCon(DriverManager.getConnection(Url, Name, Password));
	    return getCon();
	    }
//отключение
public void  Disconnected() throws Exception {
	getCon().close();
 
    }
public void setUrl(String url) {
	Url = url;
}
public String getUrl() {
	return Url;
}
public void setName(String name) {
	Name = name;
}
public String getName() {
	return Name;
}
public void setPassword(String password) {
	Password = password;
}
public String getPassword() {
	return Password;
}
public void setServerIP(String serverIP) {
	ServerIP = serverIP;
}
public String getServerIP() {
	return ServerIP;
}
public void setDatabaseName(String databaseName) {
	DatabaseName = databaseName;
}
public String getDatabaseName() {
	return DatabaseName;
}
public String getPort() {
	return Port;
}
public void setPort(String port) {
	Port = port;
}
public static void setCon(Connection con) {
	OracleConnect.con = con;
}
public Connection getCon() {
	return con;
}
}
