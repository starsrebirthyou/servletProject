package everytable.menu.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.menu.dao.MenuDAO;

public class MenuViewService implements Service {
    private MenuDAO dao;
    @Override public void setDAO(DAO dao) { this.dao = (MenuDAO) dao; }

    @Override
    public Object service(Object obj) throws Exception {
        return dao.view((Long) obj);
    }
}