<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 예약하기</title>
<script type="text/javascript">
  $(function(){
      // 취소 버튼 클릭 시 이전 페이지(매장 상세 페이지)로 이동
      $(".cancelBtn").click(function(){
         history.back();
      });
  });
</script>
</head>
<body>
<div class="container">
    <h2 class="my-4">📅 예약 정보 입력</h2>
    
    <form action="order.jsp" method="post">
        <input type="hidden" name="storeId" value="${storeVO.storeId}">
        <input type="hidden" name="userId" value="${login.id}">
        <input type="hidden" name="perPageNum" value="${param.perPageNum}">
        
        <div class="mb-3 mt-3">
            <label class="form-label">예약 매장</label>
            <input type="text" class="form-control" name="storeName" 
                   value="${storeVO.storeName}" readonly style="background-color: #eee;">
        </div>

        <div class="mb-3 mt-3">
            <label class="form-label">예약자 성함</label>
            <input type="text" class="form-control" value="${login.name}" readonly style="background-color: #eee;">
        </div>

        <div class="mb-3 mt-3">
            <label for="resPhone" class="form-label">연락처 (당일 연락 가능한 번호)</label>
            <input type="tel" class="form-control" id="resPhone" name="resPhone" 
                   placeholder="010-0000-0000" value="${login.tel}" 
                   pattern="0\d{1,2}-\d{3,4}-\d{4}" required >
            <div class="form-text text-muted">* 기본 연락처와 다를 경우 수정해 주세요.</div>
        </div>

        <div class="mb-3 mt-3">
            <label for="resDate" class="form-label">예약 날짜</label>
            <input type="date" class="form-control" id="resDate" name="resDate" required>
        </div>

        <div class="mb-3 mt-3">
            <label for="resTime" class="form-label">예약 시간</label>
            <input type="time" class="form-control" id="resTime" name="resTime" required>
        </div>

        <div class="mb-3 mt-3">
            <label for="resCount" class="form-label">예약 인원</label>
            <input type="number" class="form-control" id="resCount" name="resCount" 
                   min="1" max="100" placeholder="인원수를 입력하세요." required>
        </div>

        <div class="mb-3 mt-3">
            <label for="resType" class="form-label">예약 유형</label>
            <select class="form-select" id="resType" name="resType">
                <option value="단체">단체 방문</option>
                <option value="픽업">픽업</option>
            </select>
        </div>

            <a href="/order/writeForm.do" class="btn btn-primary">메뉴 선택</a>
            <button type="reset" class="btn btn-warning">새로입력</button>
            <button type="button" class="cancelBtn btn btn-outline-secondary">취소</button>
    </form>
</div>
</body>
</html>