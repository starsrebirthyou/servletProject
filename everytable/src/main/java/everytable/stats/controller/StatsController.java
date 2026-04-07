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
        
        // 로그인 아이디 가져오기 (테스트 시 "A001")
        String id = (login != null) ? login.getId() : "A001"; 
        
        try {
            String uri = request.getServletPath();
            
            switch (uri) {
                case "/stats/dashboard.do":
                    return "stats/dashboard";

                case "/stats/dashboard_home.do":
                    PageObject poHome = PageObject.getInstance(request);
                    
                    // 1. 하단 테이블용 리스트 (기존 일별 통계 테이블)
                    request.setAttribute("list", Execute.execute(Init.getService("/stats/list.do"), poHome));
                    
                    // 2. 상단 카드용 오늘 요약 (실시간 orders 테이블)
                    // StatsTodaySummaryService 필요
                    request.setAttribute("today", Execute.execute(Init.getService("/stats/todaySummary.do"), id));
                    
                    // 3. 도넛 차트용 카테고리 통계 (실시간 order_item 테이블)
                    // StatsCategorySalesService 필요
                    request.setAttribute("categoryList", Execute.execute(Init.getService("/stats/categorySales.do"), id));
                    
                    request.setAttribute("pageObject", poHome);
                    return "stats/dashboard_home";

                case "/stats/sales.do":
                    String startDate = request.getParameter("startDate");
                    String endDate = request.getParameter("endDate");
                    if(startDate == null || startDate.equals("")) startDate = "2026-03-01"; 
                    if(endDate == null || endDate.equals("")) endDate = "2026-03-31";

                    PageObject poSales = PageObject.getInstance(request);
                    // 기간별 조회를 위해 배열이나 Map으로 전달 가능
                    List<StatsVO> salesList = (List<StatsVO>) Execute.execute(Init.getService("/stats/list.do"), poSales);
                    
                    double totalSum = 0;
                    if(salesList != null) {
                        for(StatsVO vo : salesList) totalSum += vo.getTotalSales();
                    }

                    request.setAttribute("list", salesList);
                    request.setAttribute("totalSum", totalSum);
                    request.setAttribute("pageObject", poSales);
                    return "stats/sales_period";

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