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
    public int write(PaymentVO vo) throws Exception {
        int result = 0;
        con = DB.getConnection();
        
        // 1. 시퀀스 번호 뽑기
        String seqSql = "SELECT PAYMENT_SEQ.NEXTVAL FROM DUAL";
        pstmt = con.prepareStatement(seqSql);
        rs = pstmt.executeQuery();
        long newId = 0;
        if(rs.next()) newId = rs.getLong(1); 
        if(rs != null) rs.close();
        if(pstmt != null) pstmt.close();
        
        // 2. 부모(ORDERS) 테이블 입력
        String orderSql = "INSERT INTO ORDERS (ORDER_ID, STORE_ID, USER_ID, TOTAL_PRICE, CREATED_AT, RES_NO) "
                        + "VALUES (?, ?, ?, ?, SYSDATE, NULL)";
        pstmt = con.prepareStatement(orderSql);
        pstmt.setLong(1, newId);
        pstmt.setLong(2, vo.getStoreid());
        pstmt.setString(3, vo.getUser_id());
        pstmt.setLong(4, vo.getAmount());
        pstmt.executeUpdate();
        pstmt.close();

        // 3. 자식(PAYMENT) 테이블 입력 
        // ★ PICKUP_DATE 컬럼과 물음표(?)를 추가했습니다 ★
        String paySql = "INSERT INTO PAYMENT (PAYMENT_ID, ORDER_ID, USER_ID, AMOUNT, METHOD, STATUS, PAY_DATE, PICKUP_DATE) "
                      + "VALUES (PAYMENT_SEQ.NEXTVAL, ?, ?, ?, ?, 'SUCCESS', SYSDATE, ?)";
        
        pstmt = con.prepareStatement(paySql);
        pstmt.setLong(1, newId);               // ORDER_ID
        pstmt.setString(2, vo.getUser_id());     // USER_ID
        pstmt.setLong(3, vo.getAmount());        // AMOUNT
        pstmt.setString(4, vo.getMethod());      // METHOD
        
        // ★ [핵심] VO에 담긴 픽업 날짜를 DB 형식에 맞춰 넣어줍니다 ★
        if (vo.getPickupDate() != null) {
            pstmt.setTimestamp(5, new java.sql.Timestamp(vo.getPickupDate().getTime()));
        } else {
            // 날짜가 없으면 현재 시간이라도 넣어줍니다 (에러 방지)
            pstmt.setTimestamp(5, new java.sql.Timestamp(System.currentTimeMillis()));
        }
        
        result = pstmt.executeUpdate();
        DB.close(con, pstmt, rs);
        
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