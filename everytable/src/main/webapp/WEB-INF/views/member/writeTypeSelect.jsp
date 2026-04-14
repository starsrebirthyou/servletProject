<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<style>
body { background-color: #f4f6f3; }

.wrap {
    max-width: 520px; margin: 60px auto 0; padding: 0 16px;
}
.page-header {
    text-align: center; margin-bottom: 32px;
}
.page-header .logo-box {
    width: 60px; height: 60px; background: #e8f5ee;
    border-radius: 16px; display: inline-flex;
    align-items: center; justify-content: center;
    font-size: 1.6rem; color: #0f7a54; margin-bottom: 14px;
}
.page-header h2 {
    font-size: 1.5rem; font-weight: 700; color: #1a1a1a; margin: 0 0 6px;
}
.page-header p { font-size: 0.88rem; color: #888; margin: 0; }

.type-cards {
    display: flex; gap: 16px; margin-bottom: 20px;
}
.type-card {
    flex: 1; background: #fff; border-radius: 16px;
    border: 2px solid #e8ebe6; padding: 28px 20px;
    text-align: center; cursor: pointer;
    transition: all 0.2s;
}
.type-card:hover {
    border-color: #0f7a54;
    box-shadow: 0 4px 16px rgba(15,122,84,0.12);
    transform: translateY(-2px);
}
.type-card .icon-box {
    width: 56px; height: 56px; border-radius: 14px;
    display: inline-flex; align-items: center;
    justify-content: center; font-size: 1.6rem;
    margin-bottom: 14px;
}
.type-card.member .icon-box { background: #e8f5ee; color: #0f7a54; }
.type-card.owner  .icon-box { background: #fff3e0; color: #e65100; }

.type-card h5 {
    font-size: 1rem; font-weight: 700; color: #1a1a1a; margin: 0 0 6px;
}
.type-card p {
    font-size: 0.82rem; color: #888; margin: 0 0 16px;
}
.type-card .btn-select {
    width: 100%; height: 38px; border: none;
    border-radius: 8px; font-size: 0.85rem;
    font-weight: 600; cursor: pointer; transition: background 0.15s;
}
.type-card.member .btn-select { background: #0f7a54; color: #fff; }
.type-card.member .btn-select:hover { background: #0a5e3f; }
.type-card.owner  .btn-select { background: #e65100; color: #fff; }
.type-card.owner  .btn-select:hover { background: #bf360c; }

.btn-back {
    width: 100%; height: 42px; background: #f1f3f0;
    border: none; border-radius: 10px; color: #666;
    font-size: 0.88rem; cursor: pointer;
}
.btn-back:hover { background: #e2e6e0; }
</style>
</head>
<body>

<div class="wrap">
    <div class="page-header">
        <div class="logo-box"><i class="fa fa-user-plus"></i></div>
        <h2>회원가입</h2>
        <p>가입 유형을 선택해 주세요.</p>
    </div>

    <div class="type-cards">
        <div class="type-card member" onclick="location.href='writeForm.do?gradeNo=1'">
            <div class="icon-box"><i class="fas fa-user"></i></div>
            <h5>일반회원</h5>
            <p>서비스 이용</p>
            <button class="btn-select">일반회원 가입</button>
        </div>
        <div class="type-card owner" onclick="location.href='writeForm.do?gradeNo=2'">
            <div class="icon-box"><i class="fas fa-store"></i></div>
            <h5>매장점주</h5>
            <p>매장 운영</p>
            <button class="btn-select">매장점주 가입</button>
        </div>
    </div>

    <button class="btn-back" onclick="history.back()">취소</button>
</div>

</body>
</html>
