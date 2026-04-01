package everytable.reservation.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;
import everytable.util.page.PageObject;

public class ReservationListService implements Service{
	
	private ReservationDAO dao = null;

	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		this.dao = (ReservationDAO) dao;
		
	}

	@Override
	public Object service(Object obj) throws Exception {
		PageObject pageObject = (PageObject) obj;
		// TODO Auto-generated method stub
		pageObject.setTotalRow(dao.getTotalRow(pageObject));
		
		return dao.list(pageObject);
	}
	
	

}
