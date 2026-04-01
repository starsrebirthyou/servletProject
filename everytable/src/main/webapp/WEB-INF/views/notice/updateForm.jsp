<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>공지 수정</title>

<!-- Bootstrap / jQuery / awesome4(icon) 라이브러리 등록 : default_decorator에 등록 -->

<script type="text/javascript">
$(function(){
    // 취소 버튼
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
            
            // 현재 이미지 업데이트
            let previewSrc = $("#previewImg").attr("src");
            $("#currentImgArea").html(
                "<img id='currentImg' src='" + previewSrc + "' style='max-width: 200px; width: 100%; height: auto;'><br>"
            );
            
            // deleteImage 플래그 초기화 & 삭제 버튼 다시 표시
            $("#deleteImage").val("N");
            $("#deleteImageBtn").show();
        }
        $("#changeImageModal").modal("hide");
    });

    // 이미지 삭제 버튼
    $("#deleteImageBtn").click(function(){
        if (confirm("이미지를 삭제하시겠습니까?")) {
            // 현재 이미지 영역 비우기
            $("#currentImgArea").html("");
            // 삭제 버튼 숨기기
            $("#deleteImageBtn").hide();
            // 삭제 플래그 세팅
            $("#deleteImage").val("Y");
            // 모달에서 선택한 파일 초기화
            $("#imageFile").val("");
        }
    });
    
    $("#changeImageModal").on("hidden.bs.modal", function(){
        $("#modalImageFile").val("");
        $("#previewImg").attr("src", "").hide();
    });
});
</script>

</head>
<body>
	<h2>공지 수정</h2>
	<!-- URL & Header & body(data)로 넘기는 방식 : post -- 넘어가는 데이터가 보이지 않는다. -->
	<form action="update.do" method="post" enctype="multipart/form-data">
    <input type="hidden" name="no" value="${vo.no}">
	  <input type="hidden" name="page" value="${param.page}">
	  <input type="hidden" name="perPageNum" value="${param.perPageNum}">
    <input type="hidden" name="delFileName" value="${vo.fileName}">

	  <div class="mb-3 mt-3">
	    <label for="cateNo" class="form-label">카테고리</label>
        <div class="d-inline-flex">
		  <select class="form-select" name="cateNo" id="cateNo">
		    <option value="1" ${vo.cateNo == 1 ? 'selected' : ''}>공지사항</option>
		    <option value="2" ${vo.cateNo == 2 ? 'selected' : ''}>시스템</option>
		    <option value="3" ${vo.cateNo == 3 ? 'selected' : ''}>이벤트</option>
		    <option value="4" ${vo.cateNo == 4 ? 'selected' : ''}>업데이트</option>
	      </select>
	    </div>
      </div>
	  <div class="mb-3 mt-3">
	    <label for="title" class="form-label">제목</label>
	    <input type="text" class="form-control" id="title" placeholder="제목을 입력하세요." name="title"
	    		title="제목은 필수 입력 항목입니다." value="${vo.title}" required>
	  </div>
	  <div class="mb-3 mt-3">
        <label for="content">내용</label>
        <textarea class="form-control" rows="5" id="content" placeholder="내용을 입력하세요." name="content"
        		required>${vo.content}</textarea>
      </div>
      <input type="hidden" name="deleteImage" id="deleteImage" value="N">
	  <div class="mb-3 mt-3">
	    <label for="imageFile" class="form-label">이미지</label>
	    <div id="currentImgArea">
	        <c:if test="${!empty vo.fileName}">
	            <img id="currentImg" src="${vo.fileName}"
	                 style="max-width: 200px; width: 100%; height: auto;"><br>
	        </c:if>
	    </div>
    		<!-- 변경/삭제 버튼 -->
        <button type="button" class="btn btn-success btn-sm mt-2"
        		 data-bs-toggle="modal" data-bs-target="#changeImageModal">변경</button>
		<button type="button" class="btn btn-danger btn-sm mt-2" id="deleteImageBtn"
        		 style="${empty vo.fileName ? 'display:none;' : ''}">삭제</button>
	    <input type="file" class="form-control" id="imageFile" name="imageFile" style="display:none;">
	  </div>

	  <button type="submit" class="btn btn-primary">수정</button>
	  <button type="reset" class="btn btn-warning">리셋</button>
	  <button type="button" class="cancelBtn btn btn-secondary">취소</button>
	</form>
	
	<!-- 이미지 변경 모달 -->
	<div class="modal fade" id="changeImageModal" tabindex="-1">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title">이미지 변경</h5>
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