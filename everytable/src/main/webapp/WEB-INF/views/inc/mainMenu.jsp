<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> EveryTable </title>
<style>
    /* ── 네비게이션 바 배경 ── */
    .custom-green {
        background-color: #87a372 !important; /* 요청하신 기존 연녹색 유지 */
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 밋밋하지 않게 아주 살짝 그림자 */
        padding: 12px 0;
    }

/* ── 로고 전용 스타일 ── */
    .navbar-brand {
        display: flex;
        align-items: center;
        color: #ffffff !important;
        font-weight: 900;
        font-size: 1.5rem;
        letter-spacing: -0.5px;
        margin-right: 30px;
        text-decoration: none;
    }
    
    .brand-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 36px;
        height: 36px;
        background-color: #ffffff;
        color: #87a372; /* 아이콘을 배경과 같은 연녹색으로 반전 */
        border-radius: 50%; /* 동그란 원형 배경 */
        margin-right: 10px;
        font-size: 1.1rem;
        box-shadow: 0 3px 6px rgba(0,0,0,0.15);
        transition: transform 0.3s ease; /* 애니메이션 효과 */
    }

    /* 마우스 올렸을 때 로고 아이콘 살짝 회전&확대 */
    .navbar-brand:hover .brand-icon {
        transform: rotate(-15deg) scale(1.1); 
    }

    /* ── 메뉴 링크 기본 스타일 ── */
    .custom-green .nav-link {
        color: rgba(255, 255, 255, 0.8) !important; /* 너무 쨍하지 않은 부드러운 흰색 */
        font-weight: 500;
        font-size: 0.95rem;
        padding: 8px 14px !important;
        margin: 0 2px;
        position: relative; /* 밑줄 효과를 위한 설정 */
    }

    /* ── 메뉴 마우스 호버(올렸을 때) ── */
    .custom-green .nav-link:hover {
        color: #ffffff !important; /* 마우스 올리면 완전한 흰색으로 밝아짐 */
    }
    
    .custom-green .nav-link:hover::after { width: 70%; }

    /* ── 로그인 정보(이름, 등급) 버튼 스타일 ── */
    .user-info-link {
        border: 1px solid rgba(255, 255, 255, 0.5); /* 얇은 테두리 */
        border-radius: 20px;
        padding: 6px 16px !important;
        margin-right: 15px;
    }
    .user-info-link:hover {
        background-color: rgba(255, 255, 255, 0.1); /* 올렸을 때 살짝 밝아짐 */
    }
    .user-info-link strong { font-weight: 700; color: #ffffff; }

    /* 모바일 햄버거 버튼 색상 (배경이 어두우니 흰색으로) */
    .navbar-toggler { border-color: rgba(255, 255, 255, 0.5); }
    .navbar-toggler-icon { filter: invert(1); } 

    /* 본문 띄우기 */
    body { padding-top: 80px; }
</style>
</head>
<body>

<!-- 상단 네비게이션 바 -->
<nav class="navbar navbar-expand-sm custom-green fixed-top">
  <div class="container-fluid px-4">
	<a class="navbar-brand" href="/main/main.do">
        <span class="brand-icon"><i class="fa fa-cutlery"></i></span>
        EveryTable
    </a>
    
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mynavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    
    <div class="collapse navbar-collapse" id="mynavbar">
      
      <!-- 좌측 메인 메뉴 -->
      <ul class="navbar-nav me-auto align-items-center">
        <li class="nav-item">
          <a class="nav-link" href="/notice/list.do">공지사항</a>
        </li>

        <c:if test="${empty login}">
          <li class="nav-item">
            <a class="nav-link" href="/store/list.do">매장</a>
          </li>
        </c:if>

        <c:if test="${!empty login}">
          
          <c:if test="${login.gradeNo == 1}">
            <li class="nav-item"><a class="nav-link" href="/store/list.do">매장둘러보기</a></li>
            <li class="nav-item"><a class="nav-link" href="/reservation/list.do">주문내역</a></li>
            <li class="nav-item"><a class="nav-link" href="/payment/list.do">결제내역</a></li>
            <li class="nav-item"><a class="nav-link" href="/review/list.do">리뷰내역</a></li>
          </c:if>

          <c:if test="${login.gradeNo == 2}">
            <li class="nav-item"><a class="nav-link" href="/store/update.do">매장관리</a></li>
            <li class="nav-item"><a class="nav-link" href="/reservation/adminList.do">주문관리</a></li>
            <li class="nav-item"><a class="nav-link" href="/menu/write.do">메뉴관리</a></li>
          </c:if>

          <c:if test="${login.gradeNo == 9}">
            <li class="nav-item"><a class="nav-link" href="/member/list.do">회원관리</a></li>
            <li class="nav-item"><a class="nav-link" href="/stats/dashboard.do">대시보드</a></li>
            <li class="nav-item"><a class="nav-link" href="/shop/list.do">매장관리</a></li>
          </c:if>

        </c:if>
      </ul>

      <!-- 우측 로그인/유저 메뉴 -->
      <ul class="navbar-nav d-flex justify-content-end align-items-center">
        <c:choose>
          <c:when test="${empty login}">
            <li class="nav-item"><a class="nav-link fw-bold" href="/member/loginForm.do">로그인</a></li>
            <li class="nav-item"><a class="nav-link" href="/member/writeTypeSelect.do">회원가입</a></li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <a class="nav-link user-info-link" href="/member/view.do" style="text-decoration:none;">
                  <strong>${login.name}</strong> (${login.gradeName})님
              </a>
            </li>
            <li class="nav-item"><a class="nav-link" href="/member/logout.do">로그아웃</a></li>
          </c:otherwise>
        </c:choose>
      </ul>

    </div>
  </div>
</nav>

</body>
</html>