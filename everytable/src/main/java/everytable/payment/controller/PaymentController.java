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
                    // 주소창(?totalPrice=72000)에서 데이터를 낚아챕니다.
                    String tPrice = request.getParameter("totalPrice");
                    String rNo = request.getParameter("resNo");

                    vo = new PaymentVO();
                    if (tPrice != null && !tPrice.equals("")) vo.setAmount(Long.parseLong(tPrice));
                    if (rNo != null && !rNo.equals("")) vo.setOrder_id(Long.parseLong(rNo));

                    request.setAttribute("vo", vo); // 이제 JSP에서 ${vo.amount}로 나옵니다!
                    return "payment/writeForm";

                case "/payment/write.do":
                    try {
                        vo = new PaymentVO();
                        vo.setOrder_id(Long.parseLong(request.getParameter("order_id")));
                        vo.setAmount(Long.parseLong(request.getParameter("amount")));
                        vo.setUser_id(request.getParameter("user_id"));
                        vo.setMethod(request.getParameter("method"));
                        
                        // store_id 세팅
                        String storeIdStr = request.getParameter("store_id");
                        if(storeIdStr != null && !storeIdStr.isEmpty()) {
                            vo.setStoreid(Long.parseLong(storeIdStr));
                        } else {
                            vo.setStoreid(73L); 
                        }
                        
                        // ★ 수정: DAO와 맞게 초기 상태를 "결제대기"로 설정 ★
                        vo.setStatus("status"); 
                        
                        String pDate = request.getParameter("pickupDate");
                        if(pDate != null && !pDate.isEmpty()) {
                            vo.setPickupDate(java.sql.Date.valueOf(pDate));
                        } else {
                            vo.setPickupDate(new java.sql.Date(System.currentTimeMillis()));
                        }

                        Execute.execute(Init.getService(uri), vo);
                        
                        // 메시지도 "완료"보다는 "접수" 느낌으로 수정하면 더 자연스럽습니다.
                        request.getSession().setAttribute("msg", "결제 요청이 접수되었습니다! 매장 승인을 기다려주세요.");
                        return "redirect:list.do";
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new Exception("결제 처리 중 오류: " + e.getMessage());
                    }
                   
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