package everytable.main.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DAO {
	
	// DB필요한 객체
	// DB 연결 객체 - DB 회사에서 제공하는 드라이버를 사용한다.
	// 드라이버가 필요하다. 오라클인 경우 설치하면 폴더 안에 존재한다. - 라이브러리로 등록 시킨다.
	public Connection con = null;
	// 쿼리를 실행하는 객체
	public PreparedStatement pstmt = null;
	// 결과를 저장하는 객체 - select 일때만 사용되는 객체
	public ResultSet rs = null;

}
