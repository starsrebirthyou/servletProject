package everytable.stats.controller;

import java.util.List;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.LoginVO;
import everytable.stats.vo.StatsVO;
import everytable.util.page.PageObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class StatsController implements Controller {

    @Override
    public String execute(HttpServletRequest request) {
        HttpSession session = request.getSession();
        LoginVO login = (LoginVO) session.getAttribute("login");
        
        try {
            String uri = request.getServletPath();
            
            switch (uri) {
                case "/stats/dashboard.do":
                    // 1. 로그인 체크: 로그인을 안 했으면 리스트 페이지나 메인으로 보냄
                    if (login == null) {
                        // 권한 없음을 알리고 메인으로 리다이렉트 (또는 로그인 페이지)
                        return "redirect:/member/loginForm.do";
                    }

                    // 2. ID 설정 로직
                    String id = "";
                    if (login.getId().equals("admin")) {
                        // admin일 경우 통계를 볼 특정 매장 번호를 지정 (테스트용 샘플 1번)
                        id = "1"; 
                    } else {
                        // 일반 점주일 경우 본인의 ID(또는 연결된 store_id)를 사용
                        // 만약 점주 ID가 숫자가 아니라면 여기서 숫자로 변환하는 로직이 필요함
                        id = login.getId(); 
                    }

                    // 3. 데이터 조회 (반드시 id가 숫자 형태의 문자열이어야 에러가 안 남)
                    PageObject po = PageObject.getInstance(request);
                    po.setWord(id); 

                    request.setAttribute("list", Execute.execute(Init.getService("/stats/list.do"), po));
                    request.setAttribute("today", Execute.execute(Init.getService("/stats/todaySummary.do"), id));
                    request.setAttribute("categoryList", Execute.execute(Init.getService("/stats/categorySales.do"), id));
                    
                    request.setAttribute("pageObject", po);
                    return "stats/dashboard";
                    
                case "/stats/sales.do":
                    // 1. 파라미터 수집 (주소창의 값을 읽어옴)
                    String startDate = request.getParameter("startDate");
                    String endDate = request.getParameter("endDate");
                    
                    // 2. 관리자(admin)인 경우 샘플 매장 '1'번 고정
                    String salesId = "1"; 
                    
                    // 3. 서비스 호출을 위한 PageObject 설정
                    PageObject poSales = PageObject.getInstance(request);
                    poSales.setWord(salesId); 

                    // [추가] 날짜 데이터가 있다면 PageObject의 accept에 담아서 DAO로 전달
                    if (startDate != null && !startDate.equals("") && endDate != null && !endDate.equals("")) {
                        poSales.setAccept(new String[]{startDate, endDate});
                    }

                    // 4. 데이터 가져오기
                    List<StatsVO> salesList = (List<StatsVO>) Execute.execute(Init.getService("/stats/list.do"), poSales);
                    
                    // 5. 합계 계산
                    double totalSum = 0;
                    if(salesList != null) {
                        for(StatsVO vo : salesList) totalSum += vo.getTotalSales();
                    }

                    // 6. JSP에서 사용할 수 있도록 request에 담기
                    request.setAttribute("list", salesList);
                    request.setAttribute("totalSum", totalSum);
                    request.setAttribute("startDate", startDate);
                    request.setAttribute("endDate", endDate);
                    
                    return "stats/sales_period";

                case "/stats/categorystats.do":
                    // 1. 관리자 기준 샘플 매장번호 '1' (로그인 연동 시 login.getId() 등으로 변경)
                    String catStoreId = "1"; 
                    
                    // 2. 서비스 실행 (Init.java에 등록된 CategoryStatsService 호출)
                    // 서비스에서 List<StatsVO> 형태의 데이터를 반환한다고 가정합니다.
                    request.setAttribute("list", Execute.execute(Init.getService(uri), catStoreId));
                    
                    // 3. JSP 경로 리턴
                    // WEB-INF/views/stats/category_stats.jsp 파일이 있어야 합니다.
                    return "stats/category_stats";
                    
                default:
                    return "error/404";
            } 
        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("e", e);
            return "error/500"; 
        } 
    } 
}