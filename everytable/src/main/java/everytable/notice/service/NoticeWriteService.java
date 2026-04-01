package everytable.notice.service;

import everytable.main.dao.DAO;
import everytable.notice.dao.NoticeDAO;
import everytable.notice.vo.NoticeVO;

public class NoticeWriteService implements everytable.main.service.Service {
	
	private NoticeDAO dao = null;

	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		this.dao = (NoticeDAO) dao;
	}

	@Override
	public Object service(Object obj) throws Exception {
		// TODO Auto-generated method stub
		return dao.write((NoticeVO) obj);
	}

}
