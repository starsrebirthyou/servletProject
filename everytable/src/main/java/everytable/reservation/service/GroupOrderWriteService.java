package everytable.reservation.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.vo.ReservationVO;

public class GroupOrderWriteService implements Service {
    private ReservationDAO dao;
    @Override public void setDAO(DAO dao) { this.dao = (ReservationDAO) dao; }

    @Override
    public Object service(Object obj) throws Exception {
        dao.orderWrite((ReservationVO) obj);
        return null;
    }

}
