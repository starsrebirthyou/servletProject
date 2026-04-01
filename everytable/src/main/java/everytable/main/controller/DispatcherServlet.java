package everytable.main.controller;

import java.io.IOException;

import jakarta.servlet.Servlet;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
// import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DispatcherServlet
 */
// @WebServlet() Spring lib DispatcherServlet을 수정을 못한다.
// 모든 설정은 web.xml에서 설정해서 사용한다. - web server가 실행될 때 처리되는 설정. 아래 어노테이션은 반드시 주석 처리한다.
// @WebServlet("/DispatcherServlet")
public class DispatcherServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	// jsp 로 forward 할 앞에 붙는 글자와 뒤에 붙는 글자를 저장해 놓은 변수.
	String prefix = "/WEB-INF/views/"; 
	String suffix = ".jsp"; 
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DispatcherServlet() {
        super();
        // TODO Auto-generated constructor stub
		System.out.println("DispatcherServlet() 생성자 -------------------------------------");
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */
    // 서버가 시작될 때 한번 호출한다. 단, web.xml에 servlet 태그 안에 load-on-starup 이 설정되어있어야만 한다.
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		System.out.println("DispatcherServlet.init() -------------------------------------");
	}

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	// Servlet에서 service()는 넘어오는 요청방식(get/post)과 상관없이 실행되는 메서드 - doGet이나 doPost 메서드 보다 우선 실행
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// 흐름 로그 출력
		System.out.println("DispatcherServlet.service() -------------------------------------");
		
		// 0. uri를 request에서 부터 가져 온다. 실제적으로는 path를 제외한 servletPath를 가져온다.
		String uri = request.getServletPath();
		System.out.println("DispatcherServlet.service().uri = " + uri);
		
		// 1. homepage 리다이렉트(변경 다시 요청) 처리  "/", "/main.do" -> "/main/main.do"
		if(uri.equals("/") || uri.equals("/main.do")) {
			response.sendRedirect("/main/main.do");
			return;
		}
		
		// 2. 모듈 명 꺼내기 - Controller 선택
		// 실행 모듈(Controller)을 선택하기 위한 모듈 이름 꺼내기
		int pos = uri.indexOf("/", 1);
		// pos가 -1이면 모듈이 없음. 요청하신 페이지 없음.
		if(pos == -1) {
			System.out.println("DispatcherServlet.service() - 요청하신 페이지가 존재하지 않습니다.");
			return;
		}
		String module = uri.substring(0, pos);
		// 모듈 출력하기
		System.out.println("DispatcherServlet.service().module = " + module);
		
		// 모듈을 가지고 Controller를 꺼내오자 : 선택
		Controller controller = Init.getController(module);
		
		String jsp = null;
		
		// 3. 모듈 실행
		if(controller != null) { 
			System.out.println("DispatcherServlet.service().Controller 이름 출력 : " + controller.getClass().getName());
			// 가져온 Controller를 실행해서 처리한다.
			jsp = controller.execute(request);
		} else {
			System.out.println("DispatcherServlet.service() - 요청하신 페이지가 존재하지 않습니다.");
			jsp = "error/noPage";
		}
		
		// 4. JSP로 forward 또는 redirect
		//  - JSP나 redirect의 정보는 각 Controller에서 결정이된다. 그래서 리턴 타입을 String 정의한다.
		//  jsp 변수 값의 맨 처음에 redirect:이 붙으면 redirect를 시킨다. 아니면 forward시킨다.
		System.out.println("DispatcherServlet.service().jsp - " + jsp);
		//  0이면 redirect 시킨다. 0이 아니면 forward 시킨다.
		int isRedirect = jsp.indexOf("redirect:");
		if(isRedirect == 0) {
			// 앞에 붙은 redirect: 은 제거하고 나머지 데이터로 리다렉트시킨다.
			response.sendRedirect(jsp.substring("redirect:".length()));
			return;
		} else {
			// jsp로 forward 시킨다.
			// /WEB-INF/views/ + board/list + .jsp
			request.getRequestDispatcher(prefix + jsp + suffix).forward(request, response);
			return;
		}
	}

}
