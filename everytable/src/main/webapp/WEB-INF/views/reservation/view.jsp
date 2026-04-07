<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 상세 정보</title>
<style type="text/css">
/* 스타일만 첫 번째 예시의 현대적인 감각으로 교체 */
body {
	background-color: #f8f9fa;
	font-family: 'Pretendard', sans-serif;
}

* {
	box-sizing: border-box;
}

.page-wrap {
	max-width: 900px;
	margin: 0 auto;
	padding: 40px 20px;
}

.page-header {
	margin-bottom: 24px;
}

.page-header h2 {
	font-size: 24px;
	font-weight: 700;
	color: #111;
	letter-spacing: -0.5px;
}

/* 카드 레이아웃 */
.detail-card {
	background: #fff;
	border-radius: 20px;
	border: 1px solid #ebebeb;
	padding: 32px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
}

/* 배지 스타일 */
.status-badge {
	display: inline-block;
	font-size: 13px;
	font-weight: 600;
	padding: 6px 14px;
	border-radius: 100px;
}

.badge-wait {
	background: #fff8e1;
	color: #b7791f;
}

.badge-ok {
	background: #e8f4fd;
	color: #1a56db;
}

.badge-done {
	background: #f0fdf4;
	color: #166534;
}

.badge-cancel {
	background: #fff1f1;
	color: #b91c1c;
}

/* 섹션 타이틀 */
.section-title {
	font-size: 14px;
	font-weight: 700;
	color: #888;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	margin-bottom: 20px;
	padding-bottom: 8px;
	border-bottom: 1px solid #f0f0f0;
}

/* 정보 테이블 */
.info-table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

.info-table th {
	width: 40%;
	padding: 12px 0;
	font-size: 14px;
	color: #888;
	font-weight: 500;
	text-align: left;
}

.info-table td {
	padding: 12px 0;
	font-size: 15px;
	color: #111;
	font-weight: 600;
}

.text-highlight {
	color: #16a34a;
}

/* 메뉴 리스트 테이블 */
.menu-table {
	width: 100%;
	border-collapse: collapse;
}

.menu-table th {
	padding: 10px 0;
	font-size: 12px;
	color: #aaa;
	border-bottom: 1px solid #f0f0f0;
}

.menu-table td {
	padding: 14px 0;
	font-size: 14px;
	border-bottom: 1px solid #fafafa;
}

.total-row {
	margin-top: 15px;
	padding-top: 15px;
	border-top: 2px solid #f0f0f0;
	display: flex;
	justify-content: space-between;
	font-weight: 700;
	font-size: 16px;
}

.total-price {
	color: #16a34a;
	font-size: 18px;
}

/* 버튼 그룹 */
.action-bar {
	display: flex;
	justify-content: center;
	gap: 10px;
	margin-top: 30px;
	padding-top: 20px;
	border-top: 1px solid #f0f0f0;
}

.btn-custom {
	padding: 12px 28px;
	border-radius: 10px;
	font-size: 14px;
	font-weight: 600;
	text-decoration: none;
	transition: all 0.2s;
	border: none;
}

.btn-primary-custom {
	background: #111;
	color: #fff;
}

.btn-danger-custom {
	background: #fff;
	color: #b91c1c;
	border: 1px solid #fca5a5;
}

.btn-secondary-custom {
	background: #fff;
	color: #666;
	border: 1px solid #ddd;
}

.btn-primary-custom:hover {
	background: #333;
}

.btn-danger-custom:hover {
	background: #fff1f1;
}
</style>

<script type="text/javascript">
	$(function() {
		$("#cancelBtn").click(
				function() {
					$("#cancelResNo").val("${vo.resNo}");
					// Bootstrap 5 기준 모달 호출
					var myModal = new bootstrap.Modal(document
							.getElementById('cancelModal'));
					myModal.show();
				});
	});
</script>
</head>
<body>
	<div class="page-wrap">

		<div class="page-header">
			<h2 class="fw-bold">예약 상세 내역</h2>
		</div>

		<div class="detail-card">
			<div class="row g-5">

				<%-- 왼쪽: 예약 정보 섹션 --%>
				<div class="col-12 col-md-6">
					<div class="section-title">Reservation Info</div>
					<table class="info-table">
						<tr>
							<th>예약 번호</th>
							<td>No.${vo.resNo}</td>
						</tr>
						<tr>
							<th>매장명</th>
							<td style="font-size: 18px;">${vo.storeName}</td>
						</tr>
						<tr>
							<th>예약 상태</th>
							<td><c:choose>
									<c:when test="${vo.resStatus == 1}">
										<span class="status-badge badge-wait">매장 확인 중</span>
									</c:when>
									<c:when test="${vo.resStatus == 2}">
										<span class="status-badge badge-ok">예약 확정</span>
									</c:when>
									<c:when test="${vo.resStatus == 3}">
										<span class="status-badge badge-done">이용 완료</span>
									</c:when>
									<c:when test="${vo.resStatus == 4}">
										<span class="status-badge badge-cancel">취소됨</span>
									</c:when>
									<c:otherwise>
										<span class="status-badge bg-secondary text-white">${vo.resStatus}</span>
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
							<td class="text-highlight">${vo.resDate}/ ${vo.resTime}</td>
						</tr>
						<tr>
							<th>예약 인원</th>
							<td>${vo.resCount}명(${vo.resType})</td>
						</tr>
						<tr>
							<th>요청 사항</th>
							<td>${vo.orderAdd}</td>
						</tr>
						<c:if test="${vo.resStatus == 4 && not empty vo.cancelReason}">
							<tr>
								<th>취소 사유</th>
								<td class="text-danger" style="font-weight: 500;">${vo.cancelReason}</td>
							</tr>
						</c:if>
					</table>
				</div>

				<%-- 오른쪽: 주문 메뉴 섹션 --%>
				<div class="col-12 col-md-6">
					<div class="section-title">Order Menu</div>
					<table class="menu-table">
						<thead>
							<tr>
								<th class="text-start">메뉴명</th>
								<th class="text-center">수량</th>
								<th class="text-end">금액</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<%-- vo 객체 내부에 담긴 orderList를 참조하도록 변경 --%>
								<c:when test="${not empty vo.orderList}">
									<c:forEach items="${vo.orderList}" var="item">
										<tr>
											<td class="fw-bold">${item.menuName}</td>
											<td class="text-center text-muted">${item.quantity}개</td>
											<td class="text-end"><fmt:formatNumber
													value="${item.price}" />원</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td colspan="3" class="text-center text-muted py-5">주문 메뉴
											정보가 없습니다.</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>

					<div class="total-row">
						<span>최종 결제 금액</span> <span class="total-price"> <c:choose>
								<c:when test="${not empty vo.totalPrice}">
									<fmt:formatNumber value="${vo.totalPrice}" />원</c:when>
								<c:otherwise>-</c:otherwise>
							</c:choose>
						</span>
					</div>
				</div>
			</div>

			<%-- 하단 액션 바 --%>
			<div class="action-bar">
				<c:if test="${vo.resStatus == 1 || vo.resStatus == 2}">
					<a
						href="updateForm.do?no=${vo.resNo}&page=${param.page}&perPageNum=${param.perPageNum}"
						class="btn-custom btn-primary-custom px-4">예약 수정</a>
				</c:if>
				<a href="list.do?page=${param.page}&perPageNum=${param.perPageNum}"
					class="btn-custom btn-secondary-custom px-4">목록으로</a>
			</div>
		</div>
	</div>

</body>
</html>