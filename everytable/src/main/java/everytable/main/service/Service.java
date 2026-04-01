package everytable.main.service;

import everytable.main.dao.DAO;

public interface Service {

	// dao를 Init에서 받아서 저장하는 setter를 만든다.
	public void setDAO(DAO dao);
	
	// service를 실행하는 메서드
	public Object service(Object obj) throws Exception;
	
}
