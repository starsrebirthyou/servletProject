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
        return dao.refund((RefundVO) obj);
    }
}