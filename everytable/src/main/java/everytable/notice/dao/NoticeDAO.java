package everytable.notice.dao;

import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.notice.vo.NoticeVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class NoticeDAO extends DAO {

	// 1. list()
	public List<NoticeVO> list(PageObject pageObject) throws Exception {

		List<NoticeVO> list = new ArrayList<>();

		con = DB.getConnection();

		// 3-1. 원본 데이터 정렬
		String sql = "select n.no, n.title, n.writer, m.name,"
		        + " to_char(n.write_date, 'yyyy-mm-dd') write_date,"
		        + " to_char(n.update_date, 'yyyy-mm-dd') update_date,"
		        + " n.cate_no, c.cate_name, n.hit"
		        + " from notice n, notice_cate c, member m"
		        + " where (n.cate_no = c.cate_no) and (n.writer = m.id)";
		sql += category(pageObject);
		sql += " order by n.no desc";

		// 3-2. rownum 붙이기
		sql = "select rownum rnum, no, title, writer, name, write_date, update_date, cate_no, cate_name, hit"
			+ " from(" + sql + ")";

		// 3-3. 페이지에 맞는 데이터만
		sql = "select rnum, no, title, writer, name, write_date, update_date, cate_no, cate_name, hit"
			+ " from(" + sql + ") where rnum between ? and ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, pageObject.getStartRow());
		pstmt.setLong(2, pageObject.getEndRow());

		rs = pstmt.executeQuery();

		if (rs != null) {
			while (rs.next()) {
				NoticeVO vo = new NoticeVO();
				vo.setNo(rs.getLong("no"));
				vo.setTitle(rs.getString("title"));
				vo.setWriterId(rs.getString("writer"));
				vo.setWriterName(rs.getString("name"));
				vo.setWriteDate(rs.getString("write_date"));
				vo.setUpdateDate(rs.getString("update_date"));
				vo.setCateNo(rs.getLong("cate_no"));
				vo.setCateName(rs.getString("cate_name"));
				vo.setHit(rs.getLong("hit"));
				list.add(vo);
			}
		}

		DB.close(con, pstmt, rs);
		return list;
	}


	// 1-1. getTotalRow()
	public Long getTotalRow(PageObject pageObject) throws Exception {

		long totalRow = 0;

		con = DB.getConnection();

		String sql = "select count(*) from notice n, notice_cate c, member m"
				+ " where n.cate_no = c.cate_no and n.writer = m.id";
		sql += category(pageObject);

		pstmt = con.prepareStatement(sql);
		rs = pstmt.executeQuery();

		if (rs != null && rs.next()) {
			totalRow = rs.getLong(1);
		}

		DB.close(con, pstmt, rs);
		return totalRow;
	}


	// 1-2. 카테고리 필터 메서드 (list, getTotalRow 공용)
	public String category(PageObject pageObject) {
		String sql = "";
		String key = pageObject.getKey();

		if (key != null && !key.equals("0") && !key.isEmpty()) {
			sql = " and ";
			if (key.equals("1")) sql += " n.cate_no = 1 ";
			if (key.equals("2")) sql += " n.cate_no = 2 ";
			if (key.equals("3")) sql += " n.cate_no = 3 ";
			if (key.equals("4")) sql += " n.cate_no = 4 ";
		}
		return sql;
	}


	// 2. 공지 보기
	public NoticeVO view(Long no) throws Exception {
		NoticeVO vo = null;

		con = DB.getConnection();

		String sql = "select n.no, n.title, n.content, n.image, n.writer, m.name,"
				+ " to_char(n.write_date, 'yyyy-mm-dd HH24:mi') write_date,"
				+ " to_char(n.update_date, 'yyyy-mm-dd HH24:mi') update_date,"
				+ " n.cate_no, c.cate_name, n.hit"
				+ " from notice n, notice_cate c, member m"
				+ " where n.no = ? and (n.cate_no = c.cate_no) and (n.writer = m.id)";

		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, no);
		rs = pstmt.executeQuery();

		if (rs != null && rs.next()) {
			vo = new NoticeVO();
			vo.setNo(rs.getLong("no"));
			vo.setTitle(rs.getString("title"));
			vo.setContent(rs.getString("content"));
			vo.setFileName(rs.getString("image"));
			vo.setWriterId(rs.getString("writer"));
			vo.setWriterName(rs.getString("name"));
			vo.setCateNo(rs.getLong("cate_no"));
			vo.setCateName(rs.getString("cate_name"));
			vo.setWriteDate(rs.getString("write_date"));
			vo.setUpdateDate(rs.getString("update_date"));
			vo.setHit(rs.getLong("hit"));
		}

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


	// 3. 공지 등록
	public Integer write(NoticeVO vo) throws Exception {
		Integer result = 0;

		con = DB.getConnection();

		String sql = "insert into notice(no, title, content, image, writer, cate_no, write_date)"
				+ " values(notice_seq.nextval, ?, ?, ?, ?, ?, sysdate)";

		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, vo.getTitle());
		pstmt.setString(2, vo.getContent());
		pstmt.setString(3, vo.getFileName());
		pstmt.setString(4, vo.getWriterId()); // writer = member.id
		pstmt.setLong(5, vo.getCateNo());     // ← 4 → 5 로 수정 (기존 오류)

		result = pstmt.executeUpdate();

		DB.close(con, pstmt);
		return result;
	}


	// 4. 공지 수정
	public Integer update(NoticeVO vo) throws Exception {
		Integer result = 0;

		con = DB.getConnection();

		String sql = "update notice set title = ?, content = ?, image = ?, cate_no = ?,"
				+ " update_date = sysdate where no = ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, vo.getTitle());
		pstmt.setString(2, vo.getContent());
		pstmt.setString(3, vo.getFileName());
		pstmt.setLong(4, vo.getCateNo());
		pstmt.setLong(5, vo.getNo());

		result = pstmt.executeUpdate();

		DB.close(con, pstmt);
		return result;
	}


	// 5. 공지 삭제
	public Integer delete(Long no) throws Exception {
		Integer result = 0;

		con = DB.getConnection();

		String sql = "delete from notice where no = ?";

		pstmt = con.prepareStatement(sql);
		pstmt.setLong(1, no);

		result = pstmt.executeUpdate();

		DB.close(con, pstmt);
		return result;
	}

}