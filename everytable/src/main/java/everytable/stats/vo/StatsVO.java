package everytable.stats.vo;

public class StatsVO {
    // 테이블 컬럼과 정확히 매핑된 필드들
    private long statsId;       // stats_id (PK 자동증가 번호)
    private String statsDate;   // stats_date (통계 날짜)
    private String storeId;     // store_id (매장 고유번호)
    private String storeName;   // ★ 추가: 매장명 (상세 화면/리스트 표시용)
    private int orderCount;     // order_count (그날 주문 건수)
    private double totalSales;  // total_sales (그날 총 매출액)
    private double avgOrder;    // avg_order (주문당 평균 매출액)
    private int reviewCount;    // review_count (그날 리뷰 개수)
    
    // --- 추가 필드 (기간 검색 및 요약용) ---
    private String startDate;   // 검색 시작일
    private String endDate;     // 검색 종료일
    private double avgRating;   // 평균 별점
    private double totalSum;    // 조회된 기간의 총 매출 합계

    // --- Getter / Setter ---
    public long getStatsId() { return statsId; }
    public void setStatsId(long statsId) { this.statsId = statsId; }

    public String getStatsDate() { return statsDate; }
    public void setStatsDate(String statsDate) { this.statsDate = statsDate; }

    public String getStoreId() { return storeId; }
    public void setStoreId(String storeId) { this.storeId = storeId; }

    // ★ storeName Getter / Setter
    public String getStoreName() { return storeName; }
    public void setStoreName(String storeName) { this.storeName = storeName; }

    public int getOrderCount() { return orderCount; }
    public void setOrderCount(int orderCount) { this.orderCount = orderCount; }

    public double getTotalSales() { return totalSales; }
    public void setTotalSales(double totalSales) { this.totalSales = totalSales; }

    public double getAvgOrder() { return avgOrder; }
    public void setAvgOrder(double avgOrder) { this.avgOrder = avgOrder; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }

    public String getEndDate() { return endDate; }
    public void setEndDate(String endDate) { this.endDate = endDate; }

    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double avgRating) { this.avgRating = avgRating; }

    public double getTotalSum() { return totalSum; }
    public void setTotalSum(double totalSum) { this.totalSum = totalSum; }

    @Override
    public String toString() {
        return "StatsVO [statsId=" + statsId + ", statsDate=" + statsDate + ", storeId=" + storeId 
               + ", storeName=" + storeName + ", orderCount=" + orderCount + ", totalSales=" + totalSales 
               + ", avgOrder=" + avgOrder + ", reviewCount=" + reviewCount + "]";
    }
}