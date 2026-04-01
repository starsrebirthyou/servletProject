package everytable.payment.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.payment.dao.PaymentDAO;
import everytable.payment.vo.PaymentVO;

public class PaymentUpdateService implements Service {
    private PaymentDAO dao = null;

    @Override
    public void setDAO(DAO dao) {
        this.dao = (PaymentDAO) dao;
    }

    @Override
    public Object service(Object obj) throws Exception {
        
        System.out.println("PaymentUpdateService.service() - 결제 상태 수정 실행");
        
        return dao.update((PaymentVO) obj);
    }
}