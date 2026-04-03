<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { background-color: #fdfdfd; font-family: 'Pretendard', sans-serif; }
    .btn-save { background-color: #1a6d42; color: white; border-radius: 12px; font-weight: bold; border: none; }
    .btn-cancel { border-radius: 12px; font-weight: bold; }
</style>
</head>
<body>
<div class="container py-5" style="max-width: 600px;">
    <h2 class="fw-bold mb-4">메뉴 수정</h2>
    <form action="update.do" method="post">
        <input type="hidden" name="menu_no"  value="${vo.menu_no}">
        <input type="hidden" name="store_id" value="${store_id}">

        <div class="mb-3">
            <label class="form-label fw-bold">메뉴명</label>
            <input type="text" name="menu_name" class="form-control" value="${vo.menu_name}" required>
        </div>
        <div class="mb-3">
            <label class="form-label fw-bold">가격</label>
            <input type="number" name="price" class="form-control" value="${vo.price}" required>
        </div>
        <div class="mb-3">
            <label class="form-label fw-bold">설명</label>
            <textarea name="description" class="form-control" rows="3">${vo.description}</textarea>
        </div>
        <div class="mb-4">
            <label class="form-label fw-bold">이미지 URL</label>
            <input type="text" name="image_url" class="form-control" value="${vo.image_url}">
        </div>
        <div class="d-flex gap-2">
            <button type="submit" class="btn btn-save flex-grow-1 py-2">수정 완료</button>
            <button type="button" class="btn btn-outline-secondary btn-cancel flex-grow-1 py-2"
                    onclick="history.back()">취소</button>
        </div>
    </form>
</div>
</body>
</html>