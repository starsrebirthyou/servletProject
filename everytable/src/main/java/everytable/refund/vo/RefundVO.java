package everytable.refund.vo;
import java.util.Date;

public class RefundVO {
	private Long refund_id;//환불번호
	private Long payment_id;//결제번호
	private Long order_id;//주문번호
	private String user_id;//회원번호
	private Long refund_rate;//환불비율
	private Long refund_amount;// 환불금액
	private String reason;//환불사유
	private Date refundDate;//환불일시
	private String status;//상태
	public Long getRefund_id() {
		return refund_id;
	}
	public void setRefund_id(Long refund_id) {
		this.refund_id = refund_id;
	}
	public Long getPayment_id() {
		return payment_id;
	}
	public void setPayment_id(Long payment_id) {
		this.payment_id = payment_id;
	}
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
	public Long getRefund_rate() {
		return refund_rate;
	}
	public void setRefund_rate(Long refund_rate) {
		this.refund_rate = refund_rate;
	}
	public Long getRefund_amount() {
		return refund_amount;
	}
	public void setRefund_amount(Long refund_amount) {
		this.refund_amount = refund_amount;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public Date getRefundDate() {
		return refundDate;
	}
	public void setRefundDate(Date refundDate) {
		this.refundDate = refundDate;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	@Override
	public String toString() {
		return "RefundVO [refund_id=" + refund_id + ", payment_id=" + payment_id + ", order_id=" + order_id
				+ ", user_id=" + user_id + ", refund_rate=" + refund_rate + ", refund_amount=" + refund_amount
				+ ", reason=" + reason + ", refundDate=" + refundDate + ", status=" + status + "]";
	}
	
}
