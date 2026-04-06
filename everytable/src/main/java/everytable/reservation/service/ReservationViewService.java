package everytable.reservation.service;

import java.util.List;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.reservation.dao.ReservationDAO;
import everytable.reservation.vo.ReservationVO;

public class ReservationViewService implements Service {

    private ReservationDAO dao = null;

    // Init에서 이미 생성된 dao를 전달받아 저장
    @Override
    public void setDAO(DAO dao) {
        this.dao = (ReservationDAO) dao;
    }

    /**
     * 예약 상세 보기 서비스
     * * @param obj - 조회할 예약 번호 (Long no)
     * @return ReservationVO (예약 정보 + 주문 메뉴 리스트가 합쳐진 상태)
     */
    @Override
    public ReservationVO service(Object obj) throws Exception {
        // 1. 전달받은 예약 번호(no) 캐스팅
        Long no = (Long) obj; 
        
        // 2. 예약 기본 정보 가져오기 (매장명, 예약일, 인원 등)
        ReservationVO vo = dao.view(no);
        
        // 3. 예약 정보가 정상적으로 존재할 때만 상세 메뉴 리스트를 가져와서 합치기
        if (vo != null) {
            // DAO에 새로 만든 getOrderList(no) 메서드를 호출하여 리스트를 가져옴
            List<ReservationVO> list = dao.orderList(no);
            
            // 가져온 리스트를 vo 객체 내부의 orderList 필드에 세팅
            vo.setOrderList(list);
        }
        
        // 4. 모든 정보가 담긴 vo를 컨트롤러로 반환
        return vo; 
    }
}