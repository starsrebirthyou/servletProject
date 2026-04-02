package everytable.member.dao;

import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.member.vo.LoginVO;
import everytable.member.vo.MemberVO;
import everytable.util.db.DB;
import everytable.util.page.PageObject;

public class MemberDAO extends DAO {

    // ----------------------------------------------------------------
    // 로그인 / 로그아웃
    // ----------------------------------------------------------------

    public LoginVO login(LoginVO userVO) throws Exception {
        LoginVO vo = null;
        con = DB.getConnection();
        String sql = "SELECT m.id, m.name, m.grade_no, g.grade_name"
                   + "  FROM member m, grade g"
                   + " WHERE m.id = ? AND m.pw = ?"
                   + "   AND m.grade_no = g.grade_no"
                   + "   AND m.status = '정상'";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, userVO.getId());
        pstmt.setString(2, userVO.getPw());
        rs = pstmt.executeQuery();
        if (rs != null && rs.next()) {
            vo = new LoginVO();
            vo.setId(rs.getString("id"));
            vo.setName(rs.getString("name"));
            vo.setGradeNo(rs.getInt("grade_no"));
            vo.setGradeName(rs.getString("grade_name"));
        }
        DB.close(con, pstmt, rs);
        return vo;
    }

    public Integer updateLastLogin(String id) throws Exception {
        con = DB.getConnection();
        String sql = "UPDATE member SET last_login = SYSDATE WHERE id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, id);
        Integer result = pstmt.executeUpdate();
        DB.close(con, pstmt);
        return result;
    }

    // ----------------------------------------------------------------
    // 회원가입
    // ----------------------------------------------------------------

    public Integer write(MemberVO vo) throws Exception {
        Integer result = 0;
        con = DB.getConnection();
        
        // 점주/일반 구분 없이 member 테이블의 공통 컬럼만 INSERT[cite: 2]
        String sql = "INSERT INTO member(no, id, pw, name, gender, birth, tel, email, grade_no)"
                   + " VALUES(member_seq.nextval, ?, ?, ?, ?, ?, ?, ?, ?)";
                   
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, vo.getId());
        pstmt.setString(2, vo.getPw());
        pstmt.setString(3, vo.getName());
        pstmt.setString(4, vo.getGender());
        pstmt.setString(5, vo.getBirth());
        pstmt.setString(6, vo.getTel());
        pstmt.setString(7, vo.getEmail());
        pstmt.setInt(8, vo.getGradeNo());
        
        result = pstmt.executeUpdate();
        DB.close(con, pstmt);
        return result;
    }

    // ----------------------------------------------------------------
    // 내 정보 보기
    // ----------------------------------------------------------------

    public MemberVO view(String id) throws Exception {
        MemberVO vo = null;
        con = DB.getConnection();
        String sql = "SELECT m.id, m.name, m.gender,"
                   + "       TO_CHAR(m.birth, 'yyyy-mm-dd') birth,"
                   + "       m.tel, m.email, g.grade_name,"
                   + "       TO_CHAR(m.join_date,  'yyyy-mm-dd') join_date,"
                   + "       TO_CHAR(m.last_login, 'yyyy-mm-dd') last_login"
                   + "  FROM member m, grade g"
                   + " WHERE m.id = ? AND m.grade_no = g.grade_no";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();
        if (rs != null && rs.next()) {
            vo = new MemberVO();
            vo.setId(rs.getString("id"));
            vo.setName(rs.getString("name"));
            vo.setGender(rs.getString("gender"));
            vo.setBirth(rs.getString("birth"));
            vo.setTel(rs.getString("tel"));
            vo.setEmail(rs.getString("email"));
            vo.setGradeName(rs.getString("grade_name"));
            vo.setJoinDate(rs.getString("join_date"));
            vo.setLastLogin(rs.getString("last_login"));
        }
        DB.close(con, pstmt, rs);
        return vo;
    }

    // ----------------------------------------------------------------
    // 아이디 찾기 / 비밀번호 관련
    // ----------------------------------------------------------------

    public String searchId(MemberVO vo) throws Exception { // 객체를 받는지 확인!
        String id = null;
        con = DB.getConnection();
        // 쿼리문에 오타가 없는지, 컬럼명이 name, email이 맞는지 확인
        String sql = "SELECT id FROM member WHERE name = ? AND email = ? AND status = '정상'";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, vo.getName());
        pstmt.setString(2, vo.getEmail());
        rs = pstmt.executeQuery();
        if (rs.next()) id = rs.getString("id");
        DB.close(con, pstmt, rs);
        return id;
    }

    public Integer changePw(MemberVO vo, Integer user) throws Exception {
        Integer result = 0;
        con = DB.getConnection();
        String sql = "UPDATE member SET pw = ? WHERE id = ?";
        if (user == 1) sql += " AND pw = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, vo.getNewPw());
        pstmt.setString(2, vo.getId());
        if (user == 1) pstmt.setString(3, vo.getPw());
        result = pstmt.executeUpdate();
        DB.close(con, pstmt);
        return result;
    }

    public String checkPw(MemberVO vo) throws Exception {
        String id = null;
        con = DB.getConnection();
        String sql = "SELECT id FROM member WHERE id = ? AND name = ? AND birth = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, vo.getId());
        pstmt.setString(2, vo.getName());
        pstmt.setString(3, vo.getBirth());
        rs = pstmt.executeQuery();
        if (rs != null && rs.next()) id = rs.getString("id");
        DB.close(con, pstmt, rs);
        return id;
    }

    // ----------------------------------------------------------------
    // 관리자 - 회원 목록 (검색 + 페이지네이션)
    // ----------------------------------------------------------------
    //
    // [검색/필터 조건을 담는 방법]
    // PageObject를 건드리지 않고 MemberVO의 기존 필드를 필터 조건으로 재활용:
    //   vo.getKey()      -> 검색어 (아이디/이름/연락처) — word 용도로 getEmail() 재활용 안 하고 직접 처리
    //   vo.getStatus()   -> 상태 필터
    //   vo.getGradeNo()  -> 등급 필터 (null 이면 전체)
    //   vo.getJoinDate() -> 가입일 시작
    //   vo.getLastLogin()-> 가입일 종료  (lastLogin 필드를 dateEnd로 재활용)
    //
    // → Controller에서 filterVO를 만들어서 넘기고, 여기서 꺼내 씀

    // 필터 조건 SQL 조각 생성 (list, getTotalRow 공용)
    private String searchCondition(MemberVO filter) {
        if (filter == null) return "";
        String sql = "";

        // 검색어: id / name / tel LIKE 검색 — PageObject.key를 Controller에서 filter.setName()으로 넘김
        // 검색어는 MemberVO.email 필드를 "keyword" 용도로 재활용
        String keyword = filter.getEmail();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (m.id   LIKE '%" + keyword.trim() + "%'"
                 + "   OR m.name LIKE '%" + keyword.trim() + "%'"
                 + "   OR m.tel  LIKE '%" + keyword.trim() + "%')";
        }
        // 상태 필터
        String status = filter.getStatus();
        if (status != null && !status.trim().isEmpty() && !"전체".equals(status)) {
            sql += " AND m.status = '" + status.trim() + "'";
        }
        // 등급 필터 (0이면 전체)
        if (filter.getGradeNo() != null && filter.getGradeNo() != 0) {
            sql += " AND m.grade_no = " + filter.getGradeNo();
        }
        // 가입일 시작 — joinDate 필드 재활용
        String dateFrom = filter.getJoinDate();
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql += " AND m.join_date >= TO_DATE('" + dateFrom.trim() + "', 'yyyy-mm-dd')";
        }
        // 가입일 종료 — lastLogin 필드 재활용
        String dateTo = filter.getLastLogin();
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql += " AND m.join_date < TO_DATE('" + dateTo.trim() + "', 'yyyy-mm-dd') + 1";
        }
        return sql;
    }

    // 전체 행 수 — Service에서 pageObject.setTotalRow() 호출 필요
    public Long getTotalRow(PageObject pageObject, MemberVO filter) throws Exception {
        long totalRow = 0;
        con = DB.getConnection();
        String sql = "SELECT COUNT(*) FROM member m, grade g"
                   + " WHERE m.grade_no = g.grade_no";
        sql += searchCondition(filter);
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();
        if (rs != null && rs.next()) totalRow = rs.getLong(1);
        DB.close(con, pstmt, rs);
        return totalRow;
    }

    // 회원 목록 (페이지네이션 + 검색/필터)
    public List<MemberVO> list(PageObject pageObject, MemberVO filter) throws Exception {
        List<MemberVO> list = new ArrayList<>();
        con = DB.getConnection();

        // 1단계: 조건 + 정렬
        String sql = "SELECT m.no, m.id, m.name, m.gender,"
                   + "       TO_CHAR(m.birth,      'yyyy-mm-dd') birth,"
                   + "       m.tel, m.email, m.status, m.grade_no, g.grade_name,"
                   + "       TO_CHAR(m.join_date,  'yyyy-mm-dd') join_date,"
                   + "       TO_CHAR(m.last_login, 'yyyy-mm-dd') last_login"
                   + "  FROM member m, grade g"
                   + " WHERE m.grade_no = g.grade_no";
        sql += searchCondition(filter);
        sql += " ORDER BY m.id";

        // 2단계: rownum 부여
        sql = "SELECT ROWNUM rnum, no, id, name, gender, birth, tel, email,"
            + "       status, grade_no, grade_name, join_date, last_login"
            + "  FROM (" + sql + ")";

        // 3단계: 페이지 범위 추출
        sql = "SELECT rnum, no, id, name, gender, birth, tel, email,"
            + "       status, grade_no, grade_name, join_date, last_login"
            + "  FROM (" + sql + ") WHERE rnum BETWEEN ? AND ?";

        pstmt = con.prepareStatement(sql);
        pstmt.setLong(1, pageObject.getStartRow());
        pstmt.setLong(2, pageObject.getEndRow());
        rs = pstmt.executeQuery();

        if (rs != null) {
            while (rs.next()) {
                MemberVO vo = new MemberVO();
                vo.setNo(rs.getLong("no"));
                vo.setId(rs.getString("id"));
                vo.setName(rs.getString("name"));
                vo.setGender(rs.getString("gender"));
                vo.setBirth(rs.getString("birth"));
                vo.setTel(rs.getString("tel"));
                vo.setEmail(rs.getString("email"));
                vo.setStatus(rs.getString("status"));
                vo.setGradeNo(rs.getInt("grade_no"));
                vo.setGradeName(rs.getString("grade_name"));
                vo.setJoinDate(rs.getString("join_date"));
                vo.setLastLogin(rs.getString("last_login"));
                list.add(vo);
            }
        }
        DB.close(con, pstmt, rs);
        return list;
    }

    // ----------------------------------------------------------------
    // 관리자 - 상태/등급 변경
    // ----------------------------------------------------------------

    public Integer changeStatus(MemberVO vo) throws Exception {
        con = DB.getConnection();
        String sql = "UPDATE member SET status = ? WHERE id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, vo.getStatus());
        pstmt.setString(2, vo.getId());
        Integer result = pstmt.executeUpdate();
        DB.close(con, pstmt);
        return result;
    }

    public Integer changeGrade(MemberVO vo) throws Exception {
        con = DB.getConnection();
        String sql = "UPDATE member SET grade_no = ? WHERE id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, vo.getGradeNo());
        pstmt.setString(2, vo.getId());
        Integer result = pstmt.executeUpdate();
        DB.close(con, pstmt);
        return result;
    }

    // ----------------------------------------------------------------
    // 아이디 중복 체크
    // ----------------------------------------------------------------

    public String checkId(String inId) throws Exception {
        String id = null;
        con = DB.getConnection();
        String sql = "SELECT id FROM member WHERE id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, inId);
        rs = pstmt.executeQuery();
        if (rs != null && rs.next()) id = rs.getString("id");
        DB.close(con, pstmt, rs);
        return id;
    }
    

    // ----------------------------------------------------------------
    // 전화번호 중복 체크
    // ----------------------------------------------------------------

    public String checkTel(String inTel) throws Exception {
        String tel = null;
        con = DB.getConnection();
        String sql = "SELECT tel FROM member WHERE tel = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, inTel);
        rs = pstmt.executeQuery();
        if (rs != null && rs.next()) tel = rs.getString("tel");
        DB.close(con, pstmt, rs);
        return tel;
    }

    // ----------------------------------------------------------------
    // 이메일 중복 체크
    // ----------------------------------------------------------------

    public String checkEmail(String inEmail) throws Exception {
        String email = null;
        con = DB.getConnection();
        String sql = "SELECT email FROM member WHERE email = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, inEmail);
        rs = pstmt.executeQuery();
        if (rs != null && rs.next()) email = rs.getString("email");
        DB.close(con, pstmt, rs);
        return email;
    }
}