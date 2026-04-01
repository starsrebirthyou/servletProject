package everytable.stats.dao;

import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.stats.vo.StatsVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class StatsDAO extends DAO {

    // [추가] Service에서 호출하는 메서드 이름이 report이므로 추가함
    public List<StatsVO> report(PageObject pageObject) throws Exception {
        return list(pageObject);
    }

    // 1. 통계 리스트 조회 (대시보드 및 목록용)
    public List<StatsVO> list(PageObject pageObject) throws Exception {
        
        List<StatsVO> list = new ArrayList<>();
        
        try {
            con = DB.getConnection();
            
            // 3-1. 원본 데이터 정렬 및 검색 조건 추가
            String sql = "select stats_id, stats_date, store_id, order_count, total_sales, "
                        + " avg_order, review_count from store_stats_daily ";
            
            // 검색 조건 붙이기 (WHERE store_id LIKE ?)
            sql += search(pageObject);
            
            sql += " order by stats_date desc, stats_id desc ";

            // 3-2. 순서 번호를 붙인다.
            sql = "select rownum rnum, stats_id, stats_date, store_id, order_count, total_sales, "
                        + " avg_order, review_count from (" + sql + ")";

            // 3-3. 페이지에 맞는 데이터만 가져온다.
            sql = "select rnum, stats_id, stats_date, store_id, order_count, total_sales, "
                        + " avg_order, review_count from (" + sql + ") where rnum between ? and ?";
            
            pstmt = con.prepareStatement(sql);
            int idx = 1;
            
            // [중요] 검색 데이터 세팅 (쿼리 순서상 rnum 조건인 ? 보다 앞에 위치해야 함)
            idx = searchDataSet(pstmt, idx, pageObject);
            
            pstmt.setLong(idx++, pageObject.getStartRow());
            pstmt.setLong(idx++, pageObject.getEndRow());
            
            rs = pstmt.executeQuery();
            
            if (rs != null) {
                while (rs.next()) {
                    StatsVO vo = new StatsVO();
                    vo.setStatsId(rs.getLong("stats_id"));
                    vo.setStatsDate(rs.getString("stats_date")); // 날짜 추가
                    vo.setStoreId(rs.getString("store_id"));
                    vo.setOrderCount(rs.getInt("order_count"));
                    vo.setTotalSales(rs.getDouble("total_sales"));
                    vo.setAvgOrder(rs.getDouble("avg_order"));
                    vo.setReviewCount(rs.getInt("review_count")); // 리뷰 개수 추가
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

    // 2. 전체 통계 데이터 개수 조회
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
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            DB.close(con, pstmt, rs);
        }
        return totalRow;
    }

    // 3. 검색 조건을 위한 메서드
    private String search(PageObject pageObject) {
        String sql = "";
        String word = pageObject.getWord();
        if (word != null && word.length() != 0) {
            sql += " where store_id like ? ";
        }
        return sql;
    }

    // 4. 검색 데이터 세팅 메서드
    private int searchDataSet(PreparedStatement pstmt, int idx, PageObject pageObject) throws Exception {
        String word = pageObject.getWord();
        if (word != null && word.length() != 0) {
            pstmt.setString(idx++, "%" + word + "%");
        }
        return idx;
    }

    // 5. 대시보드 전용 메서드
    public List<StatsVO> dashboard(PageObject pageObject) throws Exception {
        return list(pageObject);
    }
 // [추가] 기간별 매출 조회를 위한 메서드
    public List<StatsVO> salesPeriod(PageObject pageObject, String startDate, String endDate) throws Exception {
        List<StatsVO> list = new ArrayList<>();
        
        try {
            con = DB.getConnection();
            
            // 1. 기본 쿼리 작성 (날짜 범위 검색 조건 추가)
            String sql = " select stats_id, stats_date, store_id, order_count, total_sales, avg_order, review_count "
                       + " from store_stats_daily "
                       + " where stats_date between ? and ? "; // 날짜 조건
            
            // 매장 ID 검색이 필요하다면 추가
            if (pageObject.getWord() != null && !pageObject.getWord().equals("")) {
                sql += " and store_id like ? ";
            }
            
            sql += " order by stats_date desc ";

            // 2. 실행 객체 및 데이터 세팅
            pstmt = con.prepareStatement(sql);
            int idx = 1;
            pstmt.setString(idx++, startDate);
            pstmt.setString(idx++, endDate);
            
            if (pageObject.getWord() != null && !pageObject.getWord().equals("")) {
                pstmt.setString(idx++, "%" + pageObject.getWord() + "%");
            }
            
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
}