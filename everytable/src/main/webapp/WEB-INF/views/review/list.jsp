<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 목록</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    body { background-color: #f8f9fa; }
    .review-card { border: none; border-radius: 15px; padding: 25px; margin-bottom: 20px; background: #fff; position: relative; }
    .user-avatar { width: 45px; height: 45px; background-color: #f0f8f7; color: #1a9c82; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 1.2rem; }
    .star-rating { color: #ffc107; margin-left: 5px; }
    .review-content { font-size: 1.05rem; margin: 15px 0; color: #333; }
    .admin-btns { position: absolute; top: 25px; right: 25px; }
    .store-badge { background-color: #f1f3f5; padding: 5px 12px; border-radius: 5px; color: #666; font-size: 0.85rem; }
</style>
<script>
$(function() {
    // 1. 삭제 처리
    $(".deleteBtn").click(function() {
        if(!confirm("정말 삭제하시겠습니까?")) return;
        let no = $(this).data("no");
        // 현재 URL에서 storeId 가져오기
        let storeId = new URLSearchParams(window.location.search).get('storeId');
        location.href = "/review/delete.do?no=" + no + "&storeId=" + storeId;
    });

    // 2. 수정 처리
    $(".updateBtn").click(function() {
        let no = $(this).data("no");
        let storeId = new URLSearchParams(window.location.search).get('storeId');
        location.href = "/review/updateForm.do?no=" + no + "&storeId=" + storeId;
    });
});
</script>
</head>
<body>
<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="font-weight-bold">총 <strong>${pageObject.totalRow}</strong>개의 리뷰</h4>
    </div>

    <div id="reviewList">
        <c:forEach var="vo" items="${list}">
            <div class="review-card shadow-sm">
                <!-- 본인 확인: 세션의 login.id와 리뷰의 userId 비교 -->
                <c:if test="${login.id == vo.userId}">
                    <div class="admin-btns">
                        <button class="btn btn-sm btn-outline-secondary updateBtn" data-no="${vo.no}">수정</button>
                        <button class="btn btn-sm btn-outline-danger deleteBtn" data-no="${vo.no}">삭제</button>
                    </div>
                </c:if>

                <div class="d-flex align-items-center">
                    <div class="user-avatar">${vo.userId.substring(0,1).toUpperCase()}</div>
                    <div class="ml-3">
                        <div>
                            <strong style="font-size: 1.1rem;">${vo.userName}님</strong>
                            <span class="star-rating">
                                <c:forEach begin="1" end="${vo.rating}">★</c:forEach>
                            </span>
                        </div>
                        <small class="text-muted">${vo.createdAt}</small>
                    </div>
                </div>
                
                <div class="review-content">${vo.content}</div>
                <div><span class="store-badge">매장 번호: ${vo.storeId}</span></div>
            </div>
        </c:forEach>
        
        <c:if test="${empty list}">
            <div class="text-center p-5">작성된 리뷰가 없습니다.</div>
        </c:if>
    </div>

    <div class="text-center mt-5 mb-5">
        <button class="btn btn-success btn-lg px-5" 
                onclick="location.href='writeForm.do?storeId=${param.storeId}'"
                style="background-color: #1a9c82; border: none; border-radius: 10px;">
            리뷰 작성하기
        </button>
    </div>
</div>
</body>
</html>