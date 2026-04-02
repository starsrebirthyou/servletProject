package everytable.reservation.dao;

import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.reservation.vo.ReservationVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class ReservationDAO extends DAO {

	// 1. 예약 리스트 (내 예약만 + 식당 이름 조인)
	// 1. 예약 리스트
	public List<ReservationVO> list(PageObject pageObject) throws Exception {
	    List<ReservationVO> list = new ArrayList<>();
	    con = DB.getConnection();

	    String loginId = pageObject.getAccepter();

	    // [수정] s.store_id = r.store_id (+) 처럼 처리하거나 
	    // 표준 ANSI JOIN인 LEFT OUTER JOIN을 써서 식당정보가 없어도 예약은 나오게 합니다.
	    String sql = "select s.store_name, r.res_no, to_char(r.res_date, 'yyyy-mm-dd') res_date, "
	            + " r.res_time, r.res_type, r.res_status, r.res_count, r.res_created_at "
	            + " from reservation r LEFT OUTER JOIN store s ON r.store_id = s.store_id " 
	            + " where r.user_id = ? "; // 내 아이디 조건

	    // 검색 조건 추가 (search 메서드에서 'and'로 시작하므로 자연스럽게 연결됨)
	    sql += search(pageObject);
	    
	    sql += " order by r.res_created_at desc";

	    // 페이징 처리 래퍼
	    sql = "select rownum rnum, store_name, res_no, res_date, res_time, res_type, res_status, res_count " 
	        + " from (" + sql + ")";
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

	// 2. 전체 개수 (검색 조건 포함)
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

	// 3. 검색 조건 (기존 로직 유지)
	public String search(PageObject pageObject) {
		String sql = "";
		String key = pageObject.getKey();
		if (key != null && !key.equals("0") && !key.isEmpty()) {
			sql = " and ( r.res_status = " + key + " ) ";
		}
		return sql;
	}

	// 4. 예약 상세 보기 (식당 이름 조인 유지)
	public ReservationVO view(Long no) throws Exception {
	    ReservationVO vo = null;
	    con = DB.getConnection();

	    // SQL 수정: LEFT OUTER JOIN 사용
	    String sql = "select s.store_name, r.user_id, r.res_phone, " 
	            + " to_char(r.res_date, 'yyyy-mm-dd') res_date, r.res_time, "
	            + " r.res_count, r.res_type, r.res_no, r.total_price, r.res_status, r.cancel_reason " 
	            + " from reservation r LEFT OUTER JOIN store s ON r.store_id = s.store_id "
	            + " where r.res_no = ?";

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
	        vo.setCancelReason(rs.getString("cancel_reason"));
	    }
	    
	    // 디버깅용: 콘솔에 매장명이 찍히는지 확인하세요
	    if(vo != null) System.out.println("조회된 매장명: " + vo.getStoreName());

	    DB.close(con, pstmt, rs);
	    return vo;
	}

	// 5. 예약 하기
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

	// 6. 예약 정보 수정
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

	// 7. 예약 취소 (상태값 변경)
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
}