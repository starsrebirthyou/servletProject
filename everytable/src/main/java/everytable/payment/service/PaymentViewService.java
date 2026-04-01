package everytable.payment.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.payment.dao.PaymentDAO;

public class PaymentViewService implements Service {
	private PaymentDAO dao = null;
	@Override
	public void setDAO(DAO dao) {
		this.dao = (PaymentDAO) dao;
	}

	@Override
	public Object service(Object obj) throws Exception {
		Long no = (Long) obj;
		return dao.view(no);
	}
	
}
