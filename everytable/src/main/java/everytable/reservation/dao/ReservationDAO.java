package everytable.reservation.dao;

import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.menu.vo.MenuVO;
import everytable.reservation.vo.ReservationVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class ReservationDAO extends DAO {

	// 1. 예약 리스트 (사용자용)
	public List<ReservationVO> list(PageObject pageObject) throws Exception {
		List<ReservationVO> list = new ArrayList<>();
		con = DB.getConnection();
		String loginId = pageObject.getAccepter();
		String sql = "select s.store_name, r.res_no, to_char(r.res_date, 'yyyy-mm-dd') res_date, "
				+ " r.res_time, r.res_type, r.res_status, r.res_count, r.res_created_at "
				+ " from reservation r LEFT OUTER JOIN store s ON r.store_id = s.store_id " + " where r.user_id = ? "; 
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

	// 1-1. 예약 리스트 (매장용)
	public List<ReservationVO> adminList(PageObject pageObject) throws Exception {
		List<ReservationVO> list = new ArrayList<>();
		con = DB.getConnection();
		String storeId = pageObject.getAccepter();
		String sql = "select r.res_no, r.user_id, to_char(r.res_date, 'yyyy-mm-dd') res_date, "
				+ " r.res_time, r.res_type, r.res_status, r.res_count, r.res_created_at, r.res_phone, r.total_price "
				+ " from reservation r where r.store_id = ? ";
		sql += search(pageObject);
		sql += " order by r.res_date desc, r.res_time desc";
		sql = "select rownum rnum, res_no, user_id, res_date, res_time, res_type, res_status, res_count, res_phone, total_price, res_created_at "
				+ " from (" + sql + ")";
		sql = "select * from (" + sql + ") where rnum between ? and ?";
		pstmt = con.prepareStatement(sql);
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
				vo.setResCreatedAt(rs.getString("res_created_at"));
				vo.setTotalPrice(rs.getLong("total_price"));
				list.add(vo);
			}
		}
		DB.close(con, pstmt, rs);
		return list;
	}

	// 2. 전체 개수 (사용자용)
	public Long getTotalRow(PageObject pageObject) throws Exception {
		Long totalRow = 0L;
		con = DB.getConnection();
		String userId = pageObject.getAccepter();
		String sql = "select count(*) from reservation r where r.user_id = ? " + search(pageObject);
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, userId);
		rs = pstmt.executeQuery();
		if (rs != null && rs.next()) totalRow = rs.getLong(1);
		DB.close(con, pstmt, rs);
		return totalRow;
	}

	// 2-1. 전체 개수 (매장용)
	public Long getTotalRowAdmin(PageObject pageObject) throws Exception {
		Long totalRow = 0L;
		con = DB.getConnection();
		String storeId = pageObject.getAccepter();
		String sql = "select count(*) from reservation r where r.store_id = ? " + search(pageObject);
		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, Long.parseLong(storeId));
		rs = pstmt.executeQuery();
		if (rs != null && rs.next()) totalRow = rs.getLong(1);
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

	// 4. 예약 상세 보기 (공용)
	public ReservationVO view(Long no) throws Exception {
		ReservationVO vo = null;
		con = DB.getConnection();
		String sql = "select s.store_name, r.store_id, r.user_id, r.res_phone, "
				+ " to_char(r.res_date, 'yyyy-mm-dd') res_date, r.res_time, "
				+ " r.res_count, r.res_type, r.res_no, r.total_price, r.res_status, r.order_add, r.cancel_reason "
				+ " from reservation r LEFT OUTER JOIN store s ON r.store_id = s.store_id " + " where r.res_no = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, no);
		rs = pstmt.executeQuery();
		if (rs != null && rs.next()) {
			vo = new ReservationVO();
			vo.setResNo(rs.getLong("res_no"));
			vo.setStoreName(rs.getString("store_name"));
			vo.setStoreId(rs.getLong("store_id")); 
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

	// 5. 주문 메뉴 리스트
	public List<ReservationVO> orderList(Long resNo) throws Exception {
	    List<ReservationVO> list = new ArrayList<>();
	    con = DB.getConnection();
	    String sql = "SELECT m.menu_no, m.menu_name, oi.quantity, oi.price "
	               + " FROM order_item oi, menu m "
	               + " WHERE oi.menu_no = m.menu_no AND oi.res_no = ?";
	    pstmt = con.prepareStatement(sql);
	    pstmt.setLong(1, resNo);
	    rs = pstmt.executeQuery();
	    if (rs != null) {
	        while (rs.next()) {
	            ReservationVO menuVO = new ReservationVO();
	            menuVO.setMenuNo(rs.getLong("menu_no"));
	            menuVO.setMenuName(rs.getString("menu_name"));
	            menuVO.setQuantity(rs.getInt("quantity"));
	            menuVO.setPrice(rs.getLong("price"));
	            list.add(menuVO);
	        }
	    }
	    DB.close(con, pstmt, rs);
	    return list;
	}

	// 6. 매장 전체 메뉴판 (수정 시 참고)
	public List<ReservationVO> storeMenuList(Long storeId) throws Exception {
	    List<ReservationVO> list = new ArrayList<>();
	    con = DB.getConnection();
	    String sql = "SELECT menu_no, menu_name, price FROM menu WHERE store_id = ? ORDER BY menu_name ASC";
	    pstmt = con.prepareStatement(sql);
	    pstmt.setLong(1, storeId);
	    rs = pstmt.executeQuery();
	    if (rs != null) {
	        while (rs.next()) {
	            ReservationVO menu = new ReservationVO();
	            menu.setMenuNo(rs.getLong("menu_no"));
	            menu.setMenuName(rs.getString("menu_name"));
	            menu.setPrice(rs.getLong("price"));
	            list.add(menu);
	        }
	    }
	    DB.close(con, pstmt, rs);
	    return list;
	}

	// 7. 예약 정보 수정 (사용자용)
	public int update(ReservationVO vo) throws Exception {
		int result = 0;
		con = DB.getConnection();
		String sql = "update reservation set res_date = ?, res_time = ?, "
				+ " res_count = ?, res_phone = ?, res_type = ?, total_price = ? " + " where res_no = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, vo.getResDate());
		pstmt.setString(2, vo.getResTime());
		pstmt.setLong(3, vo.getResCount());
		pstmt.setString(4, vo.getResPhone());
		pstmt.setString(5, vo.getResType());
		pstmt.setLong(6, vo.getTotalPrice());
		pstmt.setLong(7, vo.getResNo());
		result = pstmt.executeUpdate();
		DB.close(con, pstmt);
		return result;
	}

	// 8. 예약 상태 변경 (매장용 - 수락/거절)
	public int adminUpdate(ReservationVO vo) throws Exception {
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

	// 9. 예약 취소
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

	// 10. 예약 하기 & 주문 아이템 저장
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
		if (rs.next()) resNo = rs.getLong(1);
		DB.close(con, pstmt, rs);
		return resNo;
	}

	// 단체 주문 저장 (price 자동 조회)
	public void groupOrderWrite(ReservationVO vo) throws Exception {
	    con = DB.getConnection();
	    // menu 테이블에서 price 조회
	    String priceSql = "SELECT price FROM menu WHERE menu_no = ?";
	    pstmt = con.prepareStatement(priceSql);
	    pstmt.setLong(1, vo.getMenuNo());
	    rs = pstmt.executeQuery();
	    long price = 0L;
	    if (rs.next()) price = rs.getLong("price");
	    rs.close(); pstmt.close();

	    // order_item INSERT
	    String sql = "INSERT INTO ORDER_ITEM (ORDER_ITEM_NO, RES_NO, MENU_NO, QUANTITY, PRICE) "
	               + "VALUES (ORDER_ITEM_SEQ.NEXTVAL, ?, ?, ?, ?)";
	    pstmt = con.prepareStatement(sql);
	    pstmt.setLong(1, vo.getResNo());
	    pstmt.setLong(2, vo.getMenuNo());
	    pstmt.setLong(3, vo.getQuantity());
	    pstmt.setLong(4, price);
	    pstmt.executeUpdate();
	    DB.close(con, pstmt);
	}

	
	/// 가게 메뉴 목록 (resNo로 storeId 찾아서 조회)
	public List<MenuVO> menuListByResNo(Long resNo) throws Exception {
	    List<MenuVO> list = new ArrayList<>();
	    con = DB.getConnection();
	    String sql = "SELECT m.menu_no, m.menu_name, m.price, m.description, m.image_url "
	               + "FROM menu m "
	               + "JOIN reservation r ON m.store_id = r.store_id "
	               + "WHERE r.res_no = ? AND m.is_active = 1";
	    pstmt = con.prepareStatement(sql);
	    pstmt.setLong(1, resNo);
	    rs = pstmt.executeQuery();
	    while (rs.next()) {
	        MenuVO vo = new MenuVO();
	        vo.setMenu_no(rs.getLong("menu_no"));
	        vo.setMenu_name(rs.getString("menu_name"));
	        vo.setPrice(rs.getInt("price"));
	        vo.setDescription(rs.getString("description"));
	        vo.setImage_url(rs.getString("image_url"));
	        list.add(vo);
	    }
	    DB.close(con, pstmt, rs);
	    return list;
	}

	// 단체 주문 취합 조회
	public List<MenuVO> groupOrderList(Long resNo) throws Exception {
	    List<MenuVO> list = new ArrayList<>();
	    con = DB.getConnection();
	    String sql = "SELECT m.menu_name, SUM(oi.quantity) AS quantity, oi.price "
	               + "FROM order_item oi JOIN menu m ON oi.menu_no = m.menu_no "
	               + "WHERE oi.res_no = ? "
	               + "GROUP BY m.menu_name, oi.price ORDER BY m.menu_name";
	    pstmt = con.prepareStatement(sql);
	    pstmt.setLong(1, resNo);
	    rs = pstmt.executeQuery();
	    while (rs.next()) {
	        MenuVO vo = new MenuVO();
	        vo.setMenu_name(rs.getString("menu_name"));
	        vo.setQuantity(rs.getInt("quantity"));
	        vo.setPrice(rs.getInt("price"));
	        list.add(vo);
	    }
	    DB.close(con, pstmt, rs);
	    return list;
	}

	// 단체 주문 총합계
	public Long groupOrderTotal(Long resNo) throws Exception {
	    Long total = 0L;
	    con = DB.getConnection();
	    String sql = "SELECT NVL(SUM(price * quantity), 0) FROM order_item WHERE res_no = ?";
	    pstmt = con.prepareStatement(sql);
	    pstmt.setLong(1, resNo);
	    rs = pstmt.executeQuery();
	    if (rs.next()) total = rs.getLong(1);
	    DB.close(con, pstmt, rs);
	    return total;
	}

}