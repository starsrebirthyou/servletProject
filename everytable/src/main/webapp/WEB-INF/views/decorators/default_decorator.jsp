<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator"
	prefix="decorator"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>everytable<decorator:title /></title>
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

<script type="text/javascript">
$(function(){
	// 모달 창을 띄운다.
	${(!empty msg)?"$('#msgModal').modal('show');":""}
});
	// ${(!empty msg)?"alert('" += msg += "');":""}
</script>
<!-- JSP의 Head 태그의 title 제외한 부분에 소스가 추가된다. -->
<decorator:head />
</head>
<body>
	<!-- body 이전의 메뉴바를 추가해서 나타나게 한다. -->
	<!-- 메인 메뉴 부분 ------------------------------------ -->
	<!--  include 디렉티브 태그 : 소스를 복붙해서 클래스를 한개로 만들어서 컴파일 한다. -->
	<%@ include file="../inc/mainMenu.jsp"%>
	<!-- 메인 메뉴 부분 끝 ------------------------------------ -->
	<div class="container-fluid"
		style="margin-top: 80px; margin-bottom: 80px;">
		<div class="container mt-3 mb-3">
			<!-- JSP에서 작성되 body 태그 -->
			<decorator:body />
		</div>
	</div>
	<!-- body 이후의 CopyRight나 회사 주소를 추가해서 나타나게 한다. -->
	<nav class="navbar navbar-expand-sm bg-dark navbar-dark fixed-bottom">
		<div class="container-fluid">
			<a class="navbar-brand" href="#">CopyRight Webjjang.com</a>
		</div>
	</nav>


	<!-- The Modal -->
	<div class="modal" id="msgModal">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">

				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">처리 결과</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<!-- Modal body -->
				<div class="modal-body">${msg }</div>

				<!-- Modal footer -->
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
//글 등록한 결과 메시지 지우기
session.removeAttribute("msg");
%>