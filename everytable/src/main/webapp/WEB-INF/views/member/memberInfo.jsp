<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세 정보</title>

<style>
.info-card {
    background: #fff; border-radius: 14px;
    border: 1px solid #e8ebe6; overflow: hidden;
    max-width: 640px; margin: 0 auto;
}
.info-row {
    display: flex; align-items: center;
    padding: 14px 24px; border-bottom: 1px solid #f3f5f2;
}
.info-row:last-child { border-bottom: none; }
.info-label {
    width: 130px; font-weight: 600;
    font-size: 0.88rem; color: #666; flex-shrink: 0;
}
.info-value { flex: 1; font-size: 0.95rem; color: #333; }
.btn-edit {
    background: none; border: 1px solid #0f7a54; color: #0f7a54;
    border-radius: 6px; padding: 3px 12px; font-size: 0.8rem;
    cursor: pointer; white-space: nowrap; margin-left: 8px;
}
.btn-edit:hover { background: #0f7a54; color: #fff; }

/* 인라인 수정 폼 */
.edit-form {
    display: none; background: #f8faf7;
    border-top: 1px solid #e8ebe6; padding: 16px 24px;
}
.edit-form.active { display: block; }
.edit-form .form-control { font-size: 0.88rem; }
.edit-form .btn-sm { font-size: 0.82rem; }
</style>

</head>
<body>

<div class="d-flex align-items-center mb-4 mt-3">
    <div class="me-3" style="width:54px;height:54px;background:#e8f5ee;border-radius:14px;
                              display:flex;align-items:center;justify-content:center;
                              font-size:1.5rem;color:#0f7a54;">
        <i class="fa fa-user"></i>
    </div>
    <div>
        <h2 class="fw-bold mb-0 text-dark" style="font-size:1.5rem;">회원 상세 정보</h2>
        <p class="text-muted mb-0" style="font-size:0.88rem;">회원의 상세 정보를 확인하고 관리할 수 있습니다.</p>
    </div>
</div>

<c:if test="${not empty sessionScope.msg}">
    <div class="alert alert-success">${sessionScope.msg}</div>
    <c:remove var="msg" scope="session"/>
</c:if>

<div class="info-card">

    <!-- 회원번호 -->
    <div class="info-row">
        <span class="info-label">회원번호</span>
        <span class="info-value">${vo.no}</span>
    </div>
    
    <!-- 이름 -->
    <div class="info-row">
        <span class="info-label">이름</span>
        <span class="info-value">${vo.name}</span>
    </div>

    <!-- 아이디 -->
    <div class="info-row">
        <span class="info-label">아이디</span>
        <span class="info-value">${vo.id}</span>
    </div>

    <!-- 비밀번호 -->
    <div class="info-row">
        <span class="info-label">비밀번호</span>
        <span class="info-value">******</span>
        <button class="btn-edit" data-target="pwForm">초기화</button>
    </div>

    <!-- 전화번호 -->
    <div class="info-row">
        <span class="info-label">연락처</span>
        <span class="info-value">${empty vo.tel ? '미등록' : vo.tel}</span>
    </div>

    <!-- 이메일 -->
    <div class="info-row">
        <span class="info-label">이메일</span>
        <span class="info-value">${vo.email}</span>
    </div>

    <!-- 성별 -->
    <div class="info-row">
        <span class="info-label">성별</span>
        <span class="info-value">${vo.gender}</span>
    </div>

    <!-- 생년월일 -->
    <div class="info-row">
        <span class="info-label">생년월일</span>
        <span class="info-value">${vo.birth}</span>
    </div>

    <!-- 등급 -->
    <div class="info-row">
        <span class="info-label">등급</span>
        <span class="info-value">${vo.gradeName}</span>
    </div>

    <!-- 가입일 -->
    <div class="info-row">
        <span class="info-label">가입일</span>
        <span class="info-value">${vo.joinDate}</span>
    </div>

    <!-- 최근 로그인 -->
    <div class="info-row">
        <span class="info-label">최근 접속일</span>
        <span class="info-value">${vo.lastLogin}</span>
    </div>
    
    <c:if test="${!empty vo.withdraw}">
	    <!-- 탈퇴일 -->
	    <div class="info-row">
	        <span class="info-label">탈퇴일</span>
	        <span class="info-value">${vo.withdraw}</span>
	    </div>
	</c:if>

</div>

</body>
</html>
