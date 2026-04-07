<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator"
	prefix="decorator"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>everytable <decorator:title /></title>
<!-- web 라이브러리를 등록 -->
<!-- Bootstrap 라이브러리 등록 --------- -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery 라이브러리 등록 - 자바스크립트 함수 : jQuery() ==> $() -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<!-- jQuery UI 라이브러리 등록 : datepicker 등 -->
<link rel="stylesheet"
	href="https://code.jquery.com/ui/1.14.2/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.14.2/jquery-ui.js"></script>

<!-- icon lib 등록 - awesome 4 -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<style type="text/css">
/* 하단 바 전용 스타일 정의 */
.footer-green {
	background-color: #87a372 !important;
}
</style>

<script type="text/javascript">
$(function(){
	// 모달 창을 띄운다.
	${(!empty msg)?"$('#msgModal').modal('show');":""}
});
</script>
<!-- JSP의 Head 태그의 title 제외한 부분에 소스가 추가된다. -->
<decorator:head />
</head>
<body>
	<!-- body 이전의 메뉴바를 추가해서 나타나게 한다. -->
	<!-- 메인 메뉴 부분 (mainMenu.jsp에도 bg-dark 대신 custom-green이 적용되어 있어야 합니다) -->
	<%@ include file="../inc/mainMenu.jsp"%>

	<div class="container-fluid"
		style="margin-top: 80px; margin-bottom: 80px;">
		<div class="container mt-3 mb-3">
			<!-- 실제 페이지 내용이 들어가는 부분 -->
			<decorator:body />
		</div>
	</div>

	<!-- [수정] 부자연스러운 fixed-bottom을 제거하고 하단 배경을 깔았습니다. -->
<footer style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; padding: 40px 0; margin-top: 50px; padding-bottom: 120px;"> 
    <div class="container" style="text-align: center; color: #6c757d; font-size: 0.8rem; line-height: 1.8;">
        <p style="margin-bottom: 5px;">
            (주)에브리테이블 | 대표: 홍윤정 | 사업자등록번호: 123-45-67890 | 통신판매업신고: 2026-한양여대-12345
        </p>
        <p style="margin-bottom: 5px;">
            주소: 서울특별시 성동구 살곶이길 200 pc22, 2층 | 이메일: cute@everytable.kr
        </p>
        <p style="margin-bottom: 0;">
            호스팅 서비스: Amazon Web Services (AWS) | <strong>Everytable.com</strong>
        </p>
    </div>
</footer>

	<!-- Message Modal -->
	<div class="modal" id="msgModal">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">처리 결과</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">${msg}</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-danger"
						data-bs-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
<%
// 사용한 메시지는 세션에서 제거
session.removeAttribute("msg");
%>