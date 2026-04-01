package everytable.payment.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.Login;
import everytable.payment.vo.PaymentVO;
import everytable.util.page.PageObject;

import jakarta.servlet.http.HttpServletRequest;

public class PaymentController implements Controller {

	public String execute(HttpServletRequest request) {
		request.setAttribute("url", request.getRequestURL());
		try { // 정상처리
			String uri = request.getServletPath();
			
			PaymentVO vo;
			Integer result;
			Long no;
			switch (uri) {
			case "/payment/list.do":
				PageObject pageObject = PageObject.getInstance(request);
				
				request.setAttribute("list", Execute.execute(Init.getService(uri), pageObject));
				System.out.println("PaymentController.execute().pageObject - " + pageObject);
				request.setAttribute("pageObject", pageObject);
				
				return "payment/list";

			case "/payment/view.do":
				no = Long.parseLong(request.getParameter("no"));

				request.setAttribute("vo", Execute.execute(Init.getService(uri), no));
				
				return "payment/view";
				
			case "/payment/writeForm.do":
				return "payment/writeForm";
				
			case "/payment/write.do":
				System.out.println("write.do - 결제 등록 처리");
				vo = new PaymentVO();
				vo.setOrder_id(Long.parseLong(request.getParameter("order_id")));
				vo.setAmount(Long.parseLong(request.getParameter("amount")));
				vo.setMethod(request.getParameter("method"));
				vo.setUser_id(request.getParameter("user_id"));
				vo.setStatus("SUCCESS");

				Execute.execute(Init.getService(uri), vo);
				
				request.getSession().setAttribute("msg", "결제가 완료되었습니다.");
				
				return "redirect:list.do";
				
			case "/payment/updateForm.do":
//				if(Login==null|| Login.getGradeNo()!=9) {
//					session.setAttribute("msg","관리자 권한이 필요한 서비스입니다");
//					return "redirect:list.do";
//					}
//				else{}
					no=Long.parseLong(request.getParameter("no"));
					request.setAttribute("vo",Execute.execute(Init.getService("/payment/view.do"),no));
					return "payment/updateForm";
					
			case "/payment/update.do":
			    pageObject = PageObject.getInstance(request);
			    
			    vo = new PaymentVO();
			    
			    String strId = request.getParameter("order_id");
			    if(strId != null && !strId.trim().equals("")) {
			        vo.setOrder_id(Long.parseLong(strId));
			    } else {
			        return "payment/view.do"; 
			    }
			    
			    vo.setStatus(request.getParameter("status"));
			    
			    result = (Integer) Execute.execute(Init.getService(uri), vo);
			
			    if(result == 1) request.getSession().setAttribute("msg", "수정 완료!");
			    else request.getSession().setAttribute("msg", "수정 실패!");
			    
			    return "redirect:view.do?no=" + vo.getOrder_id() + "&" + pageObject.getPageQuery();
			
			case"/payment/cancel.do":
				no= Long.parseLong(request.getParameter("no"));
				Execute.execute(Init.getService(uri), no);
				request.getSession().setAttribute("msg", "결제 취소되었습니다.");
				return "redirect:view.do?no=" + no;		
				
			default:
				return "error/noPage";
			} // switch ~ case 의 끝
		} // try 정상처리 의 끝
		catch (Exception e) { // 예외 처리
			e.printStackTrace();
			request.setAttribute("moduleName", "결제 관리");
			request.setAttribute("e", e);
			return "error/err_500";
		} // catch 의 끝
		
	} // execute()의 끝
	
} // 클래스의 끝