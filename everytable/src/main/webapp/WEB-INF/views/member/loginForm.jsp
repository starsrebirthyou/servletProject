<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<!-- Bootstrap 라이브러리 등록 -->
</head>
<body>

<h2>로그인</h2>

<%-- 비로그인 상태로 주문/리뷰 접근 시 안내 메시지 --%>
<c:if test="${not empty redirectUrl}">
  <div class="alert alert-warning">
    로그인 후 이용하실 수 있습니다.
  </div>
</c:if>

<%-- 로그인 실패 등 서버 메시지 --%>
<c:if test="${not empty msg}">
  <div class="alert alert-danger">${msg}</div>
</c:if>

<form action="login.do" method="post">

  <%-- 로그인 성공 후 돌아갈 URL 유지 --%>
  <input type="hidden" name="redirectUrl" value="${redirectUrl}">

  <div class="mb-3 mt-3">
    <label for="id" class="form-label">아이디</label>
    <input type="text" class="form-control" id="id" name="id"
           placeholder="아이디를 입력하세요." required autofocus
           autocomplete="off" maxlength="20">
  </div>

  <div class="mb-3">
    <label for="pw" class="form-label">비밀번호</label>
    <input type="password" class="form-control" id="pw" name="pw"
           placeholder="비밀번호를 입력하세요." required
           autocomplete="off" maxlength="20">
  </div>

  <button type="submit" class="btn btn-primary">로그인</button>
  <button type="button" class="btn btn-secondary"
          onclick="location.href='${pageContext.request.contextPath}/member/writeTypeSelect.do'">
    회원가입
  </button>

</form>
</body>
</html>
