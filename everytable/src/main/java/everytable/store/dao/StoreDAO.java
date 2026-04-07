package everytable.store.dao;

import java.util.ArrayList;
import java.util.List;
import everytable.main.dao.DAO;
import everytable.store.vo.StoreVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class StoreDAO extends DAO {

    // 1. 매장 등록 시 환불 정책 저장 추가
    public int write(StoreVO vo) throws Exception {
        int result = 0;
        try {
            con = DB.getConnection();
            // SQL에 refund_policy_24, 12, 0 컬럼 추가
            String sql = "insert into store (store_id, member_id, store_name, store_cate, store_addr, "
                       + "store_tel, open_time, min_order_price, prepare_time, filename, avg_rating, review_count, "
                       + "refund_policy_24, refund_policy_12, refund_policy_0) "
                       + "values (store_seq.nextval, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            int idx = 1;
            pstmt.setString(idx++, vo.getMember_id());
            pstmt.setString(idx++, vo.getStore_name());
            pstmt.setString(idx++, vo.getStore_cate());
            pstmt.setString(idx++, vo.getStore_addr());
            pstmt.setString(idx++, vo.getStore_tel());
            pstmt.setString(idx++, vo.getOpen_time());
            pstmt.setInt(idx++,    vo.getMin_order_price());
            pstmt.setString(idx++, vo.getPrepare_time());
            pstmt.setString(idx++, vo.getFilename());
            // 환불 정책 데이터 세팅
            pstmt.setString(idx++, vo.getRefund_policy_24());
            pstmt.setString(idx++, vo.getRefund_policy_12());
            pstmt.setString(idx++, vo.getRefund_policy_0());
            
            result = pstmt.executeUpdate();
        } finally { DB.close(con, pstmt, rs); }
        return result;
    }

    public List<StoreVO> list(PageObject pageObject) throws Exception {
        List<StoreVO> list = null;
        try {
            con = DB.getConnection();
            String sql = "select store_id, store_name, store_cate, store_addr, avg_rating, review_count, filename "
                       + " from ( "
                       + "     select rownum rnum, store_id, store_name, store_cate, store_addr, avg_rating, review_count, filename "
                       + "     from ( "
                       + "         select store_id, store_name, store_cate, store_addr, avg_rating, review_count, filename "
                       + "         from store where 1=1 ";
            sql += search(pageObject);
            sql += "         order by store_id desc ) ) where rnum between ? and ?";

            pstmt = con.prepareStatement(sql);
            int idx = 1;
            idx = searchDataSet(pstmt, idx, pageObject);
            pstmt.setLong(idx++, pageObject.getStartRow());
            pstmt.setLong(idx++, pageObject.getEndRow());

            rs = pstmt.executeQuery();
            while (rs.next()) {
                if (list == null) list = new ArrayList<>();
                StoreVO vo = new StoreVO();
                vo.setStore_id(rs.getLong("store_id"));
                vo.setStore_name(rs.getString("store_name"));
                vo.setStore_cate(rs.getString("store_cate"));
                vo.setStore_addr(rs.getString("store_addr"));
                vo.setAvg_rating(rs.getDouble("avg_rating"));
                vo.setReview_count(rs.getInt("review_count"));
                vo.setFilename(rs.getString("filename"));
                list.add(vo);
            }
        } finally { DB.close(con, pstmt, rs); }
        return list;
    }

    // 2. 매장 상세 보기 시 환불 정책 데이터 가져오기 추가
    public StoreVO view(Long store_id) throws Exception {
        StoreVO vo = null;
        try {
            con = DB.getConnection();
            // select * 이므로 모든 컬럼을 가져오지만, rs.get으로 VO에 담아주는 과정이 필수입니다.
            String sql = "select * from store where store_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, store_id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                vo = new StoreVO();
                vo.setStore_id(rs.getLong("store_id"));
                vo.setStore_name(rs.getString("store_name"));
                vo.setStore_cate(rs.getString("store_cate"));
                vo.setStore_addr(rs.getString("store_addr"));
                vo.setAvg_rating(rs.getDouble("avg_rating"));
                vo.setReview_count(rs.getInt("review_count"));
                vo.setFilename(rs.getString("filename"));
                vo.setStore_tel(rs.getString("store_tel"));
                vo.setOpen_time(rs.getString("open_time"));
                vo.setMin_order_price(rs.getInt("min_order_price"));
                vo.setPrepare_time(rs.getString("prepare_time"));
                
                // [추가] DB에서 가져온 환불 정책을 VO에 저장
                vo.setRefund_policy_24(rs.getString("refund_policy_24"));
                vo.setRefund_policy_12(rs.getString("refund_policy_12"));
                vo.setRefund_policy_0(rs.getString("refund_policy_0"));
            }
        } finally { DB.close(con, pstmt, rs); }
        return vo;
    }

    // 3. 매장 수정 시 환불 정책 업데이트 추가
    public int update(StoreVO vo) throws Exception {
        int result = 0;
        try {
            con = DB.getConnection();
            // SQL에 환불 정책 컬럼 업데이트 추가
            String sql = "update store set store_name=?, store_cate=?, store_addr=?, "
                       + "store_tel=?, open_time=?, min_order_price=?, prepare_time=?, "
                       + "refund_policy_24=?, refund_policy_12=?, refund_policy_0=?";
            if (vo.getFilename() != null && !vo.getFilename().isEmpty()) {
                sql += ", filename=?";
            }
            sql += " where store_id=?";

            pstmt = con.prepareStatement(sql);
            int idx = 1;
            pstmt.setString(idx++, vo.getStore_name());
            pstmt.setString(idx++, vo.getStore_cate());
            pstmt.setString(idx++, vo.getStore_addr());
            pstmt.setString(idx++, vo.getStore_tel());
            pstmt.setString(idx++, vo.getOpen_time());
            pstmt.setInt(idx++,    vo.getMin_order_price());
            pstmt.setString(idx++, vo.getPrepare_time());
            
            // [추가] 환불 정책 파라미터 세팅
            pstmt.setString(idx++, vo.getRefund_policy_24());
            pstmt.setString(idx++, vo.getRefund_policy_12());
            pstmt.setString(idx++, vo.getRefund_policy_0());
            
            if (vo.getFilename() != null && !vo.getFilename().isEmpty()) {
                pstmt.setString(idx++, vo.getFilename());
            }
            pstmt.setLong(idx++, vo.getStore_id());
            result = pstmt.executeUpdate();
        } finally { DB.close(con, pstmt, rs); }
        return result;
    }

    // (getTotalRow, search, searchDataSet 메서드는 기존과 동일하므로 유지)
    public Long getTotalRow(PageObject pageObject) throws Exception {
        Long totalRow = 0L;
        try {
            con = DB.getConnection();
            String sql = "select count(*) from store where 1=1 " + search(pageObject);
            pstmt = con.prepareStatement(sql);
            searchDataSet(pstmt, 1, pageObject);
            rs = pstmt.executeQuery();
            if (rs.next()) totalRow = rs.getLong(1);
        } finally { DB.close(con, pstmt, rs); }
        return totalRow;
    }

    private String search(PageObject pageObject) {
        String sql = "";
        String key  = pageObject.getKey();
        String word = pageObject.getWord();
        if (word != null && !word.equals("")) {
            sql += " and ( 1=0 ";
            if (key.indexOf("n") >= 0) sql += " or store_name like ? ";
            if (key.indexOf("c") >= 0) sql += " or store_cate like ? ";
            sql += " ) ";
        }
        return sql;
    }

    private int searchDataSet(java.sql.PreparedStatement pstmt, int idx, PageObject pageObject) throws Exception {
        String word = pageObject.getWord();
        if (word != null && !word.equals("")) {
            String key = pageObject.getKey();
            if (key.indexOf("n") >= 0) pstmt.setString(idx++, "%" + word + "%");
            if (key.indexOf("c") >= 0) pstmt.setString(idx++, "%" + word + "%");
        }
        return idx;
    }
}