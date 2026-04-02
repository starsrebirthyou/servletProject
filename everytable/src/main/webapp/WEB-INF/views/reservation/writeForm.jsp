<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 예약하기</title>
<style type="text/css">
    .form-label { font-weight: bold; color: #555; }
    .read-only-input { background-color: #f8f9fa !important; border: 1px solid #dee2e6; }
</style>
<script type="text/javascript">
  $(function(){
      $(".cancelBtn").click(function(){
         history.back();
      });
      
      let today = new Date().toISOString().split('T')[0];
      $("#resDate").attr('min', today);
  });
</script>
</head>
<body>
<div class="container">
    <h2 class="my-4 fw-bold">📅 예약 정보 입력</h2>
    
    <form action="/order/write.do" method="post">
        <input type="hidden" name="storeId" value="${memberVO.storeId}">
        <input type="hidden" name="userId" value="${login.id}">
        
        <div class="card p-4 shadow-sm">
            <div class="mb-3">
                <label class="form-label">예약 매장</label>
                <input type="text" class="form-control read-only-input" 
                       value="${memberVO.storeName}" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label">예약자 성함</label>
                <input type="text" class="form-control read-only-input" 
                       value="${login.name}" readonly>
            </div>

            <div class="mb-3">
                <label for="resPhone" class="form-label">연락처</label>
                <input type="tel" class="form-control" id="resPhone" name="resPhone" 
                       placeholder="- 없이 숫자 11자리" value="" required >
                <div class="form-text text-muted">* 연락이 가능한 번호인지 확인해 주세요.</div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="resDate" class="form-label">예약 날짜</label>
                    <input type="date" class="form-control" id="resDate" name="resDate" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="resTime" class="form-label">예약 시간</label>
                    <input type="time" class="form-control" id="resTime" name="resTime" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="resCount" class="form-label">예약 인원</label>
                    <input type="number" class="form-control" id="resCount" name="resCount" 
                           min="1" max="100" placeholder="인원 입력" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="resType" class="form-label">방문 유형</label>
                    <select class="form-select" id="resType" name="resType">
                        <option value="단체">단체 방문</option>
                        <option value="픽업">포장/픽업</option>
                    </select>
                </div>
            </div>
            
            <input type="hidden" name="totalPrice" value="0">

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary px-5 py-2">메뉴 주문하기</button>
                <button type="reset" class="btn btn-warning px-4 py-2">새로입력</button>
                <button type="button" class="cancelBtn btn btn-outline-secondary px-4 py-2">취소</button>
            </div>
        </div>
    </form>
</div>
</body>
</html>