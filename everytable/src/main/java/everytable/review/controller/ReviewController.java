package everytable.review.controller;

import java.io.BufferedReader;
import java.util.List;
import org.json.JSONObject;
import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.LoginVO;
import everytable.review.vo.ReviewVO;
import everytable.util.page.PageObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class ReviewController implements Controller {

	@Override
	public String execute(HttpServletRequest request) {
		HttpSession session = request.getSession();
		LoginVO login = (LoginVO) session.getAttribute("login");
		String id = null;
		if (login != null) id = login.getId();

		request.setAttribute("url", request.getRequestURL());

		try {
			String uri = request.getServletPath();
			Object result = null; // 서비스 실행 결과를 담을 변수

			switch (uri) {
			case "/review/list.do":
			    System.out.println("ReviewController.execute() - 리뷰 리스트 처리");
			    
			    // 1. 세션에서 로그인 아이디 가져오기 (이미 상단에서 id 변수를 선언했다고 가정)
			    // String id = (String) session.getAttribute("id"); // 이런 식으로 가져오셨을 겁니다.
			    
			    PageObject pageObject = PageObject.getInstance(request);

			    // 2. 로그인 여부에 따른 처리
			    if (id != null) {
			        // 로그인 상태: 내 아이디를 pageObject에 저장 (DAO에서 검색 조건으로 사용)
			        pageObject.setAccepter(id); 
			    } else {
			        // 로그인 안 함: 바로 로그인 페이지로 보낼지, 아니면 빈 리스트를 보여줄지 결정
			        // 여기서는 로그인 페이지로 유도하는 방향으로 처리합니다.
			        return "redirect:/member/loginForm.do";
			    }

			    // 3. 서비스 실행 (이제 DAO에서 내 아이디에 해당하는 데이터만 가져옵니다)
			    List<ReviewVO> list = (List<ReviewVO>) Execute.execute(Init.getService(uri), pageObject);

			    if (list != null) {
			        for (ReviewVO vo : list) {
			            // 본인 확인 처리 (수정/삭제 버튼 노출용)
			            if (id.equals(vo.getUserId())) {
			                vo.setSameId(1);
			            }
			            // 특수 문자 처리
			            if (vo.getContent() != null) {
			                vo.setContent(vo.getContent()
			                        .replace("\\", "\\\\").replace("\n", "\\n")
			                        .replace("\"", "\\\""));
			            }
			        }
			    }

			    request.setAttribute("list", list);
			    request.setAttribute("pageObject", pageObject);
			    return "review/list";

				case "/review/write.do":
					// JSON 데이터 수집
					JSONObject jsonWrite = getJsonBody(request);
					ReviewVO writeVo = new ReviewVO();
					
					// VO 필드명에 맞춰 데이터 세팅
					writeVo.setContent(jsonWrite.getString("content"));
					writeVo.setStoreId(jsonWrite.getLong("storeId"));
					writeVo.setRating(jsonWrite.getDouble("rating"));
					writeVo.setUserId(id); 

					System.out.println("ReviewController.execute().writeVo = " + writeVo);
					Execute.execute(Init.getService(uri), writeVo);
					return "review/write";

				case "/review/update.do":
					// JSON 데이터 수집
					JSONObject jsonUpdate = getJsonBody(request);
					ReviewVO updateVo = new ReviewVO();
					
					updateVo.setReviewId(jsonUpdate.getLong("reviewId"));
					updateVo.setContent(jsonUpdate.getString("content"));
					updateVo.setRating(jsonUpdate.getDouble("rating"));
					updateVo.setUserId(id); 

					System.out.println("ReviewController.execute().updateVo = " + updateVo);
					request.setAttribute("result", Execute.execute(Init.getService(uri), updateVo));
					return "review/update";

				case "/review/delete.do":
					// JSON 데이터 수집 (보통 delete도 reviewId를 넘김)
					JSONObject jsonDelete = getJsonBody(request);
					ReviewVO deleteVo = new ReviewVO();
					
					deleteVo.setReviewId(jsonDelete.getLong("reviewId"));
					deleteVo.setUserId(id); 

					request.setAttribute("result", Execute.execute(Init.getService(uri), deleteVo));
					return "review/delete";

				default:
					break;
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("moduleName", "리뷰 관리");
			request.setAttribute("e", e);
			return "error/err_500";
		}

		return null;
	}

	// Request Body에서 JSON 객체를 추출하는 공통 메서드
	private JSONObject getJsonBody(HttpServletRequest request) throws Exception {
		StringBuilder sb = new StringBuilder();
		BufferedReader reader = request.getReader();
		String line;
		while ((line = reader.readLine()) != null) {
			sb.append(line);
		}
		return new JSONObject(sb.toString());
	}
}