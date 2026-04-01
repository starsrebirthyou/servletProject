package everytable.stats.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.stats.dao.StatsDAO;
import everytable.util.page.PageObject;

public class StatsReportService implements Service{
	private StatsDAO dao;

	@Override
	public void setDAO(DAO dao) {
		// TODO Auto-generated method stub
		this.dao = (StatsDAO) dao;
		
	}

	@Override
	public Object service(Object obj) throws Exception {
		return dao.report((PageObject) obj);
	}

}
