package everytable.review.dao;

import java.util.ArrayList;
import java.util.List;
import everytable.main.dao.DAO;
import everytable.review.vo.ReviewVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class ReviewDAO extends DAO {

	// 1. 리뷰 리스트
	public List<ReviewVO> list(PageObject pageObject) throws Exception {
	    List<ReviewVO> list = null;

	    con = DB.getConnection();

	    // 3. 쿼리 작성
	    // [수정] users u -> member m 으로 변경, u.id -> m.id 로 변경
	    String sql = " select r.review_id, r.content, m.id as user_id, m.name, r.store_id, r.rating, r.is_deleted, "
	            + " to_char(r.created_at, 'yyyy-mm-dd') created_at "
	            + " from review r, member m " // users 대신 member 테이블 사용
	            + " where r.user_id = m.id "  // 조인 조건 수정
	            + " order by r.review_id desc ";

	    // 3-2. 순서 번호(rnum) 붙이기 
	    sql = " select rownum rnum, review_id, content, user_id, name, store_id, rating, is_deleted, created_at "
	        + " from ( " + sql + " ) ";

	    // 3-3. 페이지 데이터 가져오기
	    sql = " select rnum, review_id, content, user_id, name, store_id, rating, is_deleted, created_at "
	        + " from ( " + sql + " ) "
	        + " where rnum between ? and ? ";

	    pstmt = con.prepareStatement(sql);
	    pstmt.setLong(1, pageObject.getStartRow());
	    pstmt.setLong(2, pageObject.getEndRow());

	    rs = pstmt.executeQuery();

	    if (rs != null) {
	        while (rs.next()) {
	            if (list == null) list = new ArrayList<ReviewVO>();
	            ReviewVO vo = new ReviewVO();
	            
	            vo.setReviewId(rs.getLong("review_id"));
	            vo.setContent(rs.getString("content"));
	            vo.setUserId(rs.getString("user_id")); 
	            vo.setUserName(rs.getString("name"));
	            vo.setStoreId(rs.getLong("store_id"));
	            vo.setRating(rs.getDouble("rating"));
	            vo.setIsDeleted(rs.getInt("is_deleted"));
	            vo.setCreatedAt(rs.getString("created_at"));
	            
	            list.add(vo);
	        }
	    }

	    DB.close(con, pstmt, rs);
	    return list;
	}

	// 1-1. 전체 데이터 개수
	public Long getTotalRow(PageObject pageObject) throws Exception {
		Long totalRow = 0L;
		con = DB.getConnection();
		String sql = "select count(*) from review";
		pstmt = con.prepareStatement(sql);
		rs = pstmt.executeQuery();
		if (rs != null && rs.next()) {
			totalRow = rs.getLong(1);
		}
		DB.close(con, pstmt, rs);
		return totalRow;
	}

	// 2. 리뷰 등록
	public Integer write(ReviewVO vo) throws Exception {
		Integer result = 0;
		con = DB.getConnection();
		String sql = "insert into review(review_id, content, user_id, store_id, rating, is_deleted) " 
				   + " values(review_seq.nextval, ?, ?, ?, ?, 0)";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, vo.getContent());
		pstmt.setString(2, vo.getUserId());
		pstmt.setLong(3, vo.getStoreId());
		pstmt.setDouble(4, vo.getRating());
		
		result = pstmt.executeUpdate();
		DB.close(con, pstmt);
		return result;
	}

	// 3. 리뷰 수정
	public Integer update(ReviewVO vo) throws Exception {
		Integer result = 0;
		con = DB.getConnection();
		String sql = "update review set content = ?, rating = ? " 
				   + " where review_id = ? and user_id = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, vo.getContent());
		pstmt.setDouble(2, vo.getRating());
		pstmt.setLong(3, vo.getReviewId());
		pstmt.setString(4, vo.getUserId()); 
		
		result = pstmt.executeUpdate();
		DB.close(con, pstmt);
		return result;
	}

	// 4. 리뷰 삭제
	public Integer delete(ReviewVO vo) throws Exception {
		Integer result = 0;
		con = DB.getConnection();
		String sql = "delete from review where review_id = ? and user_id = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, vo.getReviewId());
		pstmt.setString(2, vo.getUserId()); 
		
		result = pstmt.executeUpdate();
		DB.close(con, pstmt);
		return result;
	}
}