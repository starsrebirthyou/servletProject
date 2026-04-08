<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
body {
	background-color: #f8f9fa;
}

.share-box {
	max-width: 600px;
	margin: 80px auto;
	background: #fff;
	border-radius: 15px;
	padding: 40px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
	text-align: center;
}

.url-input {
	width: 100%;
	padding: 12px;
	border: 1px solid #dee2e6;
	border-radius: 8px;
	font-size: 14px;
	margin: 15px 0;
}
</style>

<div class="share-box">
	<h3 class="fw-bold mb-3">🔗 단체 주문 링크 공유</h3>
	<p class="text-muted">아래 링크를 팀원들에게 공유하세요</p>

	<input type="text" class="url-input" id="shareUrl"
		value="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/reservation/groupMenuForm.do?resNo=${resNo}&storeId=${storeId}"
		readonly>

	<button class="btn btn-success btn-lg w-100 fw-bold mb-3"
		onclick="copyUrl()">링크 복사</button>

	<a href="/reservation/groupOrderStatus.do?resNo=${resNo}&storeId=${storeId}"
		class="btn btn-outline-secondary btn-lg w-100"> 취합 현황 보기 </a>
</div>

<script>
	function copyUrl() {
		var input = document.getElementById("shareUrl");
		input.select();
		document.execCommand("copy");
		alert("링크가 복사되었습니다!");
	}
</script>
