<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매장 수정</title>
<style>
body {
    background: #f4f4f2;
    font-family: 'Pretendard', 'Apple SD Gothic Neo', sans-serif;
    margin: 0;
}

.form-card {
    background: #fff;
    border-radius: 14px;
    padding: 28px;
    margin-bottom: 16px;
}

.section-title {
    font-weight: 700;
    font-size: 1rem;
    color: #111;
    margin: 0 0 16px 0;
}

.form-label {
    display: block;
    font-size: 0.85rem;
    font-weight: 600;
    color: #555;
    margin-bottom: 6px;
    margin-top: 14px;
}
.form-label:first-of-type { margin-top: 0; }

.form-control {
    width: 100%;
    padding: 10px 12px;
    border-radius: 8px;
    border: 1px solid #ddd;
    font-size: 0.95rem;
    box-sizing: border-box;
    background: #fff;
    transition: border-color 0.2s;
}
.form-control:focus {
    outline: none;
    border-color: #1e5f3e;
    box-shadow: 0 0 0 3px rgba(30,95,62,0.08);
}

select.form-control {
    appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%23888' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 12px center;
    cursor: pointer;
}

textarea.form-control {
    resize: vertical;
    min-height: 80px;
}

/* 이미지 미리보기 */
.preview-placeholder {
    width: 100%;
    height: 200px;
    border-radius: 12px;
    border: 2px dashed #d0d0cc;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: #aaa;
    font-size: 0.9rem;
    margin-top: 12px;
    background: #f8f8f6;
    gap: 8px;
    box-sizing: border-box;
}

#previewImg {
    width: 100%;
    max-height: 200px;
    object-fit: cover;
    border-radius: 12px;
    margin-top: 12px;
    display: none;
    border: 1px solid #e8e8e4;
}

.current-file {
    font-size: 0.82rem;
    color: #888;
    margin-top: 8px;
}

/* 2열 그리드 */
.input-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 14px;
}
@media (max-width: 540px) {
    .input-row { grid-template-columns: 1fr; }
}

/* 환불 정책 3열 */
.policy-row {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 12px;
}
@media (max-width: 540px) {
    .policy-row { grid-template-columns: 1fr; }
}
.policy-badge {
    display: inline-block;
    background: #f0f0ec;
    color: #666;
    font-size: 0.75rem;
    padding: 2px 8px;
    border-radius: 20px;
    margin-bottom: 4px;
}

/* 제출 버튼 */
.btn-submit {
    width: 100%;
    padding: 14px;
    background: #1e5f3e;
    color: #fff;
    border: none;
    border-radius: 10px;
    font-size: 1rem;
    font-weight: 700;
    cursor: pointer;
    transition: background 0.2s;
    margin-top: 4px;
}
.btn-submit:hover { background: #174f34; }

/* 성공 메시지 */
.alert-success {
    background: #e8f5ee;
    border: 1px solid #b2ddc4;
    color: #1e5f3e;
    border-radius: 10px;
    padding: 12px 16px;
    margin-bottom: 16px;
    font-weight: 600;
    font-size: 0.9rem;
}
</style>
</head>
<body>
<div style="max-width:780px; margin:0 auto; padding:20px;">

    <!-- 성공 메시지 -->
    <c:if test="${result eq 'success'}">
        <div class="alert-success">✅ 매장 정보가 성공적으로 수정되었습니다.</div>
    </c:if>

    <form action="update.do" method="post">
        <input type="hidden" name="store_id" value="${vo.store_id}">

        <!-- ========================= -->
        <!-- 1. 매장 대표 이미지 (URL)  -->
        <!-- ========================= -->
        <div class="form-card">
            <p class="section-title">1. 매장 대표 이미지</p>

            <label class="form-label">이미지 URL</label>
            <input type="text"
                   name="filename"
                   id="imageUrlInput"
                   class="form-control"
                   value="${vo.filename}"
                   placeholder="https://example.com/image.jpg"
                   oninput="previewImage(this.value)">

            <c:if test="${not empty vo.filename}">
                <p class="current-file">📎 현재 이미지: ${vo.filename}</p>
            </c:if>

            <!-- 미리보기 -->
            <div class="preview-placeholder" id="previewPlaceholder">
                🖼 URL 입력 시 미리보기
            </div>
            <img id="previewImg" alt="이미지 미리보기"
                 onerror="this.style.display='none';
                          document.getElementById('previewPlaceholder').style.display='flex';">
        </div>

        <!-- ========================= -->
        <!-- 2. 기본 정보              -->
        <!-- ========================= -->
        <div class="form-card">
            <p class="section-title">2. 기본 정보</p>

            <label class="form-label">매장명</label>
            <input type="text" name="store_name" class="form-control"
                   value="${vo.store_name}" placeholder="매장 이름">

            <label class="form-label">카테고리</label>
            <select name="store_cate" class="form-control">
                <option value="">카테고리 선택</option>
                <option value="한식"  ${vo.store_cate eq '한식'  ? 'selected' : ''}>한식</option>
                <option value="중식"  ${vo.store_cate eq '중식'  ? 'selected' : ''}>중식</option>
                <option value="일식"  ${vo.store_cate eq '일식'  ? 'selected' : ''}>일식</option>
                <option value="양식"  ${vo.store_cate eq '양식'  ? 'selected' : ''}>양식</option>
                <option value="분식"  ${vo.store_cate eq '분식'  ? 'selected' : ''}>분식</option>
                <option value="치킨"  ${vo.store_cate eq '치킨'  ? 'selected' : ''}>치킨</option>
                <option value="피자"  ${vo.store_cate eq '피자'  ? 'selected' : ''}>피자</option>
                <option value="버거"  ${vo.store_cate eq '버거'  ? 'selected' : ''}>버거</option>
                <option value="디저트" ${vo.store_cate eq '디저트' ? 'selected' : ''}>디저트</option>
                <option value="기타"  ${vo.store_cate eq '기타'  ? 'selected' : ''}>기타</option>
            </select>

            <label class="form-label">주소</label>
            <input type="text" name="store_addr" class="form-control"
                   value="${vo.store_addr}" placeholder="주소">

            <label class="form-label">전화번호</label>
            <input type="text" name="store_tel" class="form-control"
                   value="${vo.store_tel}" placeholder="예) 02-1234-5678">
        </div>

        <!-- ========================= -->
        <!-- 3. 운영 정보              -->
        <!-- ========================= -->
        <div class="form-card">
            <p class="section-title">3. 운영 정보</p>

            <div class="input-row">
                <div>
                    <label class="form-label">영업 시간</label>
                    <input type="text" name="open_time" class="form-control"
                           value="${vo.open_time}" placeholder="예) 09:00 ~ 22:00">
                </div>
                <div>
                    <label class="form-label">준비 시간</label>
                    <input type="text" name="prepare_time" class="form-control"
                           value="${vo.prepare_time}" placeholder="예) 30분">
                </div>
            </div>

            <label class="form-label">최소 주문 금액 (원)</label>
            <input type="number" name="min_order_price" class="form-control"
                   value="${vo.min_order_price}" placeholder="예) 15000" min="0">
        </div>

        <!-- ========================= -->
        <!-- 4. 환불 정책              -->
        <!-- ========================= -->
        <div class="form-card">
            <p class="section-title">4. 환불 정책</p>

            <div class="policy-row">
                <div>
                    <span class="policy-badge">24시간 전</span>
                    <label class="form-label">환불 정책</label>
                    <input type="text" name="refund_policy_24" class="form-control"
                           value="${vo.refund_policy_24}" placeholder="예) 100% 환불">
                </div>
                <div>
                    <span class="policy-badge">12시간 전</span>
                    <label class="form-label">환불 정책</label>
                    <input type="text" name="refund_policy_12" class="form-control"
                           value="${vo.refund_policy_12}" placeholder="예) 50% 환불">
                </div>
                <div>
                    <span class="policy-badge">당일</span>
                    <label class="form-label">환불 정책</label>
                    <input type="text" name="refund_policy_0" class="form-control"
                           value="${vo.refund_policy_0}" placeholder="예) 환불 불가">
                </div>
            </div>
        </div>

        <!-- 수정 버튼 -->
        <button type="submit" class="btn-submit">수정하기</button>

    </form>
</div>

<script>
/* 이미지 미리보기 */
function previewImage(url) {
    const img = document.getElementById('previewImg');
    const placeholder = document.getElementById('previewPlaceholder');
    if (!url || url.trim() === '') {
        img.style.display = 'none';
        placeholder.style.display = 'flex';
    } else {
        img.src = url;
        img.style.display = 'block';
        placeholder.style.display = 'none';
    }
}

/* 페이지 로드 시 기존 이미지 미리보기 */
window.addEventListener('DOMContentLoaded', function () {
    const existing = document.getElementById('imageUrlInput').value;
    if (existing && existing.trim() !== '') {
        previewImage(existing);
    }
});
</script>
</body>
</html>
