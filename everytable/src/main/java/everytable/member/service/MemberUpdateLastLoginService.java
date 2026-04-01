package everytable.member.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.member.dao.MemberDAO;

public class MemberUpdateLastLoginService implements Service {

    private MemberDAO dao = null;
    
    public void setDAO(DAO dao) {
        this.dao = (MemberDAO) dao;
    }
 
    @Override
    public Object service(Object obj) throws Exception {
        return dao.updateLastLogin((String) obj);
    }

}
