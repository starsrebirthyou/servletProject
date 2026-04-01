package everytable.review.vo;

public class ReviewVO {

    private long reviewId;      // review_id (PK)
    private String content;     // content
    private String userId;      // user_id (작성자 ID)
    private String userName;    // name (작성자 이름)
    private long storeId;       // store_id
    private double rating;      // rating (별점)
    private int isDeleted;      // is_deleted (0: 정상, 1: 삭제)
    private String createdAt;   // created_at (작성일)
    private int sameId;         // 본인 확인용 (로그인 ID와 작성자 ID 비교)

    // Getter & Setter
    public long getReviewId() { return reviewId; }
    public void setReviewId(long reviewId) { this.reviewId = reviewId; }

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

    @Override
	public String toString() {
		return "ReviewVO [reviewId=" + reviewId + ", content=" + content + ", userId=" + userId + ", userName="
				+ userName + ", storeId=" + storeId + ", rating=" + rating + ", isDeleted=" + isDeleted + ", createdAt="
				+ createdAt + ", sameId=" + sameId + "]";
	}
}