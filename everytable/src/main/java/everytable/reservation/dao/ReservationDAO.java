package everytable.reservation.dao;

import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.reservation.vo.ReservationVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class ReservationDAO extends DAO {

	// 1. 예약 리스트
	public List<ReservationVO> list(PageObject pageObject) throws Exception {
		List<ReservationVO> list = new ArrayList<>();
		con = DB.getConnection();

		String loginId = pageObject.getAccepter();

		String sql = "select s.store_name, r.res_no, to_char(r.res_date, 'yyyy-mm-dd') res_date, "
				+ " r.res_time, r.res_type, r.res_status, r.res_count, r.res_created_at "
				+ " from reservation r LEFT OUTER JOIN store s ON r.store_id = s.store_id " + " where r.user_id = ? "; // 내
																														// 아이디
		sql += search(pageObject);

		sql += " order by r.res_created_at desc";

		sql = "select rownum rnum, store_name, res_no, res_date, res_time, res_type, res_status, res_count " + " from ("
				+ sql + ")";
		sql = "select * from (" + sql + ") where rnum between ? and ?";

		pstmt = con.prepareStatement(sql);

		pstmt.setString(1, loginId);
		pstmt.setLong(2, pageObject.getStartRow());
		pstmt.setLong(3, pageObject.getEndRow());

		rs = pstmt.executeQuery();

		if (rs != null) {
			while (rs.next()) {
				ReservationVO vo = new ReservationVO();
				vo.setStoreName(rs.getString("store_name"));
				vo.setResNo(rs.getLong("res_no"));
				vo.setResCount(rs.getLong("res_count"));
				vo.setResDate(rs.getString("res_date"));
				vo.setResTime(rs.getString("res_time"));
				vo.setResType(rs.getString("res_type"));
				vo.setResStatus(rs.getLong("res_status"));
				list.add(vo);
			}
		}
		DB.close(con, pstmt, rs);
		return list;
	}

	// 1. 예약 리스트 매장용
	public List<ReservationVO> adminList(PageObject pageObject) throws Exception {
		List<ReservationVO> list = new ArrayList<>();
		con = DB.getConnection();

		String storeId = pageObject.getAccepter();

		// 1. 내부 쿼리 (검색 및 정렬 포함)
		String sql = "select r.res_no, r.user_id, to_char(r.res_date, 'yyyy-mm-dd') res_date, "
				+ " r.res_time, r.res_type, r.res_status, r.res_count, r.res_created_at, r.res_phone, r.total_price "
				+ " from reservation r " + " where r.store_id = ? ";

		sql += search(pageObject);
		sql += " order by r.res_date desc, r.res_time desc";

		// 2. 페이징 처리 래퍼 (res_created_at 컬럼을 중간 단계에도 넣어줘야 함!)
		sql = "select rownum rnum, res_no, user_id, res_date, res_time, res_type, res_status, res_count, res_phone, total_price, res_created_at "
				+ " from (" + sql + ")";

		// 3. 최종 페이징 쿼리
		sql = "select * from (" + sql + ") where rnum between ? and ?";

		pstmt = con.prepareStatement(sql);

		// setString 혹은 setLong (DB 타입에 맞춰서)
		pstmt.setString(1, storeId);
		pstmt.setLong(2, pageObject.getStartRow());
		pstmt.setLong(3, pageObject.getEndRow());

		rs = pstmt.executeQuery();

		if (rs != null) {
			while (rs.next()) {
				ReservationVO vo = new ReservationVO();
				vo.setResNo(rs.getLong("res_no"));
				vo.setUserId(rs.getString("user_id"));
				vo.setResCount(rs.getLong("res_count"));
				vo.setResDate(rs.getString("res_date"));
				vo.setResTime(rs.getString("res_time"));
				vo.setResType(rs.getString("res_type"));
				vo.setResStatus(rs.getLong("res_status"));
				vo.setResPhone(rs.getString("res_phone"));
				vo.setResCreatedAt(rs.getString("res_created_at")); // 날짜 표시를 위해 추가

				// [중요!] totalPrice -> total_price 로 수정
				vo.setTotalPrice(rs.getLong("total_price"));

				list.add(vo);
			}
		}
		DB.close(con, pstmt, rs);
		return list;
	}

	// 2. 전체 개수 일반 사용자용
	public Long getTotalRow(PageObject pageObject) throws Exception {
		Long totalRow = 0L;
		con = DB.getConnection();

		String userId = pageObject.getAccepter();

		// search() 앞에 명시적으로 user_id 조건을 둡니다.
		String sql = "select count(*) from reservation r where r.user_id = ? " + search(pageObject);

		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, userId);

		rs = pstmt.executeQuery();
		if (rs != null && rs.next()) {
			totalRow = rs.getLong(1);
		}
		DB.close(con, pstmt, rs);
		return totalRow;
	}

	// 2. 전체 개수 매장용
	public Long getTotalRowAdmin(PageObject pageObject) throws Exception {
		Long totalRow = 0L;
		con = DB.getConnection();

		String storeId = pageObject.getAccepter();

		String sql = "select count(*) from reservation r where r.store_id = ? " + search(pageObject);

		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, Long.parseLong(storeId));

		rs = pstmt.executeQuery();
		if (rs != null && rs.next()) {
			totalRow = rs.getLong(1);
		}
		DB.close(con, pstmt, rs);
		return totalRow;
	}

	// 3. 검색 조건
	public String search(PageObject pageObject) {
		String sql = "";
		String key = pageObject.getKey();
		if (key != null && !key.equals("0") && !key.isEmpty()) {
			sql = " and ( r.res_status = " + key + " ) ";
		}
		return sql;
	}

	// 4. 예약 상세 보기 일반 사용자용
	public ReservationVO view(Long no) throws Exception {
		ReservationVO vo = null;
		con = DB.getConnection();

		// SQL 수정: LEFT OUTER JOIN 사용
		String sql = "select s.store_name, r.user_id, r.res_phone, "
				+ " to_char(r.res_date, 'yyyy-mm-dd') res_date, r.res_time, "
				+ " r.res_count, r.res_type, r.res_no, r.total_price, r.res_status, r.order_add, r.cancel_reason "
				+ " from reservation r LEFT OUTER JOIN store s ON r.store_id = s.store_id " + " where r.res_no = ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, no);
		rs = pstmt.executeQuery();

		if (rs != null && rs.next()) {
			vo = new ReservationVO();
			vo.setResNo(rs.getLong("res_no"));
			// ★ 여기서 rs.getString("store_name")이 제대로 담기는지 확인!
			vo.setStoreName(rs.getString("store_name"));
			vo.setUserId(rs.getString("user_id"));
			vo.setResPhone(rs.getString("res_phone"));
			vo.setResDate(rs.getString("res_date"));
			vo.setResTime(rs.getString("res_time"));
			vo.setResCount(rs.getLong("res_count"));
			vo.setResType(rs.getString("res_type"));
			vo.setTotalPrice(rs.getLong("total_price"));
			vo.setResStatus(rs.getLong("res_status"));
			vo.setOrderAdd(rs.getString("order_add"));
			vo.setCancelReason(rs.getString("cancel_reason"));
		}

		DB.close(con, pstmt, rs);
		return vo;
	}
	
	// 예약 상세 보기 - 메뉴
	// 예약 번호(resNo)에 해당하는 상세 메뉴 리스트 가져오기
	public List<ReservationVO> orderList(Long resNo) throws Exception {
	    List<ReservationVO> list = new ArrayList<>();
	    con = DB.getConnection();

	    // 메뉴 테이블(MENU)과 주문 아이템 테이블(ORDER_ITEM) 조인
	    String sql = "SELECT m.menu_name, oi.quantity, oi.price "
	               + " FROM order_item oi, menu m "
	               + " WHERE oi.menu_no = m.menu_no AND oi.res_no = ?";

	    pstmt = con.prepareStatement(sql);
	    pstmt.setLong(1, resNo);
	    rs = pstmt.executeQuery();

	    if (rs != null) {
	        while (rs.next()) {
	            ReservationVO menuVO = new ReservationVO();
	            menuVO.setMenuName(rs.getString("menu_name"));
	            menuVO.setQuantity(rs.getInt("quantity"));
	            menuVO.setPrice(rs.getLong("price"));
	            list.add(menuVO);
	        }
	    }
	    DB.close(con, pstmt, rs);
	    return list;
	}

	// 4. 예약 상세 보기 매장용
	public ReservationVO adminView(Long no) throws Exception {
		ReservationVO vo = null;
		con = DB.getConnection();

		// SQL 수정: LEFT OUTER JOIN 사용
		String sql = "select s.store_name, r.user_id, r.res_phone, "
				+ " to_char(r.res_date, 'yyyy-mm-dd') res_date, r.res_time, "
				+ " r.res_count, r.res_type, r.res_no, r.total_price, r.res_status, r.order_add, r.cancel_reason "
				+ " from reservation r LEFT OUTER JOIN store s ON r.store_id = s.store_id " + " where r.res_no = ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, no);
		rs = pstmt.executeQuery();

		if (rs != null && rs.next()) {
			vo = new ReservationVO();
			vo.setResNo(rs.getLong("res_no"));
			// ★ 여기서 rs.getString("store_name")이 제대로 담기는지 확인!
			vo.setStoreName(rs.getString("store_name"));
			vo.setUserId(rs.getString("user_id"));
			vo.setResPhone(rs.getString("res_phone"));
			vo.setResDate(rs.getString("res_date"));
			vo.setResTime(rs.getString("res_time"));
			vo.setResCount(rs.getLong("res_count"));
			vo.setResType(rs.getString("res_type"));
			vo.setTotalPrice(rs.getLong("total_price"));
			vo.setResStatus(rs.getLong("res_status"));
			vo.setOrderAdd(rs.getString("order_add"));
			vo.setCancelReason(rs.getString("cancel_reason"));
		}

		DB.close(con, pstmt, rs);
		return vo;
	}

	// 5. 예약 하기 - 일반 사용자용
	public Long write(ReservationVO vo) throws Exception {
		Long resNo = 0L;
		con = DB.getConnection();

		String sql = "insert into reservation(res_no, user_id, res_date, res_time, res_count, "
				+ " res_phone, res_type, store_id, total_price, res_status) "
				+ " values(reservation_seq.nextval, ?, ?, ?, ?, ?, ?, ?, ?, 1)";

		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, vo.getUserId());
		pstmt.setString(2, vo.getResDate());
		pstmt.setString(3, vo.getResTime());
		pstmt.setLong(4, vo.getResCount());
		pstmt.setString(5, vo.getResPhone());
		pstmt.setString(6, vo.getResType());
		pstmt.setLong(7, vo.getStoreId());
		pstmt.setLong(8, vo.getTotalPrice());

		pstmt.executeUpdate();
		pstmt.close();

		sql = "select reservation_seq.currval from dual";
		pstmt = con.prepareStatement(sql);
		rs = pstmt.executeQuery();

		if (rs.next())
			resNo = rs.getLong(1);

		DB.close(con, pstmt, rs);
		return resNo;
	}

	// 6. 예약 정보 수정 일반 사용자용
	public int update(ReservationVO vo) throws Exception {
		int result = 0;
		con = DB.getConnection();

		String sql = "update reservation set res_date = ?, res_time = ?, "
				+ " res_count = ?, res_phone = ?, res_type = ? " + " where res_no = ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, vo.getResDate());
		pstmt.setString(2, vo.getResTime());
		pstmt.setLong(3, vo.getResCount());
		pstmt.setString(4, vo.getResPhone());
		pstmt.setString(5, vo.getResType());
		pstmt.setLong(6, vo.getResNo());

		result = pstmt.executeUpdate();

		DB.close(con, pstmt);
		return result;
	}

	// 6- 예약 상태 변경 매장용
	public int adminUpdate(ReservationVO vo) throws Exception {
		int result = 0;
		con = DB.getConnection();

		// 상태(2:수락, 3:거절)와 거절사유를 업데이트
		String sql = "update reservation set res_status = ?, cancel_reason = ? where res_no = ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, vo.getResStatus());
		pstmt.setString(2, vo.getCancelReason());
		pstmt.setLong(3, vo.getResNo());

		result = pstmt.executeUpdate();

		DB.close(con, pstmt);
		return result;
	}

	// 7. 예약 취소 일반 사용자용
	public int cancel(ReservationVO vo) throws Exception {
		int result = 0;
		con = DB.getConnection();

		String sql = "update reservation set res_status = ?, cancel_reason = ? where res_no = ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, vo.getResStatus());
		pstmt.setString(2, vo.getCancelReason());
		pstmt.setLong(3, vo.getResNo());

		result = pstmt.executeUpdate();

		DB.close(con, pstmt);
		return result;
	}

	// 7. 예약 취소 매장용
	public int adminCancel(ReservationVO vo) throws Exception {
		int result = 0;
		con = DB.getConnection();

		String sql = "update reservation set res_status = ?, cancel_reason = ? where res_no = ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, vo.getResStatus());
		pstmt.setString(2, vo.getCancelReason());
		pstmt.setLong(3, vo.getResNo());

		result = pstmt.executeUpdate();

		DB.close(con, pstmt);
		return result;
	}

	/////////////////
	///
	///
	// 메뉴 주문
	public Long orderWrite(ReservationVO vo) throws Exception {

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
