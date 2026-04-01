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
					PageObject pageObject = PageObject.getInstance(request);

					// 서비스 실행 및 리스트 저장
					List<ReviewVO> list = (List<ReviewVO>) Execute.execute(Init.getService(uri), pageObject);

					if (list != null) {
						for (ReviewVO vo : list) {
							// 1. 본인 확인 처리 (새 필드 userId 사용)
							if (id != null && id.equals(vo.getUserId())) {
								vo.setSameId(1);
							}
							// 2. content 특수 문자 처리 (JSON 응답 대비)
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