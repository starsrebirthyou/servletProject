package everytable.main.controller;

import java.util.HashMap;
import java.util.Map;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.member.controller.MemberController;
import everytable.member.dao.MemberDAO;
import everytable.member.service.*;
import everytable.notice.controller.NoticeController;
import everytable.notice.dao.NoticeDAO;
import everytable.notice.service.*;
import everytable.payment.controller.PaymentController;
import everytable.payment.dao.PaymentDAO;
import everytable.payment.service.*;
import everytable.reservation.controller.ReservationController;
import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.service.*;
import everytable.review.controller.ReviewController;
import everytable.review.dao.ReviewDAO;
import everytable.review.service.*;
import everytable.stats.controller.StatsController;
import everytable.stats.dao.StatsDAO;
import everytable.stats.service.*;
// Store & Menu 관련 Import (패키지명 확인 필수)
import everytable.store.controller.StoreController;
import everytable.store.dao.StoreDAO;
import everytable.store.service.*;
import everytable.menu.controller.MenuController;
import everytable.menu.dao.MenuDAO;
import everytable.menu.service.*;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;

public class Init extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// 객체 저장소 (Map)
	private static Map<String, Controller> controllerMap = new HashMap<>();
	private static Map<String, Service> serviceMap = new HashMap<>();
	private static Map<String, DAO> daoMap = new HashMap<>();
	
	// 객체 꺼내기 메서드
	public static Controller getController(String module) {
		return controllerMap.get(module);
	}
	
	public static Service getService(String uri) {
		return serviceMap.get(uri);
	}
	
    public Init() {
        super();
    }

	public void init(ServletConfig config) throws ServletException {
		System.out.println("Init.init() --- 객체 생성 및 조립 시작 ---");

		// ==============================================
		// 1. 공지사항 (Notice)
		// ==============================================
		// -- Controller 저장
		controllerMap.put("/notice", new NoticeController());
		// -- Service 저장
		serviceMap.put("/notice/list.do", new NoticeListService());
		serviceMap.put("/notice/write.do", new NoticeWriteService());
		serviceMap.put("/notice/view.do", new NoticeViewService());
		serviceMap.put("/notice/update.do", new NoticeUpdateService());
		serviceMap.put("/notice/delete.do", new NoticeDeleteService());
		serviceMap.put("/notice/increaseHit.do", new NoticeIncreaseHitService());
		// -- DAO 저장
		daoMap.put("noticeDAO", new NoticeDAO());
		// -- service에 dao 조립
		serviceMap.get("/notice/list.do").setDAO(daoMap.get("noticeDAO"));
		serviceMap.get("/notice/write.do").setDAO(daoMap.get("noticeDAO"));
		serviceMap.get("/notice/view.do").setDAO(daoMap.get("noticeDAO"));
		serviceMap.get("/notice/update.do").setDAO(daoMap.get("noticeDAO"));
		serviceMap.get("/notice/delete.do").setDAO(daoMap.get("noticeDAO"));
		serviceMap.get("/notice/increaseHit.do").setDAO(daoMap.get("noticeDAO"));
		
		// ==============================================
		// 2. 회원관리 (Member)
		// ==============================================
		controllerMap.put("/member", new MemberController());
		daoMap.put("memberDAO", new MemberDAO());
		
		serviceMap.put("/member/login.do", new LoginService());
		serviceMap.put("/member/updateLastLogin.do", new MemberUpdateLastLoginService());
		serviceMap.put("/member/write.do", new MemberWriteService());
		serviceMap.put("/member/list.do", new MemberListService());
		serviceMap.put("/member/changeStatus.do", new MemberChangeStatusService());
		serviceMap.put("/member/changeGrade.do", new MemberChangeGradeService());
		serviceMap.put("/member/checkId.do", new MemberCheckIdService());
		
		serviceMap.get("/member/login.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/updateLastLogin.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/write.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/list.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/changeStatus.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/changeGrade.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/checkId.do").setDAO(daoMap.get("memberDAO"));
		
		// ==============================================
		// 3. 매장관리 (Store) - 추가됨
		// ==============================================
		controllerMap.put("/store", new StoreController());
		daoMap.put("storeDAO", new StoreDAO());
		
		serviceMap.put("/store/list.do", new StoreListService());
		serviceMap.put("/store/view.do", new StoreViewService());
		// 필요한 경우 write, update, delete 서비스 추가
		
		serviceMap.get("/store/list.do").setDAO(daoMap.get("storeDAO"));
		serviceMap.get("/store/view.do").setDAO(daoMap.get("storeDAO"));

		// ==============================================
		// 4. 메뉴관리 (Menu) - 추가됨
		// ==============================================
		controllerMap.put("/menu", new MenuController());
		daoMap.put("menuDAO", new MenuDAO());
		
		serviceMap.put("/menu/list.do", new MenuListService());
		// serviceMap.put("/menu/view.do", new MenuViewService());
		
		serviceMap.get("/menu/list.do").setDAO(daoMap.get("menuDAO"));

		// ==============================================
		// 5. 예약 (Reservation)
		// ==============================================
		controllerMap.put("/reservation", new ReservationController());
		daoMap.put("reservationDAO", new ReservationDAO());
		
		serviceMap.put("/reservation/list.do", new ReservationListService());
		serviceMap.put("/reservation/view.do", new ReservationViewService());
		serviceMap.put("/reservation/write.do", new ReservationWriteService());
		
		serviceMap.get("/reservation/list.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/view.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/write.do").setDAO(daoMap.get("reservationDAO"));

		// ==============================================
		// 6. 결제 (Payment)
		// ==============================================
		controllerMap.put("/payment", new PaymentController());
		daoMap.put("paymentDAO", new PaymentDAO());
		
		serviceMap.put("/payment/list.do", new PaymentListService());
		serviceMap.put("/payment/view.do", new PaymentViewService());
		serviceMap.put("/payment/write.do", new PaymentWriteService());
		serviceMap.put("/payment/update.do", new PaymentUpdateService());
		
		serviceMap.get("/payment/list.do").setDAO(daoMap.get("paymentDAO"));
		serviceMap.get("/payment/view.do").setDAO(daoMap.get("paymentDAO"));
		serviceMap.get("/payment/write.do").setDAO(daoMap.get("paymentDAO"));
		serviceMap.get("/payment/update.do").setDAO(daoMap.get("paymentDAO"));

		// ==============================================
		// 7. 리뷰 (Review)
		// ==============================================
		controllerMap.put("/review", new ReviewController());
		daoMap.put("reviewDAO", new ReviewDAO());
		
		serviceMap.put("/review/list.do", new ReviewListService()); 
		serviceMap.put("/review/write.do", new ReviewWriteService());
		serviceMap.put("/review/update.do", new ReviewUpdateService());
		serviceMap.put("/review/delete.do", new ReviewDeleteService());
		
		serviceMap.get("/review/list.do").setDAO(daoMap.get("reviewDAO"));
		serviceMap.get("/review/write.do").setDAO(daoMap.get("reviewDAO"));
		serviceMap.get("/review/update.do").setDAO(daoMap.get("reviewDAO"));
		serviceMap.get("/review/delete.do").setDAO(daoMap.get("reviewDAO"));

		// ==============================================
		// 8. 통계 (Stats)
		// ==============================================
		controllerMap.put("/stats", new StatsController());
		daoMap.put("statsDAO", new StatsDAO());
		
		serviceMap.put("/stats/dashboard.do", new StatsDashboardService()); 
		serviceMap.put("/stats/report.do", new StatsReportService());
		serviceMap.put("/stats/categorystats.do", new CategoryStatsService());

		serviceMap.get("/stats/dashboard.do").setDAO(daoMap.get("statsDAO"));
		serviceMap.get("/stats/report.do").setDAO(daoMap.get("statsDAO"));
		serviceMap.get("/stats/categorystats.do").setDAO(daoMap.get("statsDAO"));
		
		System.out.println("Init.init() --- 모든 객체 로딩 및 조립 완료 ---");
	}
}