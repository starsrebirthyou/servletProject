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

 // 4. 대시보드 상단 요약
    public StatsVO getTodaySummary(String storeId) throws Exception {
        StatsVO vo = new StatsVO();
        try {
            con = DB.getConnection();
            
            String sql = "SELECT NVL(SUM(TOTAL_PRICE), 0) as sales, COUNT(ORDER_ID) as cnt "
                       + "FROM orders "
                       + "WHERE STORE_ID = ? "
                       + "AND TO_CHAR(CREATED_AT, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD')";
            
            pstmt = con.prepareStatement(sql);
            
            // [보완] storeId가 null이거나 비어있으면 기본값 "1"을 세팅하여 에러 방지
            if (storeId == null || storeId.trim().equals("")) {
                storeId = "1";
            }
            
            // 숫자로 변환하여 첫 번째 물음표(?)에 세팅
            pstmt.setInt(1, Integer.parseInt(storeId));
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                vo.setTotalSales(rs.getDouble("sales"));
                vo.setOrderCount(rs.getInt("cnt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            DB.close(con, pstmt, rs);
        }
        return vo;
    }

 // StatsDAO.java 수정 부분

    private String search(PageObject pageObject) {
        String sql = "";
        // 기존 store_id 검색 기능 유지
        String word = pageObject.getWord();
        if (word != null && word.length() != 0) {
            sql += " and sd.store_id like ? "; 
        }
        
        // [추가] 날짜 기간 검색 조건 (PageObject의 accept 데이터를 활용)
        // Controller에서 startDate와 endDate를 PageObject에 담아줘야 합니다.
        if (pageObject.getAccept() != null) {
            sql += " and sd.stats_date between ? and ? ";
        }
        
        return sql;
    }

    private int searchDataSet(PreparedStatement pstmt, int idx, PageObject pageObject) throws Exception {
        String word = pageObject.getWord();
        if (word != null && word.length() != 0) {
            pstmt.setString(idx++, "%" + word + "%");
        }
        
        // [추가] 날짜 데이터 세팅
        if (pageObject.getAccept() != null) {
            // accept 객체에 담긴 날짜 배열이나 맵을 사용 (아래 Controller 수정 참고)
            String[] dates = (String[]) pageObject.getAccept();
            pstmt.setString(idx++, dates[0]); // startDate
            pstmt.setString(idx++, dates[1]); // endDate
        }
        
        return idx;
    }}