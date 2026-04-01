<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 예약 내역</title>
<style type="text/css">
.res-card {
	border: 1px solid #e9ecef;
	border-radius: 12px;
	padding: 20px;
	margin-bottom: 25px;
	transition: transform 0.2s, box-shadow 0.2s;
	background-color: #fff;
}

.res-card:hover {
	transform: translateY(-3px);
	box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
	cursor: pointer;
}

.status-badge {
	font-size: 0.85rem;
	padding: 5px 12px;
	border-radius: 50px;
	font-weight: bold;
}

.info-box {
	background-color: #f8f9fa;
	border-radius: 8px;
	padding: 15px;
	margin: 15px 0;
}

.info-label {
	color: #6c757d;
	font-size: 0.9rem;
	margin-bottom: 5px;
}

.info-value {
	font-weight: bold;
	font-size: 1.1rem;
}

.step-text {
	font-size: 0.9rem;
	font-weight: bold;
	color: #198754;
}

.step-dim {
	color: #dee2e6;
}
</style>

<script type="text/javascript">
	$(function() {
		$(".res-card").click(function() {
			let no = $(this).data("no");
			location = "view.do?no=" + no + "&${pageObject.pageQuery}";
		});

		$("#key .btn")
				.click(
						function(e) {
							e.preventDefault();
							location = "list.do?page=1&perPageNum=${pageObject.perPageNum}&key="
									+ $(this).val();
						});

		let currentKey = "${pageObject.key}" || "0";
		$("#key .btn[value='" + currentKey + "']").removeClass(
				"btn-outline-success").addClass("btn-success active");
	});
</script>
</head>
<body>

	<div class="container">
		<h2 class="my-4 fw-bold">내 예약 내역</h2>

		<div class="btn-group mb-4" id="key">
			<button type="button" class="btn btn-outline-success" value="0">전체</button>
			<button type="button" class="btn btn-outline-success" value="1">대기</button>
			<button type="button" class="btn btn-outline-success" value="2">승인</button>
			<button type="button" class="btn btn-outline-success" value="3">완료</button>
			<button type="button" class="btn btn-outline-success" value="4">취소·환불</button>
		</div>

		<c:if test="${empty list}">
			<div class="text-center py-5 border rounded bg-light">
				<p class="text-muted mb-0">예약 데이터가 존재하지 않습니다.</p>
			</div>
		</c:if>

		<c:forEach items="${list}" var="vo">
			<div class="res-card" data-no="${vo.resNo}">

				<%-- 상태 배지 --%>
				<div class="d-flex justify-content-between align-items-center mb-3">
					<div>
						<h4 class="fw-bold mb-1">${vo.storeName}</h4>
						<span class="text-muted small">예약번호 ${vo.resNo}</span>
					</div>
					<c:choose>
						<c:when test="${vo.resStatus == 1}">
							<span class="status-badge bg-warning text-dark">매장 확인 중</span>
						</c:when>
						<c:when test="${vo.resStatus == 2}">
							<span class="status-badge bg-primary text-white">예약 확정</span>
						</c:when>
						<c:when test="${vo.resStatus == 3}">
							<span class="status-badge bg-success text-white">완료</span>
						</c:when>
						<c:when test="${vo.resStatus == 4}">
							<span class="status-badge bg-danger text-white">취소·환불</span>
						</c:when>
						<c:otherwise>
							<span class="status-badge bg-secondary text-white">알 수 없음</span>
						</c:otherwise>
					</c:choose>
				</div>

				<%-- 방문 정보 --%>
				<div class="row info-box g-0 text-center">
					<div class="col-6 border-end">
						<div class="info-label">방문 예정일</div>
						<div class="info-value text-success">${vo.resDate}
							${vo.resTime}</div>
					</div>
					<div class="col-6">
						<div class="info-label">예약 인원</div>
						<div class="info-value">${vo.resCount}명(${vo.resType})</div>
					</div>
				</div>

				<%-- 진행 단계: resStatus 숫자 기준 --%>
				<%-- 1=대기(결제완료→승인대기), 2=승인완료, 3=이용완료, 4=취소·환불 --%>
				<<%-- 진행 단계 --%> <c:choose> <c:when test="${vo.resStatus == 4}">
				<div class="d-flex justify-content-center px-2 mb-3"> <span
				class="step-text text-danger">취소 · 환불 처리됨</span> </div> </c:when>
				<c:otherwise> <div class="d-flex justify-content-between
				align-items-center px-2 mb-3"> <%-- 1단계: 대기 (항상 활성) --%> <span
				class="step-text">대기</span> <%-- 화살표: 2 이상이면 활성 --%> <span
				class="${vo.resStatus >= 2 ? 'step-text' : 'step-dim'}">▶</span>

				<%-- 2단계: 승인 --%> <span class="${vo.resStatus >= 2 ? 'step-text' :
				'step-dim'}">승인</span> <%-- 화살표: 3 이상이면 활성 --%> <span
				class="${vo.resStatus >= 3 ? 'step-text' : 'step-dim'}">▶</span>

				<%-- 3단계: 완료 --%> <span class="${vo.resStatus >= 3 ? 'step-text' :
				'step-dim'}">완료</span> </div> </c:otherwise> </c:choose> <%-- 버튼 영역
				--%> <div class="d-flex justify-content-end gap-2"> <c:if
				test="${vo.resStatus == 1 || vo.resStatus == 2}"> <button class="btn
				btn-outline-danger btn-sm px-4">주문 취소</button> </c:if> <button
				class="btn btn-dark btn-sm px-4">상세보기</button> </div>

			</div>
		</c:forEach>

		<div class="d-flex justify-content-center mt-5">
			<pageNav:pageNav listURI="list.do" pageObject="${pageObject}" />
		</div>

		<div class="mt-4 mb-5">
			<a href="writeForm.do" class="btn btn-primary">새 예약하기</a> <a
				href="list.do" class="btn btn-outline-secondary">목록 새로고침</a>
		</div>
	</div>

</body>
</html>