package everytable.order.dao;

import java.util.List;

import everytable.main.dao.DAO;
import everytable.order.vo.OrderVO; // 위 필드들이 담긴 VO
import everytable.util.db.DB;

public class OrderDAO extends DAO {

	// 주문 등록 (여러 메뉴 일괄 저장)
	public int write(List<OrderVO> list) throws Exception {
		int result = 0;

		try {
			// 1.2. 연결
			con = DB.getConnection();
			// 트랜잭션 시작 (자동 커밋 해제)
			con.setAutoCommit(false);

			// [STEP 1] 주문 마스터 정보 insert (orders 테이블)
			// 첫 번째 객체에서 주문 공통 정보(resNo, storeId, userId, totalPrice)를 가져옴
			String sqlOrder = "insert into orders(order_no, res_no, store_id, user_id, total_price, order_add) "
					+ " values(orders_seq.nextval, ?, ?, ?, ?, ?)";

			pstmt = con.prepareStatement(sqlOrder);
			pstmt.setLong(1, list.get(0).getResNo());
			pstmt.setLong(2, list.get(0).getStoreId());
			pstmt.setString(3, list.get(0).getUserId());
			pstmt.setLong(4, list.get(0).getTotalPrice());
			pstmt.setString(5, list.get(0).getOrderAdd());

			result = pstmt.executeUpdate();

			// [STEP 2] 주문 상세 메뉴 insert (order_item 테이블)
			// 리스트에 담긴 메뉴 개수만큼 반복 실행
			String sqlItem = "insert into order_item(order_item_no, res_no, menu_no, quantity, price) "
					+ " values(order_item_seq.nextval, ?, ?, ?, ?)";

			for (OrderVO vo : list) {
				// 수량이 0인 메뉴는 제외하고 저장
				if (vo.getQuantity() > 0) {
					pstmt = con.prepareStatement(sqlItem);
					pstmt.setLong(1, vo.getResNo());
					pstmt.setLong(2, vo.getMenuNo());
					pstmt.setLong(3, vo.getQuantity());
					pstmt.setLong(4, vo.getPrice()); // 메뉴 단가

					pstmt.executeUpdate();
				}
			}

			// 모든 작업 성공 시 커밋
			con.commit();
			result = 1;

		} catch (Exception e) {
			// 하나라도 실패하면 롤백
			e.printStackTrace();
		} finally {
			// 자원 반납
			DB.close(con, pstmt);
		}

		return result;
	}
}