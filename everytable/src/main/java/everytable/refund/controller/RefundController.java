package everytable.refund.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.payment.vo.PaymentVO;
import everytable.refund.vo.RefundVO;
import jakarta.servlet.http.HttpServletRequest;

public class RefundController implements Controller {

    public String execute(HttpServletRequest request) {
        request.setAttribute("url", request.getRequestURL());
        
        try {
            String uri = request.getServletPath();
            Object result;
            Long no;

            switch (uri) {
                // 1. 환불 신청 폼
                case "/refund/refundForm.do":
                    String strNo = request.getParameter("no");
                    if (strNo == null || strNo.equals("")) {
                        request.getSession().setAttribute("msg", "잘못된 접근입니다. 주문 번호가 없어요!");
                        return "redirect:/payment/list.do";
                    }
                    no = Long.parseLong(strNo);
                    
                    // 결제 정보 가져오기 
                    PaymentVO paymentVO = (PaymentVO) Execute.execute(Init.getService("/payment/view.do"), no);
                    
                    long now = new java.util.Date().getTime();
                    long pickup = paymentVO.getPickupDate().getTime();
                    long diffHours = (pickup - now) / (1000 * 60 * 60);
                    
                    int rate = 0;
                    if (diffHours >= 24) rate = 100;
                    else if (diffHours >= 12) rate = 50;
                    else {
                        request.getSession().setAttribute("msg", "픽업 12시간 이내라 환불이 안 돼요!");
                        return "redirect:/payment/view.do?no=" + no;
                    }
                    
                    long refundAmount = paymentVO.getAmount() * rate / 100;
                    
                    request.setAttribute("vo", paymentVO);
                    request.setAttribute("refund_rate", rate);
                    request.setAttribute("refund_amount", refundAmount);
                    request.setAttribute("diffHours", diffHours);
                    
                    return "refund/refundForm";

                // 2. 실제 환불 처리 (DB 저장)
                case "/refund/refund.do":
                    RefundVO vo = new RefundVO();
                    vo.setOrder_id(Long.parseLong(request.getParameter("order_id")));
                    vo.setUser_id(request.getParameter("user_id"));
                    vo.setRefund_amount(Long.parseLong(request.getParameter("refund_amount")));
                    vo.setRefund_rate(Long.parseLong(request.getParameter("refund_rate")));
                    vo.setReason(request.getParameter("reason"));
                    vo.setPayment_id(Long.parseLong(request.getParameter("payment_id")));
                    
                    result = Execute.execute(Init.getService(uri), vo);
                    
                    if ((Integer)result == 1) {
                        request.getSession().setAttribute("msg", "환불 처리가 완료되었습니다!");
                        // 상세 페이지로 이동해서 바뀐 상태 확인
                        return "redirect:/payment/view.do?no=" + vo.getPayment_id(); 
                    } else {
                        request.getSession().setAttribute("msg", "환불 실패 했습니다.");
                        return "redirect:/payment/list.do";
                    }
                    // ★ 여기가 Unreachable code 였던 곳! (중복 리턴 삭제됨)

                default:
                    return "error/noPage";
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("moduleName", "환불 관리");
            request.setAttribute("e", e);
            return "error/err_500";
        }
    }
}