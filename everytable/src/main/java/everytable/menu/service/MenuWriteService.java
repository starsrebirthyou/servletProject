package everytable.menu.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.menu.dao.MenuDAO;
import everytable.menu.vo.MenuVO;

public class MenuWriteService implements Service {
    private MenuDAO dao;
    @Override public void setDAO(DAO dao) { this.dao = (MenuDAO) dao; }

    @Override
    public Object service(Object obj) throws Exception {
        return dao.write((MenuVO) obj);
    }
}