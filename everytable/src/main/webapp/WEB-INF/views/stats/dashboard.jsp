<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매자용 대시보드</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
body {
	background-color: #f8f9fa;
}

.card {
	margin-bottom: 20px;
	border: none;
	box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
}

.sidebar {
	background: #343a40;
	color: white;
	min-height: 100vh;
	padding: 20px;
}
</style>
</head>
<body>

	<div class="container-fluid">
		<div class="row">
			<nav class="col-md-2 sidebar">
				<h3>Seller Admin</h3>
				<hr>
				<ul class="nav flex-column">
					<li class="nav-item"><a class="nav-link text-white"
						href="dashboard.do" target="mainFrame">대시보드 홈</a></li>
					<li class="nav-item"><a class="nav-link text-white" 
						href="sales.do" target="mainFrame">기간별 매출조회</a></li>
					<li class="nav-item"><a class="nav-link text-white" 
						href="categorystats.do" target="mainFrame">카테고리 통계</a></li>
				</ul>
			</nav>

			<main class="col-md-10 p-4">
				<h2 class="mb-4">판매 통계 대시보드</h2>

				<div class="row">
					<div class="col-md-4">
						<div class="card bg-primary text-white p-3">
							<h5>오늘의 매출</h5>
							<h3>₩1,250,000</h3>
						</div>
					</div>

					<div class="col-md-4">
						<div class="card bg-success text-white p-3">
							<h5>인기 카테고리</h5>
							<h3>한식 / 비빔밥</h3>
						</div>
					</div>

					<div class="row mt-4">
						<div class="col-md-7">
							<div class="card p-3">
								<h5>기간별 매출 추이 (최근 7일)</h5>
								<canvas id="salesChart"></canvas>
							</div>
						</div>
						<div class="col-md-5">
							<div class="card p-3">
								<h5>카테고리별 인기 메뉴</h5>
								<canvas id="categoryChart"></canvas>
							</div>
						</div>
					</div>
			</main>
		</div>
	</div>

	<script>
    // 기간별 매출 차트 (Line Chart)
    const salesCtx = document.getElementById('salesChart').getContext('2d');
    new Chart(salesCtx, {
        type: 'line',
        data: {
            labels: ['월', '화', '수', '목', '금', '토', '일'],
            datasets: [{
                label: '매출액 (만원)',
                data: [65, 59, 80, 81, 56, 95, 120],
                borderColor: 'rgb(75, 192, 192)',
                tension: 0.1
            }]
        }
    });

    // 카테고리별 인기 메뉴 (Doughnut Chart)
    const categoryCtx = document.getElementById('categoryChart').getContext('2d');
    new Chart(categoryCtx, {
        type: 'doughnut',
        data: {
            labels: ['한식', '일식', '양식', '분식'],
            datasets: [{
                data: [300, 50, 100, 80],
                backgroundColor: ['#ff6384', '#36a2eb', '#ffce56', '#4bc0c0']
            }]
        }
    });
</script>

</body>
</html>