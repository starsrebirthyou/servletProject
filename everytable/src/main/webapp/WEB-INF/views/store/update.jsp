<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매장 정보 수정</title>
<style>
  body { background: #f4f4f2; font-family: 'Pretendard', 'Apple SD Gothic Neo', sans-serif; margin: 0; }

  /* ── 상단 배너 ── */
  .welcome-banner {
    background: #1e5f3e;
    color: #fff;
    padding: 28px 32px;
    border-radius: 14px;
    margin-bottom: 24px;
    display: flex;
    align-items: flex-start;
    gap: 18px;
  }
  .welcome-banner .icon-box {
    background: rgba(255,255,255,0.15);
    border-radius: 12px;
    width: 52px; height: 52px;
    display: flex; align-items: center; justify-content: center;
    font-size: 24px; flex-shrink: 0;
  }
  .welcome-banner h2 { margin: 0 0 4px; font-size: 1.3rem; font-weight: 700; }
  .welcome-banner p  { margin: 0; font-size: 0.88rem; opacity: .85; }

  /* ── 성공 알림 ── */
  .alert-success {
    background: #d4edda; border: 1.5px solid #a8d5b5;
    color: #1e5f3e; border-radius: 10px;
    padding: 14px 18px; margin-bottom: 16px;
    font-size: 0.9rem; font-weight: 600;
    display: flex; align-items: center; gap: 8px;
  }

  /* ── 섹션 카드 ── */
  .form-card {
    background: #fff;
    border-radius: 14px;
    padding: 28px 28px 24px;
    margin-bottom: 16px;
    box-shadow: 0 1px 4px rgba(0,0,0,.06);
  }
  .section-title {
    font-size: 1rem; font-weight: 700; color: #1a1a1a;
    margin: 0 0 20px; display: flex; align-items: center; gap: 10px;
  }
  .section-num {
    background: #1e5f3e; color: #fff;
    border-radius: 50%; width: 26px; height: 26px;
    display: flex; align-items: center; justify-content: center;
    font-size: 0.8rem; font-weight: 700; flex-shrink: 0;
  }

  /* ── 이미지 업로드 ── */
  .image-upload-area {
    border: 2px dashed #d0d0cc;
    border-radius: 12px;
    padding: 36px 20px;
    text-align: center;
    cursor: pointer;
    transition: border-color .2s, background .2s;
  }
  .image-upload-area:hover { border-color: #1e5f3e; background: #f0f7f3; }
  .image-upload-area .upload-icon { font-size: 2rem; color: #aaa; margin-bottom: 10px; }
  .image-upload-area p { margin: 0 0 4px; color: #888; font-size: 0.88rem; }
  .image-upload-area small { color: #bbb; font-size: 0.78rem; }
  .current-file { font-size: 0.82rem; color: #1e5f3e; margin-top: 10px; font-weight: 600; }
  #imageFile { display: none; }

  /* ── 폼 요소 ── */
  .form-label { font-size: 0.88rem; font-weight: 600; color: #333; margin-bottom: 6px; display: block; }
  .form-label .req { color: #e74c3c; margin-left: 2px; }
  .form-control, .form-select {
    width: 100%; padding: 11px 14px; border: 1.5px solid #e0e0dc;
    border-radius: 9px; font-size: 0.9rem; background: #fafaf8;
    box-sizing: border-box; transition: border-color .2s, box-shadow .2s; outline: none;
    font-family: inherit; color: #1a1a1a;
  }
  .form-control:focus, .form-select:focus {
    border-color: #1e5f3e; box-shadow: 0 0 0 3px rgba(30,95,62,.1); background: #fff;
  }
  .form-control::placeholder { color: #bbb; }
  .input-hint { font-size: 0.78rem; color: #999; margin-top: 5px; }

  /* ── 단위 붙은 인풋 ── */
  .input-group { position: relative; display: flex; align-items: center; }
  .input-group .form-control { padding-right: 48px; }
  .input-unit { position: absolute; right: 14px; color: #888; font-size: 0.85rem; pointer-events: none; }

  /* ── 그리드 ── */
  .row2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
  .row3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; }
  .mb-16 { margin-bottom: 16px; }

  /* ── 버튼 ── */
  .btn-row { display: flex; gap: 12px; margin-bottom: 16px; }
  .btn-submit {
    flex: 1; padding: 16px;
    background: #1e5f3e; color: #fff;
    border: none; border-radius: 12px;
    font-size: 1rem; font-weight: 700; cursor: pointer;
    display: flex; align-items: center; justify-content: center; gap: 8px;
    transition: background .2s; font-family: inherit;
  }
  .btn-submit:hover { background: #174f33; }
  .btn-cancel {
    padding: 16px 28px;
    background: #fff; color: #555;
    border: 1.5px solid #ddd; border-radius: 12px;
    font-size: 1rem; font-weight: 600; cursor: pointer;
    transition: background .2s; font-family: inherit;
  }
  .btn-cancel:hover { background: #f5f5f2; }
</style>
</head>
<body>
<div class="container mt-4" style="max-width:780px; margin:0 auto; padding:0 16px 48px;">

  <!-- 상단 배너 -->
  <div class="welcome-banner">
    <div class="icon-box">✏️</div>
    <div>
      <h2>매장 정보 수정</h2>
      <p>수정한 정보는 즉시 고객에게 반영됩니다</p>
    </div>
  </div>

  <!-- 성공 메시지 -->
  <c:if test="${result == 'success'}">
    <div class="alert-success">✅ 매장 정보가 성공적으로 수정되었습니다.</div>
  </c:if>

  <form action="update.do" method="post" enctype="multipart/form-data">
    <input type="hidden" name="store_id" value="${vo.store_id}">

    <!-- 1. 매장 대표 이미지 -->
    <div class="form-card">
      <p class="section-title"><span class="section-num">1</span> 매장 대표 이미지</p>
      <div class="image-upload-area" onclick="document.getElementById('imageFile').click()">
        <div class="upload-icon">🖼</div>
        <p>클릭하여 이미지 변경</p>
        <small>PNG, JPG, WEBP (최대 5MB)</small>
      </div>
      <c:if test="${not empty vo.filename}">
        <p class="current-file">📎 현재 파일: ${vo.filename}</p>
      </c:if>
      <input type="file" name="imageFile" id="imageFile" accept="image/*">
    </div>

    <!-- 2. 기본 정보 -->
    <div class="form-card">
      <p class="section-title"><span class="section-num">2</span> 기본 정보</p>

      <div class="mb-16">
        <label class="form-label">매장명 <span class="req">*</span></label>
        <input type="text" name="store_name" class="form-control" value="${vo.store_name}" required>
      </div>

      <div class="mb-16">
        <label class="form-label">카테고리 <span class="req">*</span></label>
        <select name="store_cate" class="form-select">
          <option value="한식" ${vo.store_cate == '한식' ? 'selected' : ''}>한식</option>
          <option value="일식" ${vo.store_cate == '일식' ? 'selected' : ''}>일식</option>
          <option value="양식" ${vo.store_cate == '양식' ? 'selected' : ''}>양식</option>
          <option value="카페" ${vo.store_cate == '카페' ? 'selected' : ''}>카페</option>
          <option value="기타" ${vo.store_cate == '기타' ? 'selected' : ''}>기타</option>
        </select>
      </div>

      <div class="mb-16">
        <label class="form-label">📍 매장 주소 <span class="req">*</span></label>
        <input type="text" name="store_addr" class="form-control" value="${vo.store_addr}" required>
      </div>

      <div>
        <label class="form-label">📞 전화번호</label>
        <input type="text" name="store_tel" class="form-control" value="${vo.store_tel}">
      </div>
    </div>

    <!-- 3. 운영 정보 -->
    <div class="form-card">
      <p class="section-title"><span class="section-num">3</span> 운영 정보</p>

      <div class="mb-16">
        <label class="form-label">⏰ 영업시간 <span class="req">*</span></label>
        <input type="text" name="open_time" class="form-control" value="${vo.open_time}" placeholder="10:00 - 22:00">
        <p class="input-hint">예: 10:00 - 22:00 (매일 동일)</p>
      </div>

      <div class="row2">
        <div>
          <label class="form-label">$ 최소 주문금액</label>
          <div class="input-group">
            <input type="number" name="min_order_price" class="form-control" value="${vo.min_order_price}">
            <span class="input-unit">원</span>
          </div>
        </div>
        <div>
          <label class="form-label">⏱ 기본 준비시간</label>
          <div class="input-group">
            <input type="text" name="prepare_time" class="form-control" value="${vo.prepare_time}">
            <span class="input-unit">시간</span>
          </div>
          <p class="input-hint">주문 확정 후 음식 준비 소요 시간</p>
        </div>
      </div>
    </div>

    <!-- 4. 환불 정책 -->
    <div class="form-card">
      <p class="section-title"><span class="section-num">4</span> 환불 정책 수정</p>
      <div class="row3">
        <div>
          <label class="form-label">24시간 전</label>
          <input type="text" name="refund_policy_24" class="form-control" value="${vo.refund_policy_24}">
        </div>
        <div>
          <label class="form-label">12시간 전</label>
          <input type="text" name="refund_policy_12" class="form-control" value="${vo.refund_policy_12}">
        </div>
        <div>
          <label class="form-label">당일</label>
          <input type="text" name="refund_policy_0" class="form-control" value="${vo.refund_policy_0}">
        </div>
      </div>
    </div>

    <!-- 버튼 -->
    <div class="btn-row">
      <button type="submit" class="btn-submit">✅ 수정 완료</button>
      <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
    </div>
  </form>
</div>

<script>
  document.getElementById('imageFile').addEventListener('change', function() {
    if (this.files && this.files[0]) {
      const area = document.querySelector('.image-upload-area p');
      area.textContent = this.files[0].name;
    }
  });
</script>
</body>
</html>
