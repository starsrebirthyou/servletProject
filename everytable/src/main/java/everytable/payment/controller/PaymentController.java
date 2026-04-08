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
                    // 1. 주소창에서 넘어온 데이터 낚아채기
                    String resNo = request.getParameter("resNo");
                    String store_id = request.getParameter("store_id");
                    String totalPrice = request.getParameter("totalPrice");
                    String pDate = request.getParameter("pickupDate");

                    // 2. VO 객체 생성 및 데이터 세팅
                    vo = new PaymentVO(); 
                    
                    if (resNo != null && !resNo.equals("")) {
                        // 만약 DB에서 예약 정보를 더 가져와야 한다면 실행
                        // vo = (PaymentVO) Execute.execute(Init.getService("/payment/view.do"), Long.parseLong(resNo));
                        
                        // 🌟 시은님이 말한 필수 데이터들 VO에 꼭꼭 담기!
                        vo.setOrder_id(Long.parseLong(resNo)); // 예약번호를 주문번호로 사용
                       // vo.setStore_id(store_id);              // 매장 아이디 담기
                        request.setAttribute("store_id", store_id);
                        if(totalPrice != null) vo.setAmount(Long.parseLong(totalPrice));
                        if(pDate != null && !pDate.isEmpty()) {
                            vo.setPickupDate(java.sql.Date.valueOf(pDate));
                        }
                        
                        // 3. JSP에서 쓸 수 있게 보내주기!
                        request.setAttribute("vo", vo);
                    }
                    return "payment/writeForm";
                    
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