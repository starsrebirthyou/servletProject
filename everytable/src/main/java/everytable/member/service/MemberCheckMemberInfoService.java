package everytable.member.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.member.dao.MemberDAO;
import everytable.member.vo.MemberVO;

public class MemberCheckMemberInfoService implements Service {

    private MemberDAO dao = null;

    public void setDAO(DAO dao) {
        this.dao = (MemberDAO) dao;
    }

    @Override
    public Object service(Object obj) throws Exception {
        return dao.checkMemberInfo((MemberVO) obj);
    }
}