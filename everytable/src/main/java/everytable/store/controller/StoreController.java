package everytable.store.controller;

import jakarta.servlet.http.HttpServletRequest;
import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.util.page.PageObject;

public class StoreController implements Controller {

    @Override
    public String execute(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String jsp = "";
        
        try {
            switch (uri) {
                case "/store/list.do":
                    PageObject pageObject = PageObject.getInstance(request);
                    request.setAttribute("list", Init.getService(uri).service(pageObject));
                    request.setAttribute("pageObject", pageObject);
                    jsp = "store/list";
                    break;
                    
                case "/store/view.do":
                    String strStoreId = request.getParameter("store_id");
                    // 파라미터가 없으면 리스트로 리다이렉트 (방어 코드)
                    if (strStoreId == null || strStoreId.trim().isEmpty()) {
                        return "redirect:list.do";
                    }
                    
                    Long store_id = Long.parseLong(strStoreId);
                    request.setAttribute("vo", Init.getService(uri).service(store_id));
                    // 메뉴 서비스 호출 (메뉴 리스트도 함께 로드)
                    request.setAttribute("menuList", Init.getService("/menu/list.do").service(store_id));
                    jsp = "store/view";
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsp = "error/500";
        }
        return jsp;
    }
}