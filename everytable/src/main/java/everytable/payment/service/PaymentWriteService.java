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
        // 1. 전달받은 객체를 PaymentVO로 캐스팅합니다.
        PaymentVO vo = (PaymentVO) obj;
        
        // 2. DAO의 write 메서드를 호출합니다.
        // 현재 DAO의 write 메서드 내부에서 [시퀀스 번호 따기 -> ORDERS 인서트 -> PAYMENT 인서트]를 
        // 한 번에 처리하고 있으므로, 서비스에서는 이 한 줄이면 충분합니다.
        return dao.write(vo);
    }
}