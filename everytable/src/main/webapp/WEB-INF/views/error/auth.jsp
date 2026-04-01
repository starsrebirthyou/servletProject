<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 서버에서 JSP를 못찾아서 sitemesh 의 적용을 받지 않는다. 라이브러리를 등록해야만 한다. -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>권한 오류</title>
<!-- web 라이브러리를 등록 -->
<!-- Bootstrap 라이브러리 등록 --------- -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery 라이브러리 등록 - 자바스크립트 함수 : jQuery() ==> $() -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

</head>
<body>
<%@ include file="../inc/mainMenu.jsp" %>
<div class="container-fluid" style="margin-top:80px; margin-bottom: 80px;">
	<div class="container mt-3 mb-3">
		<h2>권한 오류</h2>
	  <div class="card-header bg-dark text-white">요청 URL : ${url }</div>
	  <div class="card-body">
	  	페이지에 접근할 권한이 없습니다.
	  </div>
	  <div class="card-footer">에브리테이블 사이트 담당자 : 이오</div>
	</div>
</div>
</body>
</html>