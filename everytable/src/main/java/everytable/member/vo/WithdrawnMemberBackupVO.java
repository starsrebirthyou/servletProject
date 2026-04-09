package everytable.member.vo;

public class WithdrawnMemberBackupVO {

	private long no;
	private String id;
	private String join_date;
	private String withdraw_date;
	private String backup_date;
	
	public long getNo() {
		return no;
	}
	public void setNo(long no) {
		this.no = no;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getJoin_date() {
		return join_date;
	}
	public void setJoin_date(String join_date) {
		this.join_date = join_date;
	}
	public String getWithdraw_date() {
		return withdraw_date;
	}
	public void setWithdraw_date(String withdraw_date) {
		this.withdraw_date = withdraw_date;
	}
	public String getBackup_date() {
		return backup_date;
	}
	public void setBackup_date(String backup_date) {
		this.backup_date = backup_date;
	}
	
	@Override
	public String toString() {
		return "WithdrawnMemberBackupVO [no=" + no + ", id=" + id + ", join_date=" + join_date + ", withdraw_date="
				+ withdraw_date + ", backup_date=" + backup_date + "]";
	}
	
}
