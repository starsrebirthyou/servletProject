package everytable.notice.controller;

import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.member.vo.LoginVO;
import everytable.notice.vo.NoticeVO;
import everytable.util.page.PageObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

public class NoticeController implements Controller {

	private String path = "/upload/image";

	public String execute(HttpServletRequest request) {

		HttpSession session = request.getSession();
		request.setAttribute("url", request.getRequestURL());

		try {
			String uri = request.getServletPath();

			NoticeVO vo;
			Integer result;
			long no;

			switch (uri) {

			// 1. 공지 리스트
			case "/notice/list.do":
				PageObject pageObject = PageObject.getInstance(request);
				request.setAttribute("list", Execute.execute(Init.getService(uri), pageObject));
				request.setAttribute("pageObject", pageObject);
				return "notice/list";


			// 2. 공지 보기
			case "/notice/view.do":
				no = Long.parseLong(request.getParameter("no"));

				// 조회수 증가 (inc=1 일 때만)
				String inc = request.getParameter("inc");
				if (inc != null && inc.equals("1")) {
					Execute.execute(Init.getService("/notice/increaseHit.do"), no);
				}

				request.setAttribute("vo", Execute.execute(Init.getService(uri), no));
				return "notice/view";


			// 3-1. 등록 화면
			case "/notice/writeForm.do":
				return "notice/writeForm";


			// 3-2. 등록 처리
			case "/notice/write.do":
				vo = new NoticeVO();
				vo.setTitle(request.getParameter("title"));
				vo.setContent(request.getParameter("content"));
				vo.setCateNo(Long.parseLong(request.getParameter("cateNo")));

				// 로그인한 사용자 id를 writer로 저장
				LoginVO loginForWrite = (LoginVO) session.getAttribute("login");
				vo.setWriterId(loginForWrite.getId());

				// 파일 저장 경로 준비
				String savePath = request.getServletContext().getRealPath(path);
				File saveDir = new File(savePath);
				if (!saveDir.exists()) saveDir.mkdirs();

				// 파일 처리
				Part filePart = request.getPart("imageFile");
				if (filePart != null && filePart.getSize() > 0) {
					String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
					String savedFileName = UUID.randomUUID().toString() + "_" + fileName;
					filePart.write(savePath + File.separator + savedFileName);
					vo.setFileName(path + "/" + savedFileName);
				} else {
					vo.setFileName(null);
				}

				Execute.execute(Init.getService(uri), vo);
				session.setAttribute("msg", "새로운 공지가 등록되었습니다.");
				Thread.sleep(1000);
				return "redirect:list.do?perPageNum=" + request.getParameter("perPageNum");


			// 4-1. 수정 화면
			case "/notice/updateForm.do":
				no = Long.parseLong(request.getParameter("no"));
				request.setAttribute("vo", Execute.execute(Init.getService("/notice/view.do"), no));
				return "notice/updateForm";


			// 4-2. 수정 처리
			case "/notice/update.do":
				vo = new NoticeVO();
				vo.setNo(Long.parseLong(request.getParameter("no")));
				vo.setTitle(request.getParameter("title"));
				vo.setContent(request.getParameter("content"));
				vo.setCateNo(Long.parseLong(request.getParameter("cateNo")));

				// 파일 저장 경로 준비
				savePath = request.getServletContext().getRealPath(path);
				saveDir = new File(savePath);
				if (!saveDir.exists()) saveDir.mkdirs();

				// 파일 처리
				filePart = request.getPart("imageFile");
				String deleteImage = request.getParameter("deleteImage");
				String delFileName = request.getParameter("delFileName");

				if (filePart != null && filePart.getSize() > 0) {
					// 새 파일로 변경
					String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
					String savedFileName = UUID.randomUUID().toString() + "_" + fileName;
					filePart.write(savePath + File.separator + savedFileName);
					vo.setFileName(path + "/" + savedFileName);

					// 기존 파일 삭제
					if (delFileName != null && !delFileName.isEmpty()) {
						new File(request.getServletContext().getRealPath(delFileName)).delete();
					}
				} else if ("Y".equals(deleteImage)) {
					// 이미지 삭제 요청
					vo.setFileName(null);

					// 기존 파일 삭제
					if (delFileName != null && !delFileName.isEmpty()) {
						new File(request.getServletContext().getRealPath(delFileName)).delete();
					}
				} else {
					// 변경 없음 - 기존 파일 유지
					vo.setFileName(delFileName);
				}

				result = (Integer) Execute.execute(Init.getService(uri), vo);

				if (result == 1) session.setAttribute("msg", "공지가 수정되었습니다.");
				else session.setAttribute("msg", "공지 수정에 실패했습니다.");

				Thread.sleep(1000);
				return "redirect:list.do?page=" + request.getParameter("page")
					+ "&perPageNum=" + request.getParameter("perPageNum")
					+ "&key=" + request.getParameter("key");


			// 5. 공지 삭제
			case "/notice/delete.do":
				no = Long.parseLong(request.getParameter("no"));
				result = (Integer) Execute.execute(Init.getService(uri), no);

				if (result == 1) session.setAttribute("msg", "공지가 삭제되었습니다.");
				else session.setAttribute("msg", "이미 삭제된 공지입니다.");

				return "redirect:list.do?perPageNum=" + request.getParameter("perPageNum");


			default:
				return "error/noPage";
			}

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("moduleName", "공지사항");
			request.setAttribute("e", e);
			return "error/err_500";
		}
	}

	// 파일명 앞에 s_ 붙이는 메서드
	public static String addPreString(String fileName) {
		int pos = fileName.lastIndexOf("/") + 1;
		return fileName.substring(0, pos) + "s_" + fileName.substring(pos);
	}

	// list의 파일명 앞에 s_ 붙이는 메서드
	public static void addPreList(List<NoticeVO> list) {
		for (NoticeVO vo : list) {
			vo.setFileName(addPreString(vo.getFileName()));
		}
	}
}