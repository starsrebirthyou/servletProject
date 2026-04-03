<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기간별 매출 조회</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background-color: #fff;
	padding: 20px;
}

.search-card {
	background: #f8f9fa;
	border: 1px solid #e9ecef;
	border-radius: 10px;
	margin-bottom: 30px;
}

.table thead {
	background-color: #f1f3f5;
	font-weight: bold;
}

.total-badge {
	font-size: 1.1rem;
	padding: 10px 20px;
	background-color: #1a9c82 !important;
}

.empty-msg {
	color: #6c757d;
	padding: 50px 0;
}
</style>
</head>
<body>

	<div class="container-fluid">
		<h3 class="mb-4 font-weight-bold">기간별 매출 조회</h3>

		<div class="card search-card p-4">
			<form action="sales.do" method="get"
				class="row g-3 align-items-center">
				<div class="col-auto">
					<label class="form-label mb-0">조회 기간</label>
				</div>
				<div class="col-auto">
					<input type="date" name="startDate" class="form-control"
						value="${startDate}">
				</div>
				<div class="col-auto text-muted">~</div>
				<div class="col-auto">
					<input type="date" name="endDate" class="form-control"
						value="${endDate}">
				</div>
				<div class="col-auto">
					<button type="submit" class="btn btn-primary px-4 shadow-sm">조회하기</button>
				</div>
			</form>
		</div>

		<div class="d-flex justify-content-between align-items-center mb-3">
			<h5>
				조회 결과 <small class="text-muted">(총 ${list.size()}건)</small>
			</h5>
			<div class="badge total-badge shadow-sm">
				총 매출액: ₩
				<fmt:formatNumber value="${totalSum}" pattern="#,###" />
			</div>
		</div>

		<div class="table-responsive">
			<table class="table table-hover border">
				<thead>
					<tr class="text-center">
						<th>날짜</th>
						<th>주문 건수</th>
						<th>매출액</th>
						<th>평균 객단가</th>
						<th>리뷰 수</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty list}">
							<tr>
								<td colspan="5" class="text-center empty-msg"><i
									class="bi bi-exclamation-circle"></i> 해당 기간에 등록된 매출 데이터가 없습니다.
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="vo" items="${list}">
								<tr class="text-center align-middle">
									<td>${vo.statsDate}</td>
									<td>${vo.orderCount}건</td>
									<td class="text-end fw-bold text-primary">₩<fmt:formatNumber
											value="${vo.totalSales}" pattern="#,###" />
									</td>
									<td class="text-end text-muted">₩<fmt:formatNumber
											value="${vo.avgOrder}" pattern="#,###" />
									</td>
									<td><span class="badge bg-light text-dark border">${vo.reviewCount}</span></td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
	</div>

</body>
</html>