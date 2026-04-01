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

	@Override
	public Object service(Object obj) throws Exception {
		// TODO Auto-generated method stub
		return dao.delete((ReviewVO)obj);
	}
	

}
