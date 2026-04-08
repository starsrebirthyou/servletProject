package everytable.review.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.LoginVO;
import everytable.review.vo.ReviewVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class ReviewController implements Controller {

    @Override
    public String execute(HttpServletRequest request) {
        HttpSession session = request.getSession();
        LoginVO login = (LoginVO) session.getAttribute("login");

        try {
            String uri = request.getServletPath();
            String storeIdStr = request.getParameter("storeId");
            String noStr = request.getParameter("no");

            switch (uri) {
                case "/review/list.do":
                    if (login == null) {
                        request.setAttribute("msg", "로그인이 필요한 서비스입니다.");
                        return "member/loginForm";
                    }
                    ReviewVO listVO = new ReviewVO();
                    listVO.setUserId(login.getId());
                    request.setAttribute("list", Execute.execute(Init.getService(uri), listVO));
                    return "review/list";

                case "/review/writeForm.do":
                    request.setAttribute("storeId", storeIdStr);
                    return "review/writeForm";

                case "/review/write.do":
                    // 1. 필수 파라미터 검증 (null 문자열 방어)
                    if (storeIdStr == null || storeIdStr.trim().isEmpty() || storeIdStr.equals("null")) {
                        return "redirect:/store/list.do"; 
                    }

                    ReviewVO writeVO = new ReviewVO();
                    writeVO.setStoreId(Long.parseLong(storeIdStr));
                    writeVO.setUserId((login != null) ? login.getId() : "user01");
                    writeVO.setContent(request.getParameter("content"));
                    // storeName이 넘어오지 않을 경우를 대비해 기본값 설정
                    String storeName = request.getParameter("storeName");
                    writeVO.setStoreName((storeName != null) ? storeName : "일반 매장");

                    String ratingStr = request.getParameter("rating");
                    writeVO.setRating((ratingStr != null) ? Double.parseDouble(ratingStr) : 5.0);

                    Execute.execute(Init.getService(uri), writeVO);
                    return "redirect:list.do";

                case "/review/updateForm.do":
                    // 기존 작성하신 코드 ... (잘 하셨습니다!)
                    long no = Long.parseLong(request.getParameter("no"));
                    request.setAttribute("vo", Execute.execute(Init.getService("/review/view.do"), no));
                    return "review/updateForm";

                // ★ 이 부분을 추가하세요 ★
                case "/review/update.do":
                    ReviewVO updateVO = new ReviewVO();
                    // 1. 수정할 리뷰 번호 (hidden으로 넘어온 no)
                    updateVO.setNo(Long.parseLong(request.getParameter("no")));
                    // 2. 수정된 내용
                    updateVO.setContent(request.getParameter("content"));
                    // 3. 수정된 평점
                    String updateRatingStr = request.getParameter("rating");
                    updateVO.setRating(Double.parseDouble(updateRatingStr));

                    // Service 실행 (ReviewUpdateService 호출)
                    Execute.execute(Init.getService(uri), updateVO);
                    
                    // 수정 완료 후 본인 리뷰 리스트로 이동
                    return "redirect:list.do";

                case "/review/delete.do":
                    // 기존 작성하신 코드 ...
                    Execute.execute(Init.getService(uri), Long.parseLong(noStr));
                    return "redirect:list.do";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "error/500";
        }
        return "error/404";
    }
}