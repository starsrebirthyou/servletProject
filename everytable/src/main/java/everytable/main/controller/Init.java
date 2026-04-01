package everytable.main.controller;

import java.util.HashMap;
import java.util.Map;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.member.controller.MemberController;
import everytable.member.dao.MemberDAO;
import everytable.member.service.LoginService;
import everytable.member.service.MemberChangeGradeService;
import everytable.member.service.MemberChangeStatusService;
import everytable.member.service.MemberCheckIdService;
import everytable.member.service.MemberListService;
import everytable.member.service.MemberUpdateLastLoginService;
import everytable.member.service.MemberWriteService;
import everytable.notice.controller.NoticeController;
import everytable.notice.dao.NoticeDAO;
import everytable.notice.service.NoticeDeleteService;
import everytable.notice.service.NoticeListService;
import everytable.notice.service.NoticeUpdateService;
import everytable.notice.service.NoticeViewService;
import everytable.notice.service.NoticeWriteService;
import everytable.payment.controller.PaymentController;
import everytable.payment.dao.PaymentDAO;
import everytable.payment.service.PaymentCancelService;
import everytable.payment.service.PaymentListService;
import everytable.payment.service.PaymentUpdateService;
import everytable.payment.service.PaymentViewService;
import everytable.payment.service.PaymentWriteService;
import everytable.reservation.controller.ReservationController;
import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.service.ReservationListService;
import everytable.reservation.service.ReservationViewService;
import everytable.reservation.service.ReservationWriteService;
import everytable.review.controller.ReviewController;
import everytable.review.dao.ReviewDAO;
import everytable.review.service.ReviewDeleteService;
import everytable.review.service.ReviewListService;
import everytable.review.service.ReviewUpdateService;
import everytable.review.service.ReviewWriteService;
import everytable.stats.controller.StatsController;
import everytable.stats.dao.StatsDAO;
import everytable.stats.service.CategoryStatsService;
import everytable.stats.service.StatsDashboardService;
import everytable.stats.service.StatsReportService;
import jakarta.servlet.Servlet;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
// import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

/**
 * Servlet implementation class Init
 */
// DB 클래스 확인, 객체 생성 / 저장 / 조립
// @WebServlet("/Init")
public class Init extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// 생성된 객체를 저장하는 변수 선언 ----------------------------------
	// Controller를 저장하는 변수 - 모듈명으로 저장
	private static Map<String, Controller> controllerMap = new HashMap<>();
	// Service를 저장하는 변수 - URI로 저장
	private static Map<String, Service> serviceMap = new HashMap<>();
	// DAO를 저장하는 변수 - 클래스이름 앞 부분 소문자로 저장
	private static Map<String, DAO> daoMap = new HashMap<>();
	
	// Controller 저장변수에서 Controller를 꺼내가는 메서드
	public static Controller getController(String module) {
		return controllerMap.get(module);
	}
	
	// Service 저장변수에서 Service를 꺼내가는 메서드
	public static Service getService(String uri) {
		return serviceMap.get(uri);
	}
	
    /**
     * Default constructor. 
     */
    public Init() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */
    // 서버가 돌아갈 때 실행되도록 하고 싶다.
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		System.out.println("Init.init()-----------------------------------------------------");
		// 1. 생성하고, 2 저장 - map, 3. 조립
		// 생성해서 저장해 놓는다.
		
		// ***공지사항 생성/저장/조립
		// -- Controller 저장
		controllerMap.put("/notice", new NoticeController());
		// -- Service 저장
		serviceMap.put("/notice/list.do", new NoticeListService());
		serviceMap.put("/notice/write.do", new NoticeWriteService());
		serviceMap.put("/notice/view.do", new NoticeViewService());
		serviceMap.put("/notice/update.do", new NoticeUpdateService());
		serviceMap.put("/notice/delete.do", new NoticeDeleteService());
		// -- DAO 저장
		daoMap.put("noticeDAO", new NoticeDAO());
		// -- service에 dao 조립
		serviceMap.get("/notice/list.do").setDAO(daoMap.get("noticeDAO"));
		serviceMap.get("/notice/write.do").setDAO(daoMap.get("noticeDAO"));
		serviceMap.get("/notice/view.do").setDAO(daoMap.get("noticeDAO"));
		serviceMap.get("/notice/update.do").setDAO(daoMap.get("noticeDAO"));
		serviceMap.get("/notice/delete.do").setDAO(daoMap.get("noticeDAO"));
		
		
		// *** 회원관리 생성/저장/조립
		// 1. Controller 저장
		controllerMap.put("/member", new MemberController());
		// 2. Service 저장 - uri를 키값으로 저장
		serviceMap.put("/member/login.do", new LoginService());
		// 최근 접속일 변경 (Controller 내부에서 강제 호출하는 URI)
		serviceMap.put("/member/updateLastLogin.do", new MemberUpdateLastLoginService());
		serviceMap.put("/member/write.do", new MemberWriteService());
		serviceMap.put("/member/list.do", new MemberListService());
		serviceMap.put("/member/changeStatus.do", new MemberChangeStatusService());
		serviceMap.put("/member/changeGrade.do", new MemberChangeGradeService());
		serviceMap.put("/member/checkId.do", new MemberCheckIdService());
		// 3. DAO 저장
		daoMap.put("memberDAO", new MemberDAO());
		// 4. 조립 (Service에 DAO 주입)
		serviceMap.get("/member/login.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/updateLastLogin.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/write.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/list.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/changeStatus.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/changeGrade.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/checkId.do").setDAO(daoMap.get("memberDAO"));
		
		
		// ***예약 생성/저장/조립
		// Controller
		controllerMap.put("/reservation", new ReservationController());
		// Service
		serviceMap.put("/reservation/list.do", new ReservationListService());
		serviceMap.put("/reservation/view.do", new ReservationViewService());
		serviceMap.put("/reservation/write.do", new ReservationWriteService());
		// DAO
		daoMap.put("reservationDAO", new ReservationDAO());
		// service에 dao 조립
		serviceMap.get("/reservation/list.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/view.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/write.do").setDAO(daoMap.get("reservationDAO"));
		
		
		// ***결제 생성/저장/조립
		// Controller
		controllerMap.put("/payment", new PaymentController());
		// Service
		serviceMap.put("/payment/list.do", new PaymentListService());
		serviceMap.put("/payment/view.do", new PaymentViewService());
		serviceMap.put("/payment/write.do", new PaymentWriteService());
		serviceMap.put("/payment/update.do", new PaymentUpdateService());
		serviceMap.put("/payment/cancel.do", new PaymentCancelService());
		// DAO
		daoMap.put("paymentDAO", new PaymentDAO());
		// service에 dao 조립
		serviceMap.get("/payment/list.do").setDAO(daoMap.get("paymentDAO"));
		serviceMap.get("/payment/view.do").setDAO(daoMap.get("paymentDAO"));
		serviceMap.get("/payment/write.do").setDAO(daoMap.get("paymentDAO"));
		serviceMap.get("/payment/update.do").setDAO(daoMap.get("paymentDAO"));
		serviceMap.get("/payment/cancel.do").setDAO(daoMap.get("paymentDAO"));
		
		
		// *** 통계(Stats) 생성/저장/조립 추가
		// -- Controller 저장
		controllerMap.put("/stats", new StatsController());
		// 2. Service 등록 (URI 전체 경로로 저장)
		// 주의: StatsListService, StatsDAO 등은 본인의 클래스명에 맞게 수정하세요.
		serviceMap.put("/stats/dashboard.do", new StatsDashboardService()); 
		serviceMap.put("/stats/report.do", new StatsReportService());
		serviceMap.put("/stats/categorystats.do", new CategoryStatsService());

		// 3. DAO 등록
		daoMap.put("statsDAO", new StatsDAO());

		// 4. Service에 DAO 조립
		serviceMap.get("/stats/dashboard.do").setDAO(daoMap.get("statsDAO"));
		serviceMap.get("/stats/report.do").setDAO(daoMap.get("statsDAO"));
		serviceMap.get("/stats/categorystats.do").setDAO(daoMap.get("statsDAO"));
		
		
		//review 생성/저장/등록/조립
		// -- Controller 저장
		controllerMap.put("/review", new ReviewController());
		// 2. Service 등록 (URI 전체 경로로 저장)
		// 주의: StatsListService, StatsDAO 등은 본인의 클래스명에 맞게 수정하세요.
		serviceMap.put("/review/list.do", new ReviewListService()); 
		serviceMap.put("/review/write.do", new ReviewWriteService());
		serviceMap.put("/review/update.do", new ReviewUpdateService());
		serviceMap.put("/review/delete.do", new ReviewDeleteService());
		
		// 3. DAO 등록
		daoMap.put("reviewDAO", new ReviewDAO());
		
		// 4. Service에 DAO 조립
		serviceMap.get("/review/list.do").setDAO(daoMap.get("reviewDAO"));
		serviceMap.get("/review/write.do").setDAO(daoMap.get("reviewDAO"));
		serviceMap.get("/review/update.do").setDAO(daoMap.get("reviewDAO"));
		serviceMap.get("/review/delete.do").setDAO(daoMap.get("reviewDAO"));
				
		
		System.out.println("Init.init() - 객체 로딩 완료 -----------------------------------");
	}

}