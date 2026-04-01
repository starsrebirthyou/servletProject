package everytable.menu.controller;

import jakarta.servlet.http.HttpServletRequest;
import everytable.main.controller.Controller;
import everytable.main.controller.Init;

public class MenuController implements Controller {

    @Override
    public String execute(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String jsp = "";
        
        try {
            switch (uri) {
                case "/menu/list.do":
                    // 단독 메뉴 페이지가 필요할 경우 사용
                    Long store_id = Long.parseLong(request.getParameter("store_id"));
                    request.setAttribute("menuList", Init.getService(uri).service(store_id));
                    jsp = "menu/list";
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsp = "error/500";
        }
        return jsp;
    }
}