<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매장 리뷰 목록</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<style>
    body { background-color: #f8f9fa; }
    .review-card { border: none; border-radius: 15px; padding: 25px; margin-bottom: 20px; background: #fff; position: relative; }
    /* 아바타 색상을 조금 다르게 해서 구분감을 줄 수 있어요 */
    .user-avatar { width: 45px; height: 45px; background-color: #e8f4f1; color: #1a9c82; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; }
    .star-rating { color: #ffc107; margin-left: 5px; }
    .review-content { font-size: 1.05rem; margin: 15px 0; color: #333; min-height: 40px; }
    .admin-btns { position: absolute; top: 25px; right: 25px; }
    /* 매장 전용 페이지이므로 매장 이름 배지는 뺌 (상단에 제목으로 배치) */
</style>
</head>
<body>
<div class="container mt-5">
    <!-- 상단 헤더: 어떤 매장의 리뷰인지 명시 -->
    <div class="mb-4">
        <h3 class="font-weight-bold">매장 리뷰 <small class="text-muted">(총 ${pageObject.totalRow}개)</small></h3>
        <hr>
    </div>

    <div id="reviewList">
        <c:forEach var="vo" items="${list}">
            <div class="review-card shadow-sm">
                <!-- 본인 리뷰일 때만 수정/삭제 노출 -->
                <c:if test="${login.id == vo.userId}">
                    <div class="admin-btns">
                        <button class="btn btn-sm btn-outline-secondary" onclick="location.href='/review/updateForm.do?no=${vo.no}&storeId=${param.storeId}'">수정</button>
                        <button class="btn btn-sm btn-outline-danger" onclick="if(confirm('삭제하시겠습니까?')) location.href='/review/delete.do?no=${vo.no}&storeId=${param.storeId}'">삭제</button>
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
            </div>
        </c:forEach>
        
        <c:if test="${empty list}">
            <div class="text-center p-5 bg-white shadow-sm" style="border-radius: 15px;">
                <p class="text-muted">아직 작성된 리뷰가 없습니다.<br>첫 번째 리뷰의 주인공이 되어보세요!</p>
            </div>
        </c:if>
    </div>

    <!-- 하단 버튼 영역 -->
    <div class="text-center mt-5 mb-5">
        <button type="button" class="btn btn-outline-secondary btn-lg px-4 mr-2" onclick="history.back()">뒤로가기</button>
        <button class="btn btn-success btn-lg px-5" 
                onclick="location.href='/review/writeForm.do?storeId=${param.storeId}'"
                style="background-color: #1a9c82; border: none; border-radius: 10px;">
            리뷰 작성하기
        </button>
    </div>
</div>
</body>
</html>