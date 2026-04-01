package everytable.util.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import everytable.member.vo.LoginVO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet Filter implementation class AutorityFilter
 */
// @WebFilter("/AutorityFilter") -> web.xml에 설정. 여기는 반드시 주석처리한다.
public class AuthorityFilter extends HttpFilter implements Filter {
       
	private static final long serialVersionUID = 1L;

	private Map<String, Integer> authMap = new HashMap<>();
	
	/**
     * @see HttpFilter#HttpFilter()
     */
    public AuthorityFilter() { // 생성자
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() { // 소멸자
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 * 
	 * 필터 처리 메서드 - request, response 타입이 다르다.
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		// place your code here - 실행 전 필터 처리 : 권한 처리
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		
		String uri = req.getServletPath();
		
		System.out.println("AutorityFilter.doFilter().uri : " + uri);
		
		System.out.println("AutorityFilter.doFilter() 실행전 처리 : 권한 처리 ----------------------");

		Integer pageGradeNo = authMap.get(uri);
		
		if(pageGradeNo != null) {
			// 사용자가 로그인 처리가 되어 있어야만 한다.
			// 1. 로그인 정보를 가져온다.
			HttpSession session = req.getSession();
			LoginVO login = (LoginVO) session.getAttribute("login");
			// 2. 로그인이 안되었을 때 로그인 하라고 시킨다.
			if(login == null) {
				// 메시지 처리
				session.setAttribute("msg", "로그인이 필요한 페이지입니다.");
				res.sendRedirect("/member/loginForm.do");
				return;
			} // 로그인이 안되었을 때의 처리 끝
			
			// 로그인이 되었을 때의 관리자 처리
			if(pageGradeNo == 9) {
				// 관리자 권한이 아닌 경우의 처리 - 일반 회원인 경우(1)
				if(login.getGradeNo() < pageGradeNo) {
					req.setAttribute("url", req.getRequestURL());
					req.getRequestDispatcher("/WEB-INF/views/error/auth.jsp").forward(req, res);
					return;
				} // 관리자 권한 if의 끝
			} // 페이지의 권한이 관리자인 경우 끝
			
		} // if(pageGradeNo != null) 의 끝
		
		// pass the request along the filter chain
		chain.doFilter(request, response); // 요청에 따른 실제적인 실행
		
		// 실행 후 필터 처리
	}

	/**
	 * @see Filter#init(FilterConfig)
	 * 모든 페이지에 대한 권한 저장
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
		System.out.println("AutorityFilter.init()-------------------");
		
		// 공지사항
		// 1. 리스트. 2. 보기 - 일반 사용자. : 저장하지 않음.
		// 3. 글등록, 4. 수정, 5.삭제 - 관리자. : 저장함.
		// 모든 기능을 개발하고 권한 처리는 마지막에 하는 것이 편리하다.
		//authMap.put("/notice/writeForm.do", 9);
		//authMap.put("/notice/write.do", 9);
		//authMap.put("/notice/updateForm.do", 9);
		//authMap.put("/notice/update.do", 9);
		//authMap.put("/notice/delete.do", 9);
		
		// 회원관리 --------------------
		// 1.로그인, 2. 아이디 찾기, 3. 비밀번호 찾기, 4. 회원가입 - 일반 사용. : 저장하지 않음.
		// 5.로그아웃, 6. 내 정보보기, 7. 비밀번호 변경 - 회원 : 저장함 - 1
		// 회원 권한
		// authMap.put("/member/logout.do", 1);
		authMap.put("/member/view.do", 1);
		authMap.put("/member/changePw.do", 1);
		// 관리자 권한
		authMap.put("/member/list.do", 9);
		
		// 이미지 게시판 -----------------
		// 일반 회원
		authMap.put("/image/writeForm.do", 1);
		authMap.put("/image/write.do", 1);
		authMap.put("/image/updateForm.do", 1);
		authMap.put("/image/update.do", 1);
		authMap.put("/image/delete.do", 1);
		authMap.put("/image/changeImage.do", 1);
		
	}

}
