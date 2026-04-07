package everytable.menu.service;

import everytable.main.service.Service;
import everytable.main.dao.DAO;
import everytable.menu.dao.MenuDAO;

public class MenuListService implements Service {
    private MenuDAO dao;
    @Override public void setDAO(DAO dao) { this.dao = (MenuDAO) dao; }

    @Override
    public Object service(Object obj) throws Exception {
        // obj가 Long이면 사용자용(is_active=1), Object[] 이면 점주용으로 처리 가능
        // 여기서는 단순화를 위해 Long(store_id)만 처리
        return dao.list((Long) obj, true); 
    }
}