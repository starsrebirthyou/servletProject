package everytable.util.filter;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import everytable.member.vo.LoginVO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthorityFilter extends HttpFilter implements Filter {

	private static final long serialVersionUID = 1L;

	private Map<String, Set<Integer>> authMap = new HashMap<>();

	public AuthorityFilter() {
		super();
	}
	public void destroy() {
	}


	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

		String uri = req.getServletPath();

		System.out.println("AuthorityFilter.doFilter().uri : " + uri);

		Set<Integer> allowGrades = authMap.get(uri);

		// 권한 설정이 없으면 그냥 통과
		if (allowGrades == null) {
			chain.doFilter(request, response);
			return;
		}

		// 비로그인 허용 페이지
		if (allowGrades.contains(0)) {
			chain.doFilter(request, response);
			return;
		}

		HttpSession session = req.getSession();
		LoginVO login = (LoginVO) session.getAttribute("login");

		// 1. 로그인이 안 된 경우
		if (login == null) {
			session.setAttribute("msg", "로그인이 필요한 페이지입니다.");
			res.sendRedirect("/member/loginForm.do");
			return;
		}

		// 2. 로그인은 했지만 권한이 없는 경우
		if (!allowGrades.contains(login.getGradeNo())) {
			req.setAttribute("url", req.getRequestURL());
			req.getRequestDispatcher("/WEB-INF/views/error/auth.jsp").forward(req, res);
			return;
		}

		chain.doFilter(request, response);
	}

	@Override
	public void init(FilterConfig fConfig) throws ServletException {
		System.out.println("AuthorityFilter.init() -------------------");

		// 회원관리 권한 설정
		// 로그인 필요
		authMap.put("/member/view.do", Set.of(1, 2, 9));
		authMap.put("/member/changePw.do", Set.of(1, 2, 9));
		authMap.put("/member/changeTel.do", Set.of(1, 2, 9));
		authMap.put("/member/changeEmail.do", Set.of(1, 2, 9));
		authMap.put("/member/withdraw.do", Set.of(1, 2, 9));

		authMap.put("/member/list.do", Set.of(9));
		authMap.put("/member/memberInfo.do", Set.of(9));
		authMap.put("/member/changeStatus.do", Set.of(9));
		authMap.put("/member/changeGrade.do", Set.of(9));
		authMap.put("/member/resetPw.do", Set.of(9));

		// 공지사항 권한 설정
		authMap.put("/notice/writeForm.do", Set.of(9));
		authMap.put("/notice/updateForm.do", Set.of(9));
		authMap.put("/notice/delete.do", Set.of(9));
		
		// [단체 주문 관련] 비로그인 허용 (권한 0으로 명시적 설정)
		authMap.put("/reservation/groupShare.do", Set.of(0));
		authMap.put("/reservation/groupMenuForm.do", Set.of(0));
		authMap.put("/reservation/groupOrderWrite.do", Set.of(0));
		authMap.put("/reservation/groupOrderComplete.do", Set.of(0));

		// 예약 관리자 기능
		authMap.put("/reservation/adminList.do", Set.of(2)); // 매장용
		authMap.put("/reservation/adminView.do", Set.of(2));
		authMap.put("/reservation/adminUpdate.do", Set.of(2));
	}
}