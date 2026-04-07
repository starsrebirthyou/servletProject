package everytable.review.dao;

import java.util.ArrayList;
import java.util.List;
import everytable.main.dao.DAO;
import everytable.review.vo.ReviewVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class ReviewDAO extends DAO {

    // 1. 리뷰 리스트
    public List<ReviewVO> list(ReviewVO vo) throws Exception {
        List<ReviewVO> list = null;
        try {
            con = DB.getConnection();
            // [수정] r.no -> r.review_id as no
            String sql = "SELECT r.review_id as no, r.content, r.user_id, m.name as user_name, "
                       + " r.store_id, s.store_name, r.rating, r.is_deleted, "
                       + " TO_CHAR(r.created_at, 'yyyy-mm-dd') created_at "
                       + " FROM review r, member m, store s where (r.user_id = m.id) and (r.store_id = s.store_id) " 
                       + " ORDER BY r.review_id DESC "; // 정렬도 review_id로

            sql = "SELECT * FROM ( "
                + "    SELECT rownum rnum, a.* FROM ( " 
                +          sql 
                + "    ) a "
                + ") WHERE user_id = ? ";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, vo.getUserId());
            rs = pstmt.executeQuery();

            if (rs != null) {
                while (rs.next()) {
                    if (list == null) list = new ArrayList<>();
                    vo = new ReviewVO();
                    vo.setNo(rs.getLong("no")); // 위에서 as no 했으므로 "no" 가능
                    vo.setContent(rs.getString("content"));
                    vo.setUserId(rs.getString("user_id")); 
                    vo.setUserName(rs.getString("user_name") == null ? rs.getString("user_id") : rs.getString("user_name"));
                    vo.setStoreId(rs.getLong("store_id"));
                    vo.setStoreName(rs.getString("store_name"));
                    vo.setRating(rs.getDouble("rating"));
                    vo.setIsDeleted(rs.getInt("is_deleted"));
                    vo.setCreatedAt(rs.getString("created_at"));
                    list.add(vo);
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

    // 1-1. 전체 데이터 개수
    public Long getTotalRow(PageObject pageObject) throws Exception {
        Long totalRow = 0L;
        try {
            con = DB.getConnection();
            String sql = "SELECT COUNT(*) FROM review";
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs != null && rs.next()) {
                totalRow = rs.getLong(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("전체 리뷰 개수 조회 중 DB 오류 발생");
        } finally {
            DB.close(con, pstmt, rs);
        }
        return totalRow;
    }

    // 1-2. 상세 보기 (이미 잘 고쳐진 부분)
    public ReviewVO view(long no) throws Exception {
        ReviewVO vo = null;
        try {
            con = DB.getConnection();
            String sql = "SELECT review_id as no, content, user_id, store_id, store_name , rating, "
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
    
    // 2. 리뷰 등록
    public Integer write(ReviewVO vo) throws Exception {
        Integer result = 0;
        try {
            con = DB.getConnection();
            // [수정] 테이블 컬럼명에 맞춰 no -> review_id
            String sql = "INSERT INTO review(review_id, content, user_id, store_id,store_name, rating, is_deleted, created_at) " 
                       + " VALUES(review_seq.nextval, ?, ?, ?, ?, 0, SYSDATE)";
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

    // 3. 리뷰 수정
    public Integer update(ReviewVO vo) throws Exception {
        Integer result = 0;
        try {
            con = DB.getConnection();
            // [수정] no -> review_id
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

    // 4. 리뷰 삭제
    public Integer delete(long no) throws Exception {
        Integer result = 0;
        try {
            con = DB.getConnection();
            // [수정] no -> review_id
            String sql = "DELETE FROM review WHERE review_id = ?"; 
            
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, no);
            result = pstmt.executeUpdate();
            
            if(result == 0) throw new Exception("삭제할 리뷰 번호가 존재하지 않습니다.");
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("리뷰 삭제 중 DB 오류 발생 : " + e.getMessage());
        } finally {
            DB.close(con, pstmt);
        }
        return result;
    }
}