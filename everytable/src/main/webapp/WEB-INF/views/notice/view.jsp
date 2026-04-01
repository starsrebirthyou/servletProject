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
<!-- 메인 메뉴 부분 : default_decorator에 등록 -->
	<h2>공지 글 보기</h2>
	<table class="table">
		<tbody>
			<tr>
				<th>제목</th>
				<td>[${vo.cateName}] ${vo.title}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${vo.content}</td>
			</tr>
			<c:if test="${!empty vo.fileName}">
				<tr>
					<th>
						이미지<br>
					</th>
					<td colspan="1" id="imgTD">
						<img alt="공지사항 이미지" class="img-fluid" src="${vo.fileName}" style="max-width: 600px;
	  						width: 100%;height: auto;">
					</td>
				</tr>
			</c:if>
			<tr>
				<th>작성일</th>
				<td>${vo.writeDate}</td>
			</tr>
			<c:if test="${!empty vo.updateDate}">
				<tr>
					<th>수정일</th>
					<td>${vo.updateDate}</td>
				</tr>
			</c:if>
		</tbody>
	</table>
	<%-- <c:if test="${!empty login && login.gradeNo == 9}"> --%>
		<a href="updateForm.do?no=${param.no}&page=${param.page}&perPageNum=${param.perPageNum}
			&key=${param.key}" class="btn btn-primary">수정</a>
		<a id="deleteBtn" class="btn btn-danger">삭제</a>
	<%-- </c:if> --%>
	<a href="list.do?page=${param.page}&perPageNum=${param.perPageNum}&key=${param.key}" 
		class="btn btn-warning">리스트</a>
	
</body>
</html>