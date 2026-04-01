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
            
            switch (uri) {
                case "/stats/dashboard.do":
                    return "stats/dashboard";

                case "/stats/dashboard_home.do":
                    PageObject poHome = PageObject.getInstance(request);
                    request.setAttribute("list", Execute.execute(Init.getService("/stats/dashboard.do"), poHome));
                    request.setAttribute("pageObject", poHome);
                    return "stats/dashboard_home";

                // --- 3. 기간별 매출 조회 수정 부분 ---
                case "/stats/sales.do":
                    System.out.println("StatsController - 기간별 매출조회 시작");
                    
                    // 1) 날짜 파라미터 수집
                    String startDate = request.getParameter("startDate");
                    String endDate = request.getParameter("endDate");
                    
                    // 2) 기본값 설정 (파라미터가 없을 때)
                    if(startDate == null || startDate.equals("")) startDate = "2026-03-01"; 
                    if(endDate == null || endDate.equals("")) endDate = "2026-03-31";

                    PageObject poSales = PageObject.getInstance(request);
                    
                    // 3) 검색 데이터를 VO에 담아서 서비스로 전달 (Map을 써도 되지만 VO에 startDate/endDate를 추가했으므로 활용)
                    StatsVO searchVo = new StatsVO();
                    searchVo.setStoreId(id != null ? id : "A001");
                    searchVo.setStartDate(startDate);
                    searchVo.setEndDate(endDate);
                    
                    // 4) 데이터 요청 (Init에 등록된 서비스가 PageObject와 검색 조건을 모두 처리한다고 가정)
                    // 만약 서비스가 하나만 받는다면 파라미터를 배열이나 Map에 담으세요.
                    @SuppressWarnings("unchecked")
                    List<StatsVO> salesList = (List<StatsVO>) Execute.execute(Init.getService("/stats/report.do"), poSales);
                    
                    // 5) 매출 총합 계산 (JSP에서 요약 표시용)
                    double totalSum = 0;
                    if(salesList != null) {
                        for(StatsVO vo : salesList) {
                            totalSum += vo.getTotalSales();
                        }
                    }

                    request.setAttribute("list", salesList);
                    request.setAttribute("totalSum", totalSum); // 총합 전달
                    request.setAttribute("pageObject", poSales);
                    // JSP에서 <input value="${startDate}"> 로 보여주기 위해 다시 저장
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
                    PageObject pageObject3 = PageObject.getInstance(request);
                    StatsVO categoryVo = new StatsVO();
                    categoryVo.setStoreId(id != null ? id : "A001");
                    request.setAttribute("categoryStats", Execute.execute(Init.getService("/stats/categorystats.do"), categoryVo));
                    request.setAttribute("pageObject", pageObject3);
                    return "stats/categorystats";
            }
            
        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("moduleName", "통계 모듈");
            request.setAttribute("e", e);
            return "error/err_500";
        }
        
        return "error/404"; 
    }
}