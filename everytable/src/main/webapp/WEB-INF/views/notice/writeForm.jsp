<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 등록</title>

<style type="text/css">
    body { background-color: #f8f9fa; }
    h2 { font-weight: bold; margin-bottom: 25px; color: #212529; }
    
    /* 입력 폼 전체 카드 스타일 */
    .form-container {
        background-color: #ffffff;
        padding: 40px;
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        border: 1px solid #eaeaea;
        margin-bottom: 40px;
    }
    
    /* 라벨 텍스트 강조 */
    .form-label { font-weight: 600; color: #495057; margin-bottom: 8px; }
    
    /* 입력창 디자인 (포커스 시 녹색 테마) */
    .form-control, .form-select {
        border: 1px solid #ced4da;
        border-radius: 8px;
        padding: 12px 15px;
        transition: all 0.2s;
    }
    .form-control:focus, .form-select:focus {
        border-color: #198754;
        box-shadow: 0 0 0 0.2rem rgba(25, 135, 84, 0.25);
    }
    
    /* 이미지 업로드 영역 테두리 */
    .img-upload-box {
        border: 1px dashed #ced4da;
        border-radius: 8px;
        padding: 20px;
        background-color: #f8f9fa;
        min-height: 100px;
    }
    
    /* 하단 버튼 스타일 */
    .btn-submit { background-color: #0f7a54; color: white; border: none; padding: 10px 25px; border-radius: 8px; font-weight: 500;}
    .btn-submit:hover { background-color: #0c6344; color: white; }
    .btn-action { padding: 10px 25px; border-radius: 8px; font-weight: 500;}
</style>

<script type="text/javascript">
$(function(){
	$(".cancelBtn").click(function(){
		history.back();
	});
	
    // 모달 - 이미지 미리보기
    $("#modalImageFile").change(function(){
        let file = this.files[0];
        if (file) {
            let reader = new FileReader();
            reader.onload = function(e) {
                $("#previewImg").attr("src", e.target.result).show();
            }
            reader.readAsDataURL(file);
        }
    });

    // 모달 - 선택 버튼
    $("#confirmChangeBtn").click(function(){
        let file = $("#modalImageFile")[0].files[0];
        if (file) {
            let dt = new DataTransfer();
            dt.items.add(file);
            $("#imageFile")[0].files = dt.files;

            let previewSrc = $("#previewImg").attr("src");
            $("#currentImgArea").html(
                "<img src='" + previewSrc + "' class='rounded shadow-sm' style='max-width: 200px; width: 100%; height: auto;'><br>"
            );
            // 삭제 버튼 표시
            $("#deleteImageBtn").show();
        }
        $("#changeImageModal").modal("hide");
    });

    // 이미지 삭제 버튼
    $("#deleteImageBtn").click(function(){
        $("#currentImgArea").html("");
        $("#imageFile").val("");
        $("#deleteImageBtn").hide();
    });

    // 모달 닫힐 때 초기화
    $("#changeImageModal").on("hidden.bs.modal", function(){
        $("#modalImageFile").val("");
        $("#previewImg").attr("src", "").hide();
    });
});
</script>
</head>
<body>
	<h2>공지 등록</h2>
	
    <div class="form-container">
        <form action="write.do" method="post" enctype="multipart/form-data">
            <input type="hidden" name="perPageNum" value="${param.perPageNum}">
            
            <div class="mb-4">
                <label for="cateNo" class="form-label">카테고리</label>
                <div class="d-inline-flex w-25">
                <select class="form-select" name="cateNo" id="cateNo">
                    <option value="1">공지사항</option>
                    <option value="2">시스템</option>
                    <option value="3">이벤트</option>
                    <option value="4">업데이트</option>
                </select>
                </div>
            </div>
            
            <div class="mb-4">
                <label for="title" class="form-label">제목</label>
                <input type="text" class="form-control" id="title" placeholder="제목을 입력하세요." name="title" title="제목은 필수 입력 항목입니다." required>
            </div>
            
            <div class="mb-4">
                <label for="content" class="form-label">내용</label>
                <textarea class="form-control" rows="8" id="content" placeholder="내용을 입력하세요." name="content" required></textarea>
            </div>
            
            <div class="mb-5">
                <label class="form-label">이미지 첨부</label>
                <div class="img-upload-box text-center">
                    <div id="currentImgArea" class="mb-2 text-muted">선택된 이미지가 없습니다.</div>
                    <button type="button" class="btn btn-outline-success btn-sm mt-2" data-bs-toggle="modal" data-bs-target="#changeImageModal">
                        <i class="fa fa-image"></i> 이미지 등록
                    </button>
                    <button type="button" class="btn btn-outline-danger btn-sm mt-2" id="deleteImageBtn" style="display:none;">삭제</button>
                    <input type="file" name="imageFile" id="imageFile" style="display:none;">
                </div>
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-submit me-2">등록 완료</button>
                <button type="reset" class="btn btn-outline-secondary btn-action me-2">초기화</button>
                <button type="button" class="cancelBtn btn btn-outline-dark btn-action">취소</button>
            </div>
        </form>
    </div>
	
	<div class="modal fade" id="changeImageModal" tabindex="-1">
	    <div class="modal-dialog modal-dialog-centered">
	        <div class="modal-content border-0 shadow">
	            <div class="modal-header">
	                <h5 class="modal-title fw-bold">이미지 등록</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	            </div>
	            <div class="modal-body p-4 text-center">
	                <input type="file" class="form-control mb-3" id="modalImageFile" accept="image/*">
	                <img id="previewImg" class="rounded shadow-sm" src="" style="max-width: 100%; display:none;">
	            </div>
	            <div class="modal-footer border-0">
	                <button type="button" class="btn btn-submit" id="confirmChangeBtn">선택 완료</button>
	                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>