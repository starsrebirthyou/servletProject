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
        ReviewVO vo = (ReviewVO) obj;
        List<ReviewVO> list = null;

        // ✅ storeId가 0이 아니면 매장별 리뷰 조회
        if (vo.getStoreId() != 0) {
            System.out.println("--- [Service] 매장 리뷰 조회 실행 (ID: " + vo.getStoreId() + ")");
            list = dao.list(vo);
        } 
        // ✅ storeId가 0이면 내 리뷰(userId 기준) 조회
        else {
            System.out.println("--- [Service] 내 리뷰 목록 조회 실행 (User: " + vo.getUserId() + ")");
            list = dao.myList(vo); // 👈 핵심 수정: list에서 myList로 변경!
        }

        // ✅ 본인 리뷰 체크 (수정/삭제 버튼 활성화용)
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