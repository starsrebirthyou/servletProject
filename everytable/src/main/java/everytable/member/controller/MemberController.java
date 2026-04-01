package everytable.member.controller;

import java.io.PrintWriter;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.LoginVO;
import everytable.member.vo.MemberVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class MemberController implements Controller {

    public String execute(HttpServletRequest request) {
        request.setAttribute("url", request.getRequestURL());
        try {
            String uri = request.getServletPath();
            HttpSession session = request.getSession();
            LoginVO loginVO = (LoginVO) session.getAttribute("login");
            String loginId = (loginVO != null) ? loginVO.getId() : null;

            switch (uri) {

            // --------------------------------------------------------
            // 로그인
            // --------------------------------------------------------
            case "/member/loginForm.do":
                return "member/loginForm";

            case "/member/login.do": {
                LoginVO userVO = new LoginVO();
                userVO.setId(request.getParameter("id"));
                userVO.setPw(request.getParameter("pw"));

                loginVO = (LoginVO) Execute.execute(Init.getService(uri), userVO);
                if (loginVO == null)
                    throw new Exception("아이디 또는 비밀번호가 일치하지 않거나 이용이 제한된 계정입니다.");

                session.setAttribute("login", loginVO);
                // 메서드명 변경: changeConDate → updateLastLogin
                Execute.execute(Init.getService("/member/updateLastLogin.do"), loginVO.getId());

                session.setAttribute("msg", loginVO.getName() + "님, 환영합니다.");

                // 로그인 후 원래 가려던 페이지로 되돌아가기
                // loginRequired.do 를 거쳐 온 경우 redirectUrl 파라미터가 있다
                String redirectUrl = request.getParameter("redirectUrl");
                if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                    return "redirect:" + redirectUrl;
                }
                return "redirect:/main/main.do";
            }

            // --------------------------------------------------------
            // 로그아웃
            // --------------------------------------------------------
            case "/member/logout.do":
                session.removeAttribute("login");
                session.setAttribute("msg", "로그아웃되었습니다.");
                return "redirect:/main/main.do";

            // --------------------------------------------------------
            // 회원가입 - 유형 선택 화면 (일반회원 / 매장점주)
            // --------------------------------------------------------
            case "/member/writeTypeSelect.do":
                return "member/writeTypeSelect";

            // --------------------------------------------------------
            // 회원가입 - 폼 (type 파라미터로 일반/점주 구분)
            //   type=member  → 일반회원 가입 폼  (grade_no = 1)
            //   type=owner   → 매장점주 가입 폼  (grade_no = 2)
            // --------------------------------------------------------
            case "/member/writeForm.do": {
                String type = request.getParameter("type");
                if ("owner".equals(type)) {
                    return "member/writeForm_owner";
                }
                return "member/writeForm";   // 기본: 일반회원
            }

            // --------------------------------------------------------
            // 회원가입 - 처리
            // --------------------------------------------------------
            case "/member/write.do": {
                MemberVO vo = new MemberVO();
                vo.setId(request.getParameter("id"));
                vo.setPw(request.getParameter("pw"));
                vo.setName(request.getParameter("name"));
                vo.setGender(request.getParameter("gender"));
                vo.setBirth(request.getParameter("birth"));
                vo.setTel(request.getParameter("tel"));
                vo.setEmail(request.getParameter("email"));

                // 폼의 hidden input "gradeNo" 값으로 일반(1) / 점주(2) 구분
                // 폼에서 반드시 <input type="hidden" name="gradeNo" value="1"> 또는 value="2" 포함
                int gradeNo = 1;
                String gradeNoParam = request.getParameter("gradeNo");
                if ("2".equals(gradeNoParam)) gradeNo = 2;
                vo.setGradeNo(gradeNo);

                Execute.execute(Init.getService(uri), vo);

                // 가입 완료 후 자동 로그인
                loginVO = new LoginVO();
                loginVO.setId(vo.getId());
                loginVO.setName(vo.getName());
                loginVO.setGradeNo(gradeNo);
                loginVO.setGradeName(gradeNo == 2 ? "매장점주" : "일반회원");
                session.setAttribute("login", loginVO);
                Execute.execute(Init.getService("/member/updateLastLogin.do"), loginVO.getId());

                session.setAttribute("msg", "회원가입을 축하드립니다. 자동 로그인 되었습니다.");
                return "redirect:/main/main.do";
            }

            // --------------------------------------------------------
            // 로그인 필요 페이지 접근 처리
            //   비로그인 상태에서 주문/리뷰 등을 눌렀을 때
            //   loginForm 으로 보내되 원래 URL 을 redirectUrl 파라미터로 전달
            // --------------------------------------------------------
            case "/member/loginRequired.do": {
                String redirectUrl = request.getParameter("redirectUrl");
                if (loginId != null) {
                    // 이미 로그인된 상태면 원래 페이지로 바로 이동
                    if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                        return "redirect:" + redirectUrl;
                    }
                    return "redirect:/main/main.do";
                }
                // 비로그인: 로그인 폼으로 이동하면서 redirectUrl 전달
                request.setAttribute("redirectUrl", redirectUrl);
                return "member/loginForm";
            }
            
            case "/member/loginAjax.do": {
                LoginVO userVO = new LoginVO();
                userVO.setId(request.getParameter("id"));
                userVO.setPw(request.getParameter("pw"));

                loginVO = (LoginVO) Execute.execute(Init.getService("/member/login.do"), userVO);

                // redirect 대신 JSON 문자열을 직접 응답으로 씀
                response.setContentType("application/json; charset=UTF-8");
                PrintWriter out = response.getWriter();

                if (loginVO == null) {
                    out.print("{\"result\":\"fail\",\"msg\":\"아이디 또는 비밀번호가 틀렸습니다.\"}");
                } else {
                    session.setAttribute("login", loginVO);
                    Execute.execute(Init.getService("/member/updateLastLogin.do"), loginVO.getId());
                    out.print("{\"result\":\"ok\",\"name\":\"" + loginVO.getName() + "\"}");
                }
                out.flush();
                return null;  // View로 안 넘기고 직접 응답 끝냄
            }

            // --------------------------------------------------------
            // 아이디 중복 체크 (Ajax)
            // --------------------------------------------------------
            case "/member/checkId.do": {
                String id = request.getParameter("id");
                request.setAttribute("id", Execute.execute(Init.getService(uri), id));
                return "member/checkId";
            }

            // --------------------------------------------------------
            // 관리자 - 회원 목록
            // --------------------------------------------------------
            case "/member/list.do":
                request.setAttribute("list", Execute.execute(Init.getService(uri), null));
                return "member/list";

            // --------------------------------------------------------
            // 관리자 - 회원 상태 변경
            // --------------------------------------------------------
            case "/member/changeStatus.do": {
                MemberVO vo = new MemberVO();
                vo.setId(request.getParameter("id"));
                if (vo.getId().equals(loginId)) {
                    session.setAttribute("msg", "로그인한 관리자의 상태는 변경할 수 없습니다.");
                    return "redirect:list.do";
                }
                vo.setStatus(request.getParameter("status"));
                Integer result = (Integer) Execute.execute(Init.getService(uri), vo);
                if (result == 1) {
                    session.setAttribute("msg",
                        "아이디 <" + vo.getId() + ">의 상태가 <" + vo.getStatus() + ">(으)로 변경되었습니다.");
                } else {
                    session.setAttribute("msg", "상태 변경에 실패하였습니다.");
                }
                return "redirect:list.do";
            }

            // --------------------------------------------------------
            // 관리자 - 회원 등급 변경
            // --------------------------------------------------------
            case "/member/changeGrade.do": {
                MemberVO vo = new MemberVO();
                vo.setId(request.getParameter("id"));
                if (vo.getId().equals(loginId)) {
                    session.setAttribute("msg", "로그인한 관리자의 등급은 변경할 수 없습니다.");
                    return "redirect:list.do";
                }
                vo.setGradeNo(Integer.parseInt(request.getParameter("gradeNo")));
                Integer result = (Integer) Execute.execute(Init.getService(uri), vo);
                if (result == 1) {
                    String gradeName;
                    switch (vo.getGradeNo()) {
                        case 2:  gradeName = "매장점주"; break;
                        case 9:  gradeName = "관리자";   break;
                        default: gradeName = "일반회원"; break;
                    }
                    session.setAttribute("msg",
                        "아이디 <" + vo.getId() + ">의 등급이 <" + gradeName + ">으로 변경되었습니다.");
                } else {
                    session.setAttribute("msg", "등급 변경에 실패하였습니다.");
                }
                return "redirect:list.do";
            }

            default:
                return "error/noPage";
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("moduleName", "회원정보");
            request.setAttribute("e", e);
            return "error/err_500";
        }
    }
}