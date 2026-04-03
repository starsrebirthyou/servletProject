package everytable.menu.service;

import everytable.main.service.Service;
import everytable.main.dao.DAO;
import everytable.menu.dao.MenuDAO;
import everytable.menu.vo.MenuVO;

public class MenuChangeStatusService implements Service {
    private MenuDAO dao;
    @Override
    public void setDAO(DAO dao) { this.dao = (MenuDAO) dao; }

    @Override
    public Object service(Object obj) throws Exception {
        // MenuVO를 받아서 DB 업데이트 수행
        return dao.changeStatus((MenuVO) obj);
    }
}