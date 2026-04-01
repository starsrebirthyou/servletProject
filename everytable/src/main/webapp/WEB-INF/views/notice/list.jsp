<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 리스트</title>
<!-- Bootstrap / jQuery 라이브러리 등록 : default_decorator에 등록 -->
   
<style type="text/css">
    /* 전체 배경을 살짝 어둡게 하여 테이블을 돋보이게 함 */
    body { background-color: #f8f9fa; }
    
    /* 제목 스타일링 */
    h2 { font-weight: bold; margin-bottom: 20px; color: #212529; }

    /* 카테고리 버튼 그룹 여백 조정 */
    #key { margin-bottom: 20px; }

    /* 테이블을 카드 형식으로 둥글고 그림자 지게 만듦 */
    .table {
        background-color: #ffffff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        border: none;
    }
    
    /* 테이블 헤더 */
    .table thead th {
        background-color: #212529;
        color: #fff;
        border-bottom: none;
        padding: 15px 10px;
    }

    /* 테이블 본문 여백 */
    .table tbody td {
        vertical-align: middle;
        padding: 12px 10px;
        border-bottom: 1px solid #f1f3f5;
    }

    /* 데이터 행 마우스 오버 효과 (자연스러운 전환) */
    .dataRow {
        transition: background-color 0.2s ease;
    }
    .dataRow:hover {
        background-color: #f1f3f5;
        cursor: pointer;
    }
</style>
  
<!-- 동작을 시키는 j5 : 위치와 상관없이 코딩할 수 있다. -->
<script type="text/javascript">
$(function(){
	// 카드 클릭 시 모달 띄우기
	$(".dataRow").click(function(){
		let no = $(this).data("no");
		
		// view.do를 호출하되, 결과 HTML 중 id가 'modalInner'인 부분만 잘라서 가져옵니다.
		let url = "view.do?no=" + no + "&inc=1&page=${pageObject.page}&perPageNum=${pageObject.perPageNum}&key=${pageObject.key} #modalInner";
		
		// 모달 바디 영역에 데이터를 로드한 후 모달 창을 엽니다.
		$("#noticeModalBody").load(url, function() {
			$("#noticeModal").modal("show");
		});
	});

	// 카테고리 버튼 클릭
    $("#key button").click(function(e){
        e.preventDefault();  // 폼 기본 제출 방지
        let key = $(this).val();  // 버튼의 value 값 수집
        location = "list.do?key=" + key + "&perPageNum=${pageObject.perPageNum}";
    });

 	// 현재 key와 버튼 value가 같으면 활성화
    $("#key button").each(function(){
        if($(this).val() == "${pageObject.key}"){
            $(this).removeClass("btn-outline-success").addClass("btn-success");
        }
    });
});
</script>
</head>
<body>

<!-- 메인 메뉴 부분 : default_decorator에 등록 -->

    <h2>공지사항</h2>
  
    <form class="btn-group" style="margin-top: 20px; margin-bottom: 10px;" name="key" id="key">
      <button class="btn btn-outline-success" value="0">전체</button >
      <button class="btn btn-outline-success" style="margin-left: 5px" value="1">공지사항</button >
      <button class="btn btn-outline-success" style="margin-left: 5px" value="2">시스템</button >
      <button class="btn btn-outline-success" style="margin-left: 5px" value="3">이벤트</button >
      <button class="btn btn-outline-success" style="margin-left: 5px" value="4">업데이트</button >
    </form>
	<div class="notice-list mt-3">
	    <c:if test="${empty list}">
	        <div class="alert alert-secondary text-center">공지가 존재하지 않습니다.</div>
	    </c:if>
	    <c:if test="${!empty list}">
	        <c:forEach items="${list}" var="vo">
	            <div class="card mb-3 dataRow" data-no="${vo.no}" style="border-radius: 12px; border: 1px solid #d1e7dd;">
	                <div class="card-body">
	                    <div class="d-flex align-items-center mb-2">
	                        <span class="badge text-success bg-success bg-opacity-10 border border-success me-2">
	                            ${vo.cateName}
	                        </span>
	                    </div>
	                    
	                    <h5 class="card-title fw-bold text-dark mb-3">${vo.title}</h5>
	                    
	                    <div class="text-secondary d-flex align-items-center" style="font-size: 0.85rem;">
	                        <span class="me-3"><i class="fa fa-calendar"></i> ${vo.writeDate}</span>
	                        <span class="me-3"><i class="fa fa-eye"></i> ${vo.hit}</span>
	                        <span><i class="fa fa-user"></i> 에브리테이블 관리자</span>
	                    </div>
	                </div>
	            </div>
	        </c:forEach>
	    </c:if>
	</div>
  <div>
  	<pageNav:pageNav listURI="list.do" pageObject="${pageObject}"/>
  </div>
  <c:if test="${!empty login && login.gradeNo == 9}">
	<a href="writeForm.do?perPageNum=${pageObject.perPageNum}" class="btn btn-primary">공지 등록</a>
  </c:if>

<%-- JSP의 주석 : 표현식으로 가져온 데이터 출력 --%>
<%--= list --%>
	<div class="modal fade" id="noticeModal" tabindex="-1" aria-hidden="true">
	    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
	        <div class="modal-content" id="noticeModalBody" style="border-radius: 16px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
	            </div>
	    </div>
	</div>
</body>
</html>