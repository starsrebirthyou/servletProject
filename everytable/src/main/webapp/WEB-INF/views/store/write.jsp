<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매장 등록</title>
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
  .welcome-banner p  { margin: 0 0 14px; font-size: 0.88rem; opacity: .85; }
  .steps { display: flex; align-items: center; gap: 10px; font-size: 0.82rem; }
  .step  { display: flex; align-items: center; gap: 6px; }
  .step-num {
    background: rgba(255,255,255,0.25);
    border-radius: 50%; width: 22px; height: 22px;
    display: flex; align-items: center; justify-content: center;
    font-size: 0.75rem; font-weight: 700;
  }
  .step-arrow { opacity: .6; font-size: 0.9rem; }

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
    padding: 48px 20px;
    text-align: center;
    cursor: pointer;
    transition: border-color .2s, background .2s;
  }
  .image-upload-area:hover { border-color: #1e5f3e; background: #f0f7f3; }
  .image-upload-area .upload-icon { font-size: 2rem; color: #aaa; margin-bottom: 10px; }
  .image-upload-area p { margin: 0; color: #888; font-size: 0.88rem; }
  .image-upload-area small { color: #bbb; font-size: 0.78rem; }
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
  .input-unit {
    position: absolute; right: 14px; color: #888; font-size: 0.85rem; pointer-events: none;
  }

  /* ── 그리드 ── */
  .row2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
  .row3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; }
  .mb-16 { margin-bottom: 16px; }

  /* ── 제출 버튼 ── */
  .btn-submit {
    width: 100%; padding: 16px;
    background: #1e5f3e; color: #fff;
    border: none; border-radius: 12px;
    font-size: 1rem; font-weight: 700; cursor: pointer;
    display: flex; align-items: center; justify-content: center; gap: 8px;
    transition: background .2s, transform .1s;
    margin-bottom: 16px;
  }
  .btn-submit:hover { background: #174f33; }
  .btn-submit:active { transform: scale(.99); }

  /* ── 안내 박스 ── */
  .info-box {
    background: #eef4ff; border-radius: 12px;
    padding: 18px 20px; margin-bottom: 16px;
  }
  .info-box .info-title { font-size: 0.88rem; font-weight: 700; color: #2255a4; margin-bottom: 10px; display: flex; align-items: center; gap: 6px; }
  .info-box ul { margin: 0; padding-left: 0; list-style: none; }
  .info-box ul li { font-size: 0.83rem; color: #3366cc; padding: 3px 0; display: flex; align-items: flex-start; gap: 6px; }
  .info-box ul li::before { content: '•'; flex-shrink: 0; }
</style>
</head>
<body>
<div class="container mt-4" style="max-width:780px; margin:0 auto; padding:0 16px 48px;">

  <!-- 상단 배너 -->
  <div class="welcome-banner">
    <div class="icon-box">🏪</div>
    <div>
      <h2>에브리테이블에 오신 것을 환영합니다!</h2>
      <p>매장을 등록하고 단체 주문 서비스를 시작해보세요</p>
      <div class="steps">
        <div class="step"><div class="step-num">1</div> 매장 정보 입력</div>
        <span class="step-arrow">→</span>
        <div class="step"><div class="step-num">2</div> 메뉴 등록</div>
        <span class="step-arrow">→</span>
        <div class="step"><div class="step-num">3</div> 주문 관리 시작</div>
      </div>
    </div>
  </div>

  <form action="write.do" method="post" enctype="multipart/form-data">
    <input type="hidden" name="member_id" value="${login.id}">

    <!-- 1. 매장 대표 이미지 -->
    <div class="form-card">
      <p class="section-title"><span class="section-num">1</span> 매장 대표 이미지</p>
      <div class="image-upload-area" onclick="document.getElementById('imageFile').click()">
        <div class="upload-icon">🖼</div>
        <p>클릭하여 이미지 업로드</p>
        <small>PNG, JPG, WEBP (최대 5MB)</small>
      </div>
      <input type="file" name="imageFile" id="imageFile" accept="image/*">
    </div>

    <!-- 2. 기본 정보 -->
    <div class="form-card">
      <p class="section-title"><span class="section-num">2</span> 기본 정보</p>

      <div class="mb-16">
        <label class="form-label">매장명 <span class="req">*</span></label>
        <input type="text" name="store_name" class="form-control" placeholder="예: 한강뷰 레스토랑" required>
      </div>

      <div class="mb-16">
        <label class="form-label">카테고리 <span class="req">*</span></label>
        <select name="store_cate" class="form-select">
          <option value="">선택하세요</option>
          <option value="한식">한식</option>
          <option value="일식">일식</option>
          <option value="양식">양식</option>
          <option value="카페">카페</option>
          <option value="기타">기타</option>
        </select>
      </div>

      <div class="mb-16">
        <label class="form-label">📍 매장 주소 <span class="req">*</span></label>
        <input type="text" name="store_addr" class="form-control" placeholder="예: 서울시 마포구 와우산로 94" required>
      </div>

      <div>
        <label class="form-label">📞 전화번호 <span class="req">*</span></label>
        <input type="text" name="store_tel" class="form-control" placeholder="예: 02-1234-5678">
      </div>
    </div>

    <!-- 3. 운영 정보 -->
    <div class="form-card">
      <p class="section-title"><span class="section-num">3</span> 운영 정보</p>

      <div class="mb-16">
        <label class="form-label">⏰ 영업시간 <span class="req">*</span></label>
        <input type="text" name="open_time" class="form-control" placeholder="10:00 - 22:00">
        <p class="input-hint">예: 10:00 - 22:00 (매일 동일)</p>
      </div>

      <div class="row2">
        <div>
          <label class="form-label">$ 최소 주문금액 <span class="req">*</span></label>
          <div class="input-group">
            <input type="number" name="min_order_price" class="form-control" value="200000">
            <span class="input-unit">원</span>
          </div>
        </div>
        <div>
          <label class="form-label">⏱ 기본 준비시간 <span class="req">*</span></label>
          <div class="input-group">
            <input type="text" name="prepare_time" class="form-control" placeholder="4">
            <span class="input-unit">시간</span>
          </div>
          <p class="input-hint">주문 확정 후 음식 준비 소요 시간</p>
        </div>
      </div>
    </div>

    <!-- 4. 환불 정책 -->
    <div class="form-card">
      <p class="section-title"><span class="section-num">4</span> 환불 정책 설정</p>
      <div class="row3">
        <div>
          <label class="form-label">24시간 전 환불 비율</label>
          <input type="text" name="refund_policy_24" class="form-control" value="100% 환불">
        </div>
        <div>
          <label class="form-label">12시간 전 환불 비율</label>
          <input type="text" name="refund_policy_12" class="form-control" value="50% 환불">
        </div>
        <div>
          <label class="form-label">당일 환불 비율</label>
          <input type="text" name="refund_policy_0" class="form-control" value="환불 불가">
        </div>
      </div>
    </div>

    <!-- 등록 버튼 -->
    <button type="submit" class="btn-submit">🏪 매장 등록하기</button>

    <!-- 안내 박스 -->
    <div class="info-box">
      <p class="info-title">ℹ 매장 등록 안내</p>
      <ul>
        <li>매장 등록 후 메뉴를 추가하고 주문 관리를 시작할 수 있습니다</li>
        <li>모든 정보는 고객에게 공개되므로 정확하게 입력해주세요</li>
        <li>매장 정보는 언제든지 수정할 수 있습니다</li>
      </ul>
    </div>
  </form>
</div>

<script>
  // 이미지 선택 시 파일명 표시
  document.getElementById('imageFile').addEventListener('change', function() {
    if (this.files && this.files[0]) {
      const area = document.querySelector('.image-upload-area p');
      area.textContent = this.files[0].name;
    }
  });
</script>
</body>
</html>
