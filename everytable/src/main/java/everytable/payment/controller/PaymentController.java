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
                // 1. 페이지 정보 생성
                PageObject pageObject = PageObject.getInstance(request);
                
                // 2. 세션에서 로그인 정보 꺼내기
                // (세션에 "login"이라는 이름으로 LoginVO 객체가 저장되어 있어야 합니다)
                LoginVO login = (LoginVO) request.getSession().getAttribute("login");

                // 3. 권한에 따른 데이터 필터링 (핵심!)
                // 관리자(9등급)가 아니라면 무조건 본인 아이디로 검색되게 강제 설정
                if (login != null && login.getGradeNo() != 9) {
                    pageObject.setKey("u");             // 검색 키를 '아이디(u)'로 고정
                    pageObject.setWord(login.getId());  // 검색어를 '내 아이디'로 고정
                }

                // 4. 서비스 실행
                request.setAttribute("list", Execute.execute(Init.getService(uri), pageObject));
                request.setAttribute("pageObject", pageObject);
                
                return "payment/list";

                case "/payment/view.do":
                    // 1. 번호 가져오기
                    no = Long.parseLong(request.getParameter("no"));
                    
                    // 2. DB에서 데이터 가져오기 (한 번만 실행)
                    vo = (PaymentVO) Execute.execute(Init.getService(uri), no);
                    
                    // 3. 시간 차이 계산 로직 (여기에 추가!)
                    if (vo != null && vo.getPickupDate() != null) {
                        long now = new java.util.Date().getTime(); // 현재 시간
                        long pickup = vo.getPickupDate().getTime(); // DB에 저장된 픽업 시간
                        
                        // 밀리초를 시간 단위로 변환 (1000ms * 60s * 60m)
                        long diffHours = (pickup - now) / (1000 * 60 * 60);
                        
                        // JSP에서 ${diffHours}로 쓸 수 있게 보냄
                        request.setAttribute("diffHours", diffHours);
                    }
                    
                    // 4. VO 객체 전달 및 이동
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
                        // 1. 금액, 유저, 결제수단 세팅 (ID는 세팅하지 마세요!)
                        vo.setAmount(Long.parseLong(request.getParameter("amount")));
                        vo.setUser_id(request.getParameter("user_id"));
                        vo.setMethod(request.getParameter("method"));
                        
                        String storeIdStr = request.getParameter("store_id");
                        vo.setStoreid((storeIdStr != null && !storeIdStr.isEmpty()) ? Long.parseLong(storeIdStr) : 73L);
                        
                        vo.setStatus("SUCCESS"); 
                        
                        // 2. ★ 픽업 예정일 처리 ★
                        String pDate = request.getParameter("pickupDate"); 
                        if(pDate != null && !pDate.trim().isEmpty()) {
                            try {
                                // "/" -> " " 변환 및 초(:00) 추가
                                String formattedDate = pDate.replace("/", " ");
                                if(formattedDate.length() == 16) formattedDate += ":00";
                                
                                vo.setPickupDate(java.sql.Timestamp.valueOf(formattedDate));
                            } catch (Exception e) {
                                vo.setPickupDate(new java.sql.Timestamp(System.currentTimeMillis()));
                            }
                        } else {
                            vo.setPickupDate(new java.sql.Timestamp(System.currentTimeMillis()));
                        }

                        Execute.execute(Init.getService(uri), vo);
                        request.getSession().setAttribute("msg", "결제 요청이 접수되었습니다!");
                        return "redirect:list.do";
                        
                    } catch (Exception e) {
                        e.printStackTrace();
                        throw new Exception("결제 처리 중 오류: " + e.getMessage());
                    }
                case "/payment/updateForm.do":
                    login = (LoginVO) request.getSession().getAttribute("login");
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