package everytable.store.controller;

import jakarta.servlet.http.HttpServletRequest;
import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.util.page.PageObject;

public class StoreController implements Controller {

    private final String MODULE = "store";

    @Override
    public String execute(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String jsp = "";
        
        try {
            switch (uri) {
                // 1. 매장 리스트
                case "/store/list.do":
                    PageObject pageObject = PageObject.getInstance(request);
                    pageObject.setPerPageNum(9); 
                    request.setAttribute("list", Init.getService(uri).service(pageObject));
                    request.setAttribute("pageObject", pageObject);
                    jsp = MODULE + "/list"; // /WEB-INF/views/store/list.jsp 로 이동
                    break;

                // 2. 매장 상세보기 (메뉴 리스트 포함)
                case "/store/view.do":
                    Long no = Long.parseLong(request.getParameter("no"));
                    // 매장 정보 가져오기
                    request.setAttribute("vo", Init.getService(uri).service(no));
                    // ★ 중요: 매장 상세 안에서 메뉴 리스트를 함께 서빙함
                    request.setAttribute("menuList", Init.getService("/menu/list.do").service(no));
                    jsp = MODULE + "/view"; // /WEB-INF/views/store/view.jsp 로 이동
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("exception", e);
            jsp = "error/500";
        }
        return jsp;
    }
}