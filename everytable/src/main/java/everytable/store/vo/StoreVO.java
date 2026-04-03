package everytable.store.vo;

public class StoreVO {
    private long store_id;
    private String member_id;
    private double avg_rating;
    private int review_count;
    private String filename;
    private String store_name;
    private String store_cate;
    private String store_addr;
    private String store_tel;
    private String open_time;
    private int min_order_price;
    private String prepare_time;

    // Getter & Setter
    public long getStore_id() { return store_id; }
    public void setStore_id(long store_id) { this.store_id = store_id; }
    public String getMember_id() { return member_id; }
    public void setMember_id(String member_id) { this.member_id = member_id; }
    public double getAvg_rating() { return avg_rating; }
    public void setAvg_rating(double avg_rating) { this.avg_rating = avg_rating; }
    public int getReview_count() { return review_count; }
    public void setReview_count(int review_count) { this.review_count = review_count; }
    public String getFilename() { return filename; }
    public void setFilename(String filename) { this.filename = filename; }
    public String getStore_name() { return store_name; }
    public void setStore_name(String store_name) { this.store_name = store_name; }
    public String getStore_cate() { return store_cate; }
    public void setStore_cate(String store_cate) { this.store_cate = store_cate; }
    public String getStore_addr() { return store_addr; }
    public void setStore_addr(String store_addr) { this.store_addr = store_addr; }
    public String getStore_tel() { return store_tel; }
    public void setStore_tel(String store_tel) { this.store_tel = store_tel; }
    public String getOpen_time() { return open_time; }
    public void setOpen_time(String open_time) { this.open_time = open_time; }
    public int getMin_order_price() { return min_order_price; }
    public void setMin_order_price(int min_order_price) { this.min_order_price = min_order_price; }
    public String getPrepare_time() { return prepare_time; }
    public void setPrepare_time(String prepare_time) { this.prepare_time = prepare_time; }
}