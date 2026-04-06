package everytable.refund.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import everytable.main.dao.DAO;
import everytable.refund.vo.RefundVO;
import everytable.util.db.DB;

public class RefundDAO extends DAO {

    // 1. 환불 데이터 삽입
    public Integer refund(RefundVO vo) throws Exception {
        Integer result = 0;
        
        try {
            con = DB.getConnection();
            String sql = "insert into refund(refund_id, order_id, user_id, payment_id, refund_amount, refund_rate, reason, refund_date, status) "
                       + " values(refund_seq.nextval, ?, ?, ?, ?, ?, ?, sysdate, 'REQUESTED') ";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, vo.getOrder_id());
            pstmt.setString(2, vo.getUser_id());
            pstmt.setLong(3, vo.getPayment_id());
            pstmt.setLong(4, vo.getRefund_amount());
            pstmt.setLong(5, vo.getRefund_rate());
            pstmt.setString(6, vo.getReason());
            
            result = pstmt.executeUpdate();
            
            // ★ 성공 시 결제 상태 변경 (payment_id를 넘겨줘야 함!)
            if(result == 1) {
                updatePaymentStatus(vo.getPayment_id());
            }
        } finally {
            // 마지막에 한 번만 닫기
            DB.close(con, pstmt);
        }
        
        return result;
    }

    // 2. 상태 변경 메서드 (독립적인 con, pstmt 사용)
    public void updatePaymentStatus(Long paymentId) throws Exception {
        Connection conUpdate = null;
        PreparedStatement pstmtUpdate = null;
        
        try {
            conUpdate = DB.getConnection(); // 새로 연결 맺기
            String sql = "update payment set status = 'REFUNDED', update_date = sysdate where payment_id = ?";            
            pstmtUpdate = conUpdate.prepareStatement(sql);
            pstmtUpdate.setLong(1, paymentId);
            pstmtUpdate.executeUpdate();
            
            System.out.println(">>> DB 상태 변경 완료: ID " + paymentId);
        } finally {
            // 사용한 자원 즉시 닫기
            if(pstmtUpdate != null) pstmtUpdate.close();
            if(conUpdate != null) conUpdate.close();
        }
    }
}