package everytable.review.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.review.dao.ReviewDAO;
import everytable.review.vo.ReviewVO;

public class ReviewWriteService implements Service {
    private ReviewDAO dao;
    
    @Override
    public Object service(Object obj) throws Exception {
        // obj는 컨트롤러에서 넘겨준 ReviewVO입니다.
        return dao.write((ReviewVO) obj);
    }

	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		this.dao = (ReviewDAO) dao;
	}
}