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
            // 파라미터 가져오기 (trim()을 추가해서 공백 방지)
            String storeIdStr = request.getParameter("storeId");
            String noStr = request.getParameter("no");

            switch (uri) {

                // 1. [일반 사용자] 내가 쓴 리뷰 목록
                case "/review/list.do":
                    if (login == null) return "member/loginForm";
                    
                    ReviewVO myVO = new ReviewVO();
                    myVO.setUserId(login.getId());
                    request.setAttribute("list", Execute.execute(Init.getService(uri), myVO));
                    return "review/list";

                // 2. [일반 사용자] 매장 상세페이지 내 리뷰 목록
                case "/review/storeList.do":
                    // 1. 매장 이름 파라미터를 받아서 JSP로 다시 넘겨줌 (리뷰쓰기 버튼용)
                    request.setAttribute("storeName", request.getParameter("storeName"));
                    
                    ReviewVO storeVO = new ReviewVO();
                    storeVO.setStoreId(Long.parseLong(storeIdStr));
                    request.setAttribute("list", Execute.execute(Init.getService(uri), storeVO));
                    return "review/storeList";
                    
                // 3. [관리자용] 내 매장 리뷰 관리 리스트
                case "/review/adminList.do":
                    if (login == null || login.getGradeNo() < 5) {
                        request.setAttribute("msg", "관리자 권한이 필요합니다.");
                        return "member/loginForm";
                    }
                    
                    ReviewVO adminVO = new ReviewVO();
                    // 💡 사장님의 storeId를 세팅 (0이 아니어야 함)
                    adminVO.setStoreId(login.getStoreId());
                    
                    System.out.println("✅ 관리자 매장 ID 조회: " + adminVO.getStoreId());
                    
                    request.setAttribute("list", Execute.execute(Init.getService(uri), adminVO));
                    return "review/adminList";

                // 4. 리뷰 작성 처리
                 // ReviewController.java의 case "/review/write.do":
                case "/review/write.do":
                    if (login == null) return "member/loginForm";
                    
                    ReviewVO writeVO = new ReviewVO();
                    writeVO.setStoreId(Long.parseLong(storeIdStr));
                    writeVO.setUserId(login.getId());
                    writeVO.setContent(request.getParameter("content"));
                    writeVO.setRating(Double.parseDouble(request.getParameter("rating")));
                    
                    // ✅ 추가: 폼에서 넘어온 storeName 파라미터를 수집합니다.
                    String storeName = request.getParameter("storeName");
                    writeVO.setStoreName(storeName); 
                    
                    Execute.execute(Init.getService(uri), writeVO);
                    return "redirect:storeList.do?storeId=" + storeIdStr;
                    
                case "/review/writeForm.do":
                    // 2. 작성 폼으로 갈 때도 이름 파라미터를 받아 request에 세팅
                    request.setAttribute("storeId", storeIdStr);
                    request.setAttribute("storeName", request.getParameter("storeName")); 
                    return "review/writeForm";
                    
                // 5. 리뷰 삭제
                case "/review/delete.do":
                    if (noStr != null && !noStr.isEmpty()) {
                        Execute.execute(Init.getService(uri), Long.parseLong(noStr));
                    }
                    String from = request.getParameter("from");
                    if("admin".equals(from)) return "redirect:adminList.do";
                    return "redirect:list.do";
                    
                 // 6. 리뷰 수정 폼
                case "/review/updateForm.do":
                    if (noStr == null || noStr.isEmpty()) {
                        return "redirect:list.do";
                    }
                    // 수정을 위해 기존 데이터를 DB에서 가져옴 (view 서비스 호출)
                    // Init.java에 "/review/view.do"가 등록되어 있어야 합니다.
                    request.setAttribute("vo", Execute.execute(Init.getService("/review/view.do"), Long.parseLong(noStr)));
                    return "review/updateForm";

                // 7. 리뷰 수정 처리
                case "/review/update.do":
                    ReviewVO updateVO = new ReviewVO();
                    // 수정할 리뷰 번호
                    updateVO.setNo(Long.parseLong(noStr));
                    // 수정된 내용 및 평점 수집
                    updateVO.setContent(request.getParameter("content"));
                    updateVO.setRating(Double.parseDouble(request.getParameter("rating")));
                    
                    Execute.execute(Init.getService(uri), updateVO);

                    // 수정 후 매장 상세 리뷰로 돌아갈지, 내 리뷰 목록으로 갈지 결정
                    // 여기서는 기본적으로 내 리뷰 목록으로 보냅니다.
                    return "redirect:list.do";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "리뷰 처리 중 오류 발생: " + e.getMessage());
            return "error/500";
        }
        return "error/404";
    }
}