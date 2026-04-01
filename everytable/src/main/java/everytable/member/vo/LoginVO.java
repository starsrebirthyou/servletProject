package everytable.member.vo;

// 로그인 처리할 때 필요한 정보. - 아이디, 비밀번호, 이름, 등급번호, 등급명
public class LoginVO {

	private String id;
	private String pw;
	private String name;
	private Integer gradeNo;
	private String gradeName;
	
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
	
	@Override
	public String toString() {
		return "LoginVO [id=" + id + ", pw=" + pw + ", name=" + name + ", gradeNo=" + gradeNo + ", gradeName="
				+ gradeName + "]";
	}
	
}
