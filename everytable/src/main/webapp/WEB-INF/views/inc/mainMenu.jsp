<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>EveryTable</title>
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

        <c:if test="${empty login}">
          <li class="nav-item">
            <a class="nav-link" href="/shop/list.do">매장</a>
          </li>
        </c:if>

        <c:if test="${!empty login}">
          
          <c:if test="${login.gradeNo == 1}">
            <li class="nav-item"><a class="nav-link" href="/shop/list.do">매장둘러보기</a></li>
            <li class="nav-item"><a class="nav-link" href="/reservation/list.do">내주문보기</a></li>
            <li class="nav-item"><a class="nav-link" href="/review/myList.do">내 리뷰보기</a></li>
          </c:if>

          <c:if test="${login.gradeNo == 2}">
            <li class="nav-item"><a class="nav-link" href="/shop/manage.do">매장관리</a></li>
            <li class="nav-item"><a class="nav-link" href="/reservation/adminList.do">주문관리</a></li>
            <li class="nav-item"><a class="nav-link" href="/menu/manage.do">메뉴관리</a></li>
          </c:if>

          <c:if test="${login.gradeNo == 9}">
            <li class="nav-item"><a class="nav-link" href="/member/list.do">회원관리</a></li>
            <li class="nav-item"><a class="nav-link" href="/admin/dashboard.do">대시보드</a></li>
            <li class="nav-item"><a class="nav-link" href="/shop/list.do">매장관리</a></li>
          </c:if>

        </c:if>
      </ul>

      <ul class="navbar-nav d-flex justify-content-end">
        <c:choose>
          <c:when test="${empty login}">
            <li class="nav-item"><a class="nav-link" href="/member/loginForm.do">로그인</a></li>
            <li class="nav-item"><a class="nav-link" href="/member/writeTypeSelect.do">회원가입</a></li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link" href="/member/view.do"><strong>${login.name}</strong>(${login.gradeName})님</a>
            </li>
            <li class="nav-item"><a class="nav-link" href="/member/logout.do">로그아웃</a></li>
          </c:otherwise>
        </c:choose>
      </ul>

    </div>
  </div>
</nav>
<!--  
<nav class="navbar navbar-expand-sm bg-dark navbar-dark fixed-bottom">
  <div class="container-fluid">
    <span class="navbar-text text-white">
      © CopyRight everytable.com
    </span>
  </div>
  -->
</nav>
</body>
</html>