package everytable.reservation.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;
import everytable.util.page.PageObject;

public class ReservationListService implements Service {

    private ReservationDAO dao;

    // 조립용 setter (Init 클래스에서 호출됨)
    public void setDAO(DAO dao) {
        this.dao = (ReservationDAO) dao;
    }

    @Override
    public Object service(Object obj) throws Exception {
        PageObject pageObject = (PageObject) obj;

        // 1. 내 예약 총 개수 구하기 (내부에서 pageObject.getAccepter() 사용)
        pageObject.setTotalRow(dao.getTotalRow(pageObject));

        // 2. 내 예약 리스트 가져오기
        return dao.list(pageObject);
    }
}