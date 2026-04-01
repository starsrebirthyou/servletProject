package everytable.reservation.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.reservation.vo.ReservationVO;
import everytable.util.page.PageObject;
import jakarta.servlet.http.HttpServletRequest;

public class ReservationController implements Controller {

	@Override
	public String execute(HttpServletRequest request) {
		// TODO Auto-generated method stub
		request.setAttribute("url", request.getRequestURL());

		try {
			String uri = request.getServletPath();
			
			ReservationVO vo;
			Long no;
			Integer result;;

			switch (uri) {
			case "/reservation/list.do":
				PageObject pageObject = PageObject.getInstance(request);

				request.setAttribute("list", Execute.execute(Init.getService(uri), pageObject));

				System.out.println("ReservationControllr.execute().pageObject - " + pageObject);
				request.setAttribute("pageObject", pageObject);

				return "reservation/list";

			case "/reservation/view.do":
			    // 1. 파라미터 수집 (no가 null이면 리스트로 튕겨냄)
			    String strNo = request.getParameter("no");
			    if (strNo == null || strNo.equals("")) return "redirect:list.do";
			    
			    no = Long.parseLong(strNo);

			    // 2. 서비스 실행 (조회수 inc는 예약에 필요 없으므로 제거)
			    request.setAttribute("vo", Execute.execute(Init.getService(uri), no));

			    return "reservation/view";
			    
			case "/reservation/writeForm.do":
				return "reservation/writeForm";
				
			case "/reservation/write.do":
			    System.out.println("write.do - 예약 등록 처리");
			    
			    // 1. VO 객체 생성
			    // (위에서 vo 변수가 선언되어 있다면 그대로 사용, 안 되어 있다면 ReservationVO vo = new ReservationVO();)
			    vo = new ReservationVO();
			    
			    // 2. 넘어오는 데이터 수집 (JSP의 input name 속성과 일치해야 함)
			    // - 사용자 입력 정보
			    vo.setResDate(request.getParameter("resDate"));
			    vo.setResTime(request.getParameter("resTime"));
			    vo.setResCount(Long.parseLong(request.getParameter("resCount")));
			    vo.setResPhone(request.getParameter("resPhone"));
			    vo.setResType(request.getParameter("resType"));
			    
			    // - 시스템 정보 (hidden으로 넘어온 값들)
			    vo.setUserId(request.getParameter("userId")); // 회원 ID
			    vo.setStoreId(Long.parseLong(request.getParameter("storeId"))); // 매장 번호
			    
			    // 3. 서비스 실행 (Init에 등록된 ReservationWriteService 실행)
			    Execute.execute(Init.getService(uri), vo);
			    
			    // 4. 처리 결과 메시지 담기
			    request.getSession().setAttribute("msg", "예약이 완료되었습니다.");
			    
			    // 5. 리스트로 이동 (페이지 정보가 있다면 파라미터 유지)
			    return "redirect:list.do?perPageNum=" + request.getParameter("perPageNum");
			    
			case "/reservation/updateForm.do":
			    // 1. 파라미터 수집
			    String strUpdateNo = request.getParameter("no");
			    if (strUpdateNo == null || strUpdateNo.equals("")) return "redirect:list.do";
			    
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
			    
			    if(result == 1)
			        request.getSession().setAttribute("msg", "예약이 수정되었습니다.");
			    else
			        request.getSession().setAttribute("msg", "예약 수정에 실패하였습니다.");
			    
			    // 리다이렉트 주소에서 inc=0 제거 (예약은 조회수가 없으니까요)
			    return "redirect:view.do?no=" + vo.getResNo() + "&" + updatePageObject.getPageQuery();
				

			} // switch~case 끝

		} catch (Exception e) {
			e.printStackTrace();
			return "error/err_500";
		} // try~catch 끝

		return null;
	} // execute() 끝

}
