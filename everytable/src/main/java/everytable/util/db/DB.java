package everytable.util.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DB {

	// DB 연결 정보
	private static final String DRIVER = "oracle.jdbc.OracleDriver";
//	private static final String URL = "jdbc:oracle:thin:@localhost:1521:xe";
	// 쌤 DB 사용
	// private static final String URL = "jdbc:oracle:thin:@10.15.21.178:1521:xe";
	// 1팀 DB 사용
	// private static final String URL = "jdbc:oracle:thin:@10.15.21.219:1521:xe";
	// 2팀 DB 사용
	private static final String URL = "jdbc:oracle:thin:@10.15.21.232:1521/xe";
	// 3팀 DB 사용
	// private static final String URL = "jdbc:oracle:thin:@10.15.21.205:1521:xe";
	private static final String UID = "everytable";
	private static final String UPW = "everytable";

	static {
		// 1. 드라이버 확인
		try {
			Class.forName(DRIVER);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	// DB.getConnection()
	public static Connection getConnection() throws Exception{
		// 2. 연결 객체
		return DriverManager.getConnection(URL, UID, UPW);
	}
	
	// 사용했던 객체 닫기 - insert, update, delete
	public static void close(Connection con, PreparedStatement pstmt) throws Exception {
		if(con != null) con.close();
		if(pstmt != null) pstmt.close();
	}
	
	// 사용했던 객체 닫기 - select
	public static void close(Connection con, PreparedStatement pstmt, ResultSet rs) throws Exception {
		close(con, pstmt);
		if(rs != null) rs.close();
	}
	
}
