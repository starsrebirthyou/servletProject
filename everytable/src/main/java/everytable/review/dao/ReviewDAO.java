package everytable.review.dao;

import java.util.ArrayList;
import java.util.List;
import everytable.main.dao.DAO;
import everytable.review.vo.ReviewVO;
import everytable.util.db.DB;

public class ReviewDAO extends DAO {

	    // 1. 매장별 리뷰 목록 (storeId가 있을 때)
	    public List<ReviewVO> list(ReviewVO vo) throws Exception {
	        List<ReviewVO> list = null;
	        try {
	            con = DB.getConnection();
	            // is_deleted 컬럼을 SELECT 항목에 추가했습니다.
	            String sql = "SELECT r.review_id as no, r.content, r.user_id, m.name as user_name, "
	                       + " r.store_id, s.store_name, r.rating, r.is_deleted, " 
	                       + " TO_CHAR(r.created_at, 'yyyy-mm-dd') created_at "
	                       + " FROM review r, member m, store s "
	                       + " WHERE r.user_id = m.id "
	                       + " AND r.store_id = ? "
	                       + " AND r.is_deleted = 0 "
	                       + " AND r.store_id = s.store_id "
	                       + " ORDER BY r.review_id DESC ";

	            pstmt = con.prepareStatement(sql);
	            pstmt.setLong(1, vo.getStoreId()); 

	            rs = pstmt.executeQuery();

	            while (rs != null && rs.next()) {
	                if (list == null) list = new ArrayList<>();
	                ReviewVO resultVO = new ReviewVO();
	                resultVO.setNo(rs.getLong("no"));
	                resultVO.setContent(rs.getString("content"));
	                resultVO.setUserId(rs.getString("user_id"));
	                resultVO.setUserName(rs.getString("user_name"));
	                resultVO.setStoreId(rs.getLong("store_id"));
	                resultVO.setStoreName(rs.getString("store_name"));
	                resultVO.setRating(rs.getDouble("rating"));
	                resultVO.setIsDeleted(rs.getInt("is_deleted"));
	                resultVO.setCreatedAt(rs.getString("created_at"));
	                list.add(resultVO);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            throw new Exception("매장 리뷰 조회 중 DB 오류");
	        } finally { DB.close(con, pstmt, rs); }
	        return list;
	    }

	    // ✅ 1-1. 내가 쓴 리뷰 목록 (userId로 조회 - storeId가 0일 때 대비)
	    public List<ReviewVO> myList(ReviewVO vo) throws Exception {
	        List<ReviewVO> list = null;
	        try {
	            con = DB.getConnection();
	            // store 테이블 조인을 빼서 데이터 누락을 방지했습니다.
	         // AS-IS: 회원이 없으면 리뷰도 안 나옴
	            StringBuilder sql = new StringBuilder();
	            sql.append("SELECT r.review_id as no, r.content, r.user_id, m.name as user_name, ");
	            sql.append(" r.store_id, s.store_name, r.rating, r.is_deleted, ");
	            sql.append(" TO_CHAR(r.created_at, 'yyyy-mm-dd') created_at ");
	            sql.append(" FROM review r, member m, store s ");
	            sql.append(" WHERE r.user_id = m.id ");
	            sql.append(" AND r.user_id = ? ");
	            sql.append(" AND r.is_deleted = 0 ");
	            sql.append(" AND r.store_id = s.store_id ");
	            sql.append(" ORDER BY r.review_id DESC ");

	            pstmt = con.prepareStatement(sql.toString());
	            pstmt.setString(1, vo.getUserId());

	            rs = pstmt.executeQuery();

	            while (rs != null && rs.next()) {
	                if (list == null) list = new ArrayList<>();
	                ReviewVO resultVO = new ReviewVO();
	                resultVO.setNo(rs.getLong("no"));
	                resultVO.setContent(rs.getString("content"));
	                resultVO.setUserId(rs.getString("user_id"));
	                resultVO.setUserName(rs.getString("user_name"));
	                resultVO.setStoreId(rs.getLong("store_id"));
	                resultVO.setStoreName(rs.getString("store_name"));
	                resultVO.setRating(rs.getDouble("rating"));
	                resultVO.setIsDeleted(rs.getInt("is_deleted"));
	                resultVO.setCreatedAt(rs.getString("created_at"));
	                list.add(resultVO);
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	            throw new Exception("내 리뷰 조회 중 DB 오류");
	        } finally { DB.close(con, pstmt, rs); }
	        return list;
	    }

	    // 2. 리뷰 등록
	 // ReviewDAO.java의 write 메서드
	 // ReviewDAO.java 내 write 메서드
	    public Integer write(ReviewVO vo) throws Exception {
	        Integer result = 0;
	        try {
	            con = DB.getConnection();
	            // store_name 컬럼이 누락되지 않았는지, VALUES의 ? 개수가 맞는지 확인
	            String sql = "INSERT INTO review (review_id, content, user_id, store_id, rating, is_deleted, created_at) " 
	                       + " VALUES (review_seq.nextval, ?, ?, ?, ?, ?, 0, SYSDATE)";
	            
	            pstmt = con.prepareStatement(sql);
	            pstmt.setString(1, vo.getContent());  
	            pstmt.setString(2, vo.getUserId());   
	            pstmt.setLong(3, vo.getStoreId());    
	            pstmt.setDouble(4, vo.getRating()); 
	            
	            result = pstmt.executeUpdate();
	        } catch (Exception e) {
	            e.printStackTrace();
	            throw new Exception("리뷰 등록 중 DB 오류");
	        } finally { DB.close(con, pstmt); }
	        return result;
	    }

    // 3. 리뷰 상세보기
    public ReviewVO view(long no) throws Exception {
        ReviewVO vo = null;
        try {
            con = DB.getConnection();

            String sql = "SELECT r.review_id as no, r.content, r.user_id, r.store_id, s.store_name, r.rating, "
                       + " TO_CHAR(r.created_at, 'yyyy-mm-dd') created_at "
                       + " FROM review r, store s WHERE (review_id = ?) AND (r.store_id = s.store_id)";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, no);
            rs = pstmt.executeQuery();

            if (rs != null && rs.next()) {
                vo = new ReviewVO();
                vo.setNo(rs.getLong("no"));
                vo.setContent(rs.getString("content"));
                vo.setUserId(rs.getString("user_id"));
                vo.setStoreId(rs.getLong("store_id"));
                vo.setStoreName(rs.getString("store_name"));
                vo.setRating(rs.getDouble("rating"));
                vo.setCreatedAt(rs.getString("created_at"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("리뷰 상세 조회 중 DB 오류 발생");
        } finally {
            DB.close(con, pstmt, rs);
        }
        return vo;
    }

    // 4. 리뷰 수정
    public Integer update(ReviewVO vo) throws Exception {
        Integer result = 0;
        try {
            con = DB.getConnection();

            String sql = "UPDATE review SET content = ?, rating = ? WHERE review_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, vo.getContent());
            pstmt.setDouble(2, vo.getRating());
            pstmt.setLong(3, vo.getNo());
            
            result = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("리뷰 수정 중 DB 오류 발생");
        } finally {
            DB.close(con, pstmt);
        }
        return result;
    }

    // 5. 리뷰 삭제
    public Integer delete(long no) throws Exception {
        Integer result = 0;
        try {
            con = DB.getConnection();

            String sql = "DELETE FROM review WHERE review_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, no);

            result = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("리뷰 삭제 중 DB 오류 발생");
        } finally {
            DB.close(con, pstmt);
        }
        return result;
    }
}
