package everytable.order.vo;

public class OrderVO {

	private long resNo;
	private long storeId;
	private String userId;
	private long totalPrice;
	private String createdAt;
	private String orderAdd;
	private long orderItemNo;
	private long menuNo;
	private long quantity;
	private long price;

	public long getResNo() {
		return resNo;
	}

	public void setResNo(long resNo) {
		this.resNo = resNo;
	}

	public long getStoreId() {
		return storeId;
	}

	public void setStoreId(long storeId) {
		this.storeId = storeId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(long totalPrice) {
		this.totalPrice = totalPrice;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}

	public String getOrderAdd() {
		return orderAdd;
	}

	public void setOrderAdd(String orderAdd) {
		this.orderAdd = orderAdd;
	}

	public long getOrderItemNo() {
		return orderItemNo;
	}

	public void setOrderItemNo(long orderItemNo) {
		this.orderItemNo = orderItemNo;
	}

	public long getMenuNo() {
		return menuNo;
	}

	public void setMenuNo(long menuNo) {
		this.menuNo = menuNo;
	}

	public long getQuantity() {
		return quantity;
	}

	public void setQuantity(long quantity) {
		this.quantity = quantity;
	}

	public long getPrice() {
		return price;
	}

	public void setPrice(long price) {
		this.price = price;
	}

	@Override
	public String toString() {
		return "OrderVO [resNo=" + resNo + ", storeId=" + storeId + ", userId=" + userId + ", totalPrice=" + totalPrice
				+ ", createdAt=" + createdAt + ", orderAdd=" + orderAdd + ", orderItemNo=" + orderItemNo + ", menuNo="
				+ menuNo + ", quantity=" + quantity + ", price=" + price + "]";
	}

}
