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
			// ReviewController.java 내 list.do 부분
			case "/review/list.do":
			    // 세션에서 로그인 정보 가져오기 (속성명이 "login"이 맞는지 확인 필수!)
			    LoginVO loginVO = (LoginVO) session.getAttribute("login");
			    
			    if (loginVO == null) {
			        System.out.println("로그인 정보 없음: 로그인 페이지로 리다이렉트");
			        request.setAttribute("msg", "로그인이 필요한 서비스입니다.");
			        return "member/loginForm"; // 로그인 폼 JSP 이름
			    }

			    ReviewVO vo = new ReviewVO();
			    
			    // 2. DAO의 SQL문에서 id = ? 에 들어갈 값을 세팅합니다.
			    vo.setUserId(login.getId());

			    // 서비스 실행 및 데이터 전달
			    request.setAttribute("list", Execute.execute(Init.getService(uri), vo));
			    
			    // 반드시 리스트 JSP를 리턴해야 합니다!
			    return "review/list";

			// 2. 리뷰 작성 폼 이동
			case "/review/writeForm.do":
				// 1. DB에서 활성화된 매장 리스트를 가져옵니다. (매장 서비스/DAO 필요)
				// 예: List<StoreVO> storeList = (List<StoreVO>)
				// Execute.execute(storeListService, null);
				// request.setAttribute("storeList", storeList);

				// 테스트용: 만약 매장 서비스가 없다면 임시로 storeId를 직접 받게 처리
				request.setAttribute("storeId", request.getParameter("storeId"));
				return "review/writeForm";

			// 3. 실제 리뷰 등록 처리
			case "/review/write.do":
				// 방어 코드: storeIdStr이 null이거나 빈 문자열인지 확인
				if (storeIdStr == null || storeIdStr.trim().isEmpty()) {
					System.out.println("에러: storeId가 전달되지 않았습니다.");
					return "redirect:list.do"; // 혹은 에러 페이지로 이동
				}

				ReviewVO writeVO = new ReviewVO();
				// 이제 숫자로 변환해도 에러가 나지 않습니다.
				writeVO.setStoreId(Long.parseLong(storeIdStr));

				writeVO.setUserId((login != null) ? login.getId() : "user01");
				writeVO.setContent(request.getParameter("content"));

				String ratingStr = request.getParameter("rating");
				writeVO.setRating((ratingStr != null) ? Double.parseDouble(ratingStr) : 5.0);

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