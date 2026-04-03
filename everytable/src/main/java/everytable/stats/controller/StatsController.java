package everytable.stats.controller;

import java.util.List;
import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.LoginVO; // 반드시 추가되어야 함
import everytable.stats.vo.StatsVO;
import everytable.util.page.PageObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class StatsController implements Controller {

    @Override
    public String execute(HttpServletRequest request) {
        HttpSession session = request.getSession();
        
        // [수정 포인트] 세션의 "login"은 LoginVO 타입입니다.
        LoginVO login = (LoginVO) session.getAttribute("login");
        
        String id = null;
        // 로그인 정보가 있다면 아이디를 가져옵니다.
        if(login != null) {
            id = login.getId(); 
        }
        
        request.setAttribute("url", request.getRequestURL());
        
        try {
            String uri = request.getServletPath();
            System.out.println("StatsController 진입 - URI: " + uri);
            
            switch (uri) {
                // 1. 대시보드 메인 프레임
                case "/stats/dashboard.do":
                    return "stats/dashboard";

                // 2. 대시보드 내부 콘텐츠 (차트 등)
                case "/stats/dashboard_home.do":
                    PageObject poHome = PageObject.getInstance(request);
                    // Init에 "/stats/dashboard.do" 서비스가 등록되어 있어야 합니다.
                    request.setAttribute("list", Execute.execute(Init.getService("/stats/dashboard.do"), poHome));
                    request.setAttribute("pageObject", poHome);
                    return "stats/dashboard_home";

                // 3. 기간별 매출 조회
                case "/stats/sales.do":
                    System.out.println("StatsController - 기간별 매출조회 시작");
                    String startDate = request.getParameter("startDate");
                    String endDate = request.getParameter("endDate");
                    
                    // 기본 날짜 설정 (데이터가 없을 경우 대비)
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

                // 4. 레포트 출력
                case "/stats/report.do":
                    PageObject pageObject2 = PageObject.getInstance(request);
                    StatsVO reportVo = new StatsVO();
                    // 로그인한 사용자의 ID를 사용하거나 없으면 기본값 세팅
                    reportVo.setStoreId(id != null ? id : "A001");
                    
                    request.setAttribute("report", Execute.execute(Init.getService("/stats/report.do"), reportVo));
                    request.setAttribute("pageObject", pageObject2);
                    return "stats/report";

                // 5. 카테고리별 통계
                case "/stats/categorystats.do":
                    System.out.println("StatsController - 카테고리 통계 시작");
                    PageObject pageObject3 = PageObject.getInstance(request);
                    request.setAttribute("list", Execute.execute(Init.getService("/stats/categorystats.do"), pageObject3));
                    request.setAttribute("pageObject", pageObject3);
                    return "stats/category_stats";

                default:
                    System.out.println("StatsController - 존재하지 않는 URI: " + uri);
                    return "error/404";
            } 
            
        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("moduleName", "통계 모듈");
            request.setAttribute("e", e);
            // 에러 페이지 경로 확인 (err_500 인지 500 인지)
            return "error/500"; 
        } 
    } 
}