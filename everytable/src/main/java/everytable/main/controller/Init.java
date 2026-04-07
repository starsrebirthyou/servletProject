package everytable.main.controller;

import java.util.HashMap;
import java.util.Map;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.member.controller.MemberController;
import everytable.member.dao.MemberDAO;
import everytable.member.service.LoginService;
import everytable.member.service.MemberChangeEmailService;
import everytable.member.service.MemberChangeGradeService;
import everytable.member.service.MemberChangePwService;
import everytable.member.service.MemberChangeStatusService;
import everytable.member.service.MemberChangeTelService;
import everytable.member.service.MemberCheckEmailService;
import everytable.member.service.MemberCheckIdService;
import everytable.member.service.MemberCheckMemberInfoService;
import everytable.member.service.MemberCheckTelService;
import everytable.member.service.MemberInfoService;
import everytable.member.service.MemberListService;
import everytable.member.service.MemberResetPwService;
import everytable.member.service.MemberSearchIdService;
import everytable.member.service.MemberUpdateLastLoginService;
import everytable.member.service.MemberViewService;
import everytable.member.service.MemberWithdrawService;
import everytable.member.service.MemberWriteService;
import everytable.menu.controller.MenuController;
import everytable.menu.dao.MenuDAO;
import everytable.menu.service.MenuChangeStatusService;
import everytable.menu.service.MenuDeleteService;
import everytable.menu.service.MenuListService;
import everytable.menu.service.MenuUpdateService;
import everytable.menu.service.MenuViewService;
import everytable.menu.service.MenuWriteService;
import everytable.notice.controller.NoticeController;
import everytable.notice.dao.NoticeDAO;
import everytable.notice.service.NoticeDeleteService;
import everytable.notice.service.NoticeIncreaseHitService;
import everytable.notice.service.NoticeListService;
import everytable.notice.service.NoticeUpdateService;
import everytable.notice.service.NoticeViewService;
import everytable.notice.service.NoticeWriteService;
import everytable.payment.controller.PaymentController;
import everytable.payment.dao.PaymentDAO;
import everytable.payment.service.PaymentListService;
import everytable.payment.service.PaymentUpdateService;
import everytable.payment.service.PaymentViewService;
import everytable.payment.service.PaymentWriteService;
import everytable.refund.controller.RefundController;
import everytable.refund.dao.RefundDAO;
import everytable.refund.service.RefundRefundService;
import everytable.reservation.controller.ReservationController;
import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.service.GroupMenuFormService;
import everytable.reservation.service.GroupOrderListService;
import everytable.reservation.service.GroupOrderTotalService;
import everytable.reservation.service.GroupOrderWriteService;
import everytable.reservation.service.ReservationAdminCancelService;
import everytable.reservation.service.ReservationAdminListService;
import everytable.reservation.service.ReservationAdminUpdateService;
import everytable.reservation.service.ReservationAdminViewService;
import everytable.reservation.service.ReservationCancelService;
import everytable.reservation.service.ReservationListService;
import everytable.reservation.service.ReservationUpdateService;
import everytable.reservation.service.ReservationViewService;
import everytable.reservation.service.ReservationWriteService;
import everytable.review.controller.ReviewController;
import everytable.review.dao.ReviewDAO;
import everytable.review.service.ReviewDeleteService;
import everytable.review.service.ReviewListService;
import everytable.review.service.ReviewUpdateService;
import everytable.review.service.ReviewViewService;
import everytable.review.service.ReviewWriteService;
import everytable.stats.controller.StatsController;
import everytable.stats.dao.StatsDAO;
import everytable.stats.service.CategoryStatsService;
import everytable.stats.service.StatsCategorySalesService;
import everytable.stats.service.StatsDashboardService;
import everytable.stats.service.StatsReportService;
import everytable.stats.service.StatsTodaySummaryService;
// Store & Menu 관련 Import (패키지명 확인 필수)
import everytable.store.controller.StoreController;
import everytable.store.dao.StoreDAO;
import everytable.store.service.StoreListService;
import everytable.store.service.StoreUpdateService;
import everytable.store.service.StoreViewService;
import everytable.store.service.StoreWriteService;
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
		// -- Controller 저장
		controllerMap.put("/member", new MemberController());
		// -- Service 저장
		serviceMap.put("/member/login.do", new LoginService());
		serviceMap.put("/member/view.do", new MemberViewService());
		serviceMap.put("/member/updateLastLogin.do", new MemberUpdateLastLoginService());
		serviceMap.put("/member/write.do", new MemberWriteService());
		serviceMap.put("/member/list.do", new MemberListService());
		serviceMap.put("/member/changeStatus.do", new MemberChangeStatusService());
		serviceMap.put("/member/changeGrade.do", new MemberChangeGradeService());
		serviceMap.put("/member/checkId.do", new MemberCheckIdService());
		serviceMap.put("/member/checkTel.do", new MemberCheckTelService());
		serviceMap.put("/member/checkEmail.do", new MemberCheckEmailService());
		serviceMap.put("/member/searchId.do", new MemberSearchIdService());
		serviceMap.put("/member/checkMemberInfo.do", new MemberCheckMemberInfoService());
		serviceMap.put("/member/resetPw.do", new MemberResetPwService());
		serviceMap.put("/member/changeTel.do", new MemberChangeTelService());
		serviceMap.put("/member/changeEmail.do", new MemberChangeEmailService());
		serviceMap.put("/member/changePw.do", new MemberChangePwService());
		serviceMap.put("/member/withdraw.do", new MemberWithdrawService());
		serviceMap.put("/member/memberInfo.do", new MemberInfoService());
		// -- DAO 저장
		daoMap.put("memberDAO", new MemberDAO());
		// -- service에 dao 조립
		serviceMap.get("/member/login.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/view.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/updateLastLogin.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/write.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/list.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/changeStatus.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/changeGrade.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/checkId.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/checkTel.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/checkEmail.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/searchId.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/checkMemberInfo.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/resetPw.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/changeTel.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/changeEmail.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/withdraw.do").setDAO(daoMap.get("memberDAO"));
		serviceMap.get("/member/memberInfo.do").setDAO(daoMap.get("memberDAO"));

		// ==============================================
		// 3. 매장관리 (Store)
		// ==============================================
		controllerMap.put("/store", new StoreController());
		daoMap.put("storeDAO", new StoreDAO());

		serviceMap.put("/store/list.do",   new StoreListService());
		serviceMap.put("/store/view.do",   new StoreViewService());
		serviceMap.put("/store/write.do",  new StoreWriteService()); 
		serviceMap.put("/store/update.do", new StoreUpdateService());

		serviceMap.get("/store/list.do").setDAO(daoMap.get("storeDAO"));
		serviceMap.get("/store/view.do").setDAO(daoMap.get("storeDAO"));
		serviceMap.get("/store/write.do").setDAO(daoMap.get("storeDAO")); 
		serviceMap.get("/store/update.do").setDAO(daoMap.get("storeDAO"));


		// ==============================================
		// 4. 메뉴관리 (Menu)
		// ==============================================
		controllerMap.put("/menu", new MenuController()); // 
		daoMap.put("menuDAO", new MenuDAO());

		serviceMap.put("/menu/list.do",         new MenuListService());
		serviceMap.put("/menu/view.do",         new MenuViewService());
		serviceMap.put("/menu/write.do",        new MenuWriteService());
		serviceMap.put("/menu/update.do",       new MenuUpdateService());
		serviceMap.put("/menu/delete.do",       new MenuDeleteService());
		serviceMap.put("/menu/changeStatus.do", new MenuChangeStatusService());

		serviceMap.get("/menu/list.do").setDAO(daoMap.get("menuDAO"));
		serviceMap.get("/menu/view.do").setDAO(daoMap.get("menuDAO"));
		serviceMap.get("/menu/write.do").setDAO(daoMap.get("menuDAO"));
		serviceMap.get("/menu/update.do").setDAO(daoMap.get("menuDAO"));
		serviceMap.get("/menu/delete.do").setDAO(daoMap.get("menuDAO"));
		serviceMap.get("/menu/changeStatus.do").setDAO(daoMap.get("menuDAO"));
		
		// ==============================================
		// 5. 예약 (Reservation)
		// ==============================================
		controllerMap.put("/reservation", new ReservationController());
		daoMap.put("reservationDAO", new ReservationDAO());

		serviceMap.put("/reservation/list.do", new ReservationListService());
		serviceMap.put("/reservation/view.do", new ReservationViewService());
		serviceMap.put("/reservation/write.do", new ReservationWriteService());
		serviceMap.put("/reservation/update.do", new ReservationUpdateService());
		serviceMap.put("/reservation/cancel.do", new ReservationCancelService());
		// 관리자
		serviceMap.put("/reservation/adminList.do", new ReservationAdminListService());
		serviceMap.put("/reservation/adminView.do", new ReservationAdminViewService());
		serviceMap.put("/reservation/adminUpdate.do", new ReservationAdminUpdateService());
		serviceMap.put("/reservation/adminCancel.do", new ReservationAdminCancelService());
		// url
		serviceMap.put("/reservation/groupOrderWrite.do",  new GroupOrderWriteService());
		serviceMap.put("/reservation/groupOrderList.do",   new GroupOrderListService());
		serviceMap.put("/reservation/groupOrderTotal.do",  new GroupOrderTotalService());
		serviceMap.put("/reservation/groupMenuForm.do", new GroupMenuFormService());
		serviceMap.put("/reservation/groupShare.do", new ReservationViewService());


		serviceMap.get("/reservation/list.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/view.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/write.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/update.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/cancel.do").setDAO(daoMap.get("reservationDAO"));
		// 관리자
		serviceMap.get("/reservation/adminList.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/adminView.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/adminUpdate.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/adminCancel.do").setDAO(daoMap.get("reservationDAO"));
		// url
		serviceMap.get("/reservation/groupOrderWrite.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/groupOrderList.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/groupOrderTotal.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/groupMenuForm.do").setDAO(daoMap.get("reservationDAO"));
		serviceMap.get("/reservation/groupShare.do").setDAO(daoMap.get("reservationDAO"));



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
		serviceMap.put("/review/view.do", new ReviewViewService());

		serviceMap.get("/review/list.do").setDAO(daoMap.get("reviewDAO"));
		serviceMap.get("/review/write.do").setDAO(daoMap.get("reviewDAO"));
		serviceMap.get("/review/update.do").setDAO(daoMap.get("reviewDAO"));
		serviceMap.get("/review/delete.do").setDAO(daoMap.get("reviewDAO"));
		serviceMap.get("/review/view.do").setDAO(daoMap.get("reviewDAO"));

		// ==============================================
		// 8. 통계 (Stats)
		// ==============================================
		controllerMap.put("/stats", new StatsController());
		daoMap.put("statsDAO", new StatsDAO());

		// 서비스 등록 - 각각 고유한 URI를 부여해야 합니다.
		serviceMap.put("/stats/list.do", new StatsDashboardService()); // 리스트용
		serviceMap.put("/stats/report.do", new StatsReportService());  // 리포트용
		serviceMap.put("/stats/todaySummary.do", new StatsTodaySummaryService()); // 오늘 요약용 (추가)
		serviceMap.put("/stats/categorySales.do", new StatsCategorySalesService()); // 카테고리 차트용 (추가)
		// 만약 기존에 쓰던 이름이 있다면 유지
		serviceMap.put("/stats/categorystats.do", new CategoryStatsService()); 

		// DAO 조립 (프라이팬 쥐여주기)
		serviceMap.get("/stats/list.do").setDAO(daoMap.get("statsDAO"));
		serviceMap.get("/stats/report.do").setDAO(daoMap.get("statsDAO"));
		serviceMap.get("/stats/todaySummary.do").setDAO(daoMap.get("statsDAO"));
		serviceMap.get("/stats/categorySales.do").setDAO(daoMap.get("statsDAO"));
		serviceMap.get("/stats/categorystats.do").setDAO(daoMap.get("statsDAO"));
		
		// ==============================================
		// 10. 환불 (Refund)
		// ==============================================
		controllerMap.put("/refund", new RefundController());
		daoMap.put("refundDAO", new RefundDAO());

		serviceMap.put("/refund/refund.do", new RefundRefundService());

		serviceMap.get("/refund/refund.do").setDAO(daoMap.get("refundDAO"));

		System.out.println("Init.init() --- 모든 객체 로딩 및 조립 완료 ---");
	}
}