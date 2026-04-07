package everytable.review.vo;

public class ReviewVO {

    private long review_id;            // review_id (PK) -> 이름을 no로 변경
    private String content;     
    private String userId;      
    private String userName;    
    private long storeId;       
    private String storeName;       
    private double rating;      
    private int isDeleted;      
    private String createdAt;   
    private int sameId;         

    
    // no에 대한 Getter & Setter (이게 있어야 Controller의 에러가 사라집니다)
    public long getNo() { return review_id; }
    public void setNo(long no) { this.review_id = no; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public long getStoreId() { return storeId; }
    public void setStoreId(long storeId) { this.storeId = storeId; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getIsDeleted() { return isDeleted; }
    public void setIsDeleted(int isDeleted) { this.isDeleted = isDeleted; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public int getSameId() { return sameId; }
    public void setSameId(int sameId) { this.sameId = sameId; }

    public long getReview_id() {
		return review_id;
	}
	public void setReview_id(long review_id) {
		this.review_id = review_id;
	}
	public String getStoreName() {
		return storeName;
	}
	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}
	@Override
	public String toString() {
		return "ReviewVO [review_id=" + review_id + ", content=" + content + ", userId=" + userId + ", userName="
				+ userName + ", storeId=" + storeId + ", storeName=" + storeName + ", rating=" + rating + ", isDeleted="
				+ isDeleted + ", createdAt=" + createdAt + ", sameId=" + sameId + "]";
	}
}
