package everytable.main.controller;

import java.io.IOException;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DispatcherServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	String prefix = "/WEB-INF/views/"; 
	String suffix = ".jsp"; 
	
    public DispatcherServlet() {
        super();
		System.out.println("DispatcherServlet() 생성자 -------------------------------------");
		try {
	        Class.forName("everytable.main.controller.Init");
	        System.out.println("Init 클래스 로딩 성공!");
	    } catch (ClassNotFoundException e) {
	        e.printStackTrace();
	    }
    }

	public void init(ServletConfig config) throws ServletException {
		System.out.println("DispatcherServlet.init() -------------------------------------");
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    System.out.println("DispatcherServlet.service() -------------------------------------");
	    
	    // 0. URI 정보 가져오기
	    String uri = request.getRequestURI(); 
	    String contextPath = request.getContextPath(); // "/everytable"
	    
	    System.out.println("DispatcherServlet.service().originalUri = " + uri);
	    
	    // [강력 수정] ContextPath가 있다면 무조건 잘라냅니다.
	    if (contextPath != null && !contextPath.equals("") && uri.startsWith(contextPath)) {
	        uri = uri.substring(contextPath.length());
	    }
	    
	    // 결과가 "/reservation/groupMenuForm.do" 인지 확인하는 로그
	    System.out.println("DispatcherServlet.service().cleanedUri = " + uri);
	    
	    // 1. 홈페이지 리다이렉트 처리
	    if(uri.equals("/") || uri.equals("/main.do")) {
	        response.sendRedirect(contextPath + "/main/main.do");
	        return;
	    }
	    
	    // 2. 모듈 명 꺼내기 (예: "/reservation/list.do" -> "/reservation")
	    String module = "";
	    int pos = uri.indexOf("/", 1); // 두 번째 슬래시 위치 찾기
	    
	    if (pos != -1) {
	        module = uri.substring(0, pos);
	    } else {
	        // 슬래시가 하나뿐인 경우 (예: /main.do) 전체를 모듈로 시도
	        module = uri;
	    }
	    
	    System.out.println("DispatcherServlet.service().module = " + module);
	    
	    // [확인용] 만약 여전히 module이 /everytable 이라면 강제로 한 번 더 자름 (보험)
	    if (module.equals("/everytable")) {
	        uri = uri.substring(11); // "/everytable" 문자열 길이만큼 강제 커트
	        pos = uri.indexOf("/", 1);
	        module = (pos != -1) ? uri.substring(0, pos) : uri;
	        System.out.println("DispatcherServlet.service().module(Re-Try) = " + module);
	    }

	    // 모듈을 가지고 Controller를 꺼내오자
	    Controller controller = Init.getController(module);
	    
	    String jsp = null;
	    
	    // 3. 모듈 실행
	    if(controller != null) { 
	        System.out.println("DispatcherServlet.service().Controller : " + controller.getClass().getSimpleName());
	        jsp = controller.execute(request);
	    } else {
	        System.out.println("DispatcherServlet.service() [Error] - " + module + " 컨트롤러를 찾을 수 없습니다.");
	        jsp = "error/noPage";
	    }
	    
	    // 4. JSP 이동 처리
	    if(jsp == null) return; // jsp가 null이면 처리를 중단 (에러 방지)

	    if(jsp.startsWith("redirect:")) {
	        String moveUri = jsp.substring("redirect:".length());
	        if(!moveUri.startsWith("http")) moveUri = contextPath + moveUri;
	        response.sendRedirect(moveUri);
	    } else {
	        request.getRequestDispatcher(prefix + jsp + suffix).forward(request, response);
	    }
	}
}