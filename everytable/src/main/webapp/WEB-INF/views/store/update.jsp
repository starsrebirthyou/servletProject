<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매장 정보 수정 - 에브리테이블</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    body { background-color: #f8f9fa; font-family: 'Pretendard', sans-serif; }

    /* 페이지 헤더 */
    .page-header { display: flex; align-items: center; gap: 12px; margin-bottom: 24px; }
    .page-header .icon-box {
        width: 44px; height: 44px; background: #e8f5ee; border-radius: 12px;
        display: flex; align-items: center; justify-content: center; color: #1a6d42; font-size: 1.2rem;
    }
    .page-header h2 { font-weight: 800; font-size: 1.4rem; margin: 0; }
    .page-header p  { color: #868e96; font-size: 0.85rem; margin: 0; }

    /* 섹션 카드 */
    .section-card {
        background: #fff; border-radius: 20px;
        box-shadow: 0 2px 12px rgba(0,0,0,0.05);
        padding: 28px; margin-bottom: 16px;
    }
    .section-title {
        font-weight: 700; font-size: 1rem;
        color: #333; margin-bottom: 20px;
    }

    /* 이미지 박스 */
    .img-preview-box {
        width: 100%; height: 220px; border-radius: 16px;
        overflow: hidden; position: relative; background: #f1f3f5;
        display: flex; align-items: center; justify-content: center;
        margin-bottom: 12px;
    }
    .img-preview-box img { width: 100%; height: 100%; object-fit: cover; }
    .btn-img-change {
        background: none; border: none; color: #1a6d42;
        font-weight: 700; font-size: 0.9rem; padding: 0;
    }
    .btn-img-change:hover { text-decoration: underline; }

    /* 입력 필드 */
    .form-label { font-weight: 600; font-size: 0.9rem; color: #495057; margin-bottom: 6px; }
    .form-label .req { color: #fa5252; margin-left: 3px; }
    .form-control {
        border-radius: 12px; border: 1.5px solid #e9ecef;
        padding: 12px 16px; font-size: 0.95rem; transition: 0.2s;
    }
    .form-control:focus { border-color: #1a6d42; box-shadow: 0 0 0 3px rgba(26,109,66,0.1); }
    .input-hint { font-size: 0.8rem; color: #adb5bd; margin-top: 5px; }

    /* 입력 단위 suffix */
    .input-group-text {
        border-radius: 0 12px 12px 0; border: 1.5px solid #e9ecef;
        border-left: none; background: #f8f9fa; color: #868e96; font-size: 0.9rem;
    }
    .input-group .form-control { border-radius: 12px 0 0 12px; }

    /* 저장 버튼 */
    .btn-save {
        width: 100%; padding: 16px; border-radius: 14px;
        background-color: #1a6d42; color: #fff;
        font-weight: 800; font-size: 1rem; border: none;
        transition: 0.2s; margin-top: 8px;
    }
    .btn-save:hover { background-color: #155836; }

    /* 안내 박스 */
    .info-box {
        background: #e8f5ee; border-radius: 16px;
        padding: 20px 24px; margin-top: 16px;
    }
    .info-box .info-title { font-weight: 700; color: #1a6d42; font-size: 0.9rem; margin-bottom: 10px; }
    .info-box ul { padding-left: 18px; margin: 0; }
    .info-box ul li { color: #2d6a4f; font-size: 0.85rem; line-height: 1.8; }

    /* 저장 완료 토스트 */
    .toast-success {
        position: fixed; top: 24px; left: 50%; transform: translateX(-50%);
        background: #1a6d42; color: #fff; padding: 14px 28px;
        border-radius: 50px; font-weight: 700; font-size: 0.95rem;
        box-shadow: 0 8px 24px rgba(26,109,66,0.3);
        z-index: 9999; display: none; align-items: center; gap: 8px;
    }
</style>
</head>
<body>

<%-- 저장 완료 토스트 --%>
<div class="toast-success" id="toastSuccess">
    <i class="fa-solid fa-circle-check"></i> 변경사항이 저장되었습니다.
</div>

<div class="container py-4" style="max-width: 520px;">

    <%-- 페이지 헤더 --%>
    <div class="page-header">
        <div class="icon-box"><i class="fa-solid fa-store"></i></div>
        <div>
            <h2>매장 정보 수정</h2>
            <p>매장 정보를 수정하고 업데이트하세요</p>
        </div>
    </div>

    <form action="update.do" method="post" id="updateForm">
        <input type="hidden" name="store_id" value="${vo.store_id}">

        <%-- 매장 대표 이미지 --%>
        <div class="section-card">
            <p class="section-title">매장 대표 이미지</p>
            <div class="img-preview-box">
                <img src="/upload/store/${vo.filename}" id="previewImg"
                     onerror="this.src='https://via.placeholder.com/480x220?text=No+Image'">
            </div>
            <div class="text-center">
                <button type="button" class="btn-img-change" onclick="document.getElementById('fileInput').click()">
                    <i class="fa-solid fa-arrows-rotate me-1"></i> 이미지 변경하기
                </button>
                <input type="file" id="fileInput" accept="image/*" style="display:none"
                       onchange="previewLocalImage(this)">
                <%-- 파일 업로드 미구현 시 기존 파일명 유지 --%>
                <input type="hidden" name="filename" id="filenameInput" value="">
            </div>
        </div>

        <%-- 기본 정보 --%>
        <div class="section-card">
            <p class="section-title">기본 정보</p>

            <div class="mb-3">
                <label class="form-label">매장명 <span class="req">*</span></label>
                <input type="text" name="store_name" class="form-control"
                       value="${vo.store_name}" placeholder="한강뷰 레스토랑" required maxlength="100">
            </div>

            <div class="mb-3">
                <label class="form-label">카테고리 <span class="req">*</span></label>
                <select name="store_cate" class="form-control" required>
                    <option value="">카테고리 선택</option>
                    <option value="한식"  ${vo.store_cate == '한식'  ? 'selected' : ''}>한식</option>
                    <option value="일식"  ${vo.store_cate == '일식'  ? 'selected' : ''}>일식</option>
                    <option value="중식"  ${vo.store_cate == '중식'  ? 'selected' : ''}>중식</option>
                    <option value="양식"  ${vo.store_cate == '양식'  ? 'selected' : ''}>양식</option>
                    <option value="카페"  ${vo.store_cate == '카페'  ? 'selected' : ''}>카페</option>
                    <option value="분식"  ${vo.store_cate == '분식'  ? 'selected' : ''}>분식</option>
                    <option value="기타"  ${vo.store_cate == '기타'  ? 'selected' : ''}>기타</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">
                    <i class="fa-solid fa-location-dot me-1 text-muted"></i>매장 주소 <span class="req">*</span>
                </label>
                <input type="text" name="store_addr" class="form-control"
                       value="${vo.store_addr}" placeholder="서울시 마포구 와우산로 94" required maxlength="200">
            </div>

            <div class="mb-1">
                <label class="form-label">
                    <i class="fa-solid fa-phone me-1 text-muted"></i>전화번호 <span class="req">*</span>
                </label>
                <input type="text" name="store_tel" class="form-control"
                       value="${vo.store_tel}" placeholder="02-1234-5678" maxlength="20">
            </div>
        </div>

        <%-- 운영 정보 --%>
        <div class="section-card">
            <p class="section-title">운영 정보</p>

            <div class="mb-3">
                <label class="form-label">
                    <i class="fa-regular fa-clock me-1 text-muted"></i>영업시간 <span class="req">*</span>
                </label>
                <input type="text" name="open_time" class="form-control"
                       value="${vo.open_time}" placeholder="10:00 - 22:00" maxlength="50">
                <p class="input-hint">예) 10:00 - 22:00 (매일 동일)</p>
            </div>

            <div class="mb-3">
                <label class="form-label">
                    <i class="fa-solid fa-dollar-sign me-1 text-muted"></i>최소 주문금액 <span class="req">*</span>
                </label>
                <div class="input-group">
                    <input type="number" name="min_order_price" class="form-control"
                           value="${vo.min_order_price}" placeholder="200000" min="0">
                    <span class="input-group-text">원</span>
                </div>
                <p class="input-hint">20만원 이상</p>
            </div>

            <div class="mb-1">
                <label class="form-label">
                    <i class="fa-regular fa-clock me-1 text-muted"></i>기본 준비시간 <span class="req">*</span>
                </label>
                <div class="input-group">
                    <input type="number" name="prepare_time" class="form-control"
                           value="${vo.prepare_time}" placeholder="4" min="1">
                    <span class="input-group-text">시간</span>
                </div>
                <p class="input-hint">주문 확정 후 음식 준비에 소요되는 평균 시간</p>
            </div>
        </div>

        <%-- 저장 버튼 --%>
        <button type="submit" class="btn-save">
            <i class="fa-solid fa-floppy-disk me-2"></i>변경사항 저장
        </button>
    </form>

    <%-- 안내 박스 --%>
    <div class="info-box">
        <p class="info-title"><i class="fa-solid fa-circle-info me-2"></i>매장 정보 관리 안내</p>
        <ul>
            <li>매장 정보는 고객에게 공개되는 중요한 정보입니다</li>
            <li>정확한 정보를 입력하여 신뢰도를 높여주세요</li>
            <li>변경사항은 즉시 반영되어 고객에게 노출됩니다</li>
        </ul>
    </div>

</div>

<script>
// 저장 완료 토스트 표시
window.onload = function() {
    <c:if test="${result == 'success'}">
        showToast();
    </c:if>
};

function showToast() {
    const toast = document.getElementById('toastSuccess');
    toast.style.display = 'flex';
    setTimeout(() => { toast.style.display = 'none'; }, 3000);
}

// 이미지 로컬 미리보기
function previewLocalImage(input) {
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('previewImg').src = e.target.result;
        };
        reader.readAsDataURL(input.files[0]);
        // 실제 파일 업로드 구현 전까지 파일명만 임시 세팅
        document.getElementById('filenameInput').value = input.files[0].name;
    }
}
</script>
</body>
</html>