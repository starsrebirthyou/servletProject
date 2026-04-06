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
			    // 1. 파라미터로 넘어온 예약 번호(no) 받기
			    no = Long.parseLong(request.getParameter("no"));

			    // 2. 서비스를 실행하여 모든 정보(예약+메뉴리스트)가 담긴 vo를 가져와서 셋팅
			    // 실행되는 서비스(ReservationViewService) 안에서 이미 orderList를 vo에 담아줍니다.
			    request.setAttribute("vo", Execute.execute(Init.getService(uri), no));

			    // 3. JSP 경로 반환
			    return "reservation/view";
			    
			// 2. 예약 상세 보기 - 매장용
			// 관리자 예약 상세보기
			case "/reservation/adminView.do":
				no = Long.parseLong(request.getParameter("no"));
				request.setAttribute("vo", Execute.execute(Init.getService("/reservation/view.do"), no));
				return "reservation/adminView";

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
			// 관리자 상태 변경 (승인: 2, 거절: 4)
			case "/reservation/adminUpdate.do":
				vo = new ReservationVO();
				vo.setResNo(Long.parseLong(request.getParameter("resNo")));
				vo.setResStatus(Long.parseLong(request.getParameter("resStatus")));
				vo.setCancelReason(request.getParameter("cancelReason"));

				Execute.execute(Init.getService(uri), vo);

				String statusMsg = (vo.getResStatus() == 2) ? "예약을 승인하였습니다." : "예약을 거절하였습니다.";
				session.setAttribute("msg", statusMsg);
				return "redirect:adminList.do";

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

			// 8. 사용자 예약 취소 일반 사용자용
			case "/reservation/cancel.do":
				vo = new ReservationVO();
				vo.setResNo(Long.parseLong(request.getParameter("resNo")));
				vo.setCancelReason(request.getParameter("cancelReason"));
				vo.setResStatus(4L);

				Execute.execute(Init.getService(uri), vo);
				session.setAttribute("msg", "예약 취소가 완료되었습니다.");
				return "redirect:list.do";

			// 8. 사용자 예약 취소 매장용
			case "/reservation/adminCancel.do":
				vo = new ReservationVO();
				vo.setResNo(Long.parseLong(request.getParameter("resNo")));
				vo.setCancelReason(request.getParameter("cancelReason"));
				vo.setResStatus(4L);

				Execute.execute(Init.getService(uri), vo);
				session.setAttribute("msg", "예약 거절이 완료되었습니다.");
				return "redirect:adminVist.do";

			// 9. 메뉴 주문 폼
			case "/reservation/orderWriteForm.do":
				return "reservation/orderWriteForm";

			// 10. 메뉴 주문
			case "/reservation/orderWrite.do":
				System.out.println("/reservation/orderWrite.do - 메뉴 주문 처리");

				// 2. [주의] 'OrderVO vo = ...' 가 아니라 그냥 'vo = ...' 라고 써야 합니다!
				vo = new ReservationVO();

				// JSP에서 보내는 배열 데이터 받기
				String[] menuNo = request.getParameterValues("menuNo");
				String[] quantity = request.getParameterValues("quantity");
				String StoreId = request.getParameter("storeId");
				String TotalPrice = request.getParameter("totalPrice");

				// 기본 정보 세팅 (null 체크)
				vo.setStoreId((StoreId != null && !StoreId.equals("")) ? Long.parseLong(StoreId) : 0L);
				vo.setTotalPrice((TotalPrice != null && !TotalPrice.equals("")) ? Long.parseLong(TotalPrice) : 0L);

				// 수량이 0보다 큰 첫 번째 메뉴만 우선 담기 (에러 방지용)
				if (menuNo != null && quantity != null) {
					for (int i = 0; i < menuNo.length; i++) {
						if (!quantity[i].equals("0")) {
							vo.setMenuNo(Long.parseLong(menuNo[i]));
							vo.setQuantity(Long.parseLong(quantity[i]));
							break;
						}
					}
				}

				Long resNo = (Long) Execute.execute(Init.getService(uri), vo);

				request.getSession().setAttribute("msg", "메뉴 주문이 완료되었습니다.");

				return "redirect:/reservation/orderView.do?resNo=" + resNo;

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