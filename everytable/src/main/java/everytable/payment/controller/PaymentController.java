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
                    // 🌟 이전 화면에서 보낸 파라미터 낚아채기
                    String strNo = request.getParameter("no"); // resNo
                    String totalPrice = request.getParameter("totalPrice");
                    String pickupDate = request.getParameter("pickupDate");

                    if (strNo != null && !strNo.equals("")) {
                        no = Long.parseLong(strNo);
                        // DB에서 정보를 가져오거나 새로 만듦
                        vo = (PaymentVO) Execute.execute(Init.getService("/payment/view.do"), no);
                        if (vo == null) vo = new PaymentVO();
                        
                        // 🌟 받아온 데이터 vo에 쏙쏙 담기 (그래야 JSP에서 ${vo.amount}로 나옴!)
                        vo.setOrder_id(no);
                        if(totalPrice != null) vo.setAmount(Long.parseLong(totalPrice));
                        if(pickupDate != null && !pickupDate.isEmpty()) {
                            try { vo.setPickupDate(java.sql.Date.valueOf(pickupDate)); } catch(Exception e) {}
                        }
                        
                        request.setAttribute("vo", vo);
                    }
                    return "payment/writeForm";

                case "/payment/write.do":
                    vo = new PaymentVO();
                    
                    // 1. JSP에서는 resNo(order_id)만 확실히 받습니다.
                    long orderId = Long.parseLong(request.getParameter("order_id"));
                    vo.setOrder_id(orderId);
                    
                    // 2. 🌟 여기서 마법! 예약 서비스(또는 DAO)를 호출해서 매장 아이디를 직접 가져옵니다.
                    // (이미 만들어진 예약 상세조회 서비스가 있다면 활용하세요!)
                    // 예시: ReservationVO resVO = (ReservationVO) Execute.execute(Init.getService("/reservation/view.do"), orderId);
                    // String storeIdFromDB = resVO.getStore_id(); 
                    
                    // 3. 만약 위 서비스 호출이 복잡하다면, 지금은 단순하게 파라미터로 처리하거나
                    // 결제 DAO의 write 메서드 안에서 subquery를 써도 됩니다. (아래 DAO 설명 참고)
                    
                    vo.setAmount(Long.parseLong(request.getParameter("amount")));
                    vo.setUser_id(request.getParameter("user_id"));
                    vo.setMethod(request.getParameter("method"));
                    vo.setStatus("SUCCESS");
                    
                    // 4. 나머지 날짜 세팅
                    String pDate = request.getParameter("pickupDate");
                    if(pDate != null) vo.setPickupDate(java.sql.Date.valueOf(pDate));

                    Execute.execute(Init.getService(uri), vo);
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