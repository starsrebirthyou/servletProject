package everytable.stats.dao;

import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.stats.vo.StatsVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class StatsDAO extends DAO {

    // 1. 서비스에서 호출하는 리포트 메서드
    public List<StatsVO> report(PageObject pageObject) throws Exception {
        return list(pageObject);
    }

    // 2. 과거 통계 리스트 조회 (store_stats_daily 테이블 활용)
    public List<StatsVO> list(PageObject pageObject) throws Exception {
        List<StatsVO> list = new ArrayList<>();
        try {
            con = DB.getConnection();
            String sql = "select stats_id, stats_date, store_id, order_count, total_sales, "
                        + " avg_order, review_count from store_stats_daily ";
            
            sql += search(pageObject);
            sql += " order by stats_date desc, stats_id desc ";

            sql = "select rownum rnum, stats_id, stats_date, store_id, order_count, total_sales, "
                        + " avg_order, review_count from (" + sql + ")";

            sql = "select rnum, stats_id, stats_date, store_id, order_count, total_sales, "
                        + " avg_order, review_count from (" + sql + ") where rnum between ? and ?";
            
            pstmt = con.prepareStatement(sql);
            int idx = 1;
            idx = searchDataSet(pstmt, idx, pageObject);
            pstmt.setLong(idx++, pageObject.getStartRow());
            pstmt.setLong(idx++, pageObject.getEndRow());
            
            rs = pstmt.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    StatsVO vo = new StatsVO();
                    vo.setStatsId(rs.getLong("stats_id"));
                    vo.setStatsDate(rs.getString("stats_date"));
                    vo.setStoreId(rs.getString("store_id"));
                    vo.setOrderCount(rs.getInt("order_count"));
                    vo.setTotalSales(rs.getDouble("total_sales"));
                    vo.setAvgOrder(rs.getDouble("avg_order"));
                    vo.setReviewCount(rs.getInt("review_count"));
                    list.add(vo);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            DB.close(con, pstmt, rs);
        }
        return list;
    }

    // 3. 전체 데이터 개수 (페이징용)
    public Long getTotalRow(PageObject pageObject) throws Exception {
        Long totalRow = 0L;
        try {
            con = DB.getConnection();
            String sql = "select count(*) from store_stats_daily ";
            sql += search(pageObject);
            pstmt = con.prepareStatement(sql);
            int idx = 1;
            idx = searchDataSet(pstmt, idx, pageObject);
            rs = pstmt.executeQuery();
            if (rs != null && rs.next()) {
                totalRow = rs.getLong(1);
            }
        } finally {
            DB.close(con, pstmt, rs);
        }
        return totalRow;
    }

    // --- [여기서부터 대시보드 실시간 연동을 위해 추가된 메서드들입니다] ---

    /**
     * 4. 대시보드 상단 카드용: 오늘의 실시간 요약 (오늘 매출액, 오늘 주문건수)
     * 테이블: orders (실시간 주문 테이블)
     */
    public StatsVO getTodaySummary(String storeId) throws Exception {
        StatsVO vo = new StatsVO();
        try {
            con = DB.getConnection();
            // 오늘(SYSDATE) 날짜의 매출 합계와 주문 개수를 구함
            String sql = "SELECT NVL(SUM(total_price), 0) as sales, COUNT(*) as cnt "
                       + "FROM orders "
                       + "WHERE store_id = ? "
                       + "AND TO_CHAR(created_at, 'YYYYMMDD') = TO_CHAR(SYSDATE, 'YYYYMMDD')";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, storeId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                vo.setTotalSales(rs.getDouble("sales"));
                vo.setOrderCount(rs.getInt("cnt"));
            }
        } finally {
            DB.close(con, pstmt, rs);
        }
        return vo;
    }

    /**
     * 5. 카테고리별 판매량 (도넛 차트용)
     * 테이블 조인: order_item + menu + menu_category
     */
    public List<StatsVO> getCategorySales(String storeId) throws Exception {
        List<StatsVO> list = new ArrayList<>();
        try {
            con = DB.getConnection();
            // 카테고리별로 그룹화하여 판매 수량(quantity) 합산
            String sql = "SELECT mc.category_name, SUM(oi.quantity) as qty "
                       + "FROM order_item oi "
                       + "JOIN menu m ON oi.menu_no = m.menu_no "
                       + "JOIN menu_category mc ON m.category_no = mc.category_no "
                       + "JOIN orders o ON oi.order_id = o.order_id "
                       + "WHERE o.store_id = ? "
                       + "GROUP BY mc.category_name "
                       + "ORDER BY qty DESC";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, storeId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                StatsVO vo = new StatsVO();
                // VO의 storeId 필드에 임시로 카테고리명을 담거나, VO에 별도 필드를 추가하세요.
                vo.setStoreId(rs.getString("category_name")); 
                vo.setOrderCount(rs.getInt("qty"));
                list.add(vo);
            }
        } finally {
            DB.close(con, pstmt, rs);
        }
        return list;
    }

    // --- [기존 유틸리티 메서드] ---
    private String search(PageObject pageObject) {
        String sql = "";
        String word = pageObject.getWord();
        if (word != null && word.length() != 0) {
            sql += " where store_id like ? ";
        }
        return sql;
    }

    private int searchDataSet(PreparedStatement pstmt, int idx, PageObject pageObject) throws Exception {
        String word = pageObject.getWord();
        if (word != null && word.length() != 0) {
            pstmt.setString(idx++, "%" + word + "%");
        }
        return idx;
    }
}