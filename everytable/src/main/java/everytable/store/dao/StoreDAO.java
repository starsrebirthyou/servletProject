package everytable.store.dao;

import java.util.ArrayList;
import java.util.List;
import everytable.main.dao.DAO;
import everytable.store.vo.StoreVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class StoreDAO extends DAO {

    // 1. 매장 등록
    public int write(StoreVO vo) throws Exception {
        int result = 0;
        try {
            con = DB.getConnection();
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
            pstmt.setInt   (idx++, vo.getMin_order_price());
            pstmt.setString(idx++, vo.getPrepare_time());
            pstmt.setString(idx++, vo.getFilename());
            pstmt.setString(idx++, vo.getRefund_policy_24());
            pstmt.setString(idx++, vo.getRefund_policy_12());
            pstmt.setString(idx++, vo.getRefund_policy_0());
            result = pstmt.executeUpdate();
        } finally { DB.close(con, pstmt, rs); }
        return result;
    }

    // 2. 매장 리스트 조회 (페이징)
    public List<StoreVO> list(PageObject pageObject) throws Exception {
        List<StoreVO> list = null;
        try {
            con = DB.getConnection();
            String sql = "select * from ("
                       + "  select rownum rn, a.* from ("
                       + "    select * from store where 1=1 " + search(pageObject)
                       + "    order by store_id desc"
                       + "  ) a where rownum <= ?"
                       + ") where rn >= ?";
            pstmt = con.prepareStatement(sql);
            int idx = searchDataSet(pstmt, 1, pageObject);
            pstmt.setLong(idx++, pageObject.getEndRow());
            pstmt.setLong(idx++, pageObject.getStartRow());
            rs = pstmt.executeQuery();
            while (rs.next()) {
                if (list == null) list = new ArrayList<>();
                StoreVO vo = new StoreVO();
                vo.setStore_id        (rs.getLong  ("store_id"));
                vo.setMember_id       (rs.getString("member_id"));
                vo.setStore_name      (rs.getString("store_name"));
                vo.setStore_cate      (rs.getString("store_cate"));
                vo.setStore_addr      (rs.getString("store_addr"));
                vo.setStore_tel       (rs.getString("store_tel"));
                vo.setOpen_time       (rs.getString("open_time"));
                vo.setMin_order_price (rs.getInt   ("min_order_price"));
                vo.setPrepare_time    (rs.getString("prepare_time"));
                vo.setFilename        (rs.getString("filename"));
                vo.setAvg_rating      (rs.getDouble("avg_rating"));
                vo.setReview_count    (rs.getInt   ("review_count"));
                list.add(vo);
            }
        } finally { DB.close(con, pstmt, rs); }
        return list;
    }

    // 3. 매장 상세 보기
    public StoreVO view(Long store_id) throws Exception {
        StoreVO vo = null;
        try {
            con = DB.getConnection();
            String sql = "select * from store where store_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, store_id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                vo = new StoreVO();
                vo.setStore_id        (rs.getLong  ("store_id"));
                vo.setMember_id       (rs.getString("member_id"));
                vo.setStore_name      (rs.getString("store_name"));
                vo.setStore_cate      (rs.getString("store_cate"));
                vo.setStore_addr      (rs.getString("store_addr"));
                vo.setAvg_rating      (rs.getDouble("avg_rating"));
                vo.setReview_count    (rs.getInt   ("review_count"));
                vo.setFilename        (rs.getString("filename"));
                vo.setStore_tel       (rs.getString("store_tel"));
                vo.setOpen_time       (rs.getString("open_time"));
                vo.setMin_order_price (rs.getInt   ("min_order_price"));
                vo.setPrepare_time    (rs.getString("prepare_time"));
                vo.setRefund_policy_24(rs.getString("refund_policy_24"));
                vo.setRefund_policy_12(rs.getString("refund_policy_12"));
                vo.setRefund_policy_0 (rs.getString("refund_policy_0"));
            }
        } finally { DB.close(con, pstmt, rs); }
        return vo;
    }

    // 4. 매장 정보 수정
    public int update(StoreVO vo) throws Exception {
        int result = 0;
        try {
            con = DB.getConnection();
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
            pstmt.setInt   (idx++, vo.getMin_order_price());
            pstmt.setString(idx++, vo.getPrepare_time());
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

    // 5. member_id로 매장 조회
    public StoreVO findByMemberId(String memberId) throws Exception {
        StoreVO vo = null;
        try {
            con = DB.getConnection();
            String sql = "select * from store where member_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, memberId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                vo = new StoreVO();
                vo.setStore_id        (rs.getLong  ("store_id"));
                vo.setMember_id       (rs.getString("member_id"));
                vo.setStore_name      (rs.getString("store_name"));
                vo.setStore_cate      (rs.getString("store_cate"));
                vo.setStore_addr      (rs.getString("store_addr"));
                vo.setAvg_rating      (rs.getDouble("avg_rating"));
                vo.setReview_count    (rs.getInt   ("review_count"));
                vo.setFilename        (rs.getString("filename"));
                vo.setStore_tel       (rs.getString("store_tel"));
                vo.setOpen_time       (rs.getString("open_time"));
                vo.setMin_order_price (rs.getInt   ("min_order_price"));
                vo.setPrepare_time    (rs.getString("prepare_time"));
                vo.setRefund_policy_24(rs.getString("refund_policy_24"));
                vo.setRefund_policy_12(rs.getString("refund_policy_12"));
                vo.setRefund_policy_0 (rs.getString("refund_policy_0"));
            }
        } finally { DB.close(con, pstmt, rs); }
        return vo;
    }

    // 6. 전체 행 수 조회 (페이징용)
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
            if (key != null && key.indexOf("n") >= 0) sql += " or store_name like ? ";
            if (key != null && key.indexOf("a") >= 0) sql += " or store_addr like ? ";
            if (key != null && key.indexOf("c") >= 0) sql += " or store_cate like ? ";
            sql += " ) ";
        }
        return sql;
    }


    private int searchDataSet(java.sql.PreparedStatement pstmt, int idx, PageObject pageObject) throws Exception {
        String word = pageObject.getWord();
        if (word != null && !word.equals("")) {
            String key = pageObject.getKey();
            if (key != null && key.indexOf("n") >= 0) pstmt.setString(idx++, "%" + word + "%");
            if (key != null && key.indexOf("a") >= 0) pstmt.setString(idx++, "%" + word + "%");
            if (key != null && key.indexOf("c") >= 0) pstmt.setString(idx++, "%" + word + "%");
        }
        return idx;
    }
}