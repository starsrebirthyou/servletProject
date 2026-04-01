<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 리스트</title>
<!-- Bootstrap 라이브러리 등록 : default_decorator에 등록 -->
<!--  jQuery 라이브러리 등록 - 자비스크립트 함수 : jQuery() ==> $() : default_decorator에 등록 -->
   
<style type="text/css">
/* :hover - 마우스가 올라갔을 때 CSS. 공백 없이 :hover 작성 */
.dataRow:hover{
  /* background: #888;  /* 배경색 변경 - Bootstrap 5에서 적용이 안 됨 */
  cursor: pointer;  /* 손가락 */
}
/* 상태 변경 버튼, 등급 변경 버튼 */
.changeStatusBtn, .changeGradeNoBtn{
  display: none;
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
		let id = $(this).find(".id").text();  // js = jQuery
		//alert("클릭한 글 번호 : " + no);  // js
		// 페이지 이동 시키기 - 브라우저 객체 중 location 객체가 있다. 보여지는 페이지들의 정보를 가지고 있는 객체
		// location 객체 - BOM 객체 중 하나
		// location.href = "view.jsp?no=" + no;  // location = "url" == location.href = "url"
		// location = "url" : 자동으로 location.href에 들어간다
		location = "view.do?id=" + id + "&inc=1";
	}).mouseover(function(){
		$(this).addClass("table-success");
	}).mouseout(function(){
		$(this).removeClass("table-success");
	})
	
	$(".dataRow").on("click", ".noMove", function(event){
		// 페이지 이동을 막는다.
		//event.preventDefault();
		//alert("페이지 이동 막음...");
		return false;
	});
	
	// 상태 값이 변경되면 상태 변경 버튼이 나타나야 한다.
	$(".status").on("change", function(){
		//alert("상태 값이 변경되었습니다.");
		// next() - 다음에 나오는 요소 객체(태그)
		// prev() - 앞에 있는 요소 객체(태그)
		// parent() - 부모에 해당되는 태그
		$(this).next().show();
	});
	
	$(".gradeNo").on("change", function(){
		//alert("상태 값이 변경되었습니다.");
		// next() - 다음에 나오는 요소 객체(태그)
		// prev() - 앞에 있는 요소 객체(태그)
		// parent() - 부모에 해당되는 태그
		$(this).next().show();
	});
	
	// 나타난 상태 수정 버튼을 클릭했을 때 처리
	$(".changeStatusBtn").on("click", function(){
		//alert("상태 수정 버튼 클릭!!")
		// id와 상태 데이터 찾아와야한다.
		// closest() - 조상 객체 중에서 제일 처음 만나는 요소 객체(태그)
		// text() - 태그 안에 글자 가져오기, text("text") - 태그 안에 글자 넣기
		let id = $(this).closest(".dataRow").find(".id").text();
		let status = $(this).closest(".dataRow").find(".status").val();
		//alert("id : " + id + ", status : " + status);
		location = "changeStatus.do?id=" + id + "&status=" + status;
	});
	
	// 나타난 상태 수정 버튼을 클릭했을 때 처리
	$(".changeGradeNoBtn").on("click", function(){
		//alert("등급 수정 버튼 클릭!!")
		// id와 등급 데이터 찾아와야 한다.
		// closest() - 조상 객체 중에서 제일 처음 만나는 요소 객체(태그)
		// text() - 태그 안에 글자 가져오기, text("text") - 태그 안에 글자 넣기
		let id = $(this).closest(".dataRow").find(".id").text();
		let gradeNo = $(this).closest(".dataRow").find(".gradeNo").val();
		//alert("id : " + id + ", status : " + status);
		location = "changeGrade.do?id=" + id + "&gradeNo=" + gradeNo;
	});
})
</script>
</head>
<body>

<!-- 메인 메뉴 부분 : default_decorator에 등록 -->

	<h2>회원 리스트</h2>
	<table class="table">
		<thead class="table-dark">
			<tr>
				<th>아이디</th>
				<th>이름</th>
				<th>성별</th>
				<th>생년월일</th>
				<th>연락처</th>
				<th>이메일</th>
				<th>상태</th>
				<th>등급</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${empty list}">
			<tr>
				<td colspan="5">데이터가 존재하지 않습니다.</td>
			</tr>
		</c:if>
		<c:if test="${!empty list}">
			<c:forEach items="${list}" var="vo">
				<tr class="dataRow">
					<td class="id">${vo.id}</td>
					<td>${vo.name}</td>
					<td>${vo.gender}</td>
					<td>${vo.birth}</td>
					<td>${vo.tel}</td>
					<td>${vo.email}</td>
					<td>
					  <div class="d-inline-flex">
						  <!-- select tag - 풀다운 메뉴. option tag가 나타남.
						  	   option tag에 보여주는 데이터와 값이 다른 경우는 안에 value 속성 안에 값을 넣어둔다.
						  	   DB에 가져온 데이터 적용 - option tag 안에 selected라는 속성을 붙여준다. -->
						  <select class="form-select noMove status">
						    <option ${(vo.status == "정상")?"selected":""}>정상</option>
						    <option ${(vo.status == "탈퇴")?"selected":""}>탈퇴</option>
						    <option ${(vo.status == "강퇴")?"selected":""}>강퇴</option>
						    <option ${(vo.status == "휴면")?"selected":""}>휴면</option>
						  </select>
						  <button class="btn btn-warning noMove changeStatusBtn" style="width: 100px">수정</button>
					  </div>
					</td>
					<td>
					  <div class="d-inline-flex">
						  <!-- select tag - 풀다운 메뉴. option tag가 나타남.
						  	   option tag에 보여주는 데이터와 값이 다른 경우는 안에 value 속성 안에 값을 넣어둔다.
						  	   DB에 가져온 데이터 적용 - option tag 안에 selected라는 속성을 붙여준다. -->
						  <select class="form-select noMove gradeNo">
						    <option value="1" ${(vo.gradeNo == 1)?"selected":""}>일반회원</option>
						    <option value="9" ${(vo.gradeNo == 9)?"selected":""}>관리자</option>
						  </select>
						  <button class="btn btn-warning noMove changeGradeNoBtn" style="width: 100px">수정</button>
					  </div>
					</td>
				</tr>
			</c:forEach>
		</c:if>
		</tbody>
	</table>
	<a href="list.do" class="btn btn-success">새로고침</a>

<%-- JSP의 주석 : 표현식으로 가져온 데이터 출력 --%>
<%--= list --%>
</body>
</html>