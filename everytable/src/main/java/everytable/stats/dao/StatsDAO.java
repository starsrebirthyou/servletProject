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

    // 2. 과거 통계 리스트 조회 (JOIN 추가 및 페이징 처리)
    public List<StatsVO> list(PageObject pageObject) throws Exception {
        List<StatsVO> list = new ArrayList<>();
        try {
            con = DB.getConnection();
            
            // JOIN을 사용하여 매장 이름(store_name)을 가져옴
            String sql = "select sd.stats_id, sd.stats_date, sd.store_id, s.store_name, sd.order_count, sd.total_sales, "
                        + " sd.avg_order, sd.review_count "
                        + " from store_stats_daily sd, store s "
                        + " where sd.store_id = s.store_id "; 
            
            String searchSql = search(pageObject);
            if (searchSql != null && !searchSql.equals("")) {
                sql += searchSql.replace("where", "and");
            }

            sql += " order by sd.stats_date desc, sd.stats_id desc ";

            sql = "select rownum rnum, stats_id, stats_date, store_id, store_name, order_count, total_sales, "
                        + " avg_order, review_count from (" + sql + ")";

            sql = "select rnum, stats_id, stats_date, store_id, store_name, order_count, total_sales, "
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
                    vo.setStoreName(rs.getString("store_name")); // VO에 추가한 필드에 세팅
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

    // 3. 전체 데이터 개수
    public Long getTotalRow(PageObject pageObject) throws Exception {
        Long totalRow = 0L;
        try {
            con = DB.getConnection();
            String sql = "select count(*) from store_stats_daily sd "; // Alias sd 추가
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

    // 4. 대시보드 상단 요약 (에러 해결을 위해 다시 추가)
    public StatsVO getTodaySummary(String storeId) throws Exception {
        StatsVO vo = new StatsVO();
        try {
            con = DB.getConnection();
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

    // 5. 카테고리별 판매량 (서비스 에러의 원인이었던 메서드)
    public List<StatsVO> getCategorySales(String storeId) throws Exception {
        List<StatsVO> list = new ArrayList<>();
        try {
            con = DB.getConnection();
            String sql = "SELECT mc.category_name, SUM(oi.quantity) as qty "
                       + "FROM menu_category mc "
                       + "JOIN menu m ON mc.category_no = m.category_no "
                       + "JOIN order_item oi ON m.menu_no = oi.menu_no "
                       + "WHERE m.store_id = ? "
                       + "GROUP BY mc.category_name "
                       + "ORDER BY qty DESC";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, storeId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                StatsVO vo = new StatsVO();
                vo.setStoreId(rs.getString("category_name")); 
                vo.setOrderCount(rs.getInt("qty"));
                list.add(vo);
            }
        } finally {
            DB.close(con, pstmt, rs);
        }
        return list;
    }

    private String search(PageObject pageObject) {
        String sql = "";
        String word = pageObject.getWord();
        if (word != null && word.length() != 0) {
            sql += " where sd.store_id like ? "; 
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