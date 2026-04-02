<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>mainMenu</title>
</head>
<body>
<nav class="navbar navbar-expand-sm navbar-dark bg-dark fixed-top">
  <div class="container-fluid">
    <a class="navbar-brand" href="/">EveryTable</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mynavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="mynavbar">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link" href="/notice/list.do">공지사항</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/shop/list.do">쇼핑몰</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/board/list.do">일반게시판</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/qna/list.do">질문답변</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/image/list.do">이미지</a>
        </li>
        <c:if test="${!empty login && login.gradeNo == 9}">
          <!-- 관리자 메뉴 -->
          <li class="nav-item">
            <a class="nav-link" href="/member/list.do">회원관리</a>
          </li>
        </c:if>
      </ul>
      <ul class="navbar-nav d-flex justify-content-end">
	  <!-- empty는 객체가 null이거나 length나 size가 0인 상태 -->
        <c:if test="${empty login}">
        		<!-- 로그인을 하지 않았을 떄 메뉴 시작 -->
	        <li class="nav-item">
	          <a class="nav-link" href="/member/loginForm.do">로그인</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link" href="/member/writeTypeSelect.do">회원가입</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link" href="/member/idSearchForm.do">아이디 찾기</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link" href="/member/pwSearchForm.do">비밀번호 찾기</a>
	          <!-- 로그인을 하지 않았을 떄 메뉴 끝 -->
	        </li>
        </c:if>
      </ul>
      <ul class="navbar-nav d-flex justify-content-end">
	  <!-- empty는 객체가 null이거나 length나 size가 0인 상태 -->
        <c:if test="${!empty login}">
        		<!-- 로그인을 한 경우 메뉴 시작 -->
        		<li class="nav-item">
	          <a class="nav-link" href="/member/view.do">${login.name}(${login.gradeName})</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link" href="/member/logout.do">로그아웃</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link" href="/member/pwChangeForm.do">비밀번호 변경</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link" href="/member/signoutForm.do">회원탈퇴</a>
	          <!-- 로그인을 한 경우 메뉴 끝 -->
	        </li>
        </c:if>
      </ul>
      <div class="d-flex" style="background: yellow; width: 100px">
      
      </div>
    </div>
  </div>
</nav>
<!-- body 이후의 CopyRight나 회사 주소를 추가해서 나타나게 한다. -->
<nav class="navbar navbar-expand-sm bg-dark navbar-dark fixed-bottom">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">CopyRight EveryTable.com</a>
  </div>
</nav>
</body>
</html>