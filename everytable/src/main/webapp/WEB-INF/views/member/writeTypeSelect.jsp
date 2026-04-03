<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<!-- Bootstrap 라이브러리 등록 -->
</head>
<body>

<h2>회원가입</h2>
<p class="text-muted">가입 유형을 선택해 주세요.</p>

<div class="d-flex gap-4 mt-4">

  <!-- 일반회원 선택 카드 -->
  <div class="card text-center" style="width: 220px; cursor: pointer;"
       onclick="location.href='writeForm.do?gradeNo=1'">
    <div class="card-body py-4">
      <div style="font-size: 2.5rem;">👤</div>
      <h5 class="card-title mt-3">일반회원</h5>
      <p class="card-text text-muted small">서비스 이용</p>
      <button type="button" class="btn btn-primary w-100 mt-2">일반회원 가입</button>
    </div>
  </div>

  <!-- 매장점주 선택 카드 -->
  <div class="card text-center" style="width: 220px; cursor: pointer;"
       onclick="location.href='writeForm.do?gradeNo=2'">
    <div class="card-body py-4">
      <div style="font-size: 2.5rem;">🏪</div>
      <h5 class="card-title mt-3">매장점주</h5>
      <p class="card-text text-muted small">매장 운영</p>
      <button type="button"  class="btn btn-success w-100 mt-2">매장점주 가입</button>
    </div>
  </div>

</div>

<div class="mt-4">
  <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
</div>

</body>
</html>
