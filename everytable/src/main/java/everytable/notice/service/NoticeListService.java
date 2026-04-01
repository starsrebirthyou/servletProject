package everytable.notice.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.notice.dao.NoticeDAO;
import everytable.util.page.PageObject;

public class NoticeListService implements Service {
	
	private NoticeDAO dao = null;

	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		this.dao = (NoticeDAO) dao;
	}

	@Override
	public Object service(Object obj) throws Exception {
		// TODO Auto-generated method stub
		PageObject pageObject = (PageObject) obj;
		// 전체 데이터의 개수 세팅. DB 가져와서 -> dao 메서드 필요
		// 페이지 정보 계산. 누락되면 페이지 정보 이상해짐
		pageObject.setTotalRow(dao.getTotalRow(pageObject));
		return dao.list(pageObject);
	}

}
