package everytable.reservation.service;

import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.vo.ReservationVO;
import everytable.main.dao.DAO;
import everytable.main.service.Service;

public class ReservationFinalOrderService implements Service {
    
    private ReservationDAO dao;

    @Override
    public void setDAO(DAO dao) {
        this.dao = (ReservationDAO) dao;
    }

    @Override
    public Integer service(Object obj) throws Exception {
        ReservationVO vo = (ReservationVO) obj;
        
        // 1. 현재까지 담긴 메뉴들의 총 합계를 DAO에서 계산해옴
        Long totalPrice = dao.groupOrderTotal(vo.getResNo());
        
        // 2. 계산된 총액과 사용자가 입력한 요청사항(orderAdd)을 DB에 최종 업데이트
        return dao.updateFinalOrder(vo.getResNo(), totalPrice, vo.getOrderAdd());
    }
}