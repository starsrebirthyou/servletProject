package everytable.reservation.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.vo.ReservationVO;

public class ReservationAdminUpdateService implements Service {
	
	private ReservationDAO dao = null;
	
	// Init에서 이미 생성된 dao를 전달해서 저장해 놓는다.
	public void setDAO(DAO dao) {
		this.dao = (ReservationDAO) dao;
	}
	
	@Override
	public Object service(Object obj) throws Exception {
		// 관리자용 상태 변경(승인/거절/사유업데이트) 메서드 호출
		// DAO에 작성하신 updateStatus(vo) 메서드를 실행합니다.
		return dao.adminUpdate((ReservationVO) obj);
	}

}