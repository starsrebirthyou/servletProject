package everytable.refund.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.payment.vo.PaymentVO;
import everytable.refund.vo.RefundVO;
import jakarta.servlet.http.HttpServletRequest;

public class RefundController implements Controller {

    public String execute(HttpServletRequest request) {
        // 오류 발생 시 URL 확인용
        request.setAttribute("url", request.getRequestURL());
        
        try {
            String uri = request.getServletPath();
            Object result;
            Long no;

            switch (uri) {
                // 1. 환불 신청
                case "/refund/refundForm.do":
                    // 글번호(주문번호) 받기
                    no = Long.parseLong(request.getParameter("no"));
                    
                    // 결제 정보 가져오기 (Init에서 서비스 가져와서 실행)
                    PaymentVO paymentVO = (PaymentVO) Execute.execute(Init.getService("/payment/view.do"), no);
                    
                    long now = new java.util.Date().getTime();
                    long pickup = paymentVO.getPickupDate().getTime();
                    long diffHours = (pickup - now) / (1000 * 60 * 60); // ms를 시간으로 변환
                    
                    int rate = 0;
                    if (diffHours >= 24) rate = 100;      // 24시간 전: 100%
                    else if (diffHours >= 12) rate = 50;  // 12시간 전: 50%
                    else {
                        // 12시간 미만이면 환불 불가 안내 후 돌아가기
                        request.getSession().setAttribute("msg", "픽업 12시간 이내라 환불이 안 돼요!");
                        return "redirect:/payment/view.do?no=" + no;
                    }
                    
                    long refundAmount = paymentVO.getAmount() * rate / 100;
                    // ----------------------------------
                    
                    request.setAttribute("vo", paymentVO);
                    request.setAttribute("refund_rate", rate);
                    request.setAttribute("refund_amount", refundAmount);
                    request.setAttribute("diffHours", diffHours);
                    
                    return "refund/refundForm"; // /WEB-INF/views/refund/refundForm.jsp

                // 2. 실제 환불 처리 (DB 저장)
                case "/refund/refund.do":
                    RefundVO vo = new RefundVO();
                    vo.setOrder_id(Long.parseLong(request.getParameter("order_id")));
                    vo.setUser_id(request.getParameter("user_id"));
                    vo.setRefund_amount(Long.parseLong(request.getParameter("refund_amount")));
                    vo.setRefund_rate(Long.parseLong(request.getParameter("refund_rate")));
                    vo.setReason(request.getParameter("reason")); // 사용자가 쓴 사유
                    
                    result = Execute.execute(Init.getService(uri), vo);
                    
                    if ((Integer)result == 1) {
                        request.getSession().setAttribute("msg", "환불 처리가 완료되었습니다!");
                    } else {
                        request.getSession().setAttribute("msg", "환불 실패되었습니다.");
                    }
                    
                    // 처리가 끝나면 리스트로 이동
                    return "redirect:/payment/list.do";

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