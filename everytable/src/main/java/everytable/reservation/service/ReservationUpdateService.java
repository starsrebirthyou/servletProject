package everytable.reservation.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.vo.ReservationVO;

public class ReservationUpdateService implements Service{
	
private ReservationDAO dao = null;
	
	// Init에서 이미 생성된 dao를 전달해서 저장해 놓는다. - 서버가 시작될 때 : 코딩 필
	public void setDAO(DAO dao) {
		this.dao = (ReservationDAO) dao;
	}
	
	@Override
	public Object service(Object obj) throws Exception {
		// TODO Auto-generated method stub
		return dao.update((ReservationVO) obj);
	}

}
