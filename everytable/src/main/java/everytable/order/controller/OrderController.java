package everytable.order.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.order.vo.OrderVO;
import jakarta.servlet.http.HttpServletRequest;

public class OrderController implements Controller {

	@Override
	public String execute(HttpServletRequest request) {
	    request.setAttribute("url", request.getRequestURL());
	    
	    try {
	        String uri = request.getServletPath();
	        
	        // 1. 여기서 vo를 미리 선언만 해둡니다.
	        OrderVO vo = null; 
	        
	        switch (uri) {
	            case "/order/writeForm.do":
	                return "order/writeForm";
	            
	            case "/order/write.do":
	                System.out.println("/order/write.do - 메뉴 주문 처리");
	                
	                // 2. [주의] 'OrderVO vo = ...' 가 아니라 그냥 'vo = ...' 라고 써야 합니다!
	                vo = new OrderVO(); 
	                
	                // JSP에서 보내는 배열 데이터 받기
	                String[] menuNos = request.getParameterValues("menuNos");
	                String[] quantities = request.getParameterValues("quantities");
	                String strStoreId = request.getParameter("storeId");
	                String strTotalPrice = request.getParameter("totalPrice");

	                // 기본 정보 세팅 (null 체크)
	                vo.setStoreId((strStoreId != null && !strStoreId.equals("")) ? Long.parseLong(strStoreId) : 0L);
	                vo.setTotalPrice((strTotalPrice != null && !strTotalPrice.equals("")) ? Long.parseLong(strTotalPrice) : 0L);
	                
	                // 수량이 0보다 큰 첫 번째 메뉴만 우선 담기 (에러 방지용)
	                if (menuNos != null && quantities != null) {
	                    for(int i=0; i < menuNos.length; i++) {
	                        if(!quantities[i].equals("0")) {
	                            vo.setMenuNo(Long.parseLong(menuNos[i]));
	                            vo.setQuantity(Long.parseLong(quantities[i]));
	                            break; 
	                        }
	                    }
	                }

	                // 서비스 실행
	                Long resNo = (Long) Execute.execute(Init.getService(uri), vo);
	                
	                request.getSession().setAttribute("msg", "메뉴 주문이 완료되었습니다.");
	                
	                // redirect 스펠링 확인 필수!
	                return "redirect:/order/view.do?resNo=" + resNo;
	                
	        } // switch 끝
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}
}