package everytable.order.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import everytable.main.dao.DAO;
import everytable.order.vo.OrderVO; // 위 필드들이 담긴 VO
import everytable.util.db.DB;

public class OrderDAO extends DAO {

	private Connection con = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;

	// 메뉴 주문 등록 (ORDER_ITEM 테이블에 저장)
	// 예외 처리는 호출한 곳(Service)으로 던집니다.
	public Long write(OrderVO vo) throws Exception {

		// 1. DB 연결 (이미 정의된 DB 클래스 사용)
		con = DB.getConnection();

		// 2. SQL 작성 (이미지 상의 ORDER_ITEM 구조 반영)
		// ORDER_ITEM_NO는 시퀀스, 나머지는 VO에서 가져온 값
		String sql = "INSERT INTO ORDER_ITEM (ORDER_ITEM_NO, RES_NO, MENU_NO, QUANTITY, PRICE) "
				+ " VALUES (ORDER_ITEM_SEQ.NEXTVAL, ?, ?, ?, ?)";

		// 3. 실행 객체 생성 및 데이터 세팅
		pstmt = con.prepareStatement(sql);

		// 컨트롤러에서 수집한 데이터들을 순서대로 매칭
		pstmt.setLong(1, vo.getResNo()); // 예약 번호 (FK)
		pstmt.setLong(2, vo.getMenuNo()); // 메뉴 번호
		pstmt.setLong(3, vo.getQuantity()); // 주문 수량
		pstmt.setLong(4, vo.getPrice()); // 메뉴 단가 (또는 합계)

		// 4. 실행
		pstmt.executeUpdate();

		// 5. 자원 닫기 (반드시 닫아줘야 DB 연결 부족 에러가 안 납니다)
		DB.close(con, pstmt);

		// 컨트롤러에서 redirect 시 사용할 resNo 반환
		return vo.getResNo();
	}
}
