<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매자용 대시보드</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
	body { background-color: #f8f9fa; }
	.card { margin-bottom: 20px; border: none; box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); }
	.sidebar { background: #343a40; color: white; min-height: 100vh; padding: 0; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }
	.sidebar h3 { padding: 25px 20px; margin: 0; font-weight: bold; font-size: 1.3rem; background: #2c3136; }
	.sidebar .nav-link { color: #adb5bd !important; padding: 15px 25px; transition: all 0.3s; border-left: 4px solid transparent; }
	.sidebar .nav-link:hover { color: #ffffff !important; background: #3e444a; border-left: 4px solid #87a372; padding-left: 30px; }
	.sidebar .nav-link.active { color: white !important; background: #495057; border-left: 4px solid #87a372; }
	hr { margin: 0; opacity: 0.1; color: white; }
</style>
</head>
<body>
	<div class="container-fluid">
		<div class="row">
			<nav class="col-md-2 sidebar">
				<h3>Seller Admin</h3>
				<hr>
				<ul class="nav flex-column mt-2">
					<li class="nav-item"><a class="nav-link active" href="dashboard.do">대시보드 홈</a></li>
					<li class="nav-item"><a class="nav-link" href="sales.do">기간별 매출조회</a></li>
					<li class="nav-item"><a class="nav-link" href="categorystats.do">카테고리 통계</a></li>
				</ul>
			</nav>

			<main class="col-md-10 p-4">
				<h2 class="mb-4" style="font-weight: bold; color: #333;">판매 통계 대시보드</h2>
				
				<div class="row mb-4">
					<!-- 1. 오늘의 매출 카드 -->
					<div class="col-md-3">
						<div class="card bg-primary text-white p-3" style="background: linear-gradient(45deg, #0d6efd, #0b5ed7) !important; min-height: 100px;">
							<p class="mb-1 opacity-75" style="font-size: 0.85rem;">오늘의 매출</p>
							<h4 class="fw-bold mb-0">
								₩<fmt:formatNumber value="${today.totalSales}" pattern="#,###" />
							</h4>
						</div>
					</div>
					<!-- 2. 오늘의 주문수 카드 (인기 카테고리 대신 실시간 데이터로 변경) -->
					<div class="col-md-3">
						<div class="card bg-success text-white p-3" style="background: linear-gradient(45deg, #198754, #157347) !important; min-height: 100px;">
							<p class="mb-1 opacity-75" style="font-size: 0.85rem;">오늘의 주문수</p>
							<h4 class="fw-bold mb-0">${today.orderCount} 건</h4>
						</div>
					</div>
				</div>

				<div class="row mt-4">
					<div class="col-md-7">
						<div class="card p-4">
							<h5 class="mb-4 fw-bold">과거 매출 추이</h5>
							<div style="height: 350px;"><canvas id="salesChart"></canvas></div>
						</div>
					</div>
					<div class="col-md-5">
						<div class="card p-4">
							<h5 class="mb-4 fw-bold">카테고리별 판매 비중</h5>
							<div style="position: relative; height: 350px; width: 100%;">
								<canvas id="categoryChart"></canvas>
							</div>
						</div>
					</div>
				</div>
			</main>
		</div>
	</div>

<script>
    // --- 1. 매출 추이 차트 (라인 차트) ---
    const salesLabels = [];
    const salesData = [];
    
    <c:forEach items="${list}" var="vo">
        salesLabels.push("${vo.statsDate}");
        salesData.push(${vo.totalSales});
    </c:forEach>
    
    // 시간순 정렬
    salesLabels.reverse();
    salesData.reverse();

    const salesCtx = document.getElementById('salesChart').getContext('2d');
    new Chart(salesCtx, {
        type: 'line',
        data: {
            labels: salesLabels,
            datasets: [{
                label: '매출액 (원)',
                data: salesData,
                borderColor: '#198754',
                tension: 0.4,
                fill: true,
                backgroundColor: 'rgba(25, 135, 84, 0.1)'
            }]
        },
        options: { responsive: true, maintainAspectRatio: false }
    });

    // --- 2. 카테고리 통계 (도넛 차트) ---
    const catLabels = [];
    const catData = [];
    
    <c:forEach items="${categoryList}" var="v">
        // DAO에서 vo.setStoreId에 담은 카테고리명을 사용
        catLabels.push("${v.storeId}"); 
        // DAO에서 vo.setOrderCount에 담은 수량을 사용
        catData.push(${v.orderCount});   
    </c:forEach>

    const categoryCtx = document.getElementById('categoryChart').getContext('2d');
    new Chart(categoryCtx, {
        type: 'doughnut',
        data: {
            labels: catLabels,
            datasets: [{
                data: catData,
                backgroundColor: ['#198754', '#36a2eb', '#ffce56', '#ff6384', '#9966ff'],
                borderWidth: 0
            }]
        },
        options: { 
            responsive: true, 
            maintainAspectRatio: false,
            plugins: { legend: { position: 'right' } }
        }
    });
</script>
</body>
</html>