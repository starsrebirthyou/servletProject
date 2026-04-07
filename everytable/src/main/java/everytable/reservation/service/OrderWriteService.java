package everytable.reservation.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.vo.ReservationVO;

public class OrderWriteService implements Service {
	
	private ReservationDAO dao = null;

	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Object service(Object obj) throws Exception {
		// TODO Auto-generated method stub
		return dao.write((ReservationVO) obj);
	}

}
