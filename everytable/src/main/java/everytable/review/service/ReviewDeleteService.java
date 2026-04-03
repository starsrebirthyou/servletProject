package everytable.review.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.review.dao.ReviewDAO;
import everytable.review.vo.ReviewVO;

public class ReviewDeleteService implements Service{
	private ReviewDAO dao;

	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		this.dao = (ReviewDAO) dao;
		
	}

	// 수정 후 (이렇게 바꾸세요!)
	@Override
	public Object service(Object obj) throws Exception {
	    // Controller에서 이미 숫자(Long)를 보냈으므로 바로 long으로 형변환해서 사용합니다.
	    long no = (long)obj; 
	    
	    // DAO의 delete(long no) 메서드에 바로 전달
	    return dao.delete(no);
	}
}
