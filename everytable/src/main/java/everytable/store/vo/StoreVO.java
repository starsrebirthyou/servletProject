package everytable.store.vo;

public class StoreVO {
    private Long no;
    private String name;
    private String category;
    private String address;
    private Double avg_rating;
    private Integer review_count;
    private String fileName;
    // 상세페이지용 추가 필드
    private String tel;
    private String openTime;
    private Long minOrderPrice;
    private String deliveryTime;

    // Getter & Setter (전체 생성 필요)
    public Long getNo() { return no; }
    public void setNo(Long no) { this.no = no; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public Double getAvg_rating() { return avg_rating; }
    public void setAvg_rating(Double avg_rating) { this.avg_rating = avg_rating; }
    public Integer getReview_count() { return review_count; }
    public void setReview_count(Integer review_count) { this.review_count = review_count; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public String getTel() { return tel; }
    public void setTel(String tel) { this.tel = tel; }
    public String getOpenTime() { return openTime; }
    public void setOpenTime(String openTime) { this.openTime = openTime; }
    public Long getMinOrderPrice() { return minOrderPrice; }
    public void setMinOrderPrice(Long minOrderPrice) { this.minOrderPrice = minOrderPrice; }
    public String getDeliveryTime() { return deliveryTime; }
    public void setDeliveryTime(String deliveryTime) { this.deliveryTime = deliveryTime; }
}