<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 오류</title>
</head>
<body>
<h2>JSP 오류</h2>
<div class="card">
  <div class="card-header bg-dark text-white">요청 URL : ${url }</div>
  <div class="card-body">
       JSP 에러 메시지 : <%= exception.getMessage() %><br>
       다시 시도해 보세요.
  </div>
  <div class="card-footer">에브리테이블 사이트 담당자 : 이오</div>
</div>
</body>
</html>