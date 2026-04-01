<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성하기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="card shadow-sm">
        <div class="card-header bg-success text-white">
            <h4 class="mb-0">리뷰 작성</h4>
        </div>
        <div class="card-body">
            <form action="write.do" method="post">
                <input type="hidden" name="storeId" value="${param.storeId}">
                
                <div class="mb-3">
                    <label class="form-label font-weight-bold">별점 선택</label>
                    <select name="rating" class="form-select">
                        <option value="5">⭐⭐⭐⭐⭐ (5점)</option>
                        <option value="4">⭐⭐⭐⭐ (4점)</option>
                        <option value="3">⭐⭐⭐ (3점)</option>
                        <option value="2">⭐⭐ (2점)</option>
                        <option value="1">⭐ (1점)</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label font-weight-bold">리뷰 내용</label>
                    <textarea name="content" class="form-control" rows="5" placeholder="음식의 맛, 서비스 등에 대해 솔직한 리뷰를 남겨주세요." required></textarea>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-success px-5">등록하기</button>
                    <a href="list.do" class="btn btn-outline-secondary px-5">취소</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>