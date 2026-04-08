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
			// 1. 내가 쓴 리뷰 목록
			case "/review/list.do":
				if (login == null) {
					request.setAttribute("msg", "로그인이 필요한 서비스입니다.");
					return "member/loginForm";
				}
				ReviewVO myVO = new ReviewVO();
				myVO.setUserId(login.getId());
				request.setAttribute("list", Execute.execute(Init.getService(uri), myVO));
				return "review/list";

			// 2. 매장별 리뷰 목록 (storeId 기반 조회)
			case "/review/storeList.do":
				if (storeIdStr == null || storeIdStr.isEmpty()) {
					return "redirect:/store/list.do"; 
				}
				ReviewVO storeVO = new ReviewVO();
				storeVO.setStoreId(Long.parseLong(storeIdStr));
				if (login != null) storeVO.setUserId(login.getId());

				request.setAttribute("list", Execute.execute(Init.getService("/review/list.do"), storeVO));
				return "review/storeList";

			// 3. 리뷰 작성 폼
			case "/review/writeForm.do":
				request.setAttribute("storeId", storeIdStr);
				return "review/writeForm";

			// 4. 리뷰 작성 처리
			case "/review/write.do":
				if (storeIdStr == null || storeIdStr.trim().isEmpty() || storeIdStr.equals("null")) {
					return "redirect:/store/list.do";
				}

				ReviewVO writeVO = new ReviewVO();
				writeVO.setStoreId(Long.parseLong(storeIdStr));
				writeVO.setUserId((login != null) ? login.getId() : "user01");
				writeVO.setContent(request.getParameter("content"));
				
				String storeName = request.getParameter("storeName");
				writeVO.setStoreName((storeName != null) ? storeName : "일반 매장");

				String ratingStr = request.getParameter("rating");
				// 평점이 비어있을 경우 기본값 5.0 처리
				writeVO.setRating((ratingStr != null && !ratingStr.isEmpty()) ? Double.parseDouble(ratingStr) : 5.0);

				Execute.execute(Init.getService(uri), writeVO);
				return "redirect:list.do";

			// 5. 리뷰 수정 폼
			case "/review/updateForm.do":
				if (noStr == null || noStr.isEmpty()) return "redirect:list.do";
				long updateNo = Long.parseLong(noStr);
				request.setAttribute("vo", Execute.execute(Init.getService("/review/view.do"), updateNo));
				return "review/updateForm";

			// 6. 리뷰 수정 처리
			case "/review/update.do":
				ReviewVO updateVO = new ReviewVO();
				updateVO.setNo(Long.parseLong(noStr));
				updateVO.setContent(request.getParameter("content"));
				
				String updateRatingStr = request.getParameter("rating");
				if (updateRatingStr != null && !updateRatingStr.isEmpty()) {
					updateVO.setRating(Double.parseDouble(updateRatingStr));
				}

				Execute.execute(Init.getService(uri), updateVO);
				return "redirect:list.do";

			// 7. 리뷰 삭제
			case "/review/delete.do":
				if (noStr != null && !noStr.isEmpty()) {
					Execute.execute(Init.getService(uri), Long.parseLong(noStr));
				}
				return "redirect:list.do";
			}
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", e.getMessage());
			return "error/500";
		}
		return "error/404";
	}
}