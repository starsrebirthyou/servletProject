package everytable.review.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.review.dao.ReviewDAO;
import everytable.review.vo.ReviewVO;
import everytable.util.page.PageObject;

public class ReviewListService implements Service{
	private ReviewDAO dao;

	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		this.dao = (ReviewDAO) dao;
		
	}

	@Override
	public Object service(Object obj) throws Exception {
		PageObject pageObject = (PageObject) obj;
		// TODO Auto-generated method stub
		pageObject.setTotalRow(dao.getTotalRow(pageObject));
		
		return dao.list(pageObject);
	}
	

}
