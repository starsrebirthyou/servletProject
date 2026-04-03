package everytable.review.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.LoginVO;
import everytable.review.vo.ReviewVO;
import everytable.util.page.PageObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class ReviewController implements Controller {

    @Override
    public String execute(HttpServletRequest request) {
        // 세션 미리 꺼내기 (중복 선언 방지)
        HttpSession session = request.getSession();
        LoginVO login = (LoginVO) session.getAttribute("login");
        
        try {
            String uri = request.getServletPath();
            String storeIdStr = request.getParameter("storeId"); // 공통으로 많이 쓰임

            switch (uri) {
                // 1. 리뷰 리스트
                case "/review/list.do":
                    PageObject pageObject = PageObject.getInstance(request);
                    if (login != null) {
                        pageObject.setAccepter(login.getId());
                    }
                    request.setAttribute("list", Execute.execute(Init.getService(uri), pageObject));
                    request.setAttribute("pageObject", pageObject);
                    return "review/list";

                // 2. 리뷰 작성 폼 이동
                case "/review/writeForm.do":
                    request.setAttribute("storeId", storeIdStr);
                    return "review/writeForm";

                // 3. 실제 리뷰 등록 처리
                case "/review/write.do":
                    ReviewVO writeVO = new ReviewVO();
                    writeVO.setStoreId(Long.parseLong(storeIdStr));
                    // 로그인 세션에서 아이디 가져오기 (login 객체가 null이면 테스트용 아이디 사용)
                    writeVO.setUserId((login != null) ? login.getId() : "user01");
                    writeVO.setContent(request.getParameter("content"));
                    writeVO.setRating(Double.parseDouble(request.getParameter("rating")));

                    Execute.execute(Init.getService(uri), writeVO);
                    return "redirect:list.do?storeId=" + storeIdStr;

                 // 4. 리뷰 수정 폼 이동
                case "/review/updateForm.do":
                    long updateNo = Long.parseLong(request.getParameter("no"));
                    request.setAttribute("vo", Execute.execute(Init.getService("/review/view.do"), updateNo));
                    return "review/updateForm";

                // 4-2. 실제 리뷰 수정 처리 (이 부분이 추가되어야 합니다!)
                case "/review/update.do":
                    ReviewVO updateVO = new ReviewVO();
                    // 수정할 리뷰의 PK 번호
                    updateVO.setNo(Long.parseLong(request.getParameter("no"))); 
                    updateVO.setContent(request.getParameter("content"));
                    updateVO.setRating(Double.parseDouble(request.getParameter("rating")));

                    // DB 업데이트 실행
                    Execute.execute(Init.getService(uri), updateVO);
                    
                    // 수정한 리뷰가 속한 매장의 리스트로 돌아가기
                    return "redirect:list.do?storeId=" + request.getParameter("storeId");
                    
                // 5. 리뷰 삭제 처리 (추가됨)
                case "/review/delete.do":
                    long no = Long.parseLong(request.getParameter("no"));
                    
                    Execute.execute(Init.getService(uri), no);
                    return "redirect:list.do?storeId=" + storeIdStr;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "error/500";
        }
        return "error/404";
    }
}