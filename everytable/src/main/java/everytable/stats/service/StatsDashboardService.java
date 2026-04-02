package everytable.stats.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.stats.dao.StatsDAO;
import everytable.util.page.PageObject;

public class StatsDashboardService implements Service{

	private StatsDAO dao;
	
	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		this.dao = (StatsDAO) dao;
		
	}

	@Override
	public Object service(Object obj) throws Exception {
		// TODO Auto-generated method stub
		return dao.dashboard((PageObject) obj);
	}

}
