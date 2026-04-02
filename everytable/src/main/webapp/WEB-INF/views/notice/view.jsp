<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 보기</title>

<!-- Bootstrap / jQuery / awesome4(icon) 라이브러리 등록 : default_decorator에 등록 -->

<!-- 동작을 시키는 j5 : 위치와 상관없이 코딩할 수 있다. -->
<script type="text/javascript">
// jQuery :: 아래 HTML 로딩이 끝나면 실행해줘 - $() 사이에 실행할 function을 넘긴다. body가 다 로딩이 되면 function이 실행됨
$(function(){
	$("#deleteBtn").click(function(){
		if (confirm("삭제하면 복구할 수 없습니다. 삭제하시겠습니까?")) {
			location="delete.do?no=${param.no}&page=${param.page}&perPageNum=${param.perPageNum}";
		}

	});
	$("#deleteImgBtn").click(function(){
		// alert("삭제 버튼 클릭");
		if (!confirm("삭제하면 복구할 수 없습니다. 삭제하시겠습니까?")) return false;
		
		// 삭제하러 간다.
		// 1. 밑에 모달 form의 action 속성을 바꾼다.
		$("#modalForm").attr("action", "delete.do");
		// 2. submit 처리
		$("#modalForm").submit();
	});
});
</script>
</head>
<body>
<div id="modalInner">
    
    <div class="modal-header border-0 pb-0" style="padding: 24px 24px 0 24px;">
        <div>
            <span class="badge bg-success bg-opacity-10 text-success border border-success me-1 px-3 py-2" style="border-radius: 4px; font-weight: 500;">
                ${vo.cateName}
            </span>
            </div>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
    </div>

    <div class="modal-body" style="padding: 20px 24px; overflow-y: auto; max-height: 65vh;">
        <h4 class="fw-bold text-dark mb-3 mt-2">${vo.title}</h4>
        
        <div class="text-secondary mb-3 d-flex align-items-center" style="font-size: 0.9rem;">
            <span class="me-3"><i class="fa fa-user"></i> ${vo.writerName}</span>
			<span class="me-4">
		        <i class="fa fa-calendar"></i> ${vo.writeDate}
		        <c:if test="${!empty vo.updateDate}">
		            <em style="margin-left: 6px; font-size: 0.8rem; font-style: normal; 
		            		opacity: 0.7;">(수정: ${vo.updateDate})</em>
		        </c:if>
			</span>
            <span><i class="fa fa-eye"></i> 조회수 ${vo.hit}</span>
        </div>
        
        <hr class="text-muted opacity-25 mb-4">

        <div class="content-area text-dark" style="white-space: pre-wrap; line-height: 1.7;
        		 font-size: 1rem;">${vo.content}</div>

        <c:if test="${!empty vo.fileName}">
            <div class="text-center mt-4 mb-2">
                <img alt="공지사항 첨부이미지" class="img-fluid rounded" src="${vo.fileName}" style="max-width: 100%;">
            </div>
        </c:if>
        
        <div class="text-end mt-4">
            <c:if test="${!empty login && login.gradeNo == 9}">
	            <a href="updateForm.do?no=${vo.no}&page=${param.page}&perPageNum=${param.perPageNum}&key=${param.key}" class="btn btn-sm btn-outline-secondary">수정</a>
	            <a href="delete.do?no=${vo.no}&page=${param.page}&perPageNum=${param.perPageNum}" class="btn btn-sm btn-outline-danger" onclick="return confirm('삭제하면 복구할 수 없습니다. 삭제하시겠습니까?');">삭제</a>
            </c:if>
        </div>
    </div>

    <div class="modal-footer border-0" style="padding: 0 24px 24px 24px;">
        <button type="button" class="btn w-100 text-white fw-bold py-2" style="background-color: #0f7a54; border-radius: 8px; font-size: 1.05rem;" data-bs-dismiss="modal">
            닫기
        </button>
    </div>

</div>
</body>
</html>