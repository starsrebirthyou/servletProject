package everytable.reservation.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.vo.ReservationVO;

public class ReservationUpdateService implements Service {

	private ReservationDAO dao = null;

	@Override
	public void setDAO(DAO dao) {
		this.dao = (ReservationDAO) dao;
	}

	@Override
	public Object service(Object obj) throws Exception {
		if (obj instanceof Long) {
			// [수정 폼 조회 로직] 기존과 동일
			Long no = (Long) obj;
			ReservationVO vo = dao.view(no);
			if (vo != null) {
				vo.setOrderList(dao.orderList(no));
				vo.setStoreMenuList(dao.storeMenuList(vo.getStoreId()));
			}
			return vo;
		} else if (obj instanceof ReservationVO) {
			// [수정 처리 로직]
			ReservationVO vo = (ReservationVO) obj;

			// 1. 기본 예약 정보 수정 (reservation 테이블)
			int result = dao.update(vo);

			// 2. ★ 핵심: 기존 메뉴 싹 지우기 ★
			dao.deleteOrderItems(vo.getResNo());

			// 3. ★ 핵심: JSP에서 넘어온 새 메뉴 리스트 다시 넣기 ★
			// 컨트롤러에서 vo.setOrderList()로 메뉴 정보를 담아주어야 합니다.
			if (vo.getOrderList() != null) {
				for (ReservationVO item : vo.getOrderList()) {
					// 수량이 1개 이상인 경우에만 저장
					if (item.getQuantity() > 0) {
						dao.insertOrderItem(vo.getResNo(), item.getMenuNo(), item.getQuantity(), item.getPrice());
					}
				}
			}
			return result;
		}
		return null;
	}
}