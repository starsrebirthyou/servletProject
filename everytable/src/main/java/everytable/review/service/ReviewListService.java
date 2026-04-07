package everytable.review.service;

import java.util.List;
import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.review.dao.ReviewDAO;
import everytable.review.vo.ReviewVO;

public class ReviewListService implements Service {
    private ReviewDAO dao;

    @Override
    public void setDAO(DAO dao) {
        this.dao = (ReviewDAO) dao;
    }

    @Override
    public Object service(Object obj) throws Exception {
        // 1. 넘어온 객체가 PageObject인지 확인 후 형변환
    		ReviewVO vo = (ReviewVO) obj;
        
        // 2. DAO의 list 메서드 호출 (ReviewVO를 인자로 전달)
        // DAO에서 이미 유저 ID로 필터링된 리스트를 반환합니다.
        List<ReviewVO> list = dao.list(vo);
        
        // 3. [추가 로직] 본인 확인 처리 (선택 사항)
        // 만약 리스트에 담긴 리뷰들이 로그인한 사람의 리뷰라면 sameId를 1로 세팅
        if (list != null && vo.getUserId() != null) {
            for (ReviewVO listVO : list) {
                if (vo.getUserId().equals(listVO.getUserId())) {
                    listVO.setSameId(1);
                }
            }
        }
        
        return list;
    }
}