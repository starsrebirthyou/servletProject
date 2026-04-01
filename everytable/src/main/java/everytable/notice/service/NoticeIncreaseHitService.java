package everytable.notice.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.notice.dao.NoticeDAO;

public class NoticeIncreaseHitService implements Service {
	
	private NoticeDAO dao = null;

	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		this.dao = (NoticeDAO) dao;
	}

	@Override
	public Object service(Object obj) throws Exception {
		// TODO Auto-generated method stub
		return dao.increase((Long) obj);
	}

}
