package everytable.reservation.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.vo.ReservationVO;

public class ReservationOrderWriteService implements Service {
	
	private ReservationDAO dao = null;

	@Override
	public void setDAO(DAO dao) {
		// Init에서 전달한 DAO 객체를 서비스 내부 변수에 저장합니다.
		// (ReservationDAO)로 형변환(Casting)이 필요합니다.
		this.dao = (ReservationDAO) dao;
	}

	@Override
	public Object service(Object obj) throws Exception {
		// 이제 dao가 null이 아니므로 DB에 저장하는 write 메서드를 호출합니다.
		return dao.write((ReservationVO) obj);
	}

}