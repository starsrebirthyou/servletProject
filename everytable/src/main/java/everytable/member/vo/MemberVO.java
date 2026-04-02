package everytable.member.vo;

public class MemberVO {

	private long no;
	private String id; 		   // 일반회원 아이디
	private String pw; 		   // 현재 비밀번호
	private String newPw;	   // 바꿀 비밀번호
	private String name; 	   // 이름
	private String gender;     // 성별
	private String birth;  	   // 생년월일
	private String tel; 		   // 전화번호
	private String email; 	   // 이메일
	private String storeName;   // 매장 이름
	private String storeCate;   // 매장 카테고리
	private String storeAddr;   // 매장 주소
	private String status;  	   // 상태
	private Integer gradeNo;   // 등급 번호
	private String gradeName;  // 등급 이름
	private String joinDate;   // 가입일
	private String lastLogin;  // 최근 로그인 날짜
	
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
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getNewPw() {
		return newPw;
	}
	public void setNewPw(String newPw) {
		this.newPw = newPw;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getBirth() {
		return birth;
	}
	public void setBirth(String birth) {
		this.birth = birth;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getStatus() {
		return status;
	}
	public String getStoreName() {
		return storeName;
	}
	public void setStoreName(String storeName) {
		this.storeName = storeName;
	}
	public String getStoreCate() {
		return storeCate;
	}
	public void setStoreCate(String storeCate) {
		this.storeCate = storeCate;
	}
	public String getStoreAddr() {
		return storeAddr;
	}
	public void setStoreAddr(String storeAddr) {
		this.storeAddr = storeAddr;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Integer getGradeNo() {
		return gradeNo;
	}
	public void setGradeNo(Integer gradeNo) {
		this.gradeNo = gradeNo;
	}
	public String getGradeName() {
		return gradeName;
	}
	public void setGradeName(String gradeName) {
		this.gradeName = gradeName;
	}
	public String getJoinDate() {
		return joinDate;
	}
	public void setJoinDate(String joinDate) {
		this.joinDate = joinDate;
	}
	public String getLastLogin() {
		return lastLogin;
	}
	public void setLastLogin(String lastLogin) {
		this.lastLogin = lastLogin;
	}
	
	@Override
	public String toString() {
		return "MemberVO [no=" + no + ", id=" + id + ", pw=" + pw + ", newPw=" + newPw + ", name=" + name + ", gender="
				+ gender + ", birth=" + birth + ", tel=" + tel + ", email=" + email + ", storeName=" + storeName
				+ ", storeCate=" + storeCate + ", storeAddr=" + storeAddr + ", status=" + status + ", gradeNo="
				+ gradeNo + ", gradeName=" + gradeName + ", joinDate=" + joinDate + ", lastLogin=" + lastLogin + "]";
	}
	
}
