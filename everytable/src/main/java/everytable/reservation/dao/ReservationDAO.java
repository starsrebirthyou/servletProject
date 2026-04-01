package everytable.reservation.dao;

import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.reservation.vo.ReservationVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class ReservationDAO extends DAO {

	// 예약 리스트
	public List<ReservationVO> list(PageObject pageObject) throws Exception {
		List<ReservationVO> list = new ArrayList<>();

		con = DB.getConnection();

		// 3. SQL 작성
		String sql = "select s.store_name, r.res_no, to_char(r.res_date, 'yyyy-mm-dd') res_date, "
				+ " r.res_time, r.res_type, r.res_status, r.res_count " // ← res_count 추가
				+ " from reservation r, store s " + " where (r.store_id = s.store_id) ";

		// 예약 상태 조건
		sql += search(pageObject);

		// 정렬
		sql += " order by r.res_no desc";

		sql = "select rownum rnum, store_name, res_no, res_date, res_time, res_type, res_status, res_count " + " from ("
				+ sql + ")";

		sql = "select rnum, store_name, res_no, res_date, res_time, res_type, res_status, res_count " + " from (" + sql
				+ ") where rnum between ? and ?";
		// 4. 실행 준비
		pstmt = con.prepareStatement(sql);

		// 5. 매개변수 채우기
		pstmt.setLong(1, pageObject.getStartRow());
		pstmt.setLong(2, pageObject.getEndRow());

		// 4.
		rs = pstmt.executeQuery();

		// 5.
		if (rs != null) {
			while (rs.next()) {
				ReservationVO vo = new ReservationVO();

				vo.setStoreName(rs.getString("store_name"));
				vo.setResNo(rs.getLong("res_no"));
				vo.setResCount(rs.getLong("res_count"));
				;
				vo.setResDate(rs.getString("res_date"));
				vo.setResTime(rs.getString("res_time"));
				vo.setResType(rs.getString("res_type"));
				vo.setResStatus(rs.getLong("res_status"));

				list.add(vo); // 생성한 VO를 리스트에 추가
			}
		}

		// 7. 자원 반납 (필수!)
		DB.close(con, pstmt, rs);

		return list;
	} // list 끝

	// 예약 게시판 글의 개수
	public Long getTotalRow(PageObject pageObject) throws Exception {
		Long totalRow = 0L;

		// 1.2.
		con = DB.getConnection();

		// 3.
		String sql = "select count(*) from reservation r where 1=1 " + search(pageObject);

		// 4.
		pstmt = con.prepareStatement(sql);

		// 5.
		rs = pstmt.executeQuery();

		// 6.
		if (rs != null && rs.next()) {
			totalRow = rs.getLong(1);
		} // if 끝

		// 7.
		DB.close(con, pstmt, rs);

		return totalRow;
	} // getTotalRow() 끝

	// 예약 상태에 따른 카테고리
	public String search(PageObject pageObject) {
		String sql = "";

		String key = pageObject.getKey();

		if (key != null && !key.equals("0") && !key.isEmpty()) {
			sql = " and ( ";
			if (key.equals("1"))
				sql += " r.res_status = 1 ";
			else if (key.equals("2"))
				sql += " r.res_status = 2 ";
			else if (key.equals("3"))
				sql += " r.res_status = 3 ";
			else if (key.equals("4"))
				sql += " r.res_status = 4 ";

			sql += " ) ";
		}
		return sql;
	}

	// 예약 보기
	public ReservationVO view(Long no) throws Exception {
	    ReservationVO vo = null;
	    con = DB.getConnection();

	    String sql = "select s.store_name, r.user_id, r.res_phone, "
	            + " to_char(r.res_date, 'yyyy-mm-dd') res_date, r.res_time, "
	            + " r.res_count, r.res_type, r.res_no, r.total_price "
	            + " from reservation r "
	            + " join store s on r.store_id = s.store_id "
	            + " where r.res_no = ?";

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
	    }
	    DB.close(con, pstmt, rs);
	    return vo;
	} // view() 끝

	// 예약 하기
	public Integer write(ReservationVO vo) throws Exception {
	    Integer result = 0;
	    con = DB.getConnection();

	    // SQL의 ? 순서: 1.res_date, 2.res_time, 3.res_count, 4.res_phone, 5.res_type, 6.user_id, 7.store_id
	    String sql = "insert into reservation(res_no, user_id, res_date, res_time, res_count, "
	            + " res_phone, res_name, res_created_at, res_type, store_name, store_id) "
	            + " select reservation_seq.nextval, u.user_id, ?, ?, ?, ?, u.user_name, sysdate, ?, s.store_name, s.store_id "
	            + " from users u, store s " + " where u.user_id = ? and s.store_id = ?";

	    pstmt = con.prepareStatement(sql);
	    
	    // ⭐ [중요] SQL ? 순서에 맞춰 인덱스 수정
	    pstmt.setString(1, vo.getResDate());      // 첫 번째 ?
	    pstmt.setString(2, vo.getResTime());      // 두 번째 ?
	    pstmt.setLong(3, vo.getResCount());       // 세 번째 ?
	    pstmt.setString(4, vo.getResPhone());     // 네 번째 ?
	    pstmt.setString(5, vo.getResType());      // 다섯 번째 ?
	    pstmt.setString(6, vo.getUserId());       // 여섯 번째 ? (where u.user_id)
	    pstmt.setLong(7, vo.getStoreId());        // 일곱 번째 ? (where s.store_id)

	    result = pstmt.executeUpdate();
	    DB.close(con, pstmt);
	    return result;
	} // write() 끝

	// 예약 수정
	public Integer update(ReservationVO vo) throws Exception {
	    Integer result = 0;

	        // 1.2. DB 연결
	        con = DB.getConnection();

	        // 3. SQL 작성
	        // 수정 가능한 항목: 날짜, 시간, 인원, 연락처, 예약 유형
	        String sql = "update reservation set res_date = ?, res_time = ?, "
	                   + " res_count = ?, res_phone = ?, res_type = ? "
	                   + " where res_no = ?";

	        // 4. 실행객체 및 데이터 세팅
	        pstmt = con.prepareStatement(sql);
	        
	        // ? 순서대로 매핑 (1~5번은 수정 데이터, 6번은 조건인 resNo)
	        pstmt.setString(1, vo.getResDate());
	        pstmt.setString(2, vo.getResTime());
	        pstmt.setLong(3, vo.getResCount());
	        pstmt.setString(4, vo.getResPhone());
	        pstmt.setString(5, vo.getResType());
	        pstmt.setLong(6, vo.getResNo());

	        // 5. 실행
	        result = pstmt.executeUpdate();
	        
	        DB.close(con, pstmt);
	        
	        return result;
	} // update() 끝
}