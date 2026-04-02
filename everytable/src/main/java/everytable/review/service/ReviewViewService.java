package everytable.review.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.review.dao.ReviewDAO;

public class ReviewViewService implements Service {
	private ReviewDAO dao;
	
	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		this.dao =(ReviewDAO) dao;
	}

	// ReviewViewService.java

	@Override
	public Object service(Object obj) throws Exception {
	    // 로그에 찍힌 '넘겨 받은 데이터'가 22(숫자)이므로, 
	    // ReviewVO가 아니라 Long(또는 long)으로 받아야 합니다.
	    
	    // 1. obj를 long으로 형변환합니다.
	    long no = (long) obj; 
	    
	    // 2. DAO의 view 메서드에 이 번호를 넘겨줍니다.
	    return dao.view(no);
	}
}
