<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 등록</title>

<!-- Bootstrap 라이브러리 등록 : default_decorator에 등록 -->

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
                "<img src='" + previewSrc + "' style='max-width: 200px; width: 100%; height: auto;'><br>"
            );
            // 삭제 버튼 표시
            $("#deleteImageBtn").show();
        }
        $("#changeImageModal").modal("hide");
    });

    // 이미지 삭제 버튼
    $("#deleteImageBtn").click(function(){
        // 이미지 영역 비우기
        $("#currentImgArea").html("");
        // 파일 input 초기화
        $("#imageFile").val("");
        // 삭제 버튼 숨기기
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
	<!-- URL & Header & body(data)로 넘기는 방식 : post -- 넘어가는 데이터가 보이지 않는다. -->
	<form action="write.do" method="post" enctype="multipart/form-data">
	  <input type="hidden" name="perPageNum" value="${param.perPageNum}">
	  <div class="mb-3 mt-3">
	    <label for="cateNo" class="form-label">카테고리</label>
        <div class="d-inline-flex">
		  <select class="form-select" name="cateNo" id="cateNo">
		    <option value="1">공지사항</option>
		    <option value="2">시스템</option>
		    <option value="3">이벤트</option>
		    <option value="4">업데이트</option>
	      </select>
	    </div>
      </div>
	  <div class="mb-3 mt-3">
	    <label for="title" class="form-label">제목</label>
	    <input type="text" class="form-control" id="title" placeholder="제목을 입력하세요." name="title"
	    		title="제목은 필수 입력 항목입니다." required>
	  </div>
	  <div class="mb-3 mt-3">
        <label for="content">내용</label>
        <textarea class="form-control" rows="5" id="content" placeholder="내용을 입력하세요." name="content"
        		required></textarea>
      </div>
	  <div class="mb-3 mt-3">
	    <label class="form-label">이미지</label>
	    <div id="currentImgArea"></div>
	    <button type="button" class="btn btn-success btn-sm mt-2"
	            data-bs-toggle="modal" data-bs-target="#changeImageModal">등록</button>
	    <!-- 처음엔 숨겨두고 이미지 선택 시 표시 -->
    		<button type="button" class="btn btn-danger btn-sm mt-2" id="deleteImageBtn"
    				style="display:none;">삭제</button>
    		<input type="file" name="imageFile" id="imageFile" style="display:none;">
	  </div>

	  <button type="submit" class="btn btn-primary">등록</button>
	  <button type="reset" class="btn btn-warning">리셋</button>
	  <button type="button" class="cancelBtn btn btn-secondary">취소</button>
	</form>
	
	<!-- 이미지 등록 모달 -->
	<div class="modal fade" id="changeImageModal" tabindex="-1">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title">이미지 등록</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	            </div>
	            <div class="modal-body">
	                <input type="file" class="form-control" id="modalImageFile" accept="image/*">
	                <img id="previewImg" src="" style="max-width: 100%; margin-top: 10px; display:none;">
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-primary" id="confirmChangeBtn">선택</button>
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>