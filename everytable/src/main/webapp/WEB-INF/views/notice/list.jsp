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
 /* :hover - 마우스가 올라갔을 때 CSS. 공백 없이 :hover 작성 */
 .dataRow:hover{
 	/* background: #888;  /* 배경색 변경 - Bootstrap 5에서 적용이 안 됨 */
 	cursor: pointer;  /* 손가락 */
 }
 </style>
  
<!-- 동작을 시키는 j5 : 위치와 상관없이 코딩할 수 있다. -->
<script type="text/javascript">
// jQuery :: 아래 HTML 로딩이 끝나면 실행해줘 - $() 사이에 실행할 function을 넘긴다. body가 다 로딩이 되면 function이 실행됨
$(function(){
	//alert("jQuery 영역이 실행됐다~~");  // 자바 스크립트의 팝업 열기
	$(".dataRow").click(function(){  // jQuery입니다. 클래스가 dataRow인 것을 찾아서 클릭을 하면 전달된 함수를 실행한다.
		//alert("데이터 클릭 - 글 보기 이동 준비 중...");
		// 글 번호 수집
		// text() - 글자만 가져온다. html() -  tag도 가져온다. :: jQuery
		// js의 변수는 타입이 없다. - 변수 = 10 - 선언 없이 바로 사용 가능. var로 변수 선언. - let으로 변수 선언. - 지역변수 구분 확인
		// 글 번호가 눈으로 보이는 경우 태그에 no 클래스 속성 지정해서 찾는다.
		// let no = $(this).find(".no").text();  // js = jQuery
		// 글 번호가 눈으로 안 보이는 경우 태그 안에 data-항목이름="값" 형식으로 숨겨 놓는다.
		let no = $(this).data("no");  // js = jQuery
		// alert("클릭한 글 번호 : " + no);  // js
		// 페이지 이동 시키기 - 브라우저 객체 중 location 객체가 있다. 보여지는 페이지들의 정보를 가지고 있는 객체
		// location 객체 - BOM 객체 중 하나
		// location.href = "view.jsp?no=" + no;  // location = "url" == location.href = "url"
		// location = "url" : 자동으로 location.href에 들어간다
		location = "view.do?no=" + no + "&${pageObject.pageQuery}&period=${pageObject.period}";
	}).mouseover(function(){
		$(this).addClass("table-success");
	}).mouseout(function(){
		$(this).removeClass("table-success");
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
})
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
    <table class="table">
	  <thead class="table-dark">
		<tr>
			<th>제목</th>
			<th>등록일</th>
			<th>수정일</th>
		</tr>
	  </thead>
	  <tbody>
	  <c:if test="${empty list}">
		<tr>
			<td colspan="5">공지가 존재하지 않습니다.</td>
		</tr>
	  </c:if>
	  <c:if test="${!empty list}">
		<c:forEach items="${list}" var="vo">
			<tr class="dataRow" data-no="${vo.no}">
				<%-- <td class="no">${vo.no}</td> --%>
				<td>[${vo.cateName}] ${vo.title}</td>
				<td>${vo.writeDate}</td>
				<td>${vo.updateDate}</td>
			</tr>
		  </c:forEach>
	    </c:if>
	  </tbody>
    </table>
  <div>
  	<pageNav:pageNav listURI="list.do" pageObject="${pageObject}"/>
  </div>
  <%-- <c:if test="${!empty login && login.gradeNo == 9}"> --%>
	<a href="writeForm.do?perPageNum=${pageObject.perPageNum}" class="btn btn-primary">공지 등록</a>
  <%-- </c:if> --%>

<%-- JSP의 주석 : 표현식으로 가져온 데이터 출력 --%>
<%--= list --%>
</body>
</html>