<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 관리</title>
<style>
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

.page-wrap {
	max-width: 860px;
	margin: 0 auto;
	padding: 48px 24px;
}

.page-header {
	margin-bottom: 32px;
}

.page-header h1 {
	font-size: 22px;
	font-weight: 600;
	letter-spacing: -0.5px;
	color: #111;
}

.page-header p {
	font-size: 14px;
	color: #888;
	margin-top: 4px;
}

/* 필터 탭 */
.filter-bar {
	display: flex;
	gap: 6px;
	margin-bottom: 28px;
	flex-wrap: wrap;
}

.filter-btn {
	padding: 7px 16px;
	border-radius: 100px;
	border: 1.5px solid #ddd;
	background: #fff;
	font-size: 13px;
	font-weight: 500;
	color: #555;
	cursor: pointer;
	transition: all 0.15s;
	text-decoration: none;
}

.filter-btn:hover {
	border-color: #111;
	color: #111;
}

.filter-btn.active {
	background: #111;
	color: #fff;
	border-color: #111;
}

/* 카드 */
.order-card {
	background: #fff;
	border-radius: 16px;
	border: 1px solid #ebebeb;
	padding: 24px;
	margin-bottom: 16px;
	transition: box-shadow 0.2s;
}

.order-card:hover {
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.07);
}

.card-top {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 18px;
}

.card-meta {
	font-size: 12px;
	color: #aaa;
	margin-bottom: 4px;
}

.card-user {
	font-size: 14px;
	color: #444;
}

.card-user strong {
	color: #111;
	font-weight: 600;
}

/* 상태 배지 */
.badge {
	display: inline-block;
	font-size: 12px;
	font-weight: 600;
	padding: 5px 12px;
	border-radius: 100px;
	white-space: nowrap;
	flex-shrink: 0;
}

.badge-wait {
	background: #fff8e1;
	color: #b7791f;
	border: 1px solid #f6e05e;
}

.badge-ok {
	background: #e8f4fd;
	color: #1a56db;
	border: 1px solid #bfdbfe;
}

.badge-done {
	background: #f0fdf4;
	color: #166534;
	border: 1px solid #bbf7d0;
}

.badge-cancel {
	background: #fff1f1;
	color: #b91c1c;
	border: 1px solid #fecaca;
}

.badge-etc {
	background: #f3f4f6;
	color: #6b7280;
	border: 1px solid #e5e7eb;
}

/* 정보 그리드 */
.info-grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 1px;
	background: #f0f0f0;
	border-radius: 12px;
	overflow: hidden;
	margin-bottom: 18px;
}

.info-cell {
	background: #fafafa;
	padding: 14px 16px;
}

.info-cell:first-child {
	border-radius: 12px 0 0 12px;
}

.info-cell:last-child {
	border-radius: 0 12px 12px 0;
}

.info-cell .lbl {
	font-size: 11px;
	color: #aaa;
	font-weight: 500;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	margin-bottom: 4px;
}

.info-cell .val {
	font-size: 15px;
	font-weight: 600;
	color: #111;
}

.info-cell .val.green {
	color: #16a34a;
}

.info-cell .val.blue {
	color: #1d4ed8;
}

/* 거절 사유 */
.cancel-reason {
	background: #fff5f5;
	border-left: 3px solid #fca5a5;
	border-radius: 0 8px 8px 0;
	padding: 10px 14px;
	font-size: 13px;
	color: #7f1d1d;
	margin-bottom: 14px;
}

.cancel-reason strong {
	font-weight: 600;
}

/* 버튼 영역 */
.card-actions {
	display: flex;
	gap: 8px;
	justify-content: flex-end;
}

.btn {
	padding: 8px 18px;
	border-radius: 8px;
	font-size: 13px;
	font-weight: 500;
	cursor: pointer;
	border: 1.5px solid transparent;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 5px;
	transition: all 0.15s;
}

.btn-ghost {
	background: #fff;
	border-color: #ddd;
	color: #555;
}

.btn-ghost:hover {
	border-color: #999;
	color: #111;
}

.btn-dark {
	background: #111;
	color: #fff;
	border-color: #111;
}

.btn-dark:hover {
	background: #333;
}

.btn-success {
	background: #16a34a;
	color: #fff;
	border-color: #16a34a;
}

.btn-success:hover {
	background: #15803d;
}

.btn-danger {
	background: #fff;
	border-color: #fca5a5;
	color: #b91c1c;
}

.btn-danger:hover {
	background: #fff1f1;
}

/* 빈 상태 */
.empty-state {
	text-align: center;
	padding: 64px 24px;
	background: #fff;
	border-radius: 16px;
	border: 1px solid #ebebeb;
}

.empty-icon {
	font-size: 36px;
	margin-bottom: 12px;
}

.empty-state p {
	color: #aaa;
	font-size: 15px;
}

/* 페이지네이션 */
.pagination-wrap {
	display: flex;
	justify-content: center;
	margin-top: 32px;
}

/* 모달 오버레이 */
.modal-overlay {
	display: none;
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, 0.4);
	z-index: 1000;
	align-items: center;
	justify-content: center;
}

.modal-overlay.show {
	display: flex;
}

.modal-box {
	background: #fff;
	border-radius: 20px;
	padding: 32px;
	width: 100%;
	max-width: 440px;
	margin: 24px;
}

.modal-title {
	font-size: 18px;
	font-weight: 600;
	margin-bottom: 6px;
}

.modal-sub {
	font-size: 13px;
	color: #888;
	margin-bottom: 20px;
}

.modal-box select, .modal-box textarea {
	width: 100%;
	border: 1.5px solid #e5e7eb;
	border-radius: 10px;
	padding: 10px 14px;
	font-size: 14px;
	color: #111;
	background: #fafafa;
	margin-bottom: 10px;
	resize: none;
	font-family: inherit;
}

.modal-box select:focus, .modal-box textarea:focus {
	outline: none;
	border-color: #111;
	background: #fff;
}

.modal-actions {
	display: flex;
	gap: 8px;
	justify-content: flex-end;
	margin-top: 8px;
}
</style>
</head>
<body>

	<div class="page-wrap">

		<div class="page-header">
			<h1>주문 관리</h1>
			<p>접수된 예약 및 주문을 확인하고 승인·거절 처리하세요.</p>
		</div>

		<%-- 필터 탭 --%>
		<div class="filter-bar" id="filterKey">
			<button class="filter-btn" value="0">전체</button>
			<button class="filter-btn" value="1">대기</button>
			<button class="filter-btn" value="2">승인</button>
			<button class="filter-btn" value="3">완료</button>
			<button class="filter-btn" value="4">취소·환불</button>
		</div>

		<%-- 빈 상태 --%>
		<c:if test="${empty list}">
			<div class="empty-state">
				<div class="empty-icon">📭</div>
				<p>접수된 주문이 없습니다.</p>
			</div>
		</c:if>

		<%-- 카드 목록 --%>
		<c:forEach items="${list}" var="vo">
			<div class="order-card">

				<%-- 상단: 메타 + 배지 --%>
				<div class="card-top">
					<div>
						<div class="card-meta">No.${vo.resNo} &nbsp;·&nbsp; 접수
							${vo.resCreatedAt}</div>
						<div class="card-user">
							<strong>${vo.userId}</strong> &nbsp;·&nbsp; ${vo.resPhone}
						</div>
					</div>
					<c:choose>
						<c:when test="${vo.resStatus == 1}">
							<span class="badge badge-wait">대기</span>
						</c:when>
						<c:when test="${vo.resStatus == 2}">
							<span class="badge badge-ok">승인</span>
						</c:when>
						<c:when test="${vo.resStatus == 3}">
							<span class="badge badge-done">완료</span>
						</c:when>
						<c:when test="${vo.resStatus == 4}">
							<span class="badge badge-cancel">취소·환불</span>
						</c:when>
						<c:otherwise>
							<span class="badge badge-etc">알 수 없음</span>
						</c:otherwise>
					</c:choose>
				</div>

				<%-- 정보 그리드 --%>
				<div class="info-grid">
					<div class="info-cell">
						<div class="lbl">방문 일시</div>
						<div class="val green">${vo.resDate}<br>${vo.resTime}</div>
					</div>
					<div class="info-cell">
						<div class="lbl">인원 / 유형</div>
						<div class="val">${vo.resCount}명/ ${vo.resType}</div>
					</div>
					<div class="info-cell">
						<div class="lbl">주문 금액</div>
						<div class="val blue">
							<fmt:formatNumber value="${vo.totalPrice}" />
							원
						</div>
					</div>
				</div>

				<%-- 거절 사유 --%>
				<c:if test="${vo.resStatus == 4 && not empty vo.cancelReason}">
					<div class="cancel-reason">
						<strong>거절 사유:</strong> ${vo.cancelReason}
					</div>
				</c:if>

				<%-- 액션 버튼 --%>
				<div class="card-actions">
					<a href="view.do?no=${vo.resNo}" class="btn btn-ghost">상세보기</a>
					<c:if test="${vo.resStatus == 1}">
						<a href="adminUpdate.do?resNo=${vo.resNo}&resStatus=2"
							class="btn btn-success"
							onclick="return confirm('이 예약을 승인하시겠습니까?')">승인</a>
						<button type="button" class="btn btn-danger btn-reject-modal"
							data-no="${vo.resNo}">거절</button>
					</c:if>
				</div>

			</div>
		</c:forEach>

		<%-- 페이지네이션 --%>
		<div class="pagination-wrap">
			<pageNav:pageNav listURI="adminList.do" pageObject="${pageObject}" />
		</div>

	</div>

	<%-- 거절 모달 --%>
	<div class="modal-overlay" id="rejectModal">
		<div class="modal-box">
			<div class="modal-title">거절 사유 입력</div>
			<div class="modal-sub">사용자에게 전달될 거절 사유를 선택하거나 직접 입력하세요.</div>
			<form action="adminUpdate.do" method="post">
				<input type="hidden" name="resNo" id="modalResNo"> <input
					type="hidden" name="resStatus" value="4"> <select
					name="cancelReason" required>
					<option value="">사유 선택 (필수)</option>
					<option value="재료 소진으로 인한 주문 불가">재료 소진</option>
					<option value="해당 시간대 예약 만석">예약 만석</option>
					<option value="개인 사정으로 인한 임시 휴무">임시 휴무</option>
					<option value="직접 입력">기타 (직접 입력)</option>
				</select>
				<textarea name="cancelReasonDirect" rows="3"
					placeholder="기타 사유 입력 시 작성"></textarea>
				<div class="modal-actions">
					<button type="button" class="btn btn-ghost" id="modalClose">취소</button>
					<button type="submit" class="btn btn-danger"
						style="background: #b91c1c; color: #fff; border-color: #b91c1c;">거절
						처리</button>
				</div>
			</form>
		</div>
	</div>

	<script>
		(function() {
			var filterKey = "${pageObject.key}" || "0";
			var perPageNum = "${pageObject.perPageNum}";

			document.querySelectorAll("#filterKey .filter-btn").forEach(
					function(btn) {
						if (btn.value === filterKey)
							btn.classList.add("active");
						btn.addEventListener("click", function() {
							location.href = "adminList.do?page=1&perPageNum="
									+ perPageNum + "&key=" + btn.value;
						});
					});

			document
					.querySelectorAll(".btn-reject-modal")
					.forEach(
							function(btn) {
								btn
										.addEventListener(
												"click",
												function() {
													document
															.getElementById("modalResNo").value = btn.dataset.no;
													document
															.getElementById("rejectModal").classList
															.add("show");
												});
							});

			document.getElementById("modalClose").addEventListener(
					"click",
					function() {
						document.getElementById("rejectModal").classList
								.remove("show");
					});

			document.getElementById("rejectModal").addEventListener("click",
					function(e) {
						if (e.target === this)
							this.classList.remove("show");
					});
		})();
	</script>
</body>
</html>
