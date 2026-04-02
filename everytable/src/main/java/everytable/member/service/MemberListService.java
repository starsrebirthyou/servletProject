package everytable.member.service;


import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.member.dao.MemberDAO;
import everytable.member.vo.MemberVO;
import everytable.util.page.PageObject;

public class MemberListService implements Service {

    private MemberDAO dao = null;
    
    public void setDAO(DAO dao) {
        this.dao = (MemberDAO) dao;
    }
 
    // obj = Object[]{PageObject, MemberVO(filterVO)}
    @Override
    public Object service(Object obj) throws Exception {
        Object[] params = (Object[]) obj;
        PageObject pageObject = (PageObject) params[0];
        MemberVO  filterVO   = (MemberVO)   params[1];
 
        // 전체 행 수 계산 → pageObject에 세팅 (startRow/endRow/totalPage 자동 계산)
        pageObject.setTotalRow(dao.getTotalRow(pageObject, filterVO));
 
        return dao.list(pageObject, filterVO);
    }
	
}
