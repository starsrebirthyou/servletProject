package everytable.refund.dao;

import everytable.main.dao.DAO;
import everytable.refund.vo.RefundVO;
import everytable.util.db.DB;

public class RefundDAO extends DAO {

    // 환불 처리 (시은님이 배우신 방식 그대로!)
    public Integer refund(RefundVO vo) throws Exception {
        Integer result = 0;
        
        // 1. 2. 연결
        con = DB.getConnection();
        
        // 3. SQL 작성 (괄호 닫는 거 잊지 않기!)
        String sql = "insert into refund(refund_id, order_id, user_id, payment_id, refund_amount, refund_rate, reason, refund_date, status) "
                   + " values(refund_seq.nextval, ?, ?, ?, ?, ?, ?, sysdate, 'REQUESTED') ";
        
        // 4. 실행 객체 & 데이터 세팅
        pstmt = con.prepareStatement(sql);
        pstmt.setLong(1, vo.getOrder_id());
        pstmt.setString(2, vo.getUser_id());
        pstmt.setLong(3, vo.getPayment_id());
        pstmt.setLong(4, vo.getRefund_amount());
        pstmt.setLong(5, vo.getRefund_rate());
        pstmt.setString(6, vo.getReason());
        
        // 5. 실행
        result = pstmt.executeUpdate();
        
        // 6. 성공 시 결제 상태 변경 
        if(result == 1) {
            updatePaymentStatus(vo.getOrder_id());
        }
        
        // 7. 닫기 
        DB.close(con, pstmt);
        
        return result;
    }

    // 상태 변경 메서드 
    public void updatePaymentStatus(Long paymentId) throws Exception {
        String sql = "update payment set status = 'REFUNDED', update_date = sysdate where payment_id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setLong(1, paymentId);
        pstmt.executeUpdate();
    }
}