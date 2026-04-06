package everytable.reservation.vo;

import java.util.List;

public class ReservationVO {
	
	private long resNo;
	private String userId;
	private String resDate;
	private String resTime;
	private long resCount;
	private String resPhone;
	private long resStatus;
	private long storeId;
	private String storeName;
	private String menuName;
	private long totalPrice;
	private String cancelReason;
	private String resCreatedAt;
	private String resType;
	private String orderAdd;
	private long quantity;
	private String userName;
	private String createdAt;
	private long orderItemNo;
	private long menuNo;
	private long price;
	private List<ReservationVO> orderList;
	
	public long getResNo() {
		return resNo;
	}
	public void setResNo(long resNo) {
		this.resNo = resNo;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getResDate() {
		return resDate;
	}
	public void setResDate(String resDate) {
		this.resDate = resDate;
	}
	public String getResTime() {
		return resTime;
	}
	public void setResTime(String resTime) {
		this.resTime = resTime;
	}
	public long getResCount() {
		return resCount;
	}
	public void setResCount(long resCount) {
		this.resCount = resCount;
	}
	public String getResPhone() {
		return resPhone;
	}
	public void setResPhone(String resPhone) {
		this.resPhone = resPhone;
	}
	public long getResStatus() {
		return resStatus;
	}
	public void setResStatus(long resStatus) {
		this.resStatus = resStatus;
	}
	public long getStoreId() {
		return storeId;
	}
	public void setStoreId(long storeId) {
		this.storeId = storeId;
	}
	public String getStoreName() {
		return storeName;
	}
	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}
	public String getMenuName() {
		return menuName;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}
	public long getTotalPrice() {
		return totalPrice;
	}
	public void setTotalPrice(long totalPrice) {
		this.totalPrice = totalPrice;
	}
	public String getCancelReason() {
		return cancelReason;
	}
	public void setCancelReason(String cancelReason) {
		this.cancelReason = cancelReason;
	}
	public String getResCreatedAt() {
		return resCreatedAt;
	}
	public void setResCreatedAt(String resCreatedAt) {
		this.resCreatedAt = resCreatedAt;
	}
	public String getResType() {
		return resType;
	}
	public void setResType(String resType) {
		this.resType = resType;
	}
	public String getOrderAdd() {
		return orderAdd;
	}
	public void setOrderAdd(String orderAdd) {
		this.orderAdd = orderAdd;
	}
	public long getQuantity() {
		return quantity;
	}
	public void setQuantity(long quantity) {
		this.quantity = quantity;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
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
	public long getPrice() {
		return price;
	}
	public void setPrice(long price) {
		this.price = price;
	}
	public List<ReservationVO> getOrderList() {
		return orderList;
	}
	public void setOrderList(List<ReservationVO> orderList) {
		this.orderList = orderList;
	}
	
	
	@Override
	public String toString() {
		return "ReservationVO [resNo=" + resNo + ", userId=" + userId + ", resDate=" + resDate + ", resTime=" + resTime
				+ ", resCount=" + resCount + ", resPhone=" + resPhone + ", resStatus=" + resStatus + ", storeId="
				+ storeId + ", storeName=" + storeName + ", menuName=" + menuName + ", totalPrice=" + totalPrice
				+ ", cancelReason=" + cancelReason + ", resCreatedAt=" + resCreatedAt + ", resType=" + resType
				+ ", orderAdd=" + orderAdd + ", quantity=" + quantity + ", userName=" + userName + ", createdAt="
				+ createdAt + ", orderItemNo=" + orderItemNo + ", menuNo=" + menuNo + ", price=" + price
				+ ", orderList=" + orderList + "]";
	}

	
	

}
