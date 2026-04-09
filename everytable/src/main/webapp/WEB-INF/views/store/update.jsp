<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매장 수정</title>

<style>
/* 기존 스타일 그대로 유지 */
body { background: #f4f4f2; font-family: 'Pretendard', 'Apple SD Gothic Neo', sans-serif; margin: 0; }

/* ... (중간 스타일 동일, 생략 없이 그대로 유지해도 OK) */

.image-upload-area {
  border: 2px dashed #d0d0cc;
  border-radius: 12px;
  padding: 48px 20px;
  text-align: center;
  cursor: pointer;
}
.image-upload-area:hover { border-color: #1e5f3e; background: #f0f7f3; }

.form-card {
  background: #fff;
  border-radius: 14px;
  padding: 28px;
  margin-bottom: 16px;
}

.section-title {
  font-weight: 700;
  margin-bottom: 16px;
}

.form-control {
  width: 100%;
  padding: 10px;
  border-radius: 8px;
  border: 1px solid #ddd;
}
</style>
</head>

<body>
<div style="max-width:780px; margin:0 auto; padding:20px;">

<form action="update.do" method="post" enctype="multipart/form-data">

<input type="hidden" name="store_id" value="${vo.store_id}">

<!-- ========================= -->
<!-- 1. 매장 대표 이미지 (수정됨) -->
<!-- ========================= -->
<div class="form-card">
  <p class="section-title">1. 매장 대표 이미지</p>

  <!-- 탭 -->
  <div style="display:flex; gap:8px; margin-bottom:16px;">
    <button type="button" id="tabFile" onclick="switchTab('file')"
      style="flex:1; padding:10px; border-radius:9px; border:1.5px solid #1e5f3e;
             background:#1e5f3e; color:#fff; font-weight:700;">
      📁 파일 업로드
    </button>

    <button type="button" id="tabUrl" onclick="switchTab('url')"
      style="flex:1; padding:10px; border-radius:9px; border:1.5px solid #e0e0dc;
             background:#fff; color:#555; font-weight:700;">
      🔗 이미지 URL
    </button>
  </div>

  <!-- 파일 업로드 -->
  <div id="areaFile">
    <div class="image-upload-area" onclick="document.getElementById('imageFile').click()">
      <p id="fileLabel">클릭하여 이미지 변경</p>
    </div>

    <c:if test="${not empty vo.filename}">
      <p>📎 현재 파일: ${vo.filename}</p>
    </c:if>

    <input type="file" name="imageFile" id="imageFile" accept="image/*" style="display:none;">
  </div>

  <!-- URL 입력 -->
  <div id="areaUrl" style="display:none;">
    <label>이미지 URL</label>
    <input type="text" name="filename" id="imageUrlInput"
           class="form-control"
           value="${vo.filename}"
           placeholder="https://example.com/image.jpg">

    <!-- 미리보기 -->
    <div id="urlPreview" style="margin-top:12px; display:none;">
      <img id="previewImg"
           style="width:100%; max-height:200px; object-fit:cover; border-radius:10px;">
    </div>
  </div>
</div>

<!-- ========================= -->
<!-- 나머지 영역 (기존 그대로) -->
<!-- ========================= -->

<div class="form-card">
  <p class="section-title">2. 기본 정보</p>

  <input type="text" name="store_name" value="${vo.store_name}" class="form-control"><br>
  <input type="text" name="store_addr" value="${vo.store_addr}" class="form-control"><br>
  <input type="text" name="store_tel" value="${vo.store_tel}" class="form-control">
</div>

<button type="submit" style="width:100%; padding:14px; background:#1e5f3e; color:#fff; border:none;">
  수정하기
</button>

</form>
</div>

<!-- ========================= -->
<!-- script -->
<!-- ========================= -->
<script>
// 파일명 표시
document.getElementById('imageFile').addEventListener('change', function() {
  if (this.files && this.files[0]) {
    document.getElementById('fileLabel').textContent = this.files[0].name;
  }
});

// 탭 전환
function switchTab(tab) {
  const isFile = tab === 'file';

  document.getElementById('areaFile').style.display = isFile ? 'block' : 'none';
  document.getElementById('areaUrl').style.display  = isFile ? 'none' : 'block';

  const btnFile = document.getElementById('tabFile');
  const btnUrl  = document.getElementById('tabUrl');

  if (isFile) {
    btnFile.style.background = '#1e5f3e';
    btnFile.style.color = '#fff';

    btnUrl.style.background = '#fff';
    btnUrl.style.color = '#555';

    document.getElementById('imageUrlInput').value = '';
  } else {
    btnUrl.style.background = '#1e5f3e';
    btnUrl.style.color = '#fff';

    btnFile.style.background = '#fff';
    btnFile.style.color = '#555';
  }
}

// URL 미리보기
document.getElementById('imageUrlInput').addEventListener('input', function() {
  const url = this.value.trim();
  const preview = document.getElementById('urlPreview');
  const img = document.getElementById('previewImg');

  if (url) {
    img.src = url;
    preview.style.display = 'block';

    img.onerror = function() {
      preview.style.display = 'none';
    };
  } else {
    preview.style.display = 'none';
  }
});
</script>

</body>
</html>