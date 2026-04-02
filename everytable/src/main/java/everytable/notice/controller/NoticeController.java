package everytable.notice.controller;

import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import everytable.main.controller.Controller;
import everytable.main.controller.Init;
import everytable.main.service.Execute;
import everytable.notice.vo.NoticeVO;
import everytable.util.page.PageObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

// Controller
// - 웹에서 메뉴에 해당되는 URL -> 메뉴 처리

public class NoticeController implements Controller {

	// 파일이 저장되는 위치 - 전역 변수 사용
	private String path = "/upload/image";
	
	// Controller 종류이므로 main을 복사해서 사용
	public String execute(HttpServletRequest request) {
		
		// 메시지 처리를 위한 세션 꺼내기
		HttpSession session = request.getSession();
		
		// 잘못된 URI 처리 / 오류를 위한 URL 저장
		request.setAttribute("url", request.getRequestURL());
		try {  // 정상처리
			// 요청 uri에 따라 처리된다.
			// list - /notice/list.do
			// 1. 공지사항 메뉴 입력
			String uri = request.getServletPath();
			
			// 2. 공지사항 처리
			// 사용 변수 선언
			NoticeVO vo;
			Integer result;
			long no;
			
			switch (uri) {
			// 1. 공지 리스트
			case "/notice/list.do" :
				// System.out.println("공지사항 리스트 처리");
				// 페이지 처리를 위한 객체
				// getInstance() - 객체를 생성해서 넘긴다
				// - 1. PageObject 생성  2. request에서 page / 검색 정보를 받아서 세팅
				PageObject pageObject = PageObject.getInstance(request);
				
				// 생성된 Service를 가져와서 실행 -> Execute가 실행하면 로그를 남긴다.
				// List<NoticeVO> list = new NoticeListService().service(null);.
				request.setAttribute("list", Execute.execute(Init.getService(uri), pageObject));
				// 처리된 후의 prageObject 데이터 확인
				System.out.println("NoticeController.execute().pageObject - " + pageObject);
				request.setAttribute("pageObject", pageObject);
				// jsp의 위치 정보 "/WEB-INF/view/" + "board/list" + ".jsp"
				return "notice/list";

				
			// 2. 공지 보기
			case "/notice/view.do":
				// 넘어오는 데이터 수집
				// 데이터 수집 - 번호
				no = Long.parseLong(request.getParameter("no"));
				
				// 조회수 증가 처리
				String inc = request.getParameter("inc");
			    if (inc != null && inc.equals("1")) {
			        Execute.execute(Init.getService("/notice/increaseHit.do"), no);
			    }
				
				// DB 데이터 가져오기. request에 저장
				request.setAttribute("vo", Execute.execute(Init.getService(uri), no));
				
				return "notice/view";
				
				
			// 3-1. 등록 화면
			case "/notice/writeForm.do" :
				return "notice/writeForm";
				
				
			// 3-2. 등록 처리
			case "/notice/write.do" :
				
				// 데이터 수집 - NoticeVO : 제목, 내용, 이미지, 카테고리 번호
				vo = new NoticeVO();
				vo.setTitle(request.getParameter("title"));
				vo.setContent(request.getParameter("content"));
				vo.setCateNo(Long.parseLong(request.getParameter("cateNo")));
				
				System.out.println("NoticeController.execute().vo : 파일 처리 전 - " + vo);
				
				// 전달된 파일을 서버 컴퓨터에 접근할 수 있는 폴더에 저장
				// 저장 위치의 절대 위치 찾기
				String savePath = request.getServletContext().getRealPath(path);
				System.out.println("NoticeController.execute().savePath - " + savePath);
				
				// 폴더가 없는 경우 자동으로 생성
				File saveDir = new File(savePath);  // 저장위치로 디렉토리 작업이 가능한 File 객체로 만든다.
				if (!saveDir.exists()) {  // 폴더가 존재하지 않으면
					saveDir.mkdirs();  // 중간에 폴더부터 다 만든다 : mkdirs()
				}
				
				// 전달되는 파일 꺼내오기
				Part filePart = request.getPart("imageFile");

				if (filePart != null && filePart.getSize() > 0) {
				    String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
				    System.out.println("NoticeController.execute().fileName - " + fileName);
				    String uuid = UUID.randomUUID().toString();
				    String savedFileName = uuid + "_" + fileName;
				    
				    System.out.println("NoticeController.execute().saveFileName - " + path + "/" + savedFileName);
				    
				    filePart.write(savePath + File.separator + savedFileName);
				    vo.setFileName(path + "/" + savedFileName);
				} else {
				    vo.setFileName(null);
				}

				System.out.println("NoticeController.execute().vo : 파일 처리 후 - " + vo);

				// DB에 저장
				Execute.execute(Init.getService(uri), vo);
				
				// 결과 메시지 처리
				session.setAttribute("msg", "새로운 공지가 등록되었습니다.");
				
				// 파일이 큰 경우 업로드되는데 시간이 필요하다.
				Thread.sleep(1000);
				
				// jsp의 위치 정보 "/WEB-INF/views/" + "image/writeForm" + ".jsp"
				return "redirect:list.do?perPageNum=" + request.getParameter("perPageNum");
				
				
			// 4-1. 공지 수정 폼
			case "/notice/updateForm.do":
				// 넘어오는 데이터 수집
				// 데이터 수집 - 번호
				no = Long.parseLong(request.getParameter("no"));
				
				// DB 데이터 가져오기. request에 저장
				request.setAttribute("vo", Execute.execute(Init.getService("/notice/view.do"), no));
				
				return "notice/updateForm";
				
				
			// 4-2. 공지 수정 처리
			case "/notice/update.do":
				// 데이터 수집 - NoticeVO : 제목, 내용, 이미지, 카테고리 번호
				vo = new NoticeVO();
				vo.setNo(Long.parseLong(request.getParameter("no")));
				vo.setTitle(request.getParameter("title"));
				vo.setContent(request.getParameter("content"));
				vo.setCateNo(Long.parseLong(request.getParameter("cateNo")));
				
				System.out.println("NoticeController.execute().vo : 파일 처리 전 - " + vo);
				
				// 전달된 파일을 서버 컴퓨터에 접근할 수 있는 폴더에 저장
				// 저장 위치의 절대 위치 찾기
				savePath = request.getServletContext().getRealPath(path);
				System.out.println("NoticeController.execute().savePath - " + savePath);
				
				// 폴더가 없는 경우 자동으로 생성
				saveDir = new File(savePath);  // 저장위치로 디렉토리 작업이 가능한 File 객체로 만든다.
				if (!saveDir.exists()) {  // 폴더가 존재하지 않으면
					saveDir.mkdirs();  // 중간에 폴더부터 다 만든다 : mkdirs()
				}
				
				// 전달되는 파일 꺼내오기
				filePart = request.getPart("imageFile");
				String deleteImage = request.getParameter("deleteImage");

				if (filePart != null && filePart.getSize() > 0) {
				    // 새 파일로 변경
					String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
					String uuid = UUID.randomUUID().toString();
					String savedFileName = uuid + "_" + fileName;
				    filePart.write(savePath + File.separator + savedFileName);
				    vo.setFileName(path + "/" + savedFileName);
				    
				    // 기존 파일 삭제
				    String delFileName = request.getParameter("delFileName");
				    if (delFileName != null && !delFileName.isEmpty()) {
				        new File(request.getServletContext().getRealPath(delFileName)).delete();
				    }
				} else if ("Y".equals(deleteImage)) {
				    // 이미지 삭제 요청 - DB null 처리
				    vo.setFileName(null);
				    
				    // 기존 파일 삭제
				    String delFileName = request.getParameter("delFileName");
				    if (delFileName != null && !delFileName.isEmpty()) {
				        new File(request.getServletContext().getRealPath(delFileName)).delete();
				    }
				} else {
				    // 변경 없음 - 기존 파일 유지
				    vo.setFileName(request.getParameter("delFileName"));
				}
				
				System.out.println("NoticeController.execute().vo : 파일 처리 후 - " + vo);

				// DB 데이터 수정
				result = (Integer) Execute.execute(Init.getService(uri), vo);
				
				// 수정 후 처리
				if(result == 1) session.setAttribute("msg", "공지가 수정되었습니다.");
				else session.setAttribute("mag", "공지 수정에 실패했습니다.");
				
				// 파일이 큰 경우 업로드되는데 시간이 필요하다.
				Thread.sleep(1000);
				
				return "redirect:list.do?page=" + request.getParameter("page") 
			    + "&perPageNum=" + request.getParameter("perPageNum") 
			    + "&key=" + request.getParameter("key");
				
				
			// 5. 공지 삭제
			case "/notice/delete.do":
				// 넘어오는 데이터 수집 - vo : 제목, 내용, 시작일, 종료일
				// 데이터 수집 - 번호
				no = Long.parseLong(request.getParameter("no"));
				
				// DB 데이터 수정 - update, insert, delete 쿼리를 실행하면 int 데이터가 나온다.
				result = (Integer) Execute.execute(Init.getService(uri), no);
				
				// 메시지 처리
				if(result == 1) session.setAttribute("msg", "공지가 삭제되었습니다.");
				else session.setAttribute("msg", "이미 삭제된 공지입니다.");

				return "redirect:list.do?perPageNum=" + request.getParameter("perPageNum");
				
				
			default :
				// WEB-INF/views/ + error/noPage + .jsp
				return "error/noPage";
			}  // switch 끝
		} catch (Exception e) {
			e.printStackTrace();
			// 잘못된 URI 처리
			request.setAttribute("moduleName", "공지사항");
			request.setAttribute("e", e);
			// WEB-INF/views/ + error/noPage + .jsp
			return "error/err_500";
		}
	}  // execute() 끝

	//파일명 문자열을 하나 받아서 파일명 앞에 s_를 붙이는 메서드
	public static String addPreString(String fileName) {
		String resultFileName = "";
		
		// 마지막 /가 포함된 위치 - 앞 : 폴더 위치, 뒤 : 파일명
		int pos = fileName.lastIndexOf("/") + 1;
		
		// /u/i/test.jpg -> pos = 5
		resultFileName = fileName.substring(0, pos) + "s_" + fileName.substring(pos);
		
		return resultFileName;
	}
	
	// list의 파일명 앞에 s_를 붙이는 메서드 : for 반복문 처리
	public static void addPreList(List<NoticeVO> list) {
		for(NoticeVO vo : list) {
			// vo에서 파일명을 꺼내고 "s_"를 붙인다. 그리고 다시 vo의 파일명을 세팅한다.
			vo.setFileName(addPreString(vo.getFileName()));
		}
	}
}
