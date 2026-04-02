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
	width: 25%;
	background-color: #f8f9fa;
	vertical-align: middle;
}

.status-text {
	font-weight: bold;
	padding: 3px 10px;
	border-radius: 4px;
}
</style>
<script type="text/javascript">
	$(function() {
		// 취소 버튼 클릭 시 사유 입력창 토글
		$("#cancelBtn").click(function() {
			$("#cancelReason").val("");
			$("#cancelDiv").toggle();
			// 화면을 아래로 부드럽게 스크롤
			if ($("#cancelDiv").is(":visible")) {
				$('html, body').animate({
					scrollTop : $(document).height()
				}, 500);
			}
		});
	});
</script>
</head>
<body>
	<div class="container">
		<h2 class="my-4 fw-bold">예약 상세 내역</h2>

		<table class="table table-bordered">
			<tbody>
				<tr>
					<th>예약 번호</th>
					<td class="resNo">${vo.resNo}</td>
				</tr>
				<tr>
					<th>매장명</th>
					<td class="fw-bold">${vo.storeName}</td>
				</tr>
				<tr>
					<th>예약 상태</th>
					<td><c:choose>
							<%-- DB NUMBER 타입(Long)에 맞춰 숫자로 비교 --%>
							<c:when test="${vo.resStatus == 1}">
								<span class="text-warning fw-bold">매장 확인 중</span>
							</c:when>
							<c:when test="${vo.resStatus == 2}">
								<span class="text-primary fw-bold">예약 확정</span>
							</c:when>
							<c:when test="${vo.resStatus == 3}">
								<span class="text-success fw-bold">이용 완료</span>
							</c:when>
							<c:when test="${vo.resStatus == 4}">
								<span class="text-danger fw-bold">취소됨</span>
							</c:when>
							<c:otherwise>
								<span>상태코드: ${vo.resStatus}</span>
							</c:otherwise>
						</c:choose></td>
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
					<th>방문 예정 일시</th>
					<td class="text-success fw-bold">${vo.resDate}/ ${vo.resTime}</td>
				</tr>
				<tr>
					<th>예약 인원</th>
					<td>${vo.resCount}명</td>
				</tr>
				<tr>
					<th>예약 타입</th>
					<td>${vo.resType}</td>
				</tr>
				<tr>
					<th>총 결제 금액</th>
					<td class="text-danger"><strong>${vo.totalPrice}원</strong></td>
				</tr>
				<%-- 취소(4)된 예약인 경우 취소 사유 표시 --%>
				<c:if test="${vo.resStatus == 4 && not empty vo.cancelReason}">
					<tr>
						<th>취소 사유</th>
						<td class="text-muted">${vo.cancelReason}</td>
					</tr>
				</c:if>
			</tbody>
		</table>

		<div class="mb-4 text-center">
			<%-- 상태가 대기(1) 또는 승인(2)일 때만 수정/취소 가능 --%>
			<c:if test="${vo.resStatus == 1 || vo.resStatus == 2}">
				<a
					href="updateForm.do?no=${vo.resNo}&page=${param.page}&perPageNum=${param.perPageNum}"
					class="btn btn-primary px-4">예약 수정</a>
				<button id="cancelBtn" class="btn btn-danger px-4">예약 취소</button>
			</c:if>

			<a href="list.do?page=${param.page}&perPageNum=${param.perPageNum}"
				class="btn btn-outline-secondary px-4">목록으로</a>
		</div>

		<%-- 예약 취소 입력 폼 --%>
		<div id="cancelDiv" class="card card-body bg-light mb-5">
			<form action="cancel.do" method="post">

				<input type="hidden" name="resNo" value="${vo.resNo}">

				<input type="hidden" name="page" value="${param.page}"> <input
					type="hidden" name="perPageNum" value="${param.perPageNum}">

				<div class="mb-3">
					<label for="cancelReason" class="form-label text-danger"><strong>취소
							사유를 입력해주세요.</strong></label>
					<textarea class="form-control" id="cancelReason"
						name="cancelReason" rows="3" required></textarea>
				</div>

				<div class="text-end">
					<button type="submit" class="btn btn-danger px-4">취소 확정</button>
					<button type="button" onclick="$('#cancelDiv').hide();"
						class="btn btn-light border px-4">닫기</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>