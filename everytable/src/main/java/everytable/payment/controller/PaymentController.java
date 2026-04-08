package everytable.payment.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.LoginVO;
import everytable.payment.vo.PaymentVO;
import everytable.util.page.PageObject;
import jakarta.servlet.http.HttpServletRequest;

public class PaymentController implements Controller {

    public String execute(HttpServletRequest request) {
        request.setAttribute("url", request.getRequestURL());
        try { 
            String uri = request.getServletPath();
            PaymentVO vo;
            Integer result;
            Long no;

            switch (uri) {
                case "/payment/list.do":
                    PageObject pageObject = PageObject.getInstance(request);
                    request.setAttribute("list", Execute.execute(Init.getService(uri), pageObject));
                    request.setAttribute("pageObject", pageObject);
                    return "payment/list";

                case "/payment/view.do":
                    no = Long.parseLong(request.getParameter("no"));
                    // 중복 호출 제거: 한 번만 가져와서 변수에 담기
                    vo = (PaymentVO) Execute.execute(Init.getService(uri), no);
                    
                    if (vo != null && vo.getPickupDate() != null) {
                        long now = new java.util.Date().getTime();
                        long pickup = vo.getPickupDate().getTime();
                        long diffHours = (pickup - now) / (1000 * 60 * 60);
                        request.setAttribute("diffHours", diffHours);
                    }
                    request.setAttribute("vo", vo);
                    return "payment/view";

                case "/payment/writeForm.do":
                    // 1. 주소창(이전화면)에서 넘어온 데이터 싹 다 낚아채기
                    String rNo = request.getParameter("resNo");
                    String sId = request.getParameter("store_id");
                    String tPrice = request.getParameter("totalPrice"); // 👈 돈 여기있음!
                    String pDate = request.getParameter("pickupDate");

                    // 2. 예약 번호가 있으면 실행
                    if (rNo != null && !rNo.equals("")) {
                        no = Long.parseLong(rNo);
                        
                        // DB에서 기본 정보를 가져옴 (필요없으면 이 줄은 빼도 됨)
                        vo = (PaymentVO) Execute.execute(Init.getService("/payment/view.do"), no);
                        
                        // DB에 정보가 없더라도 새로 만들어서 데이터 세팅
                        if(vo == null) vo = new PaymentVO();
                        
                        // 🌟 이전 화면에서 받아온 소중한 데이터들 vo에 쏙쏙 담기
                        vo.setOrder_id(no);
                        
                        // 금액(totalPrice) 담기 - 숫자로 변환해서!
                        if(tPrice != null && !tPrice.isEmpty()) {
                            vo.setAmount(Long.parseLong(tPrice)); 
                        }
                        
                        // 날짜 담기
                        if(pDate != null && !pDate.isEmpty()) {
                            try {
                                vo.setPickupDate(java.sql.Date.valueOf(pDate));
                            } catch(Exception e) { /* 날짜에러방지 */ }
                        }
                        
                        // 3. JSP로 바구니(vo) 던지기
                        request.setAttribute("vo", vo);
                        
                        // 4. store_id는 vo에 자리가 없으면 따로라도 던지기!
                        request.setAttribute("store_id", sId); 
                    }
                    return "payment/writeForm";

                case "/payment/write.do":
                    vo = new PaymentVO();
                    
                    // 1. 이전 화면(JSP)에서 보낸 데이터들 낚아채기
                    String orderIdStr = request.getParameter("order_id"); 
                    String amountStr = request.getParameter("amount");
                    String pickupDateStr = request.getParameter("pickupDate");
                    String userId = request.getParameter("user_id");
                    String method = request.getParameter("method");
                    String storeId = request.getParameter("store_id"); // 시은님이 꼭 필요하다던 그거!

                    // 2. 글자(String)를 숫자(Long)로 바꿔서 VO에 넣기 (안전장치 포함)
                    if (orderIdStr != null && !orderIdStr.isEmpty()) {
                        vo.setOrder_id(Long.parseLong(orderIdStr)); 
                    }
                    if (amountStr != null && !amountStr.isEmpty()) {
                        vo.setAmount(Long.parseLong(amountStr)); 
                    }
                    
                    // 3. 나머지 정보들도 VO에 담기
                    vo.setUser_id(userId);
                    vo.setMethod(method);
                    vo.setStore_id(storeId); // VO에 필드 있다면 이것도 쏙!
                    vo.setStatus("SUCCESS"); // 결제 성공 상태로 강제 세팅

                    // 4. 날짜 변환 처리
                    try {
                        if(pickupDateStr != null && !pickupDateStr.isEmpty()) {
                            vo.setPickupDate(java.sql.Date.valueOf(pickupDateStr));
                        }
                    } catch (Exception e) {
                        System.out.println("날짜 변환 에러 발생!");
                    }

                    // 5. DB에 저장하러 가기!
                    Execute.execute(Init.getService(uri), vo);
                    
                    request.getSession().setAttribute("msg", "결제가 완료되었습니다! 히히히");
                    return "redirect:list.do";
                    
                    
                case "/payment/updateForm.do":
                    LoginVO login = (LoginVO) request.getSession().getAttribute("login");
                    if (login == null || login.getGradeNo() != 9) {
                        request.getSession().setAttribute("msg", "관리자만 접근 가능합니다.");
                        return "redirect:list.do";
                    }
                    no = Long.parseLong(request.getParameter("no"));
                    request.setAttribute("vo", Execute.execute(Init.getService("/payment/view.do"), no));
                    return "payment/updateForm";

                case "/payment/update.do":
                    LoginVO loginForUpdate = (LoginVO) request.getSession().getAttribute("login");
                    if (loginForUpdate == null || loginForUpdate.getGradeNo() != 9) {
                        request.getSession().setAttribute("msg", "권한이 없습니다.");
                        return "redirect:list.do";
                    }

                    vo = new PaymentVO(); 
                    String payIdstr = request.getParameter("no"); 
                    if(payIdstr == null) payIdstr = request.getParameter("payment_id");
                    
                    if(payIdstr != null && !payIdstr.trim().equals("")) {
                        vo.setPayment_id(Long.parseLong(payIdstr));
                        vo.setStatus(request.getParameter("status"));
                        Execute.execute(Init.getService(uri), vo);
                    }
                    
                    request.getSession().setAttribute("msg", "상태가 변경되었습니다.");
                    return "redirect:view.do?no=" + payIdstr + "&" + PageObject.getInstance(request).getPageQuery();

                case "/payment/cancel.do":
                    no = Long.parseLong(request.getParameter("no"));
                    Execute.execute(Init.getService(uri), no);
                    request.getSession().setAttribute("msg", "결제가 취소되었습니다.");
                    return "redirect:view.do?no=" + no;        

                default:
                    return "error/noPage";
            } 
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("moduleName", "결제 관리");
            request.setAttribute("e", e);
            return "error/err_500";
        }
    }
}