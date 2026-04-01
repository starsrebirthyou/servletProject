package everytable.reservation.service;

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
	 * 
	 * @param obj - 조회할 예약 번호 (Long no)
	 * @return ReservationVO
	 */
	@Override
	// ReservationViewService.java
	public ReservationVO service(Object obj) throws Exception {
	    // [수정] 이제 배열이 아니라 단일 Long이 들어옵/니다.
	    Long no = (Long) obj; 
	    
	    // DAO의 view 메서드 호출 (inc 파라미터는 제거)
	    return dao.view(no); 
	}
}