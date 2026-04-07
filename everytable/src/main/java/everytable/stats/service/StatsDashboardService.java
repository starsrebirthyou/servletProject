package everytable.stats.service;

import everytable.main.dao.DAO;
import everytable.main.service.Service;
import everytable.stats.dao.StatsDAO;
import everytable.util.page.PageObject;

public class StatsDashboardService implements Service {

    private StatsDAO dao;
    
    @Override
    public void setDAO(DAO dao) {
        this.dao = (StatsDAO) dao;
    }

    @Override
    public Object service(Object obj) throws Exception {
        // [수정 포인트] dashboard 대신 기존의 list 메서드를 호출합니다.
        // 이 서비스는 이제 대시보드 하단의 "일별 통계 리스트"를 가져오는 전담 요리사가 됩니다.
        return dao.list((PageObject) obj);
    }

}