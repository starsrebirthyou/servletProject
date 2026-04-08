package everytable.payment.dao;

import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import everytable.main.dao.DAO;
import everytable.payment.vo.PaymentVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class PaymentDAO extends DAO {

	// 1. 결제 리스트
	public List<PaymentVO> list(PageObject pageObject) throws Exception {
	    List<PaymentVO> list = new ArrayList<>();
	    
	    con = DB.getConnection();
	    String sql = "select payment_id, order_id, user_id, method, amount, status, pickup_date, pay_date, update_date from payment ";
	    sql += search(pageObject);
	    sql += " order by payment_id desc ";

	    sql = "select rownum rnum, payment_id ,order_id, user_id, method, amount, status, pickup_date, pay_date, update_date "
	        + " from (" + sql + ")";
	    
	    sql = "select rnum, payment_id ,order_id, user_id, method, amount, status, pickup_date, pay_date, update_date "
	        + " from (" + sql + ") where rnum between ? and ?";
	    
	    pstmt = con.prepareStatement(sql);
	    int idx = 1;
	    idx = searchDataSet(pstmt, idx, pageObject);
	    pstmt.setLong(idx++, pageObject.getStartRow());
	    pstmt.setLong(idx++, pageObject.getEndRow());
	    
	    rs = pstmt.executeQuery();
	    
	    if (rs != null) {
	        while(rs.next()) {
	            PaymentVO vo = new PaymentVO();
	            vo.setPayment_id(rs.getLong("payment_id"));
	            vo.setOrder_id(rs.getLong("order_id"));
	            vo.setUser_id(rs.getString("user_id")); 
	            vo.setMethod(rs.getString("method"));
	            vo.setAmount(rs.getLong("amount"));
	            vo.setStatus(rs.getString("status"));
	            vo.setPayDate(rs.getDate("pay_date"));
	            vo.setUpdateDate(rs.getDate("update_date"));
	            vo.setPickupDate(rs.getTimestamp("pickup_date"));
	            list.add(vo); 
	        }
	    }
	    
	    DB.close(con, pstmt, rs);
	    return list;
	}

    // 2. 전체 데이터 개수 구하기
	public Long getTotalRow(PageObject pageObject) throws Exception {
        Long totalRow = 0L;
        con = DB.getConnection();
        String sql = "select count(*) from payment ";
        sql += search(pageObject);
        
        pstmt = con.prepareStatement(sql);
        int idx = 1;
        // 중요: idx 리턴값을 받아야 검색 필터가 정상 작동합니다!
        idx = searchDataSet(pstmt, idx, pageObject); 
        
        rs = pstmt.executeQuery();
        if (rs != null && rs.next()) {
            totalRow = rs.getLong(1);
        }
        DB.close(con, pstmt, rs);
        return totalRow;
    }

    // 3. 결제 상세보기 
    public PaymentVO view(Long payment_id) throws Exception {
        PaymentVO vo = null;
        con = DB.getConnection();
        
        String sql = "select payment_id ,order_id, user_id, method, amount, status, pickup_date, " // 👈 추가
                + " pay_date, update_date "
                + " from payment where payment_id = ? ";
    
        
        pstmt = con.prepareStatement(sql);
        pstmt.setLong(1, payment_id);
        rs = pstmt.executeQuery();
        
        if(rs != null && rs.next()) {
            vo = new PaymentVO();
            
            vo.setPayment_id(rs.getLong("payment_id"));
            vo.setOrder_id(rs.getLong("order_id"));
            vo.setUser_id(rs.getString("user_id"));
            vo.setMethod(rs.getString("method"));
            vo.setAmount(rs.getLong("amount"));
            vo.setStatus(rs.getString("status"));
            vo.setPayDate(rs.getDate("pay_date"));
            vo.setUpdateDate(rs.getDate("update_date"));
            vo.setPickupDate(rs.getTimestamp("pickup_date"));
        }
        DB.close(con, pstmt, rs);
        return vo;
    }

    // 1-1. 검색 조건 생성
    public String search(PageObject pageObject) {
        String sql = "";
        String key = pageObject.getKey();
        String word = pageObject.getWord();
        if(word != null && word.length() != 0) {
            sql = " where 1=0 ";
            if(key.indexOf("m") >= 0) sql += " or method like ? ";
            if(key.indexOf("s") >= 0) sql += " or status like ? ";
            if(key.indexOf("u") >= 0) sql += " or user_id like ? ";
        }
        return sql;
    }

    // 1-2. 검색 데이터 세팅
    public Integer searchDataSet(PreparedStatement pstmt, int idx, PageObject pageObject) throws Exception {
        String key = pageObject.getKey();
        String word = pageObject.getWord();
        if(word != null && word.length() != 0) {
            if(key.indexOf("m") >= 0) pstmt.setString(idx++, "%" + word + "%");
            if(key.indexOf("s") >= 0) pstmt.setString(idx++, "%" + word + "%");
            if(key.indexOf("u") >= 0) pstmt.setString(idx++, "%" + word + "%");
        }
        return idx;
    }
   
    public Integer write(PaymentVO vo) throws Exception {
        con = DB.getConnection();
        
        // 🌟 핵심: insert 문 안에 select(서브쿼리)를 넣어서 
        // RESERVATION 테이블에서 직접 store_id를 낚아채 옵니다!
        String sql = "insert into payment(payment_id, order_id, user_id, method, amount, status, pickup_date, store_id) "
                   + " values(payment_seq.nextval, ?, ?, ?, ?, ?, ?, "
                   + " (select store_id from reservation where res_no = ?))"; // 👈 여기서 직접 찾아옴!
        
        pstmt = con.prepareStatement(sql);
        pstmt.setLong(1, vo.getOrder_id());
        pstmt.setString(2, vo.getUser_id());
        pstmt.setString(3, vo.getMethod());
        pstmt.setLong(4, vo.getAmount());
        pstmt.setString(5, vo.getStatus());
        
        if (vo.getPickupDate() != null) {
            pstmt.setTimestamp(6, new java.sql.Timestamp(vo.getPickupDate().getTime()));
        } else {
            pstmt.setNull(6, java.sql.Types.TIMESTAMP);
        }
        
        // 🌟 7번째 물음표는 이제 vo에서 꺼내는 게 아니라, 서브쿼리용 order_id를 다시 넣어줍니다!
        pstmt.setLong(7, vo.getOrder_id()); 
        
        int result = pstmt.executeUpdate();
        DB.close(con, pstmt);
        return result;
    }
    
    public int cancel(Long payment_id) throws Exception {
    	int result=0;
    	con= DB.getConnection();
		String sql = "update payment set status = 'CANCEL', update_date = sysdate "
	               + " where payment_id = ? ";
		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, payment_id);
		result=pstmt.executeUpdate();
		DB.close(con, pstmt);
		
		return result;
    }
    
	public Integer update(PaymentVO vo) throws Exception {
		Integer result = 0;
		con= DB.getConnection();
		String sql = "update payment set status = ?, update_date = sysdate where payment_id = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1,vo.getStatus());
		pstmt.setLong(2,vo.getPayment_id());
		result=pstmt.executeUpdate();
		DB.close(con, pstmt);
		
		return result;
		
	}
} // 클래스 끝