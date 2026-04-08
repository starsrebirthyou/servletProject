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
                    String strNo = request.getParameter("no");
                    if (strNo != null && !strNo.equals("")) {
                        no = Long.parseLong(strNo);
                        vo = (PaymentVO) Execute.execute(Init.getService("/payment/view.do"), no);
                        request.setAttribute("vo", vo);
                    }
                    return "payment/writeForm";

                case "/payment/write.do":
                    vo = new PaymentVO();
                    
                    String orderIdStr = request.getParameter("resNo"); 
                    String amountStr = request.getParameter("totalPrice");
                    String pickupDateStr = request.getParameter("pickupDate");

                    if (orderIdStr == null || orderIdStr.trim().isEmpty() || 
                        amountStr == null || amountStr.trim().isEmpty() ||
                        pickupDateStr == null || pickupDateStr.trim().isEmpty()) {
                        throw new Exception("필수 정보(주문번호, 금액, 픽업일)가 누락되었습니다.");
                    }

                    vo.setOrder_id(Long.parseLong(orderIdStr));
                    vo.setAmount(Long.parseLong(amountStr));
                    vo.setMethod(request.getParameter("method"));
                    vo.setUser_id(request.getParameter("user_id"));
                    vo.setStatus("SUCCESS");
                    
                    try {
                        vo.setPickupDate(java.sql.Date.valueOf(pickupDateStr));
                    } catch (Exception e) {
                        throw new Exception("날짜 형식이 잘못되었습니다. (YYYY-MM-DD)");
                    }

                    Execute.execute(Init.getService(uri), vo);
                    request.getSession().setAttribute("msg", "결제가 완료되었습니다.");
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