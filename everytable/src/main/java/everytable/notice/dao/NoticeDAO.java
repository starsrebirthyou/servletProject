package everytable.notice.dao;

import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.notice.vo.NoticeVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class NoticeDAO extends DAO {

	// 1. list() - 복사 -> 수정
	public List<NoticeVO> list(PageObject pageObejct) throws Exception {
		
//		System.out.println("NoticeDAO.list() ---------------------------");
		
		// 리턴 타입과 동일한 변수 선언 - 결과 저장
		List<NoticeVO> list = new ArrayList<>();
		
		// 1. 드라이버 확인 - static으로 선언된 내용이 자동으로 올라간다
		// & 2. 연결 객체 - 정보를 넣고 서버에 다녀온다
		// getConnection() - static
		con = DB.getConnection();
		
		// 3. 실행할 쿼리 작성
		// 3-1. 원본 데이터 정렬해서 가져오기
		String sql = "select n.no, n.title, to_char(n.write_date, 'yyyy-mm-dd') write_date, n.cate_no,"
		        + " to_char(n.update_date, 'yyyy-mm-dd') update_date, c.cate_name, n.hit "
		        + " from notice n, notice_cate c where (n.cate_no = c.cate_no) ";
		// 검색 처리를 한다. -> getTotalRow()의 검색처리와 같다. -> 반복된다. 메서드를 만든다.
		sql += category(pageObejct);
		sql += " order by n.no desc";
		// 3-2. 순서 번호를 붙인다.
		sql = "select rownum rnum, no, title, write_date, update_date, cate_no, cate_name, hit "
			+ " from(" + sql + ")";
		// 3-3. page에 맞는 데이터만 가져온다.
		sql = "select rnum, no, title, write_date, update_date, cate_no, cate_name, hit "
			+ " from(" + sql + ") where rnum between ? and ? ";
		
		// 4. 준비된 실행 객체
		pstmt = con.prepareStatement(sql);
		// 1page의 정보를 하드 코딩했다.
		pstmt.setLong(1, pageObejct.getStartRow());
		pstmt.setLong(2, pageObejct.getEndRow());

		// 5. 실행 : select -> rs, insert / update / delete -> Integer
		rs = pstmt.executeQuery();
		
		// 6. DB에서 가져온 데이터 채우기
		if (rs != null) {
			while(rs.next()) {  // 데이터가 있는 만큼 반복 실행
				// 저장할 객체 생성
				NoticeVO vo = new NoticeVO();
				// 데이터 저장
				vo.setNo(rs.getLong("no"));
				vo.setTitle(rs.getString("title"));
				vo.setWriteDate(rs.getString("write_date"));
				vo.setUpdateDate(rs.getString("update_date"));
				vo.setCateNo(rs.getLong("cate_no"));
				vo.setCateName(rs.getString("cate_name"));
				vo.setHit(rs.getLong("hit"));
				// list에 담는다
				list.add(vo);
			}  // while문 끝
		}  // if문 끝
		
		// 7. DB 닫기
		DB.close(con, pstmt, rs);
		
		return list;
	}  // list() 끝
	
	
	// 1-1. getTotalRow()
	public Long getTotalRow(PageObject pageObejct) throws Exception {
		
//		System.out.println("NoticeDAO.list() ---------------------------");
		
		// 리턴 타입과 동일한 변수 선언 - 결과 저장
		long totalRow = 0;
		
		// 1. 드라이버 확인 - static으로 선언된 내용이 자동으로 올라간다
		// & 2. 연결 객체 - 정보를 넣고 서버에 다녀온다
		con = DB.getConnection();
		
		// 3. 실행할 쿼리 작성
		String sql = "select count(*) from notice n, notice_cate c "
				+ " where n.cate_no = c.cate_no ";
		
		// 검색 처리를 한다. -> list()의 검색처리와 같다. -> 반복된다. 메서드를 만든다.
		sql += category(pageObejct);
				
		// 4. 준비된 실행 객체
		pstmt = con.prepareStatement(sql);
		
		// 5. 실행 : select -> rs, insert / update / delete -> Integer
		rs = pstmt.executeQuery();
		
		// 6. DB에서 가져온 데이터 채우기
		if (rs != null && rs.next()) {
			// 데이터 저장
			totalRow = rs.getLong(1);
		}  // if문 끝
		
		// 7. DB 닫기
		DB.close(con, pstmt, rs);
		
		return totalRow;
	}  // totalRow() 끝
	
	
	// 1-2. 카테고리를 위한 메서드
	public String category(PageObject pageObject) {
		String sql = "";
		
		String key = pageObject.getKey();
		
	    // key가 null이거나 "0"(전체)이면 조건 없음
	    if (key != null && !key.equals("0") && !key.isEmpty()) {
		    	sql = " and ";
		    	if(key.equals("1")) sql += " n.cate_no = 1 ";
		    	if(key.equals("2")) sql += " n.cate_no = 2 ";
		    	if(key.equals("3")) sql += " n.cate_no = 3 ";
		    	if(key.equals("4")) sql += " n.cate_no = 4 ";
	    }
	    
		return sql;
	}  // category() 끝
	
	
	// 2. 공지 보기
	public NoticeVO view(Long no) throws Exception {
		NoticeVO vo = null;
		
		// 1. 2. DB 연결
		con = DB.getConnection();
		// 3. sql 작성
		String sql = "select no, title, content, image, to_char(write_date, 'yyyy-mm-dd HH24:mi') write_date, "
				+ " to_char(update_date, 'yyyy-mm-dd HH24:mi') update_date, "
				+ " n.cate_no, c.cate_name, n.hit "
		        + " from notice n, notice_cate c where no = ? and n.cate_no = c.cate_no";
		// 4. 실행 객체 & 데이터 세팅
		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, no);
		// 5. 실행
		rs = pstmt.executeQuery();
		// 6. 저장
		if (rs != null && rs.next()) {
			vo = new NoticeVO();
			vo.setNo(rs.getLong("no"));
			vo.setTitle(rs.getString("title"));
			vo.setContent(rs.getString("content"));
			vo.setFileName(rs.getString("image"));
			vo.setCateNo(rs.getLong("cate_no"));
			vo.setCateName(rs.getString("cate_name"));
			vo.setWriteDate(rs.getString("write_date"));
			vo.setUpdateDate(rs.getString("update_date"));
			vo.setHit(rs.getLong("hit"));
		}  // if 끝
		// 7. 닫기
		DB.close(con, pstmt, rs);
		
		return vo;
	}
	
	
	// 2-1. 조회수 증가
	public Integer increase(Long no) throws Exception {
	    Integer result = 0;
	    con = DB.getConnection();
	    String sql = "UPDATE notice SET hit = hit + 1 WHERE no = ?";
	    pstmt = con.prepareStatement(sql);
	    pstmt.setLong(1, no);
	    result = pstmt.executeUpdate();
	    DB.close(con, pstmt);
	    return result;
	}
	
	
	// 3. 공지 등록 처리
	public Integer write(NoticeVO vo) throws Exception {
		// 리턴 타입과 동일한 변수 선언
		Integer result = 0;
		
		// 1. 2. 연결 객체
		con = DB.getConnection();
		
		// 3. sql 작성
		String sql = "insert into notice(no, title, content, image, cate_no, write_date) "
				+ " values(notice_seq.nextval, ?, ?, ?, ?, sysdate)";
		
		// 4. 실행 객체 & 데이터 세팅
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, vo.getTitle());
		pstmt.setString(2, vo.getContent());
		pstmt.setString(3, vo.getFileName());
		pstmt.setLong(4, vo.getCateNo());
		
		// 5. 실행
		result = pstmt.executeUpdate();
		
		// 6. 결과 저장 - 5번에서 실행
		
		// 7. 닫기
		DB.close(con, pstmt);
		
		return result;
	}
	
	
	// 3-1. 카테고리 설정을 위한 메서드
	public String setCategory(String cateNo) {
	    if (cateNo != null && !cateNo.isEmpty()) {
	        if (cateNo.equals("1")) return "1";
	        if (cateNo.equals("2")) return "2";
	        if (cateNo.equals("3")) return "3";
	        if (cateNo.equals("4")) return "4";
	    }
	    return "1";  // 기본값
	}  // setCategory() 끝
	
	
	// 4. 공지 수정 처리
	public Integer update(NoticeVO vo) throws Exception {
		// 리턴 타입과 동일한 변수 선언
		Integer result = 0;
		
		// 1. 2. 연결 객체
		con = DB.getConnection();
		
		// 3. sql 작성
		String sql = "update notice set title = ?, content = ?, image = ?, cate_no = ?, "
				+ " update_date = sysdate where no = ? ";
		
		// 4. 실행 객체 & 데이터 세팅
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, vo.getTitle());
		pstmt.setString(2, vo.getContent());
		pstmt.setString(3, vo.getFileName());
		pstmt.setLong(4, vo.getCateNo());
		pstmt.setLong(5, vo.getNo());
		
		// 5. 실행
		result = pstmt.executeUpdate();
		
		// 6. 결과 저장 - 5번에서 실행
		
		// 7. 닫기
		DB.close(con, pstmt);
		
		return result;
	}
	
	// 5. 공지 삭제 처리
	public Integer delete(Long no) throws Exception {
		// 리턴 타입과 동일한 변수 선언
		Integer result = 0;
		
		// 1. 2. 연결 객체
		con = DB.getConnection();
		
		// 3. sql 작성
		String sql = "delete from notice where no = ? ";
		
		// 4. 실행 객체 & 데이터 세팅
		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, no);
		
		// 5. 실행
		result = pstmt.executeUpdate();
		
		// 6. 결과 저장 - 5번에서 실행
		
		// 7. 닫기
		DB.close(con, pstmt);
		
		return result;
	}
	
}  // 클래스의 끝
