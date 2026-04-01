<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage="error_jsp.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>요청하신 페이지 없음</title>
</head>
<body>
<h2>존재하지 않는 페이지 요청</h2>
<div class="card">
  <div class="card-header bg-dark text-white">요청 URL : ${url }</div>
  <div class="card-body">
  	요청하신 페이지가 존재하지 않습니다.<br>
  	다시 시도해 보세요. 정상적인 접근을 해주시기 바랍니다.
  </div>
  <div class="card-footer">에브리테이블 사이트 담당자 : 이오</div>
</div>
</body>
</html>