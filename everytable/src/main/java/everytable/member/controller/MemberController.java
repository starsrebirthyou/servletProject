package everytable.member.controller;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.LoginVO;
import everytable.member.vo.MemberVO;
import everytable.util.mail.Mail;
import everytable.util.page.PageObject;
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

            case "/member/login.do": 
                LoginVO userVO = new LoginVO();
                userVO.setId(request.getParameter("id"));
                userVO.setPw(request.getParameter("pw"));

                loginVO = (LoginVO) Execute.execute(Init.getService(uri), userVO);
                if (loginVO == null)
                    throw new Exception("아이디 또는 비밀번호가 일치하지 않거나 이용이 제한된 계정입니다.");

                session.setAttribute("login", loginVO);
                Execute.execute(Init.getService("/member/updateLastLogin.do"), loginVO.getId());
                session.setAttribute("msg", loginVO.getName() + "님, 환영합니다.");

                String redirectUrl = request.getParameter("redirectUrl");
                if (redirectUrl != null && !redirectUrl.trim().isEmpty())
                    return "redirect:" + redirectUrl;
                return "redirect:/notice/list.do";

            // --------------------------------------------------------
            // 로그아웃
            // --------------------------------------------------------
            case "/member/logout.do":
                session.removeAttribute("login");
                session.setAttribute("msg", "로그아웃되었습니다.");
                return "redirect:/notice/list.do";

            // --------------------------------------------------------
            // 회원가입 - 유형 선택
            // --------------------------------------------------------
            case "/member/writeTypeSelect.do":
                return "member/writeTypeSelect";

            case "/member/writeForm.do":
                String type = request.getParameter("type");
                if ("owner".equals(type)) return "member/writeForm_owner";
                return "member/writeForm";

            // --------------------------------------------------------
            // 회원가입 - 처리
            // --------------------------------------------------------
            case "/member/write.do":
                MemberVO vo = new MemberVO();
                vo.setId(request.getParameter("id"));
                vo.setPw(request.getParameter("pw"));
                vo.setName(request.getParameter("name"));
                vo.setGender(request.getParameter("gender"));
                vo.setBirth(request.getParameter("birth"));
                vo.setTel(request.getParameter("tel"));
                vo.setEmail(request.getParameter("email"));

                int gradeNo = 1;
                if ("2".equals(request.getParameter("gradeNo"))) gradeNo = 2;
                vo.setGradeNo(gradeNo);

                Execute.execute(Init.getService(uri), vo);

                loginVO = new LoginVO();
                loginVO.setId(vo.getId());
                loginVO.setName(vo.getName());
                loginVO.setGradeNo(gradeNo);
                loginVO.setGradeName(gradeNo == 2 ? "매장점주" : "일반회원");
                session.setAttribute("login", loginVO);
                Execute.execute(Init.getService("/member/updateLastLogin.do"), loginVO.getId());

                session.setAttribute("msg", "회원가입을 축하드립니다. 자동 로그인 되었습니다.");
                return "redirect:/notice/list.do";

            // --------------------------------------------------------
            // 로그인 필요 처리
            // --------------------------------------------------------
            case "/member/loginRequired.do":
                redirectUrl = request.getParameter("redirectUrl");
                if (loginId != null) {
                    if (redirectUrl != null && !redirectUrl.trim().isEmpty())
                        return "redirect:" + redirectUrl;
                    return "redirect:/notice/list.do";
                }
                request.setAttribute("redirectUrl", redirectUrl);
                return "member/loginForm";
            
	         // --------------------------------------------------------
	         // 아이디 찾기 - 폼 이동
	         // --------------------------------------------------------
	         case "/member/searchIdForm.do":
	             return "member/searchIdForm";
	
	         // --------------------------------------------------------
	         // 아이디 찾기 - 처리
	         // --------------------------------------------------------
	         case "/member/searchId.do":
	             vo = new MemberVO();
	             vo.setName(request.getParameter("name"));
	             vo.setEmail(request.getParameter("email"));
	             
	             String findId = (String) Execute.execute(Init.getService(uri), vo);
	             
	             if (findId != null) {
	                 request.setAttribute("msg", "회원님의 아이디는 [" + findId + "] 입니다.");
	             } else {
	                 request.setAttribute("msg", "입력하신 정보와 일치하는 회원 정보가 없습니다.");
	             }
	             
	             // 결과를 띄워줄 적절한 페이지로 리다이렉트 또는 포워드 (예: 로그인 폼으로 돌아가기)
	             request.setAttribute("redirectUrl", "/member/loginForm.do");
	             return "member/loginForm";
	             
	             
	         // --------------------------------------------------------
	         // 비밀번호 찾기 - 폼 이동
	         // --------------------------------------------------------
	         case "/member/searchPwForm.do":
	             return "member/searchPwForm";
	             
	          // ── 1단계: 아이디/이메일 확인 및 인증번호 발송 ──
	         case "/member/sendAuthCode.do":
	             findId = request.getParameter("id");
	             String findEmail = request.getParameter("email");
	             
	             vo = new MemberVO();
	             vo.setId(findId);
	             vo.setEmail(findEmail);
	             
	             // DB에서 해당 정보가 있는지 확인 (기존 checkMemberInfo 사용)
	             String checkId = (String) Execute.execute(Init.getService("/member/checkMemberInfo.do"), vo);
	             
	             if (checkId != null) {
	                 // 1. 랜덤 인증번호 생성 (6자리)
	                 int authCode = (int)(Math.random() * 899999) + 100000;
	                 
	                 // 2. 세션에 인증번호 저장 (나중에 확인용)
	                 session.setAttribute("authCode", String.valueOf(authCode));
	                 session.setAttribute("resetId", checkId); // 비밀번호 바꿀 대상 아이디 저장
	                 
	                 // 3. 이메일 발송 (작성하신 MailUtil 활용)
	                 try {
	                     String subject = "[EveryTable] 비밀번호 찾기 인증번호입니다.";
	                     String content = "인증번호: <b>" + authCode + "</b>";
	                     Mail.sendMail(findEmail, subject, content);
	                     request.setAttribute("result", "ok");
	                 } catch(Exception e) {
	            	 	 	e.printStackTrace();
	                    request.setAttribute("result", "mail_error");
	                 }
	             } else {
	                 request.setAttribute("result", "not_found");
	             }
	             return "member/ajaxResult";
	             
	         // ── 2단계: 인증번호 확인 ──
	         case "/member/verifyAuthCode.do":
	             String inputCode = request.getParameter("code");
	             String savedCode = (String) session.getAttribute("authCode");
	             
	             if (savedCode != null && savedCode.equals(inputCode)) {
	                 session.setAttribute("authStatus", true); // 인증 완료 상태 저장
	                 request.setAttribute("result", "ok");
	             } else {
	                 request.setAttribute("result", "fail");
	             }
	             return "member/ajaxResult";

	         // ── 3단계: 비밀번호 재설정 ──
	         case "/member/resetPw.do":
	             // 인증을 거쳤는지 확인
	             Boolean authStatus = (Boolean) session.getAttribute("authStatus");
	             String resetId = (String) session.getAttribute("resetId");
	             String newPw = request.getParameter("newPw");
	             
	             if (authStatus != null && authStatus && resetId != null) {
	                 vo = new MemberVO();
	                 vo.setId(resetId);
	                 vo.setNewPw(newPw); // MemberVO에 newPw 필드가 있어야 함
	                 
	                 // 비밀번호 변경 서비스 호출 (changePw 서비스 재활용)
	                 Integer res = (Integer) Execute.execute(Init.getService("/member/resetPw.do"), vo);
	                 
	                 if (res == 1) {
	                     session.removeAttribute("authCode");
	                     session.removeAttribute("authStatus");
	                     session.removeAttribute("resetId");
	                     request.setAttribute("result", "ok");
	                 } else {
	                     request.setAttribute("result", "fail");
	                 }
	             } else {
	                 request.setAttribute("result", "fail");
	             }
	             return "member/ajaxResult";
	
	         // --------------------------------------------------------
	         // 비밀번호 찾기 - 처리
	         // --------------------------------------------------------
	         case "/member/searchPw.do":
	             vo = new MemberVO();
	             vo.setName(request.getParameter("id"));
	             vo.setEmail(request.getParameter("email"));
	             
	             String findPw = (String) Execute.execute(Init.getService(uri), vo);
	             
	             if (findPw != null) {
	                 request.setAttribute("msg", "회원님의 아이디는 [" + findPw + "] 입니다.");
	             } else {
	                 request.setAttribute("msg", "입력하신 정보와 일치하는 회원 정보가 없습니다.");
	             }
	             
	             // 결과를 띄워줄 적절한 페이지로 리다이렉트 또는 포워드 (예: 로그인 폼으로 돌아가기)
	             request.setAttribute("redirectUrl", "/member/loginForm.do");
	             return "member/loginForm";
	         
	         
	         case "/member/checkMemberInfo.do": 
	        	    String name = request.getParameter("name");
	        	    String email = request.getParameter("email");
	
	        	    vo = new MemberVO();
	        	    vo.setName(name);
	        	    vo.setEmail(email);
	
	        	    String id = (String) Execute.execute(Init.getService("/member/searchId.do"), vo);
	
	        	    if (id != null) {
	        	        // 성공 시 아이디만 출력하고 끝!
	        	        // response.getWriter().print(id); 
	        	        // return null; 
	        	    
	        	    request.setAttribute("result", (id != null) ? id : "no");
	        	    return "member/ajaxResult"; 
	        	}
	         
	      // --------------------------------------------------------
	      // 아이디 찾기 - 최종 비밀번호 확인
	      // --------------------------------------------------------
	      case "/member/checkPwForId.do": 
	          loginVO = new LoginVO();
	          loginVO.setId(request.getParameter("id"));
	          loginVO.setPw(request.getParameter("pw"));
	
	          // 로그인 서비스를 재활용해서 회원 정보가 있는지 확인
	          LoginVO resultVO = (LoginVO) Execute.execute(Init.getService("/member/login.do"), loginVO);
	
	          if (resultVO != null) {
	              request.setAttribute("result", "match"); // 비밀번호 일치
	          } else {
	              request.setAttribute("result", "mismatch"); // 불일치
	          }
	          return "member/ajaxResult"; 

            // --------------------------------------------------------
            // 아이디 중복 체크
            // --------------------------------------------------------
            case "/member/checkId.do":
            	id = request.getParameter("id");
                request.setAttribute("id", Execute.execute(Init.getService(uri), id));
                return "member/checkId";

            // --------------------------------------------------------
            // 전화번호 중복 체크
            // --------------------------------------------------------
            case "/member/checkTel.do":
                String tel = request.getParameter("tel");
                request.setAttribute("tel", Execute.execute(Init.getService(uri), tel));
                return "member/checkTel";

            // --------------------------------------------------------
            // 이메일 중복 체크
            // --------------------------------------------------------
            case "/member/checkEmail.do":
                email = request.getParameter("email");
                request.setAttribute("email", Execute.execute(Init.getService(uri), email));
                return "member/checkEmail";

            // --------------------------------------------------------
            // 관리자 - 회원 목록 (검색 + 페이지네이션)
            // --------------------------------------------------------
            case "/member/list.do":
                PageObject pageObject = PageObject.getInstance(request);

                // 필터 조건을 MemberVO에 담아서 전달
                // MemberDAO.searchCondition()에서 각 필드를 꺼내 씀:
                //   filterVO.email    → 검색어 (id/name/tel LIKE)
                //   filterVO.status   → 상태 필터
                //   filterVO.gradeNo  → 등급 필터 (0이면 전체)
                //   filterVO.joinDate → 가입일 시작
                //   filterVO.lastLogin→ 가입일 종료
                MemberVO filterVO = new MemberVO();

                String keyword = request.getParameter("keyword");
                filterVO.setEmail(keyword);  // email 필드를 keyword 용도로 재활용

                String status = request.getParameter("status");
                filterVO.setStatus(status);

                String gradeNoParam = request.getParameter("gradeNo");
                if (gradeNoParam != null && !gradeNoParam.trim().isEmpty()
                        && !"전체".equals(gradeNoParam)) {
                    filterVO.setGradeNo(Integer.parseInt(gradeNoParam));
                } else {
                    filterVO.setGradeNo(0);  // 0 = 전체
                }

                filterVO.setJoinDate(request.getParameter("dateFrom"));   // 가입일 시작
                filterVO.setLastLogin(request.getParameter("dateTo"));    // 가입일 종료

                // JSP에서 필터값 유지를 위해 request attribute로도 넘김
                request.setAttribute("keyword",  keyword);
                request.setAttribute("status",   status);
                request.setAttribute("gradeNo",  gradeNoParam);
                request.setAttribute("dateFrom", request.getParameter("dateFrom"));
                request.setAttribute("dateTo",   request.getParameter("dateTo"));

                request.setAttribute("list",       Execute.execute(Init.getService(uri),
                                                       new Object[]{pageObject, filterVO}));
                request.setAttribute("pageObject", pageObject);
                return "member/list";

            // --------------------------------------------------------
            // 관리자 - 상태 변경
            // --------------------------------------------------------
            case "/member/changeStatus.do":
                vo = new MemberVO();
                vo.setId(request.getParameter("id"));
                if (vo.getId().equals(loginId)) {
                    session.setAttribute("msg", "로그인한 관리자의 상태는 변경할 수 없습니다.");
                    return "redirect:list.do";
                }
                vo.setStatus(request.getParameter("status"));
                Integer result = (Integer) Execute.execute(Init.getService(uri), vo);
                session.setAttribute("msg", result == 1
                    ? "아이디 <" + vo.getId() + ">의 상태가 <" + vo.getStatus() + ">(으)로 변경되었습니다."
                    : "상태 변경에 실패하였습니다.");
                return "redirect:view.do";

            // --------------------------------------------------------
            // 관리자 - 등급 변경
            // --------------------------------------------------------
            case "/member/changeGrade.do":
                vo = new MemberVO();
                vo.setId(request.getParameter("id"));
                if (vo.getId().equals(loginId)) {
                    session.setAttribute("msg", "로그인한 관리자의 등급은 변경할 수 없습니다.");
                    return "redirect:view.do";
                }
                vo.setGradeNo(Integer.parseInt(request.getParameter("gradeNo")));
                result = (Integer) Execute.execute(Init.getService(uri), vo);
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