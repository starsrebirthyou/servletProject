package everytable.refund.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.refund.dao.RefundDAO;
import everytable.refund.vo.RefundVO;

public class RefundRefundService implements Service {

    private RefundDAO dao;

    @Override
    public void setDAO(DAO dao) {
        this.dao = (RefundDAO) dao;
    }

    @Override 
    public Object service(Object obj) throws Exception {
        RefundVO vo = (RefundVO) obj;
        
        // 1. 환불 테이블에 기록 남기기 (INSERT)
        int result = dao.refund(vo);
        
        // 2. 결제 테이블(payment)의 상태를 'REFUNDED'로 변경하기 (UPDATE)
        // ★ 이 부분이 실행되어야 DB의 STATUS가 바뀝니다!
        if (result == 1) {
            dao.updatePaymentStatus(vo.getPayment_id());
        }
        
        return result;
    }
}