package everytable.stats.controller;

import java.util.List;
import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.stats.vo.StatsVO;
import everytable.util.page.PageObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class StatsController implements Controller {

    @Override
    public String execute(HttpServletRequest request) {
        HttpSession session = request.getSession();
        StatsVO login = (StatsVO) session.getAttribute("login");
        String id = null;
        if(login != null) id = login.getStoreId();
        
        request.setAttribute("url", request.getRequestURL());
        
        try {
            String uri = request.getServletPath();
            System.out.println("StatsController 진입 - URI: " + uri);
            
            switch (uri) {
                case "/stats/dashboard.do":
                    return "stats/dashboard";

                case "/stats/dashboard_home.do":
                    PageObject poHome = PageObject.getInstance(request);
                    request.setAttribute("list", Execute.execute(Init.getService("/stats/dashboard.do"), poHome));
                    request.setAttribute("pageObject", poHome);
                    return "stats/dashboard_home";

                case "/stats/sales.do":
                    System.out.println("StatsController - 기간별 매출조회 시작");
                    String startDate = request.getParameter("startDate");
                    String endDate = request.getParameter("endDate");
                    
                    if(startDate == null || startDate.equals("")) startDate = "2026-03-01"; 
                    if(endDate == null || endDate.equals("")) endDate = "2026-03-31";

                    PageObject poSales = PageObject.getInstance(request);
                    
                    @SuppressWarnings("unchecked")
                    List<StatsVO> salesList = (List<StatsVO>) Execute.execute(Init.getService("/stats/report.do"), poSales);
                    
                    double totalSum = 0;
                    if(salesList != null) {
                        for(StatsVO vo : salesList) {
                            totalSum += vo.getTotalSales();
                        }
                    }

                    request.setAttribute("list", salesList);
                    request.setAttribute("totalSum", totalSum);
                    request.setAttribute("pageObject", poSales);
                    request.setAttribute("startDate", startDate);
                    request.setAttribute("endDate", endDate);
                    
                    return "stats/sales_period";

                case "/stats/report.do":
                    PageObject pageObject2 = PageObject.getInstance(request);
                    StatsVO reportVo = new StatsVO();
                    reportVo.setStoreId(id != null ? id : "A001");
                    request.setAttribute("report", Execute.execute(Init.getService("/stats/report.do"), reportVo));
                    request.setAttribute("pageObject", pageObject2);
                    return "stats/report";

                case "/stats/categorystats.do":
                    System.out.println("StatsController - 카테고리 통계 시작");
                    // 1) 페이지 객체 생성
                    PageObject pageObject3 = PageObject.getInstance(request);
                    // 2) 서비스 호출 (Service에서 PageObject로 형변환하므로 pageObject3를 전달)
                    request.setAttribute("list", Execute.execute(Init.getService("/stats/categorystats.do"), pageObject3));
                    request.setAttribute("pageObject", pageObject3);
                    // 3) 아까 만든 JSP 파일명 (stats/category_stats 또는 stats/categorystats)
                    return "stats/category_stats";

                default:
                    System.out.println("StatsController - 존재하지 않는 URI: " + uri);
                    return "error/404";
            } // end of switch
            
        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("moduleName", "통계 모듈");
            request.setAttribute("e", e);
            return "error/err_500";
        } // end of try-catch
    } // end of execute
}