<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>에브리테이블 - 매장 등록</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    :root {
        --primary-green: #436551;
        --light-bg: #F8F9FA;
        --border-color: #E9ECEF;
    }
    body { background-color: var(--light-bg); font-family: 'Pretendard', sans-serif; color: #333; }
    
    .write-container { max-width: 800px; margin: 40px auto; padding: 0 20px; }
    
    /* 상단 환영 배너 */
    .welcome-banner { 
        background-color: var(--primary-green); 
        color: white; 
        border-radius: 20px; 
        padding: 35px; 
        margin-bottom: 30px; 
        display: flex; align-items: flex-start;
    }
    .welcome-icon { font-size: 2.5rem; margin-right: 20px; opacity: 0.9; }
    .step-indicator { font-size: 0.85rem; opacity: 0.8; margin-top: 15px; }

    /* 카드 섹션 공통 */
    .form-card { 
        background: white; 
        border: 1px solid var(--border-color); 
        border-radius: 20px; 
        padding: 40px; 
        margin-bottom: 25px; 
        box-shadow: 0 4px 12px rgba(0,0,0,0.02);
    }
    .section-num { 
        display: inline-block; width: 24px; height: 24px; background: #e8f3ed; 
        color: var(--primary-green); border-radius: 6px; text-align: center; 
        font-weight: 800; font-size: 0.9rem; margin-right: 10px;
    }
    .section-title { font-weight: 700; font-size: 1.25rem; margin-bottom: 30px; }

    /* 이미지 업로드 영역 */
    .image-upload-box {
        border: 2px dashed #DDE2E5;
        border-radius: 15px;
        height: 220px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: 0.3s;
        position: relative;
        overflow: hidden;
    }
    .image-upload-box:hover { background-color: #f1f3f5; border-color: #adb5bd; }
    .upload-preview { 
        position: absolute; width: 100%; height: 100%; object-fit: cover; display: none; 
    }
    
    /* 입력 폼 */
    .label-group { margin-bottom: 20px; }
    .label-group label { display: block; font-weight: 600; margin-bottom: 8px; font-size: 0.95rem; }
    .label-group label .required { color: #e74c3c; margin-left: 3px; }
    .form-control { 
        border-radius: 12px; border: 1px solid var(--border-color); padding: 14px 18px; 
        background-color: #fff; transition: 0.2s;
    }
    .form-control:focus { border-color: var(--primary-green); box-shadow: none; }

    /* 등록 버튼 */
    .btn-submit {
        background-color: var(--primary-green);
        color: white;
        border: none;
        border-radius: 15px;
        padding: 20px;
        width: 100%;
        font-weight: 700;
        font-size: 1.15rem;
        margin-bottom: 30px;
        transition: 0.3s;
    }
    .btn-submit:hover { background-color: #324d3d; transform: translateY(-3px); box-shadow: 0 10px 20px rgba(67,101,81,0.2); }

    /* 안내 박스 */
    .info-box {
        background-color: #F1F6FF;
        border-radius: 15px;
        padding: 25px;
        color: #4A69BD;
        font-size: 0.9rem;
    }
    .info-box ul { margin: 10px 0 0 0; padding-left: 20px; }
    .info-box ul li { margin-bottom: 5px; }
</style>
</head>
<body>

<div class="write-container">
    <div class="welcome-banner">
        <div class="welcome-icon"><i class="fa-solid fa-shop"></i></div>
        <div>
            <h3 class="fw-bold m-0">에브리테이블에 오신 것을 환영합니다!</h3>
            <p class="m-0 mt-1 opacity-75">매장을 등록하고 단체 주문 서비스를 시작해보세요</p>
            <div class="step-indicator">
                <span class="fw-bold">1</span> 매장 정보 입력 &nbsp; <i class="fa-solid fa-chevron-right mx-1"></i> &nbsp;
                <span>2</span> 메뉴 등록 &nbsp; <i class="fa-solid fa-chevron-right mx-1"></i> &nbsp;
                <span>3</span> 주문 관리 시작
            </div>
        </div>
    </div>

    <form action="write.do" method="post" enctype="multipart/form-data" id="writeForm">
        <div class="form-card">
            <h4 class="section-title"><span class="section-num">1</span> 매장 대표 이미지</h4>
            <div class="image-upload-box" id="dropZone">
                <img id="imgPreview" class="upload-preview">
                <i class="fa-regular fa-image fs-1 text-muted mb-3"></i>
                <div class="text-center">
                    <p class="fw-bold mb-1">클릭하여 이미지 업로드</p>
                    <p class="text-muted small">PNG, JPG, WEBP (최대 5MB)</p>
                </div>
                <input type="file" name="imageFile" id="imageFile" style="display:none;" accept="image/*">
            </div>
        </div>

        <div class="form-card">
            <h4 class="section-title"><span class="section-num">2</span> 기본 정보</h4>
            
            <div class="label-group">
                <label>매장명 <span class="required">*</span></label>
                <input type="text" name="store_name" class="form-control" placeholder="예: 한강뷰 레스토랑" required>
            </div>

            <div class="label-group">
                <label>카테고리 <span class="required">*</span></label>
                <select name="store_cate" class="form-control" required>
                    <option value="">카테고리를 선택해주세요</option>
                    <option value="한식">한식</option>
                    <option value="일식">일식</option>
                    <option value="카페">카페/디저트</option>
                    <option value="양식">양식</option>
                </select>
            </div>

            <div class="label-group">
                <label><i class="fa-solid fa-location-dot me-1"></i> 매장 주소 <span class="required">*</span></label>
                <input type="text" name="store_addr" class="form-control" placeholder="예: 서울시 마포구 와우산로 94" required>
            </div>

            <div class="label-group">
                <label><i class="fa-solid fa-phone me-1"></i> 전화번호 <span class="required">*</span></label>
                <input type="tel" name="store_tel" class="form-control" placeholder="예: 02-1234-5678" required>
            </div>
        </div>

        <div class="form-card">
            <h4 class="section-title"><span class="section-num">3</span> 운영 정보</h4>
            
            <div class="label-group">
                <label><i class="fa-regular fa-clock me-1"></i> 영업시간 <span class="required">*</span></label>
                <input type="text" name="open_time" class="form-control" placeholder="10:00 - 22:00" required>
                <small class="text-muted mt-2 d-block">예: 10:00 - 22:00 (매일 동일)</small>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="label-group">
                        <label><i class="fa-solid fa-won-sign me-1"></i> 최소 주문금액 <span class="required">*</span></label>
                        <div class="input-group">
                            <input type="number" name="min_order_price" class="form-control" placeholder="200000" required>
                            <span class="input-group-text bg-white border-start-0" style="border-radius:0 12px 12px 0;">원</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="label-group">
                        <label><i class="fa-regular fa-hourglass-half me-1"></i> 기본 준비시간 <span class="required">*</span></label>
                        <div class="input-group">
                            <input type="number" name="prepare_time" class="form-control" placeholder="4" required>
                            <span class="input-group-text bg-white border-start-0" style="border-radius:0 12px 12px 0;">시간</span>
                        </div>
                        <small class="text-muted mt-2 d-block">주문 확정 후 음식 준비 소요 시간</small>
                    </div>
                </div>
            </div>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fa-solid fa-file-signature me-2"></i> 매장 등록하기
        </button>

        <div class="info-box">
            <p class="fw-bold m-0"><i class="fa-solid fa-circle-info me-2"></i>매장 등록 안내</p>
            <ul>
                <li>매장 등록 후 메뉴를 추가하고 주문 관리를 시작할 수 있습니다</li>
                <li>모든 정보는 고객에게 공개되므로 정확하게 입력해주세요</li>
                <li>매장 정보는 언제든지 수정할 수 있습니다</li>
            </ul>
        </div>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function(){
    // 이미지 업로드 클릭 이벤트
    $("#dropZone").click(function(){
        $("#imageFile").click();
    });

    // 이미지 미리보기 기능
    $("#imageFile").change(function(e){
        const file = e.target.files[0];
        if(file) {
            const reader = new FileReader();
            reader.onload = function(e){
                $("#imgPreview").attr("src", e.target.result).fadeIn();
                $("#dropZone i, #dropZone div").hide();
            }
            reader.readAsDataURL(file);
        }
    });

    // 폼 유효성 체크
    $("#writeForm").submit(function(){
        if(!$("#imageFile").val()){
            alert("매장 대표 이미지를 등록해주세요.");
            return false;
        }
    });
});
</script>

</body>
</html>