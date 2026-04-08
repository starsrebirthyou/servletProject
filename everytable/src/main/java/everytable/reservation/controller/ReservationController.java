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
			// [수정] DispatcherServlet과 동일하게 URI 정제
			String uri = request.getRequestURI();
			String contextPath = request.getContextPath();

			if (contextPath != null && !contextPath.equals("") && uri.startsWith(contextPath)) {
				uri = uri.substring(contextPath.length());
			}

			// [보험] /everytable 강제 제거
			if (uri.startsWith("/everytable")) {
				uri = uri.substring(11);
			}

			System.out.println("ReservationController.execute().uri = " + uri);

			HttpSession session = request.getSession();
			LoginVO loginVO = (LoginVO) session.getAttribute("login");

			// [공통] 로그인 체크 (이미 정제된 uri를 사용하므로 정상 작동함)
			// [공통] 로그인 체크 예외 대상 (로그인 안 해도 들어갈 수 있는 주소들)
			boolean isExempted = uri.equals("/reservation/groupShare.do") || uri.equals("/reservation/groupMenuForm.do")
					|| uri.equals("/reservation/groupOrderWrite.do") || uri.equals("/reservation/groupOrderComplete"); // 완료
																														// 페이지
																														// 포함

			if (loginVO == null && !isExempted) {
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
				String storeIdStr = request.getParameter("storeId"); // 파라미터 이름 확인!

				// 만약 파라미터가 null이면 에러 페이지 대신 안전한 처리를 합니다.
				if (storeIdStr == null || storeIdStr.equals("")) {
					session.setAttribute("msg", "매장 정보가 없습니다. 다시 시도해주세요.");
					return "redirect:/store/list.do"; // 매장 리스트로 돌려보내기
				}

				// 이제 안심하고 변환
				Long storeId = Long.parseLong(storeIdStr);

				// 매장 정보 가져오기
				request.setAttribute("storeVO", Execute.execute(Init.getService("/store/view.do"), storeId));

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

				// 108번 라인 근처 수정
				Long writeResNo = (Long) Execute.execute(Init.getService(uri), vo);
				session.setAttribute("msg", "예약이 완료되었습니다.");

				// [수정] storeId를 파라미터에 추가하여 리다이렉트
				return "redirect:/reservation/groupShare.do?resNo=" + writeResNo + "&storeId=" + vo.getStoreId();

			// 5. [관리자 전용] 상태 변경 처리 (승인: 2, 거절: 4)
			// 관리자 상태 변경 (승인: 2, 거절: 4)
			case "/reservation/adminUpdate.do":
				vo = new ReservationVO();
				vo.setResNo(Long.parseLong(request.getParameter("resNo")));
				vo.setResStatus(Long.parseLong(request.getParameter("resStatus")));
				vo.setCancelReason(request.getParameter("cancelReason"));

				Execute.execute(Init.getService(uri), vo);

				String statusMsg = (vo.getResStatus() == 2) ? "예약을 승인하였습니다."
						: (vo.getResStatus() == 3) ? "이용 완료 처리되었습니다." : "예약을 거절(취소)하였습니다.";
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

				vo = new ReservationVO();

				// [수정] JSP의 name="menuNos", name="quantities"와 일치시켜야 합니다!
				String[] menuNos = request.getParameterValues("menuNos");
				String[] quantities = request.getParameterValues("quantities");
				String storeIdStr1 = request.getParameter("storeId");
				String totalPriceStr = request.getParameter("totalPrice");

				// 기본 정보 세팅
				vo.setStoreId((storeIdStr1 != null && !storeIdStr1.equals("")) ? Long.parseLong(storeIdStr1) : 0L);
				vo.setTotalPrice(
						(totalPriceStr != null && !totalPriceStr.equals("")) ? Long.parseLong(totalPriceStr) : 0L);

				// 수량이 0보다 큰 데이터 처리
				if (menuNos != null && quantities != null) {
					for (int i = 0; i < menuNos.length; i++) {
						// 빈값이거나 "0"인 경우 제외
						if (quantities[i] != null && !quantities[i].equals("0") && !quantities[i].equals("")) {
							// VO 구조에 따라 리스트로 담거나, 일단 첫 번째 값을 세팅
							vo.setMenuNo(Long.parseLong(menuNos[i]));
							vo.setQuantity(Long.parseLong(quantities[i]));
							break; // 일단 로직상 한 개만 처리하게 되어있으므로 break
						}
					}
				}

				// 서비스 실행 (resNo 반환)
				Long resNo = (Long) Execute.execute(Init.getService(uri), vo);

				request.getSession().setAttribute("msg", "메뉴 주문이 완료되었습니다.");

				// 상세페이지로 이동
				return "redirect:/reservation/orderView.do?resNo=" + resNo;

			// 단체 주문 - 메뉴 선택 폼 (참여자 접속)
			case "/reservation/groupMenuForm.do":
				String resNoStr = request.getParameter("resNo");
				// [추가] storeId 파라미터도 받습니다.
				String storeIdStrParam = request.getParameter("storeId");

				if (resNoStr == null || resNoStr.equals("")) {
					return "error/404";
				}
				no = Long.parseLong(resNoStr);

				// 예약 정보 가져오기
				ReservationVO groupResVO = (ReservationVO) Execute.execute(Init.getService("/reservation/view.do"), no);
				request.setAttribute("vo", groupResVO);

				// [중요] JSP에서 ${storeId}로 사용할 수 있게 세팅합니다.
				// 만약 파라미터로 안 넘어왔다면 vo에 있는 storeId를 대신 넣어줍니다.
				if (storeIdStrParam != null && !storeIdStrParam.equals("")) {
					request.setAttribute("storeId", storeIdStrParam);
				} else {
					request.setAttribute("storeId", groupResVO.getStoreId());
				}

				// 매장의 메뉴 리스트 가져오기
				request.setAttribute("menuList",
						Execute.execute(Init.getService("/menu/list.do"), groupResVO.getStoreId()));

				return "reservation/groupMenuForm";

			// 단체 주문 - 메뉴 선택 저장 (참여자가 확인 버튼 누를 때)
			case "/reservation/groupOrderWrite.do":
				String[] groupMenuNos = request.getParameterValues("menuNos");
				String[] groupQuantities = request.getParameterValues("quantities");
				String groupResNo = request.getParameter("resNo");

				// [수정] groupResNo가 유효한 숫자인지 먼저 확인 (NumberFormatException 방지)
				if (groupResNo == null || groupResNo.trim().equals("")) {
					System.out.println("에러: resNo 파라미터가 없습니다.");
					return "error/404";
				}

				long resNo1 = Long.parseLong(groupResNo.trim());

				if (groupMenuNos != null && groupQuantities != null) {
					for (int i = 0; i < groupMenuNos.length; i++) {
						// 수량이 0이거나 빈 값인 경우 스킵
						if (groupQuantities[i] == null || groupQuantities[i].trim().equals("")
								|| groupQuantities[i].equals("0")) {
							continue;
						}

						try {
							ReservationVO groupVO = new ReservationVO();
							groupVO.setResNo(resNo1); // 위에서 변환한 숫자 사용
							groupVO.setMenuNo(Long.parseLong(groupMenuNos[i].trim()));
							groupVO.setQuantity(Long.parseLong(groupQuantities[i].trim()));

							Execute.execute(Init.getService("/reservation/groupOrderWrite.do"), groupVO);
						} catch (NumberFormatException e) {
							// 특정 메뉴 번호나 수량이 숫자가 아닌 경우 해당 루프만 건너뜀
							System.out.println("숫자 변환 오류 스킵: " + e.getMessage());
							continue;
						}
					}
				}
				return "reservation/groupOrderComplete";
			// 단체 주문 - 취합 현황 (주최자 확인)
			case "/reservation/groupOrderStatus.do":
				no = Long.parseLong(request.getParameter("resNo"));
				request.setAttribute("orderList",
						Execute.execute(Init.getService("/reservation/groupOrderList.do"), no));
				request.setAttribute("total", Execute.execute(Init.getService("/reservation/groupOrderTotal.do"), no));
				request.setAttribute("resNo", no);
				request.setAttribute("storeId", no);
				return "reservation/groupOrderStatus";

			// 240번 라인 근처 수정
			case "/reservation/groupShare.do":
				String shareNo = request.getParameter("resNo");
				String shareStoreId = request.getParameter("storeId"); // [추가] 파라미터 받기

				request.setAttribute("resNo", shareNo);
				request.setAttribute("storeId", shareStoreId); // [추가] JSP에서 ${storeId}로 쓸 수 있게 세팅

				return "reservation/groupShare";

			case "/reservation/finalOrder.do":
				long resNoFinal = Long.parseLong(request.getParameter("resNo"));
				String orderAdd = request.getParameter("orderAdd");

				ReservationVO finalVO = new ReservationVO();
				finalVO.setResNo(resNoFinal);
				finalVO.setOrderAdd(orderAdd);

				// 서비스 호출 (금액 계산 + orderAdd 업데이트)
				Execute.execute(Init.getService(uri), finalVO);

				// 완료 후 예약 상세보기로 이동
				return "redirect:view.do?no=" + resNoFinal + "&inc=0";

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