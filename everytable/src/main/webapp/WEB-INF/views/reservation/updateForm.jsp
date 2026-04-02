<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 정보 수정</title>
<script type="text/javascript">
  $(function(){
      // 취소 버튼 클릭 시 이전 페이지(상세보기)로 이동
      $(".cancelBtn").click(function(){
         history.back();
      });
  });
</script>
<style type="text/css">
    .read-only-input { background-color: #eee; cursor: not-allowed; }
</style>
</head>
<body>
<div class="container">
    <h2 class="my-4">📝 예약 정보 수정</h2>
    
    <form action="update.do" method="post">
        <input type="hidden" name="resNo" value="${vo.resNo}">
        <input type="hidden" name="page" value="${param.page}">
        <input type="hidden" name="perPageNum" value="${param.perPageNum}">
        <input type="hidden" name="key" value="${param.key}">

        <div class="mb-3 mt-3">
            <label class="form-label">예약 매장</label>
            <input type="text" class="form-control read-only-input" 
                   value="${vo.storeName}" readonly>
        </div>

        <div class="mb-3 mt-3">
            <label class="form-label">예약자 아이디</label>
            <input type="text" class="form-control read-only-input" 
                   value="${vo.userId}" readonly>
        </div>

        <div class="mb-3 mt-3">
            <label for="resPhone" class="form-label">연락처</label>
            <input type="tel" class="form-control" id="resPhone" name="resPhone" 
                   value="${vo.resPhone}" required>
        </div>

        <div class="mb-3 mt-3">
            <label for="resDate" class="form-label">예약 날짜</label>
            <input type="date" class="form-control" id="resDate" name="resDate" 
                   value="${vo.resDate}" required>
        </div>

        <div class="mb-3 mt-3">
            <label for="resTime" class="form-label">예약 시간</label>
            <input type="time" class="form-control" id="resTime" name="resTime" 
                   value="${vo.resTime}" required>
        </div>

        <div class="mb-3 mt-3">
            <label for="resCount" class="form-label">예약 인원</label>
            <input type="number" class="form-control" id="resCount" name="resCount" 
                   value="${vo.resCount}" min="1" max="100" required>
        </div>

        <div class="mb-3 mt-3">
            <label for="resType" class="form-label">예약 유형</label>
            <select class="form-select" id="resType" name="resType">
                <option value="단체" ${vo.resType == '단체' ? 'selected' : ''}>단체 방문</option>
                <option value="픽업" ${vo.resType == '픽업' ? 'selected' : ''}>픽업</option>
            </select>
        </div>

        <div class="mt-4 mb-5">
            <button type="submit" class="btn btn-primary px-4">수정완료</button>
            <button type="reset" class="btn btn-warning px-4">새로고침</button>
            <button type="button" class="cancelBtn btn btn-outline-secondary px-4">취소</button>
        </div>
    </form>
</div>
</body>
</html>