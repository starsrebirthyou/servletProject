<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 상세 정보</title>
<style type="text/css">
#cancelDiv {
	display: none;
}

.table th {
	width: 20%;
	background-color: #f8f9fa;
}
</style>
<script type="text/javascript">
	$(function() {
		$("#cancelBtn").click(function(){
	         $("#cancelReason").val("");
	         $("#cancelDiv").toggle();
	     });
	});
</script>
</head>
<body>
	<div class="container">
		<h2 class="my-4">예약 상세 내역</h2>
		<table class="table table-bordered">
			<tbody>
				<tr>
					<th>예약 번호</th>
					<td class="resNo">${vo.resNo}</td>
				</tr>
				<tr>
					<th>매장명</th>
					<td>${vo.storeName}</td>
				</tr>
				<tr>
					<th>예약자 ID</th>
					<td>${vo.userId}</td>
				</tr>
				<tr>
					<th>연락처</th>
					<td>${vo.resPhone}</td>
				</tr>
				<tr>
					<th>예약 일시</th>
					<td>${vo.resDate}/ ${vo.resTime}</td>
				</tr>
				<tr>
					<th>인원</th>
					<td>${vo.resCount}명(${vo.resType})</td>
				</tr>
				<tr>
					<th>주문 메뉴</th>
					<td>${vo.menuName}(수량: ${vo.quantity})</td>
				</tr>
				<tr>
					<th>추가 요청</th>
					<td>${vo.orderAdd}</td>
				</tr>
				<tr>
					<th>총 결제 금액</th>
					<td class="text-danger"><strong>${vo.totalPrice}원</strong></td>
				</tr>
				<tr>
					<th>타입</th>
					<td>${vo.resType }</td>
				</tr>
			</tbody>
		</table>

		<div class="mb-5">
			<a
				href="updateForm.do?no=${vo.resNo}&page=${param.page}&perPageNum=${param.perPageNum}"
				class="btn btn-primary">예약 수정</a>
			<button id="cancelBtn" class="btn btn-danger">예약 취소</button>
			<a href="list.do?page=${param.page}&perPageNum=${param.perPageNum}"
				class="btn btn-warning">목록으로</a>
		</div>

		<div id="cancelDiv" class="card card-body bg-light">
            <form action="delete.do" method="post">
                <input type="hidden" name="no" value="${vo.resNo}">
                <input type="hidden" name="page" value="${param.page}">
                <input type="hidden" name="perPageNum" value="${param.perPageNum}">
                
                <div class="mb-3">
                    <label for="cancelReason" class="form-label"><strong>취소 사유를 입력해주세요.</strong></label>
                    <textarea class="form-control" id="cancelReason" name="cancelReason" rows="3" required placeholder="예: 일정이 변경되었습니다."></textarea>
                </div>
                
                <div class="text-end">
                    <button type="submit" class="btn btn-danger">취소 확정</button>
                </div>
            </form>
        </div>
	</div>
</body>
</html>