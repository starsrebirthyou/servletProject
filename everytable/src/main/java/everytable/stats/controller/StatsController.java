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
            
            // [수정] id의 기본값을 "1"로 설정하거나 세션 체크 강화
            String id = "1"; // 기본값을 1로 설정해서 에러 방지
            
            if (login != null && login.getId() != null && !login.getId().equals("")) {
                if (login.getId().equals("admin")) {
                    id = "1"; 
                } else {
                    id = login.getId(); 
                }
            }

            switch (uri) {
                case "/stats/dashboard.do":
                    // 1. 데이터 조회 설정을 위한 PageObject 생성
                    PageObject po = PageObject.getInstance(request);
                    po.setWord(id); // 매장 ID 검색 조건으로 활용

                    // 2. 과거 매출 리스트 가져오기 (메인 차트용)
                    request.setAttribute("list", Execute.execute(Init.getService("/stats/list.do"), po));
                    
                    // 3. 오늘의 매출/건수 요약 가져오기 (상단 요약 박스용)
                    request.setAttribute("today", Execute.execute(Init.getService("/stats/todaySummary.do"), id));
                    
                    // 4. 페이징 정보 전달
                    request.setAttribute("pageObject", po);
                    
                    return "stats/dashboard";

                case "/stats/sales.do":
                    // 1. 기간 조회를 위한 파라미터 수집
                    String startDate = request.getParameter("startDate");
                    String endDate = request.getParameter("endDate");
                    
                    // 2. 서비스 호출을 위한 PageObject 설정
                    PageObject poSales = PageObject.getInstance(request);
                    poSales.setWord(id); 

                    // 3. 날짜 데이터가 있다면 PageObject의 accept에 담아서 DAO로 전달
                    if (startDate != null && !startDate.equals("") && endDate != null && !endDate.equals("")) {
                        poSales.setAccept(new String[]{startDate, endDate});
                    }

                    // 4. 기간별 리스트 데이터 가져오기
                    @SuppressWarnings("unchecked")
                    List<StatsVO> salesList = (List<StatsVO>) Execute.execute(Init.getService("/stats/list.do"), poSales);
                    
                    // 5. 조회된 리스트의 총 합계 계산
                    double totalSum = 0;
                    if(salesList != null) {
                        for(StatsVO vo : salesList) totalSum += vo.getTotalSales();
                    }

                    // 6. JSP 전달 데이터 설정
                    request.setAttribute("list", salesList);
                    request.setAttribute("totalSum", totalSum);
                    request.setAttribute("startDate", startDate);
                    request.setAttribute("endDate", endDate);
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