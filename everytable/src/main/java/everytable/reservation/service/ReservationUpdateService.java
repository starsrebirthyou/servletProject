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
	public ReservationVO service(Object obj) throws Exception {
		// 1. obj가 Long인지 ReservationVO인지 체크해서 처리
		Long no = null;

		if (obj instanceof Long) {
			no = (Long) obj;
		} else if (obj instanceof ReservationVO) {
			no = ((ReservationVO) obj).getResNo();
		}

		// 2. 기존 예약 정보 가져오기 (매장 정보 포함)
		ReservationVO vo = dao.view(no);

		if (vo != null) {
			// 3. 해당 예약번호(no)로 이미 주문한 메뉴 리스트 가져와서 담기
			vo.setOrderList(dao.orderList(no));

			// 4. 해당 매장(storeId)의 전체 메뉴 리스트 가져와서 담기
			vo.setStoreMenuList(dao.storeMenuList(vo.getStoreId()));
		}

		return vo;
	}
}
