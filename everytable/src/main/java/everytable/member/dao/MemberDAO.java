package everytable.member.dao;

import java.util.ArrayList;
import java.util.List;

import everytable.main.dao.DAO;
import everytable.member.vo.LoginVO;
import everytable.member.vo.MemberVO;
import everytable.util.db.DB;

public class MemberDAO extends DAO {

    // ----------------------------------------------------------------
    // 로그인 / 로그아웃
    // ----------------------------------------------------------------

    // 로그인 처리 - id, pw 확인 후 LoginVO 반환 (불일치 시 null)
    public LoginVO login(LoginVO userVO) throws Exception {
        LoginVO vo = null;

        con = DB.getConnection();
        // DB 컬럼명: grade_no (기존: gradeNo)
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

    // 마지막 로그인 일시 갱신 (DB 컬럼명: last_login)
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

    // 회원가입 처리 - member_seq.nextval 사용, grade_no로 일반/점주 구분
    // grade_no: 1=일반회원, 2=매장점주
    // status, join_date, last_login 은 DB DEFAULT 값 사용 (생략)
    public Integer write(MemberVO vo) throws Exception {
        Integer result = 0;

        con = DB.getConnection();
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
        pstmt.setInt(8, vo.getGradeNo());   // 1: 일반회원, 2: 매장점주
        result = pstmt.executeUpdate();
        DB.close(con, pstmt);
        return result;
    }

    // ----------------------------------------------------------------
    // 내 정보 보기
    // ----------------------------------------------------------------

    // 회원 정보 단건 조회 (id 기준)
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

    // 아이디 찾기 - 이름 + 이메일로 조회
    public String searchId(MemberVO vo) throws Exception {
        String id = null;

        con = DB.getConnection();
        String sql = "SELECT id FROM member WHERE name = ? AND email = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, vo.getName());
        pstmt.setString(2, vo.getEmail());
        rs = pstmt.executeQuery();
        if (rs != null && rs.next()) id = rs.getString("id");
        DB.close(con, pstmt, rs);
        return id;
    }

    // 비밀번호 변경
    //   user = 1 : 로그인 상태에서 변경 → 현재 비밀번호(pw) 검증 포함
    //   user = 0 : 비밀번호 찾기(임시 비밀번호 발급) → 현재 비밀번호 검증 없음
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

    // 비밀번호 찾기 본인 확인 - id + 이름 + 생년월일 일치 여부 반환
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
    // 관리자 메뉴
    // ----------------------------------------------------------------

    // 회원 전체 목록 조회 (관리자용)
    public List<MemberVO> list() throws Exception {
        List<MemberVO> list = new ArrayList<>();

        con = DB.getConnection();
        // grade_no = 9(관리자) 제외하고 싶으면 WHERE 절에 AND m.grade_no != 9 추가
        String sql = "SELECT m.no, m.id, m.name, m.gender,"
                   + "       TO_CHAR(m.birth,      'yyyy-mm-dd') birth,"
                   + "       m.tel, m.email, m.status, m.grade_no, g.grade_name,"
                   + "       TO_CHAR(m.join_date,  'yyyy-mm-dd') join_date,"
                   + "       TO_CHAR(m.last_login, 'yyyy-mm-dd') last_login"
                   + "  FROM member m, grade g"
                   + " WHERE m.grade_no = g.grade_no"
                   + " ORDER BY m.id";
        pstmt = con.prepareStatement(sql);
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

    // 회원 상태 변경 (관리자용) - id 기준
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

    // 회원 등급 변경 (관리자용) - id 기준, grade_no 컬럼 사용
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

    // id가 DB에 존재하면 id 반환, 없으면 null 반환
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
}