package everytable.payment.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.payment.dao.PaymentDAO;
import everytable.util.page.PageObject;

public class PaymentListService implements Service {
	private PaymentDAO dao = null;
	@Override
	public void setDAO(DAO dao) {
		this.dao = (PaymentDAO) dao;
	}

	@Override
	public Object service(Object obj) throws Exception {
		PageObject pageObject = (PageObject) obj;
		pageObject.setTotalRow(dao.getTotalRow(pageObject));
		return dao.list(pageObject);
	}
	
}
