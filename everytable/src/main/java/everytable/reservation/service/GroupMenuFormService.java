package everytable.reservation.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;

public class GroupMenuFormService implements Service {
    private ReservationDAO dao;
    @Override public void setDAO(DAO dao) { this.dao = (ReservationDAO) dao; }

    @Override
    public Object service(Object obj) throws Exception {
        return dao.menuListByResNo((Long) obj);
    }
}
