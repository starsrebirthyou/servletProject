package everytable.store.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.store.dao.StoreDAO;
import everytable.store.vo.StoreVO;

public class StoreUpdateService implements Service {
    private StoreDAO dao;
    @Override public void setDAO(DAO dao) { this.dao = (StoreDAO) dao; }

    @Override
    public Object service(Object obj) throws Exception {
        return dao.update((StoreVO) obj);
    }
}