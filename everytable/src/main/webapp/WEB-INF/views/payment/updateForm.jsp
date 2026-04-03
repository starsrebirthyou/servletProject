<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 정보 수정</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
 
<script type="text/javascript">
$(function(){
    $(".cancelBtn").click(function(){
        history.back(); 
    });
});
</script>
</head>
<body>
<div class="container mt-5">
    <div class="card">
        <div class="card-header bg-primary text-white">
            <h2 class="mb-0">결제 정보 수정</h2>
        </div>
        <div class="card-body">
            <form action="update.do" method="post">
			   <input type="hidden" name="no" value="${vo.payment_id}">
			   <input type="hidden" name="page" value="${(empty param.page) ? 1 : param.page}">
			   <input type="hidden" name="perPageNum" value="${(empty param.perPageNum) ? 10 : param.perPageNum}">
			   <input type="hidden" name="key" value="${param.key}">
			   <input type="hidden" name="word" value="${param.word}">

    <div class="mb-3 mt-3">
	    <label for="order_id" class="form-label fw-bold">주문번호</label>
	    <input type="text" class="form-control bg-light" id="order_id" 
           name="order_id" value="${vo.order_id}" readonly="readonly">
		</div> <div class="mb-3">
	  	  <label for="user_id" class="form-label fw-bold">구매자 아이디</label>
	      <input type="text" class="form-control bg-light" id="user_id"
			           name="user_id" value="${vo.user_id}" readonly="readonly">
			</div>
			                
                <div class="mb-3">
                    <label for="amount" class="form-label fw-bold">결제 금액</label>
                    <input type="text" class="form-control bg-light" id="amount"
                           name="amount" value="${vo.amount}" readonly="readonly">
                </div>
                
                <div class="mb-3">
                    <label for="status" class="form-label fw-bold">결제 상태 변경</label>
                    <select class="form-select border-primary" name="status" id="status">
                        <option value="SUCCESS" ${vo.status == "SUCCESS" ? "selected" : ""}>결제 완료(SUCCESS)</option>
                        <option value="FAIL" ${vo.status == "FAIL" ? "selected" : ""}>결제 실패(FAIL)</option>
                        <option value="REFUNDED" ${vo.status == "REFUNDED" ? "selected" : ""}>환불 처리(REFUNDED)</option>
                    </select>
                </div>

                <div class="mt-4 text-center">
                    <button type="submit" class="btn btn-primary px-5">수정 완료</button>
                    <button type="reset" class="btn btn-warning">새로입력</button>
                    <button type="button" class="cancelBtn btn btn-secondary">취소</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>