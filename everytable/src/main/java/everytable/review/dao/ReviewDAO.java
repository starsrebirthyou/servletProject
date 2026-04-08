package everytable.review.dao;

import java.util.ArrayList;
import java.util.List;
import everytable.main.dao.DAO;
import everytable.review.vo.ReviewVO;
import everytable.util.db.DB;

public class ReviewDAO extends DAO {

    // 1. 리뷰 리스트 조회
    public List<ReviewVO> list(ReviewVO vo) throws Exception {
        List<ReviewVO> list = null;
        try {
            con = DB.getConnection();
            String sql = "SELECT r.review_id as no, r.content, r.user_id, m.name as user_name, "
                       + " r.store_id, s.store_name, r.rating, r.is_deleted, "
                       + " TO_CHAR(r.created_at, 'yyyy-mm-dd') created_at "
                       + " FROM review r, member m, store s "
                       + " WHERE (r.user_id = m.id) AND (r.store_id = s.store_id) "
                       + " AND r.user_id = ? "
                       + " ORDER BY r.review_id DESC ";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, vo.getUserId());
            rs = pstmt.executeQuery();

            if (rs != null) {
                while (rs.next()) {
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
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("리뷰 리스트 조회 중 DB 오류 발생");
        } finally {
            DB.close(con, pstmt, rs);
        }
        return list;
    }

    // 2. 리뷰 등록
    public Integer write(ReviewVO vo) throws Exception {
        Integer result = 0;
        try {
            con = DB.getConnection();
            String sql = "INSERT INTO review (review_id, content, user_id, store_id, store_name, rating, is_deleted, created_at) " 
                       + " VALUES (review_seq.nextval, ?, ?, ?, ?, ?, 0, SYSDATE)";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, vo.getContent());  
            pstmt.setString(2, vo.getUserId());   
            pstmt.setLong(3, vo.getStoreId());    
            pstmt.setString(4, vo.getStoreName()); 
            pstmt.setDouble(5, vo.getRating()); 
            
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("리뷰 등록 중 DB 오류 발생");
        } finally {
            DB.close(con, pstmt);
        }
        return result;
    }

    // 3. 리뷰 상세보기 (수정 폼 불러올 때 사용)
    public ReviewVO view(long no) throws Exception {
        ReviewVO vo = null;
        try {
            con = DB.getConnection();
            String sql = "SELECT review_id as no, content, user_id, store_id, rating, "
                       + " TO_CHAR(created_at, 'yyyy-mm-dd') created_at "
                       + " FROM review WHERE review_id = ?"; 
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, no);
            rs = pstmt.executeQuery();

            if (rs != null && rs.next()) {
                vo = new ReviewVO();
                vo.setNo(rs.getLong("no"));
                vo.setContent(rs.getString("content"));
                vo.setUserId(rs.getString("user_id"));
                vo.setStoreId(rs.getLong("store_id"));
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

    // ★ 4. 리뷰 수정 (여기에 추가되었습니다!) ★
    public Integer update(ReviewVO vo) throws Exception {
        Integer result = 0;
        try {
            con = DB.getConnection();
            // content와 rating을 수정하며, review_id(no)를 조건으로 삼음
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