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
	
	/* [수정] 사이드바 배경색 및 스타일 */
	.sidebar {
		background: #343a40; /* 세련된 연한 검은색 */
		color: white;
		min-height: 100vh;
		padding: 0; /* 내부 패딩을 0으로 하고 하단 요소에서 조정 */
		box-shadow: 2px 0 5px rgba(0,0,0,0.1);
	}
	
	.sidebar h3 {
		padding: 25px 20px;
		margin: 0;
		font-weight: bold;
		font-size: 1.3rem;
		background: #2c3136; /* 제목 부분만 살짝 더 어둡게 */
	}
	
	/* [추가] 사이드바 메뉴 호버 효과 */
	.sidebar .nav-link {
		color: #adb5bd !important; /* 기본 글자색 (회색) */
		padding: 15px 25px;
		transition: all 0.3s;
		border-left: 4px solid transparent; /* 호버 시 나타날 선 준비 */
	}
	
	.sidebar .nav-link:hover {
		color: #ffffff !important; /* 마우스 올리면 흰색으로 */
		background: #3e444a; /* 살짝 밝아지는 배경 */
		border-left: 4px solid #87a372; /* 우리 서비스 포인트 컬러(연녹색) */
		padding-left: 30px; /* 오른쪽으로 살짝 밀리는 효과 */
	}
	
	/* 현재 활성화된 메뉴 스타일 (필요시 class="active" 추가) */
	.sidebar .nav-link.active {
		color: white !important;
		background: #495057;
		border-left: 4px solid #87a372;
	}

	hr {
		margin: 0;
		opacity: 0.1;
		color: white;
	}
</style>
</head>
<body>

	<div class="container-fluid">
		<div class="row">
			<!-- 사이드바 영역 -->
			<nav class="col-md-2 sidebar">
				<h3>Seller Admin</h3>
				<hr>
				<ul class="nav flex-column mt-2">
					<li class="nav-item">
						<a class="nav-link active" href="dashboard.do">
							<i class="fa fa-dashboard me-2"></i>대시보드 홈
						</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="sales.do">
							<i class="fa fa-bar-chart me-2"></i>기간별 매출조회
						</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="categorystats.do">
							<i class="fa fa-pie-chart me-2"></i>카테고리 통계
						</a>
					</li>
				</ul>
			</nav>

			<!-- 메인 컨텐츠 영역 -->
			<main class="col-md-10 p-4">
				<h2 class="mb-4" style="font-weight: bold; color: #333;">판매 통계 대시보드</h2>

				<div class="row">
					<!-- 상단 요약 카드 영역: 더 작고 깔끔하게 수정 -->
<div class="row mb-4">
    <!-- 오늘의 매출 카드 -->
    <div class="col-md-3">
        <div class="card bg-primary text-white p-3" style="background: linear-gradient(45deg, #0d6efd, #0b5ed7) !important; min-height: 100px;">
            <p class="mb-1 opacity-75" style="font-size: 0.85rem;">오늘의 매출</p>
            <h4 class="fw-bold mb-0">₩1,250,000</h4>
        </div>
    </div>

    <!-- 인기 카테고리 카드 -->
    <div class="col-md-3">
        <div class="card bg-success text-white p-3" style="background: linear-gradient(45deg, #198754, #157347) !important; min-height: 100px;">
            <p class="mb-1 opacity-75" style="font-size: 0.85rem;">인기 카테고리</p>
            <h4 class="fw-bold mb-0" style="font-size: 1.25rem;">한식 / 비빔밥</h4>
        </div>
    </div>
    
    <!-- (선택사항) 옆에 빈 공간이 남으니 다른 지표를 하나 더 넣어도 좋습니다 -->
</div>

				<div class="row mt-4">
					<!-- 차트 영역 -->
					<div class="col-md-7">
						<div class="card p-4">
							<h5 class="mb-4 fw-bold">기간별 매출 추이 (최근 7일)</h5>
							<canvas id="salesChart"></canvas>
						</div>
					</div>
					<div class="col-md-5">
						<div class="card p-4">
							<h5 class="mb-4 fw-bold">카테고리별 인기 메뉴</h5>
							<div style="max-height: 300px; display: flex; justify-content: center;">
								<canvas id="categoryChart"></canvas>
							</div>
						</div>
					</div>
				</div>
			</main>
		</div>
	</div>

	<script>
    // 기간별 매출 차트
    const salesCtx = document.getElementById('salesChart').getContext('2d');
    new Chart(salesCtx, {
        type: 'line',
        data: {
            labels: ['월', '화', '수', '목', '금', '토', '일'],
            datasets: [{
                label: '매출액 (만원)',
                data: [65, 59, 80, 81, 56, 95, 120],
                borderColor: '#198754', /* 포인트 컬러로 변경 */
                backgroundColor: 'rgba(25, 135, 84, 0.1)',
                fill: true,
                tension: 0.4 /* 곡선을 더 부드럽게 */
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } }
        }
    });

    // 카테고리별 인기 메뉴
    const categoryCtx = document.getElementById('categoryChart').getContext('2d');
    new Chart(categoryCtx, {
        type: 'doughnut',
        data: {
            labels: ['한식', '일식', '양식', '분식'],
            datasets: [{
                data: [300, 50, 100, 80],
                backgroundColor: ['#198754', '#36a2eb', '#ffce56', '#ff6384'],
                borderWidth: 0
            }]
        },
        options: {
            cutout: '70%', /* 도넛 구멍 크기 조절 */
            plugins: {
                legend: { position: 'bottom' }
            }
        }
    });
</script>

</body>
</html>