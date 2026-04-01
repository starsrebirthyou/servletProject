package everytable.order.controller;

import java.util.List;

import everytable.main.controller.Controller;
import everytable.order.service.OrderWriteService;
import jakarta.servlet.http.HttpServletRequest;

public class OrderController implements Controller {

	@Override
	public String execute(HttpServletRequest request) {
		// TODO Auto-generated method stub
		request.setAttribute("url", request.getRequestURL());
		
		try {
			String uri = request.getServletPath();
			
			switch(uri) {
			
			case "/order/writeForm.do":
			    // 1. 파라미터 수집 (앞 단계에서 넘겨준 storeId)
			    Long storeId = Long.parseLong(request.getParameter("storeId"));
			    
			    // 2. 서비스 호출 (해당 식당의 메뉴 리스트 가져오기)
			    // SQL: select * from menu where store_id = ?
			    OrderWriteService service = new OrderWriteService();
			    List<MenuVO> menuList = service.list(storeId);
			    
			    // 3. JSP로 데이터 전달
			    request.setAttribute("menuList", menuList);
			    request.setAttribute("storeId", storeId); // 다음 단계 전송용
			    
			    return "order/writeForm";
			
		} catch(Exception e) {
			e.printStackTrace();
		} // try~catch 끝
		
		return null;
	} // execute() 끝

}
