package everytable.stats.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.stats.dao.StatsDAO;

public class StatsCategorySalesService implements Service {

	private StatsDAO dao = new StatsDAO();
    @Override
    public Object service(Object obj) throws Exception {
        return dao.getCategorySales((String)obj); // 아이디를 넘겨서 카테고리 리스트 리턴
    }
	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		
	}
}
