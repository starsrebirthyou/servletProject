<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 목록 - 에브리테이블</title>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
body {
	background-color: #fcfcfc;
}

.review-card {
	border: 1px solid #e9ecef;
	border-radius: 15px;
	padding: 25px;
	margin-bottom: 20px;
	background: #fff;
	transition: transform 0.2s;
}

.review-card:hover {
	transform: translateY(-3px);
	box-shadow: 0 10px 20px rgba(0, 0, 0, 0.05);
}

.user-avatar {
	width: 45px;
	height: 45px;
	background-color: #f0f8f7;
	color: #1a9c82;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: bold;
	font-size: 1.1rem;
}

.star-rating {
	color: #ffc107;
	font-size: 1.1rem;
}

.star-empty {
	color: #dee2e6;
}

.review-content {
	font-size: 1.05rem;
	line-height: 1.6;
	margin: 15px 0;
	color: #333;
}

.menu-tag {
	display: inline-block;
	padding: 4px 12px;
	background: #f8f9fa;
	border-radius: 6px;
	color: #6c757d;
	font-size: 0.9rem;
	border: 1px solid #eee;
}

.btn-write {
	background-color: #1a9c82;
	color: white;
	border-radius: 10px;
	padding: 15px 40px;
	font-weight: bold;
}

.btn-write:hover {
	background-color: #14806a;
	color: #fff;
}
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	$(function() {
		// 리뷰 작성하기 버튼 클릭
		$("#writeBtn").click(function() {
			let loginId = "${login.id}";
			if (!loginId) {
				if (confirm("로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?")) {
					location.href = "/member/loginForm.do";
				}
			} else {
				// 작성 폼으로 이동 (기본 매장번호 1번 전달)
				location.href = "writeForm.do?storeId=1";
			}
		});
	});
</script>
</head>
<body>

	<div class="container mt-5">
		<div
			class="review-header d-flex justify-content-between align-items-center mb-4">
			<h4 class="font-weight-bold">
				총 <span id="totalReviewCount">${pageObject.totalRow}</span>개의 리뷰
			</h4>
			<select class="form-control col-md-2" id="sortOrder">
				<option value="latest">최신순</option>
				<option value="oldest">오래된순</option>
				<option value="rating">별점순</option>
			</select>
		</div>

		<div id="reviewList">
			<c:choose>
				<%-- 데이터가 없는 경우 --%>
				<c:when test="${empty list}">
					<div class="text-center py-5 bg-white rounded shadow-sm">
						<i class="fa-regular fa-comment-dots fa-3x mb-3 text-muted"></i>
						<p class="text-muted">
							아직 등록된 리뷰가 없습니다.<br>첫 번째 리뷰의 주인공이 되어보세요!
						</p>
					</div>
				</c:when>

				<%-- 데이터가 있는 경우 반복 출력 --%>
				<c:otherwise>
					<c:forEach var="vo" items="${list}">
						<div class="review-card shadow-sm">
							<div class="d-flex align-items-center">
								<div class="user-avatar">${vo.userName.substring(0,1)}</div>
								<div class="ml-3">
									<div class="d-flex align-items-center">
										<span class="font-weight-bold mr-2">${vo.userName}님</span> <span
											class="star-rating"> <%-- 별점 로직: 1부터 5까지 반복하며 채워진 별과 빈 별 구분 --%>
											<c:forEach begin="1" end="5" var="i">
												<c:choose>
													<c:when test="${i <= vo.rating}">★</c:when>
													<c:otherwise>
														<span class="star-empty">★</span>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</span>
									</div>
									<div class="small text-muted">${vo.createdAt}</div>
								</div>
							</div>
							<div class="review-content">${vo.content}</div>
							<div class="menu-tag">
								<i class="fa-solid fa-shop mr-1"></i> 매장 번호: ${vo.storeId}
							</div>
						</div>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</div>

		<div class="text-center mt-5 mb-5">
			<c:choose>
				<%-- 1. 로그인을 안 한 경우: 로그인 버튼 표시 --%>
				<c:when test="${empty login}">
					<button class="btn btn-secondary btn-lg"
						onclick="location.href='/member/loginForm.do'">로그인하고 리뷰
						쓰기</button>
					<p class="text-muted mt-2 small">로그인 후 따뜻한 한마디를 남겨주세요</p>
				</c:when>

				<%-- 2. 로그인을 한 경우: 리뷰 작성하기 버튼 표시 --%>
				<c:otherwise>
					<button class="btn btn-write btn-lg" id="writeBtn">리뷰 작성하기
					</button>
					<p class="text-success mt-2 small">${login.name} 님이 작성하신 리뷰
						목록입니다.</p>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

</body>
</html>