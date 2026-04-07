package everytable.store.service;

import everytable.main.service.Service;
import everytable.main.dao.DAO;
import everytable.store.dao.StoreDAO;
import everytable.store.vo.StoreVO;

public class StoreWriteService implements Service {
    private StoreDAO dao;

    @Override
    public void setDAO(DAO dao) { this.dao = (StoreDAO) dao; }

    @Override
    public Object service(Object obj) throws Exception {
        return dao.write((StoreVO) obj);
    }
}
