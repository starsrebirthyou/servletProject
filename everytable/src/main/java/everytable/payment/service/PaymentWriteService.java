package everytable.payment.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.payment.dao.PaymentDAO;
import everytable.payment.vo.PaymentVO;

public class PaymentWriteService implements Service {
	private PaymentDAO dao = null;
	@Override
	public void setDAO(DAO dao) {
		this.dao = (PaymentDAO) dao;
	}

	@Override
	public Object service(Object obj) throws Exception {
		return dao.write((PaymentVO)obj);
	}
	
}
