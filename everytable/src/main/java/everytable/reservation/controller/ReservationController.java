package everytable.reservation.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.LoginVO;
import everytable.reservation.vo.ReservationVO;
import everytable.util.page.PageObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class ReservationController implements Controller {

	@Override
	public String execute(HttpServletRequest request) {
		request.setAttribute("url", request.getRequestURL());

		try {
			String uri = request.getServletPath();
			HttpSession session = request.getSession();
			LoginVO loginVO = (LoginVO) session.getAttribute("login");

			// [공통] 로그인이 안 되어 있으면 로그인 폼으로 이동 (등록 처리는 허용할 수도 있으나 리스트 등은 차단)
			if (loginVO == null && !uri.equals("/reservation/write.do")) {
				session.setAttribute("msg", "로그인이 필요한 서비스입니다.");
				return "redirect:/member/loginForm.do";
			}

			ReservationVO vo;
			Long no;
			String jsp = null; // 리턴할 jsp 경로 변수

			switch (uri) {
			// 1. 예약/주문 리스트 - 일반사용자
			case "/reservation/list.do":
				PageObject pageObject = PageObject.getInstance(request);

				pageObject.setAccepter(loginVO.getId());
				request.setAttribute("list", Execute.execute(Init.getService(uri), pageObject));
				request.setAttribute("pageObject", pageObject);
				return "reservation/list";

			// 1. 관리자용 주문 관리 리스트
			case "/reservation/adminList.do":
				PageObject adminPage = PageObject.getInstance(request);
				System.out.println("로그인 객체의 StoreID: " + loginVO.getStoreId());
				adminPage.setAccepter(String.valueOf(loginVO.getStoreId()));
				request.setAttribute("list", Execute.execute(Init.getService("/reservation/adminList.do"), adminPage));
				request.setAttribute("pageObject", adminPage);
				return "reservation/adminList";

				// 2. 예약 상세 보기 - 일반 사용자
			case "/reservation/view.do":
			    no = Long.parseLong(request.getParameter("no"));
			    request.setAttribute("vo", Execute.execute(Init.getService(uri), no));
			    // 주문 메뉴 리스트 추가 조회
			    request.setAttribute("view", Execute.execute(Init.getService("/reservation/view.do"), no));
			    return "reservation/view";

			// 3. 예약 등록 (작성 폼)
			case "/reservation/writeForm.do":
				return "reservation/writeForm";

			// 4. 예약 등록 처리
			case "/reservation/write.do":
				vo = new ReservationVO();
				vo.setResDate(request.getParameter("resDate"));
				vo.setResTime(request.getParameter("resTime"));
				vo.setResCount(Long.parseLong(request.getParameter("resCount")));
				vo.setResPhone(request.getParameter("resPhone"));
				vo.setResType(request.getParameter("resType"));
				vo.setUserId(request.getParameter("userId"));
				vo.setStoreId(Long.parseLong(request.getParameter("storeId")));

				Long writeResNo = (Long) Execute.execute(Init.getService(uri), vo);
				session.setAttribute("msg", "예약이 완료되었습니다. 메뉴를 선택해주세요.");
				return "redirect:/order/writeForm.do?resNo=" + writeResNo;

			// 5. [관리자 전용] 상태 변경 처리 (승인: 2, 거절: 4)
//			case "/reservation/adminUpdate.do":
//				vo = new ReservationVO();
//				long status = Long.parseLong(request.getParameter("resStatus"));
//				vo.setResNo(Long.parseLong(request.getParameter("resNo")));
//				vo.setResStatus(status);
//				vo.setCancelReason(request.getParameter("cancelReason"));
//
//				Execute.execute(Init.getService(uri), vo);
//
//				String statusMsg = (status == 2) ? "예약을 승인하였습니다." : "예약을 거절(취소)하였습니다.";
//				session.setAttribute("msg", statusMsg);
//				// ★ 수정: adminList.do가 아니라 다시 list.do로 보내야 관리자 리스트가 나옴
//				return "redirect:list.do";

			// 6. 예약 수정 폼
			case "/reservation/updateForm.do":
				no = Long.parseLong(request.getParameter("no"));
				request.setAttribute("vo", Execute.execute(Init.getService("/reservation/view.do"), no));
				return "reservation/updateForm";

			// 7. 예약 수정 처리
			case "/reservation/update.do":
				vo = new ReservationVO();
				vo.setResNo(Long.parseLong(request.getParameter("resNo")));
				vo.setResDate(request.getParameter("resDate"));
				vo.setResTime(request.getParameter("resTime"));
				vo.setResCount(Long.parseLong(request.getParameter("resCount")));
				vo.setResPhone(request.getParameter("resPhone"));
				vo.setResType(request.getParameter("resType"));

				Execute.execute(Init.getService(uri), vo);
				session.setAttribute("msg", "예약 정보가 수정되었습니다.");
				return "redirect:view.do?no=" + vo.getResNo();

			// 8. 사용자 예약 취소 (상태 4로 변경)
			case "/reservation/cancel.do":
				vo = new ReservationVO();
				vo.setResNo(Long.parseLong(request.getParameter("resNo")));
				vo.setCancelReason(request.getParameter("cancelReason"));
				vo.setResStatus(4L);

				Execute.execute(Init.getService(uri), vo);
				session.setAttribute("msg", "예약 취소가 완료되었습니다.");
				return "redirect:list.do";

			default:
				// 정의되지 않은 URI인 경우 404 페이지로 유도하여 NPE 방지
				return "error/404";
			} // end of switch

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("e", e);
			return "error/err_500";
		}
	}
}