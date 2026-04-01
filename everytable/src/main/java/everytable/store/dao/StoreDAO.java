package everytable.store.dao;

import java.util.ArrayList;
import java.util.List;
import everytable.main.dao.DAO;
import everytable.store.vo.StoreVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class StoreDAO extends DAO {

    // 1. 매장 리스트 조회 (member 테이블과 JOIN)
    public List<StoreVO> list(PageObject pageObject) throws Exception {
        List<StoreVO> list = null;
        try {
            con = DB.getConnection();
            
            // store(s)와 member(m) 테이블 조인: member_id와 id가 같은 데이터를 매칭
            String sql = "select store_id, store_name, store_cate, store_addr, avg_rating, review_count, filename "
                       + " from ( "
                       + "     select rownum rnum, store_id, store_name, store_cate, store_addr, avg_rating, review_count, filename "
                       + "     from ( "
                       + "         select s.store_id, m.store_name, m.store_cate, m.store_addr, s.avg_rating, s.review_count, s.filename "
                       + "         from store s, member m "
                       + "         where s.member_id = m.id "; // 조인 조건
            
            sql += search(pageObject); // 검색 조건 추가
            sql += "         order by s.store_id desc "
                 + "     ) "
                 + " ) where rnum between ? and ?";
            
            pstmt = con.prepareStatement(sql);
            
            int idx = 1;
            idx = searchDataSet(pstmt, idx, pageObject);
            pstmt.setLong(idx++, pageObject.getStartRow());
            pstmt.setLong(idx++, pageObject.getEndRow());
            
            rs = pstmt.executeQuery();
            
            if (rs != null) {
                while (rs.next()) {
                    if (list == null) list = new ArrayList<>();
                    StoreVO vo = new StoreVO();
                    vo.setNo(rs.getLong("store_id"));
                    vo.setName(rs.getString("store_name"));
                    vo.setCategory(rs.getString("store_cate"));
                    vo.setAddress(rs.getString("store_addr"));
                    vo.setAvg_rating(rs.getDouble("avg_rating"));
                    vo.setReview_count(rs.getInt("review_count"));
                    vo.setFileName(rs.getString("filename"));
                    list.add(vo);
                }
            }
        } finally {
            DB.close(con, pstmt, rs);
        }
        return list;
    }

    // 2. 매장 상세보기 (JOIN 포함)
    public StoreVO view(Long no) throws Exception {
        StoreVO vo = null;
        try {
            con = DB.getConnection();
            String sql = "select s.store_id, m.store_name, m.store_cate, m.store_addr, s.avg_rating, s.review_count, s.filename, "
                       + " s.store_tel, s.open_time, s.min_order_price, s.delivery_time "
                       + " from store s, member m "
                       + " where s.member_id = m.id and s.store_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, no);
            rs = pstmt.executeQuery();
            if (rs != null && rs.next()) {
                vo = new StoreVO();
                vo.setNo(rs.getLong("store_id"));
                vo.setName(rs.getString("store_name"));
                vo.setCategory(rs.getString("store_cate"));
                vo.setAddress(rs.getString("store_addr"));
                vo.setAvg_rating(rs.getDouble("avg_rating"));
                vo.setReview_count(rs.getInt("review_count"));
                vo.setFileName(rs.getString("filename"));
                vo.setTel(rs.getString("store_tel"));
                vo.setOpenTime(rs.getString("open_time"));
                vo.setMinOrderPrice(rs.getLong("min_order_price"));
                vo.setDeliveryTime(rs.getString("delivery_time"));
            }
        } finally {
            DB.close(con, pstmt, rs);
        }
        return vo;
    }

    // 3. 전체 데이터 개수 (JOIN 포함)
    public Long getTotalRow(PageObject pageObject) throws Exception {
        Long totalRow = 0L;
        try {
            con = DB.getConnection();
            String sql = "select count(*) from store s, member m where s.member_id = m.id ";
            sql += search(pageObject);
            
            pstmt = con.prepareStatement(sql);
            searchDataSet(pstmt, 1, pageObject);
            
            rs = pstmt.executeQuery();
            if (rs != null && rs.next()) {
                totalRow = rs.getLong(1);
            }
        } finally {
            DB.close(con, pstmt, rs);
        }
        return totalRow;
    }

    // 4. 검색 조건 (멤버 테이블 컬럼 기준)
    private String search(PageObject pageObject) {
        String sql = "";
        String key = pageObject.getKey();
        String word = pageObject.getWord();
        
        if (word != null && !word.equals("")) {
            sql += " and ( 1=0 ";
            // member 테이블(m)의 컬럼명을 사용
            if (key.indexOf("n") >= 0) sql += " or m.store_name like ? ";
            if (key.indexOf("c") >= 0) sql += " or m.store_cate like ? ";
            if (key.indexOf("a") >= 0) sql += " or m.store_addr like ? ";
            sql += " ) ";
        }
        return sql;
    }

    private int searchDataSet(java.sql.PreparedStatement pstmt, int idx, PageObject pageObject) throws Exception {
        String key = pageObject.getKey();
        String word = pageObject.getWord();
        if (word != null && !word.equals("")) {
            if (key.indexOf("n") >= 0) pstmt.setString(idx++, "%" + word + "%");
            if (key.indexOf("c") >= 0) pstmt.setString(idx++, "%" + word + "%");
            if (key.indexOf("a") >= 0) pstmt.setString(idx++, "%" + word + "%");
        }
        return idx;
    }
}