<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
body { background-color: #f4f6f3; }

.login-wrap {
    max-width: 420px; margin: 60px auto 0; padding: 0 16px;
}
.login-header {
    text-align: center; margin-bottom: 28px;
}
.login-header .logo-box {
    width: 60px; height: 60px; background: #e8f5ee;
    border-radius: 16px; display: inline-flex;
    align-items: center; justify-content: center;
    font-size: 1.6rem; color: #0f7a54; margin-bottom: 14px;
}
.login-header h2 {
    font-size: 1.5rem; font-weight: 700;
    color: #1a1a1a; margin: 0 0 4px;
}
.login-header p { font-size: 0.88rem; color: #888; margin: 0; }

.login-card {
    background: #fff; border-radius: 16px;
    border: 1px solid #e8ebe6; padding: 32px 28px;
}
.login-card .form-label {
    font-size: 0.85rem; font-weight: 600; color: #555; margin-bottom: 6px;
}
.login-card .form-control {
    border-radius: 10px; border: 1px solid #dde0da;
    background: #f9faf8; height: 44px; font-size: 0.92rem;
}
.login-card .form-control:focus {
    border-color: #0f7a54; box-shadow: 0 0 0 3px rgba(15,122,84,0.1);
    background: #fff;
}
.btn-login {
    width: 100%; height: 46px; background: #0f7a54;
    border: none; border-radius: 10px; color: #fff;
    font-size: 0.95rem; font-weight: 600; cursor: pointer;
    transition: background 0.2s;
}
.btn-login:hover { background: #0a5e3f; }

.divider {
    display: flex; align-items: center; gap: 12px;
    margin: 20px 0; color: #bbb; font-size: 0.8rem;
}
.divider::before, .divider::after {
    content: ''; flex: 1; height: 1px; background: #eee;
}

.btn-group-row {
    display: flex; gap: 8px;
}
.btn-group-row button {
    flex: 1; height: 40px; border-radius: 10px;
    border: 1px solid #dde0da; background: #f9faf8;
    color: #555; font-size: 0.82rem; font-weight: 500;
    cursor: pointer; transition: all 0.15s;
}
.btn-group-row button:hover {
    border-color: #0f7a54; color: #0f7a54; background: #f0f7f4;
}
.btn-group-row .btn-signup {
    background: #e8f5ee; border-color: #0f7a54;
    color: #0f7a54; font-weight: 600;
}
.btn-group-row .btn-signup:hover { background: #d4eddf; }
</style>
</head>
<body>

<div class="login-wrap">
    <div class="login-header">
        <div class="logo-box"><i class="fa fa-cutlery"></i></div>
        <h2>에브리테이블</h2>
        <p>서비스 이용을 위해 로그인해 주세요.</p>
    </div>

    <div class="login-card">

        <c:if test="${not empty redirectUrl}">
            <div class="alert alert-warning py-2 mb-3" style="font-size:0.85rem;">
                <i class="fa fa-lock"></i> 로그인 후 이용하실 수 있습니다.
            </div>
        </c:if>
        <c:if test="${not empty msg}">
            <div class="alert alert-danger py-2 mb-3" style="font-size:0.85rem;">${msg}</div>
        </c:if>

        <form action="login.do" method="post">
            <input type="hidden" name="redirectUrl" value="${redirectUrl}">

            <div class="mb-3">
                <label for="id" class="form-label">아이디</label>
                <input type="text" class="form-control" id="id" name="id"
                       placeholder="아이디를 입력하세요." required autofocus
                       autocomplete="off" maxlength="20">
            </div>
            <div class="mb-4">
                <label for="pw" class="form-label">비밀번호</label>
                <input type="password" class="form-control" id="pw" name="pw"
                       placeholder="비밀번호를 입력하세요." required
                       autocomplete="off" maxlength="20">
            </div>

            <button type="submit" class="btn-login">로그인</button>
        </form>

        <div class="divider">또는</div>

        <div class="btn-group-row">
            <button class="btn-signup"
                    onclick="location.href='${pageContext.request.contextPath}/member/writeTypeSelect.do'">
                회원가입
            </button>
            <button onclick="location.href='${pageContext.request.contextPath}/member/searchIdForm.do'">
                아이디 찾기
            </button>
            <button onclick="location.href='${pageContext.request.contextPath}/member/searchPwForm.do'">
                비밀번호 찾기
            </button>
        </div>

    </div>
</div>

</body>
</html>
