<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<style>
    .write-box { max-width: 600px; margin: 50px auto; padding: 30px; border: 1px solid #ddd; border-radius: 15px; background: #fff; }
    .star-radio { display: flex; flex-direction: row-reverse; justify-content: center; font-size: 2rem; }
    .star-radio input { display: none; }
    .star-radio label { color: #ddd; cursor: pointer; }
    .star-radio input:checked ~ label { color: #ffc107; }
    .star-radio label:hover, .star-radio label:hover ~ label { color: #ffdb70; }
    .btn-submit { background: #1a9c82; color: #fff; width: 100%; padding: 12px; border: none; border-radius: 8px; font-weight: bold; }
</style>
</head>
<body class="bg-light">
<div class="container">
    <div class="write-box shadow-sm">
        <h4 class="text-center font-weight-bold mb-4">리뷰 작성하기</h4>
        
        <form action="write.do" method="post" id="reviewForm">
            <!-- ✅ 핵심 수정: 매장 이름을 서버로 넘기기 위한 hidden 필드 -->
            <input type="hidden" name="storeName" id="storeNameInput" value="${storeName}">


            <div class="form-group text-center">
                <label class="text-muted">별점을 선택해주세요</label>
                <div class="star-radio">
                    <input type="radio" id="st5" name="rating" value="5" checked><label for="st5">★</label>
                    <input type="radio" id="st4" name="rating" value="4"><label for="st4">★</label>
                    <input type="radio" id="st3" name="rating" value="3"><label for="st3">★</label>
                    <input type="radio" id="st2" name="rating" value="2"><label for="st2">★</label>
                    <input type="radio" id="st1" name="rating" value="1"><label for="st1">★</label>
                </div>
            </div>

            <div class="form-group">
                <textarea name="content" class="form-control" rows="8" placeholder="음식의 맛과 서비스는 어떠셨나요?" required></textarea>
            </div>

            <div class="d-flex mt-4">
                <button type="button" class="btn btn-outline-secondary mr-2" onclick="history.back()">취소</button>
                <button type="submit" class="btn btn-submit">리뷰 등록하기</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>