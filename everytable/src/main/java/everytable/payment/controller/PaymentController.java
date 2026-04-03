package everytable.payment.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.Login;
import everytable.member.vo.LoginVO;
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
				PaymentVO paymentVO = (PaymentVO)Execute.execute(Init.getService(uri), no);
				request.setAttribute("vo", Execute.execute(Init.getService(uri), no));
				if (paymentVO != null && paymentVO.getPickupDate() != null) {
			        long now = new java.util.Date().getTime();
			        long pickup = paymentVO.getPickupDate().getTime();
			        long diffHours = (pickup - now) / (1000 * 60 * 60);
			        
			        request.setAttribute("diffHours", diffHours);
			        }
				request.setAttribute("vo", paymentVO);
				return "payment/view";
				
			case "/payment/writeForm.do":
				String strNo = request.getParameter("no");
				if(strNo != null) {
					no=Long.parseLong(strNo);
					paymentVO=(PaymentVO)Execute.execute(Init.getService("/payment/view.do"), no);
					request.setAttribute("vo", paymentVO);
				}
				
				return "payment/writeForm";
				
			case "/payment/write.do":
			    System.out.println("write.do - 결제 등록 처리");
			    vo = new PaymentVO();
			    
			    // 1. 파라미터 수집
			    String orderIdStr = request.getParameter("order_id");
			    String amountStr = request.getParameter("amount");
			    String pickupDateStr = request.getParameter("pickupDate"); // 픽업 날짜 추가

			    // 2. 필수 데이터 검증 
			    if (orderIdStr == null || orderIdStr.trim().isEmpty() || 
			        amountStr == null || amountStr.trim().isEmpty() ||
			        pickupDateStr == null || pickupDateStr.trim().isEmpty()) { // 픽업날짜 체크 추가
			        throw new Exception("주문 번호, 금액 또는 픽업 예정일이 입력되지 않았습니다.");
			    }

			    // 3. VO에 데이터 세팅
			    vo.setOrder_id(Long.parseLong(orderIdStr));
			    vo.setAmount(Long.parseLong(amountStr));
			    vo.setMethod(request.getParameter("method"));
			    vo.setUser_id(request.getParameter("user_id"));
			    vo.setStatus("SUCCESS");

			    // 4. 날짜 변환 (HTML5 date input: yyyy-mm-dd -> java.sql.Date)
			    try {
			        vo.setPickupDate(java.sql.Date.valueOf(pickupDateStr));
			    } catch (Exception e) {
			        // 혹시 날짜 형식이 잘못 넘어왔을 때를 대비한 안전장치
			        throw new Exception("픽업 날짜 형식이 올바르지 않습니다. (예: 2026-04-02)");
			    }

			    // 5. 서비스 실행
			    Execute.execute(Init.getService(uri), vo);
			    
			    request.getSession().setAttribute("msg", "결제가 완료되었습니다.");
			    return "redirect:list.do";
			    
				
			case "/payment/updateForm.do":
				LoginVO login = (LoginVO) request.getSession().getAttribute("login");

			    if (login == null || login.getGradeNo() != 9) {
			        request.getSession().setAttribute("msg", "관리자 권한이 필요한 서비스입니다.");
			        return "redirect:list.do"; // 권한 없으면 리스트로 튕기기
			    }

			    no = Long.parseLong(request.getParameter("no"));
			    request.setAttribute("vo", Execute.execute(Init.getService("/payment/view.do"), no));
			    
			    return "payment/updateForm";
			    
			    
			
			case "/payment/update.do":
			    // 1. 권한 체크 (세션에서 로그인 정보 가져오기)
			    LoginVO loginForUpdate = (LoginVO) request.getSession().getAttribute("login");
			    
			    // 관리자가 아니면 차단 (gradeNo가 9가 관리자라고 가정)
			    if (loginForUpdate == null || loginForUpdate.getGradeNo() != 9) {
			        request.getSession().setAttribute("msg", "권한이 없습니다.");
			        return "redirect:list.do";
			    }

			    // 2. 데이터 수집
			    vo = new PaymentVO(); 
			    String payIdstr = request.getParameter("no"); 
			    
			    // 만약 JSP hidden 태그 name이 "payment_id"라면 그대로 두셔도 되지만, 
			    // 안 바뀐다면 아래처럼 두 가지 다 체크해보는 게 안전합니다.
			    if(payIdstr == null) payIdstr = request.getParameter("payment_id");

			    String status = request.getParameter("status"); 
			    
			    System.out.println(">>> [확인] 넘어온 번호: " + payIdstr + ", 상태: " + status);

			    if(payIdstr != null && !payIdstr.trim().equals("")) {
			        vo.setPayment_id(Long.parseLong(payIdstr));
			        vo.setStatus(status);
			        
			        // 실행!
			        result = (Integer) Execute.execute(Init.getService(uri), vo);
			        System.out.println(">>> [확인] DB 수정 결과: " + result);
			    }
			    
			    // 리다이렉트 시에도 payIdstr를 사용하세요!
			    return "redirect:view.do?no=" + payIdstr + "&" + PageObject.getInstance(request).getPageQuery();
			    
			    
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