<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 수정하기 - EveryTable</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 1. 수정 폼 전체를 감싸는 카드 스타일 (리뷰 리스트 카드와 통일) */
        .form-card {
            border-radius: 15px; /* 둥근 모서리 */
            border: 1px solid #eaeaea; /* 연한 테두리 */
            padding: 30px;
            background-color: #fff;
            margin-top: 50px;
            margin-bottom: 50px;
        }
        /* 2. 메인 타이틀 (총 X개의 리뷰와 통일) */
        .form-title {
            font-weight: bold;
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }
        /* 3. 인풋 필드 (textarea, select) 스타일 */
        .form-control-review, .form-select-review {
            border-radius: 10px; /* 둥근 입력창 */
            border: 1px solid #ccc;
            padding: 12px;
        }
        .form-control-review:focus, .form-select-review:focus {
            border-color: #149c71; /* 포커스 시 메인 색상 */
            box-shadow: 0 0 0 0.25rem rgba(20, 156, 113, 0.25);
        }
        /* 4. '수정 완료' 버튼 (리뷰 작성하기 버튼과 통일) */
        .btn-main {
            background-color: #149c71; /* 메인 초록색 */
            color: white;
            border-radius: 8px; /* 버튼 둥글게 */
            padding: 12px 30px;
            font-weight: bold;
            width: 100%; /* 버튼 꽉 차게 */
        }
        .btn-main:hover {
            background-color: #0d7f5c; /* 호버 시 진한 초록색 */
            color: white;
        }
        /* 5. '취소' 버튼 스타일 */
        .btn-cancel {
            background-color: transparent;
            color: #8c8c8c;
            border-radius: 8px;
            padding: 10px 20px;
            font-size: 0.9em;
            text-decoration: underline; /* 텍스트 링크 느낌 */
            border: none;
            width: 100%;
        }
        .btn-cancel:hover {
            background-color: #f1f1f1;
            color: #333;
        }
    </style>
</head>
<body class="bg-light">

<div class="container d-flex justify-content-center">
    <div class="form-card shadow-sm" style="max-width: 600px; width: 100%;">
        
        <h3 class="form-title fs-4">리뷰 수정</h3>
        <p class="text-center text-muted mb-4">작성하신 리뷰 내용을 수정할 수 있습니다.</p>
        
        <form action="update.do" method="post">
            <input type="hidden" name="no" value="${vo.no}">
            <input type="hidden" name="storeId" value="${vo.storeId}">

            <div class="mb-4">
                <label for="content" class="form-label fw-bold">내용</label>
                <textarea class="form-control form-control-review" rows="6" id="content" name="content" required placeholder="솔직한 리뷰를 작성해주세요!">${vo.content}</textarea>
            </div>

            <div class="mb-5">
                <label for="rating" class="form-label fw-bold">평점 (현재: ${vo.rating}점)</label>
                <select class="form-select form-select-review" name="rating" id="rating">
                    <option value="5.0" ${vo.rating == 5.0 ? 'selected' : ''}>★★★★★ 5.0 (최고예요)</option>
                    <option value="4.0" ${vo.rating == 4.0 ? 'selected' : ''}>★★★★☆ 4.0 (좋아요)</option>
                    <option value="3.0" ${vo.rating == 3.0 ? 'selected' : ''}>★★★☆☆ 3.0 (보통이에요)</option>
                    <option value="2.0" ${vo.rating == 2.0 ? 'selected' : ''}>★★☆☆☆ 2.0 (별로예요)</option>
                    <option value="1.0" ${vo.rating == 1.0 ? 'selected' : ''}>★☆☆☆☆ 1.0 (최악이에요)</option>
                </select>
            </div>

            <div class="d-grid gap-2 text-center mt-4">
                <button type="submit" class="btn btn-main">수정 완료</button>
                <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>