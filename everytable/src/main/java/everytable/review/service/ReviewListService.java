package everytable.review.service;

import java.util.List;
import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.review.dao.ReviewDAO;
import everytable.review.vo.ReviewVO;
import everytable.util.page.PageObject;

public class ReviewListService implements Service {
    private ReviewDAO dao;

    @Override
    public void setDAO(DAO dao) {
        this.dao = (ReviewDAO) dao;
    }

    @Override
    public Object service(Object obj) throws Exception {
        // 1. 넘어온 객체가 PageObject인지 확인 후 형변환
        PageObject pageObject = (PageObject) obj;
        
        // 2. 전체 데이터 개수 세팅
        pageObject.setTotalRow(dao.getTotalRow(pageObject));
        
        // 3. 리스트 가져오기 (여기서 리턴 타입을 명확히 List<ReviewVO>로 받음)
        @SuppressWarnings("unchecked")
        List<ReviewVO> list = (List<ReviewVO>) dao.list(pageObject);
        
        // 4. [중요] 로그인 ID와 작성자 ID 비교 로직
        // Controller에서 pageObject.setAccepter("유저아이디")를 했다고 가정
        String loginId = pageObject.getAccepter();
        
        if (list != null && loginId != null && !loginId.equals("")) {
            for (ReviewVO vo : list) {
                // DB에서 가져온 userId와 로그인한 loginId가 같으면 sameId를 1로!
                if (loginId.equals(vo.getUserId())) {
                    vo.setSameId(1);
                }
            }
        }
        
        return list;
    }
}