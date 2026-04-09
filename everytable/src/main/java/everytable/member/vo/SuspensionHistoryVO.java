package everytable.member.vo;

public class SuspensionHistoryVO {
	private long no;
	private String userId;
	private String startDate;
	private String endDate;
	private String reason;
	private String adminId;
	
	public long getNo() {
		return no;
	}
	public void setNo(long no) {
		this.no = no;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public String getAdminId() {
		return adminId;
	}
	public void setAdminId(String adminId) {
		this.adminId = adminId;
	}
	
	@Override
	public String toString() {
		return "SuspensionHistoryVO [no=" + no + ", userId=" + userId + ", startDate=" + startDate + ", endDate="
				+ endDate + ", reason=" + reason + ", adminId=" + adminId + "]";
	}
	
}
