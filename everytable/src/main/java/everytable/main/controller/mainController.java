package everytable.main.controller;

import jakarta.servlet.http.HttpServletRequest;

public class mainController implements Controller {

	@Override
	public String execute(HttpServletRequest request) {
		// TODO Auto-generated method stub
        request.setAttribute("url", request.getRequestURL());
        try {
            String uri = request.getServletPath();

            switch (uri) {
            // --------------------------------------------------------
            // 메인화면
            // --------------------------------------------------------
            case "/main/main.do":
            		return "main/main";
            default:
                return "error/noPage";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("moduleName", "메인화면");
            request.setAttribute("e", e);
            return "error/err_500";
        }
	}
}