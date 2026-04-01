package everytable.member.vo;


public class Login {

	// 어디서나 누구나 접근 가능한 변수 선언 - Login을 생성하지 않고 바로 사용
	// 웹에서는 java static 변수를 사용하지 않고 session에 저장하거나 쿠키를 이용한다.
	public static LoginVO loginVO = null;
	
	// loginVO에 데이터 넣기 setter - 가져온 vo를 저장하면 로그인을 했다.
	public static void setLoginVO(LoginVO loginVO) {
		Login.loginVO = loginVO;
	}
	
	// 아이디를 받아가는 메서드
	public static String getId() {
		return loginVO.getId();
	}
	
	// 로그인이 되어있는가?
	public static boolean isLogin() {
		if(loginVO == null) return false;
		return true;
	}
	
	// 관리자인가?
	public static boolean isAdmin() throws Exception {
		// 로그인이 안 된 경우 처리
		if(loginVO == null) return false;
		// 로그인 된 경우 처리
		// - 관리자인 경우
		if(loginVO.getGradeNo() == 9) return true;
		// 관리자가 아닌 경우
		return false;
	}
	
	// 등급 번호를 받아간다
	public static int getGradeNo() {
		return loginVO.getGradeNo();
	}
	
	// 로그인 정보를 출력하는 메서드
	public static void LoginPrint() {
		System.out.println("+----------------------------------------------+");
		if(isLogin()) {  // 로그인 한 경우
			System.out.println("+ " + loginVO.getName() + "(" + loginVO.getId() + ")님은 "
					+ loginVO.getGradeName() + "(으)로 로그인하셨습니다. +");
		} else System.out.println("+ 게스트로 접속하셨습니다. 로그인해 주세요. +");
		System.out.println("+----------------------------------------------+");
	}
}
