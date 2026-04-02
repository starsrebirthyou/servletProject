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
		// TODO Auto-generated method stub
		request.setAttribute("url", request.getRequestURL());

		try {
			String uri = request.getServletPath();

			ReservationVO vo;
			Long no;
			Integer result;

			switch (uri) {
			case "/reservation/list.do":
			    // 1. 페이지 및 검색 정보 생성
			    PageObject pageObject = PageObject.getInstance(request);
			    
			    // 2. 세션에서 로그인 객체 꺼내기 (MemberController 저장 방식에 맞춤)
			    HttpSession session = request.getSession();
			    LoginVO loginVO = (LoginVO) session.getAttribute("login");
			    
			    // 로그인이 안 되어 있으면 로그인 폼으로 리다이렉트
			    if (loginVO == null) {
			        session.setAttribute("msg", "로그인이 필요한 서비스입니다.");
			        return "redirect:/member/loginForm.do";
			    }
			    
			    // 3. PageObject의 accepter 필드에 로그인 아이디 심기
			    pageObject.setAccepter(loginVO.getId());

			    // 4. 서비스 실행 (pageObject 하나만 전달)
			    request.setAttribute("list", Execute.execute(Init.getService(uri), pageObject));
			    
			    // 5. JSP 전달용 데이터
			    request.setAttribute("pageObject", pageObject);

			    return "reservation/list";

			case "/reservation/view.do":
				// 1. 파라미터 수집 (no가 null이면 리스트로 튕겨냄)
				String strNo = request.getParameter("no");
				if (strNo == null || strNo.equals(""))
					return "redirect:list.do";

				no = Long.parseLong(strNo);

				// 2. 서비스 실행 (조회수 inc는 예약에 필요 없으므로 제거)
				request.setAttribute("vo", Execute.execute(Init.getService(uri), no));

				return "reservation/view";

			case "/reservation/writeForm.do":
				return "reservation/writeForm";

			case "/reservation/write.do":
			    System.out.println("/reservation/write.do - 예약 등록 처리");

			    vo = new ReservationVO();

			    // 1. 사용자 입력 데이터 수집
			    vo.setResDate(request.getParameter("resDate"));
			    vo.setResTime(request.getParameter("resTime"));
			    vo.setResCount(Long.parseLong(request.getParameter("resCount")));
			    vo.setResPhone(request.getParameter("resPhone"));
			    vo.setResType(request.getParameter("resType"));

			    // 2. 시스템 정보 수집
			    vo.setUserId(request.getParameter("userId")); 
			    vo.setStoreId(Long.parseLong(request.getParameter("storeId"))); // 이름보다 ID가 정확함
			    // vo.setResNo는 여기서 하지 않습니다! (DB에서 생성함)

			    // 3. 서비스 실행 및 생성된 번호 받기 (핵심!)
			    // Execute.execute가 리턴하는 Object를 Long으로 캐스팅해서 변수에 담습니다.
			    Long resNo = (Long) Execute.execute(Init.getService(uri), vo);

			    // 4. 처리 결과 메시지
			    request.getSession().setAttribute("msg", "예약이 완료되었습니다. 메뉴를 선택해주세요.");

			    // 5. 생성된 번호를 들고 메뉴 주문 폼으로 이동
			    return "redirect:/order/writeForm.do?resNo=" + resNo;
				
			case "/reservation/updateForm.do":
				// 1. 파라미터 수집
				String strUpdateNo = request.getParameter("no");
				if (strUpdateNo == null || strUpdateNo.equals(""))
					return "redirect:list.do";

				no = Long.parseLong(strUpdateNo);

				// 2. 수정할 데이터를 가져오기 위해 view 서비스 호출 (inc 없이 no만 전달)
				request.setAttribute("vo", Execute.execute(Init.getService("/reservation/view.do"), no));

				return "reservation/updateForm";

			case "/reservation/update.do":
				// 페이지 정보 유지를 위해 pageObject 가져오기
				PageObject updatePageObject = PageObject.getInstance(request);

				vo = new ReservationVO();
				vo.setResNo(Long.parseLong(request.getParameter("resNo")));
				vo.setResDate(request.getParameter("resDate"));
				vo.setResTime(request.getParameter("resTime"));
				vo.setResCount(Long.parseLong(request.getParameter("resCount")));
				vo.setResPhone(request.getParameter("resPhone"));
				vo.setResType(request.getParameter("resType"));

				result = (Integer) Execute.execute(Init.getService(uri), vo);

				if (result == 1)
					request.getSession().setAttribute("msg", "예약이 수정되었습니다.");
				else
					request.getSession().setAttribute("msg", "예약 수정에 실패하였습니다.");

				// 리다이렉트 주소에서 inc=0 제거 (예약은 조회수가 없으니까요)
				return "redirect:view.do?no=" + vo.getResNo() + "&" + updatePageObject.getPageQuery();

			case "/reservation/cancel.do":
				// 1. 데이터 수집 (어떤 예약을, 무슨 사유로 취소하나?)
				vo = new ReservationVO();
				vo.setResNo(Long.parseLong(request.getParameter("resNo")));
				vo.setCancelReason(request.getParameter("cancelReason"));
				vo.setResStatus(4); // 취소 상태 번호 4

				// 2. 서비스 실행
				Execute.execute(Init.getService(uri), vo);

				// 3. 메시지 처리 및 리다이렉트
				request.getSession().setAttribute("msg", "예약 취소가 완료되었습니다.");
				return "redirect:list.do";

			} // switch~case 끝

		} catch (Exception e) {
			e.printStackTrace();
			return "error/err_500";
		} // try~catch 끝

		return null;
	} // execute() 끝

}
