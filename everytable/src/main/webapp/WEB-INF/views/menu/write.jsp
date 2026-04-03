<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴 추가</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    body { background-color: #fdfdfd; font-family: 'Pretendard', sans-serif; }
    .page-card { background: #fff; border-radius: 24px; box-shadow: 0 8px 30px rgba(0,0,0,0.07); padding: 40px; }
    .form-label { font-weight: 700; color: #333; }
    .form-control { border-radius: 12px; border: 1px solid #e9ecef; padding: 12px 16px; }
    .form-control:focus { border-color: #1a6d42; box-shadow: 0 0 0 3px rgba(26,109,66,0.1); }
    .btn-save   { background-color: #1a6d42; color: #fff; border-radius: 12px; font-weight: 700; border: none; padding: 13px; }
    .btn-save:hover { background-color: #155836; color: #fff; }
    .btn-cancel { border-radius: 12px; font-weight: 700; padding: 13px; }
    .preview-box { width: 100%; height: 220px; border-radius: 16px; object-fit: cover;
                   border: 2px dashed #dee2e6; display: none; margin-top: 12px; }
    .preview-placeholder { width: 100%; height: 220px; border-radius: 16px;
                           border: 2px dashed #dee2e6; display: flex; align-items: center;
                           justify-content: center; color: #adb5bd; font-size: 0.95rem;
                           margin-top: 12px; background: #f8f9fa; }
</style>
</head>
<body>
<div class="container py-5" style="max-width: 640px;">

    <%-- 뒤로가기 --%>
    <a href="list.do?store_id=${store_id}" class="text-decoration-none text-muted d-inline-flex align-items-center gap-2 mb-4">
        <i class="fa-solid fa-chevron-left"></i> 메뉴 관리로 돌아가기
    </a>

    <div class="page-card">
        <h2 class="fw-bold mb-1">메뉴 추가</h2>
        <p class="text-muted mb-4">새 메뉴 정보를 입력해 주세요.</p>

        <form action="write.do" method="post">
            <input type="hidden" name="store_id" value="${store_id}">

            <%-- 메뉴명 --%>
            <div class="mb-3">
                <label class="form-label">메뉴명 <span class="text-danger">*</span></label>
                <input type="text" name="menu_name" class="form-control"
                       placeholder="예) 갈비탕" required maxlength="100">
            </div>

            <%-- 가격 --%>
            <div class="mb-3">
                <label class="form-label">가격 (원) <span class="text-danger">*</span></label>
                <input type="number" name="price" class="form-control"
                       placeholder="예) 18000" required min="0">
            </div>

            <%-- 설명 --%>
            <div class="mb-3">
                <label class="form-label">메뉴 설명</label>
                <textarea name="description" class="form-control" rows="3"
                          placeholder="예) 국내산 소갈비로 진하게 우린 국물" maxlength="500"></textarea>
            </div>

            <%-- 이미지 URL --%>
            <div class="mb-4">
                <label class="form-label">이미지 URL</label>
                <input type="text" name="image_url" id="imageUrlInput" class="form-control"
                       placeholder="https://..." oninput="previewImage(this.value)">
                <div class="preview-placeholder" id="previewPlaceholder">
                    <span><i class="fa-regular fa-image me-2"></i>URL 입력 시 미리보기</span>
                </div>
                <img id="previewImg" class="preview-box" alt="미리보기"
                     onerror="this.style.display='none'; document.getElementById('previewPlaceholder').style.display='flex';">
            </div>

            <%-- 버튼 --%>
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-save flex-grow-1">
                    <i class="fa-solid fa-plus me-2"></i>메뉴 추가
                </button>
                <button type="button" class="btn btn-outline-secondary btn-cancel flex-grow-1"
                        onclick="location='list.do?store_id=${store_id}'">취소</button>
            </div>
        </form>
    </div>
</div>

<script>
function previewImage(url) {
    const img = document.getElementById('previewImg');
    const placeholder = document.getElementById('previewPlaceholder');
    if (url.trim() === '') {
        img.style.display = 'none';
        placeholder.style.display = 'flex';
    } else {
        img.src = url;
        img.style.display = 'block';
        placeholder.style.display = 'none';
    }
}
</script>
</body>
</html>