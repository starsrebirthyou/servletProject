package everytable.stats.vo;

public class StatsVO {
    private Long statsId;
    private String statsDate;
    private String storeId;
    private String storeName; // 추가된 필드
    private int orderCount;
    private double totalSales;
    private double avgOrder;
    private int reviewCount;

    // Getter & Setter
    public Long getStatsId() { return statsId; }
    public void setStatsId(Long statsId) { this.statsId = statsId; }
    public String getStatsDate() { return statsDate; }
    public void setStatsDate(String statsDate) { this.statsDate = statsDate; }
    public String getStoreId() { return storeId; }
    public void setStoreId(String storeId) { this.storeId = storeId; }
    
    // storeName Getter/Setter 추가
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
}