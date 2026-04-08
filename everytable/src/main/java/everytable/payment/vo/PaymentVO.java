package everytable.payment.vo;
import java.util.Date;

public class PaymentVO {
	private Long order_id;//주문번호
	private String user_id;//회원번호
	private String method;//결제수단 카드,통장입금
	private Long amount;// 결제금액
	private String status;//결제상태
	private Date payDate;//결제 일시
	private Date updateDate;//수정일시
	private Date pickupDate; //픽업예정 일시
	private Long payment_id; //고유번호
	private String store_id;
	
	public Long getOrder_id() {
		return order_id;
	}
	public void setOrder_id(Long order_id) {
		this.order_id = order_id;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getMethod() {
		return method;
	}
	public void setMethod(String method) {
		this.method = method;
	}
	public Long getAmount() {
		return amount;
	}
	public void setAmount(Long amount) {
		this.amount = amount;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getPayDate() {
		return payDate;
	}
	public void setPayDate(Date payDate) {
		this.payDate = payDate;
	}
	public Date getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	public Date getPickupDate() {
		return pickupDate;
	}
	public void setPickupDate(Date pickupDate) {
		this.pickupDate = pickupDate;
	}
	public Long getPayment_id() {
		return payment_id;
	}
	public void setPayment_id(Long payment_id) {
		this.payment_id = payment_id;
	}
	public String getStore_id() { return store_id; }
	public void setStore_id(String store_id) { this.store_id = store_id; }
	@Override
	public String toString() {
		return "PaymentVO [order_id=" + order_id + ", user_id=" + user_id + ", method=" + method + ", amount=" + amount
				+ ", status=" + status + ", payDate=" + payDate + ", updateDate=" + updateDate + ", pickupDate="
				+ pickupDate + ", payment_id=" + payment_id + ", store_id=" + store_id + "]";
	}
	
	
	
}