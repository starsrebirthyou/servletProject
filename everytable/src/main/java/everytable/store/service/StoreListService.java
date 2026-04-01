package everytable.store.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.store.dao.StoreDAO;
import everytable.util.page.PageObject;

public class StoreListService implements Service {
    private StoreDAO dao;
    @Override
    public void setDAO(DAO dao) { this.dao = (StoreDAO) dao; }

    @Override
    public Object service(Object obj) throws Exception {
        PageObject pageObject = (PageObject) obj;
        // DB에서 전체 데이터 개수를 가져와 페이징 계산
        pageObject.setTotalRow(dao.getTotalRow(pageObject));
        return dao.list(pageObject);
    }
}