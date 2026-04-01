package everytable.reservation.dao;

import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.reservation.vo.ReservationVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class ReservationDAO extends DAO {

	// 1. 예약 리스트 (MEMBER 테이블의 STORE_NAME 사용)
	public List<ReservationVO> list(PageObject pageObject) throws Exception {
	    List<ReservationVO> list = new ArrayList<>();
	    con = DB.getConnection();

	    // 1. 기본 데이터 추출 (정렬 기준인 res_created_at을 SELECT에 포함)
	    String sql = "select m.store_name, r.res_no, to_char(r.res_date, 'yyyy-mm-dd') res_date, "
	               + " r.res_time, r.res_type, r.res_status, r.res_count, r.res_created_at " // 정렬용 컬럼 추가
	               + " from reservation r, member m " 
	               + " where (r.user_id = m.id) "; 

	    // 검색 조건 추가
	    sql += search(pageObject);
	    
	    // [수정] 정렬 기준 변경: 최신 등록순(DESC)
	    sql += " order by r.res_created_at desc";

	    // 2. RowNum 부여 (바깥쪽에서 쓸 컬럼들만 정리)
	    sql = "select rownum rnum, store_name, res_no, res_date, res_time, res_type, res_status, res_count " 
	        + " from (" + sql + ")";
	    
	    // 3. 페이징 처리
	    sql = "select * from (" + sql + ") where rnum between ? and ?";
	    
	    System.out.println("실행 SQL: " + sql); 

	    pstmt = con.prepareStatement(sql);
	    pstmt.setLong(1, pageObject.getStartRow());
	    pstmt.setLong(2, pageObject.getEndRow());

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

	// 2. 예약 게시판 글의 개수
	public Long getTotalRow(PageObject pageObject) throws Exception {
		Long totalRow = 0L;
		con = DB.getConnection();
		String sql = "select count(*) from reservation r where 1=1 " + search(pageObject);
		pstmt = con.prepareStatement(sql);
		rs = pstmt.executeQuery();
		if (rs != null && rs.next()) {
			totalRow = rs.getLong(1);
		}
		DB.close(con, pstmt, rs);
		return totalRow;
	}

	// 3. 검색 조건 (RES_STATUS 숫자 타입 대응)
	public String search(PageObject pageObject) {
		String sql = "";
		String key = pageObject.getKey();
		if (key != null && !key.equals("0") && !key.isEmpty()) {
			sql = " and ( ";
			if (key.equals("1")) sql += " r.res_status = 1 ";
			else if (key.equals("2")) sql += " r.res_status = 2 ";
			else if (key.equals("3")) sql += " r.res_status = 3 ";
			else if (key.equals("4")) sql += " r.res_status = 4 ";
			sql += " ) ";
		}
		return sql;
	}

	// 4. 예약 보기
	public ReservationVO view(Long no) throws Exception {
		ReservationVO vo = null;
		con = DB.getConnection();
		String sql = "select m.store_name, r.user_id, r.res_phone, "
				+ " to_char(r.res_date, 'yyyy-mm-dd') res_date, r.res_time, "
				+ " r.res_count, r.res_type, r.res_no, r.total_price, r.res_status "
				+ " from reservation r, member m "
				+ " where r.user_id = m.id and r.res_no = ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, no);
		rs = pstmt.executeQuery();

		if (rs != null && rs.next()) {
			vo = new ReservationVO();
			vo.setResNo(rs.getLong("res_no"));
			vo.setStoreName(rs.getString("store_name"));
			vo.setUserId(rs.getString("user_id"));
			vo.setResPhone(rs.getString("res_phone"));
			vo.setResDate(rs.getString("res_date"));
			vo.setResTime(rs.getString("res_time"));
			vo.setResCount(rs.getLong("res_count"));
			vo.setResType(rs.getString("res_type"));
			vo.setTotalPrice(rs.getLong("total_price"));
			vo.setResStatus(rs.getLong("res_status"));
		}
		DB.close(con, pstmt, rs);
		return vo;
	}

	// 5. 예약 하기
	public Integer write(ReservationVO vo) throws Exception {
		Integer result = 0;
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

		result = pstmt.executeUpdate();
		DB.close(con, pstmt);
		return result;
	}

	// 6. 예약 수정 (찾으시던 부분!)
	public Integer update(ReservationVO vo) throws Exception {
		Integer result = 0;
		con = DB.getConnection();
		String sql = "update reservation set res_date = ?, res_time = ?, "
				+ " res_count = ?, res_phone = ?, res_type = ? "
				+ " where res_no = ?";
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
}