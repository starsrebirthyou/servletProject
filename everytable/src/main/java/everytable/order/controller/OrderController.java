package everytable.order.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.order.vo.OrderVO;
import jakarta.servlet.http.HttpServletRequest;

public class OrderController implements Controller {

	@Override
	public String execute(HttpServletRequest request) {
		// TODO Auto-generated method stub
		request.setAttribute("url", request.getRequestURL());
		
		try {
			String uri = request.getServletPath();
			
			OrderVO vo;
			
			switch (uri) {
			
			case "/order/writeForm.do":
				return "order/writeForm";
			
			case "/order/write.do":
				System.out.println("/order/write.do - 메뉴 주문 처리");
				
				vo = new OrderVO();
				
				// 사용자 입력
				vo.setOrderItemNo(Long.parseLong(request.getParameter("orderItemNo")));
				vo.setMenuName(request.getParameter("menuName"));
				vo.setQuantity(Long.parseLong(request.getParameter("quantity")));
				
				vo.setOrderAdd(request.getParameter("orderAdd"));
				
				// hidden으로 넘어온 값
				vo.setStoreName(request.getParameter("storeName"));
				
				// 불러오기 - 자동 계산
				vo.setMenuNo(Long.parseLong(request.getParameter("menuNo")));
				vo.setPrice(Long.parseLong(request.getParameter("price")));
				vo.setTotalPrice(Long.parseLong(request.getParameter("totalPrice")));
				
				Long resNo = (Long) Execute.execute(Init.getService(uri), vo);
				
				request.getSession().setAttribute("msg", "메뉴 주문이 완료되었습니다");
				
				return "rediredct:/order/view.do?resNo=" + resNo;
				
				
				
				
				
			
			} // switch~case 끝
			
		} catch (Exception e) {
			e.printStackTrace();
		} // try~catch 끝

		return null;
	}
}