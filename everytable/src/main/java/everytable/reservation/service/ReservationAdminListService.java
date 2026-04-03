package everytable.reservation.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;
import everytable.util.page.PageObject;

public class ReservationAdminListService implements Service {

    private ReservationDAO dao;

    // 조립용 setter (Init 클래스에서 호출됨)
    public void setDAO(DAO dao) {
        this.dao = (ReservationDAO) dao;
    }

    @Override
    public Object service(Object obj) throws Exception {
        PageObject pageObject = (PageObject) obj;

        // 1. [수정] 매장 주문 총 개수 구하기 (관리자용 메서드 호출)
        // 내부에서 pageObject.getAccepter()에 담긴 storeId를 사용합니다.
        pageObject.setTotalRow(dao.getTotalRowAdmin(pageObject));

        // 2. [수정] 매장 주문 리스트 가져오기 (관리자용 메서드 호출)
        return dao.adminList(pageObject);
    }
}