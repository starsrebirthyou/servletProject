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
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthorityFilter extends HttpFilter implements Filter {

	private static final long serialVersionUID = 1L;
	private Map<String, Integer> authMap = new HashMap<>();

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

		Integer pageGradeNo = authMap.get(uri); // 여기서 0을 가져옴

		if (pageGradeNo != null && pageGradeNo > 0) {
			HttpSession session = req.getSession();
			LoginVO login = (LoginVO) session.getAttribute("login");

			// 1. 로그인이 안되었을 때 처리
			if (login == null) {
				session.setAttribute("msg", "로그인이 필요한 페이지입니다.");
				res.sendRedirect("/member/loginForm.do");
				return;
			}

			// 2. 로그인은 되었으나 권한이 부족한 경우 (관리자 페이지 등)
			if (pageGradeNo == 9) {
				if (login.getGradeNo() < pageGradeNo) {
					req.setAttribute("url", req.getRequestURL());
					req.getRequestDispatcher("/WEB-INF/views/error/auth.jsp").forward(req, res);
					return;
				}
			}
		}

		// 권한이 없거나(null), 권한이 0인 경우 바로 실행
		chain.doFilter(request, response);
	}

	@Override
	public void init(FilterConfig fConfig) throws ServletException {
		System.out.println("AuthorityFilter.init() -------------------");

		// 회원관리 권한 설정
		authMap.put("/member/view.do", 1);
		authMap.put("/member/changePw.do", 1);
		authMap.put("/member/list.do", 9); // 관리자 전용

		// [단체 주문 관련] 비로그인 허용 (권한 0으로 명시적 설정)
		authMap.put("/reservation/groupShare.do", 0);
		authMap.put("/reservation/groupMenuForm.do", 0);
		authMap.put("/reservation/groupOrderWrite.do", 0);
		authMap.put("/reservation/groupOrderComplete.do", 0);

		// 이미지 게시판 권한 설정
		authMap.put("/image/writeForm.do", 1);
		authMap.put("/image/write.do", 1);
		authMap.put("/image/updateForm.do", 1);
		authMap.put("/image/update.do", 1);
		authMap.put("/image/delete.do", 1);
		authMap.put("/image/changeImage.do", 1);

		// 예약 관리자 기능
		authMap.put("/reservation/adminList.do", 1); // 매장용
		authMap.put("/reservation/adminView.do", 1);
		authMap.put("/reservation/adminUpdate.do", 1);
	}
}