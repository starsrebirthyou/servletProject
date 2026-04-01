<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="pageObject" required="true"
 type="everytable.util.page.PageObject" %>
<%@ attribute name="listURI" required="true"
 type="java.lang.String" %>
<%@ attribute name="query" required="false"
 type="java.lang.String" %> 

<% /** PageNation을 위한 사용자 JSP 태그  *
	 * 작성자 웹짱 이영환 강사 
	 * 작성일 2026.02.19
	 * 버전 5.1
	 * 환경 JDK 17, Tomcat 10.1, Bootstrap 5, awesome 4 - icon
	 
	 * query 데이터가 있는 경우 - 일반 게시판 페이지 정보로 사용한다. (int=1 --> int=0 으로 바꿔서 사용)
	 *   - listURI="list.do"
	 *	 - query 정보는 페이지 정보 외에 전달할 다른 정보가 있으면 &key=value 형식으로 작성한다.
	 * 사용방법 :<pageNav:pageNav listURI="list.do"
	 			pageObject= "웹짱 페이지 객체" query="일반 게시판 페이지 정보 외 다른 전달 정보" />
   */ %>

<%
	// 클릭이 안되는 아이콘이나 숫자의 색상 : 회색으로 만들어 준다.
	request.setAttribute("noLinkColor", "#999"); 
%>
<% request.setAttribute("tooltip", " data-bs-toggle=\"tooltip\" data-bs-placement=\"top\" "); %>
<% request.setAttribute("noMove", " title=\"no move page!\" "); %>

<ul class="pagination">
  	<li data-page="1" class="page-item">
		<c:if test="${pageObject.page > 1}">
			<!-- 맨 첫페이지로 이동 : query가 없는 경우 - 일반 게시판 페이지 처리 -->
	  		<a href="${listURI }?page=1&${pageObject.notPageQuery}${query}"
	  		  title="click to move first page!" ${tooltip } class="page-link">
	  			<i class="fa fa-backward"></i>
	  		</a>
  		</c:if>
		<c:if test="${pageObject.page == 1 }">
	  		<a href="#" 
	  		 ${noMove }  ${tooltip } class="page-link disabled">
	  			<i class="fa fa-backward" style="color: ${noLinkColor};"></i>
	  		</a>
	  	</c:if>
	</li>
	
	
	<li data-page="${pageObject.startPage -1 }"  class="page-item">
		<c:if test="${pageObject.startPage > 1 }">
	  		<a href="${listURI }?page=${pageObject.startPage - 1 }&${pageObject.notPageQuery}${query}"
	  		  title="click to move previous page group!" ${tooltip } 
	  		  class="page-link">
	  			<i class="fa fa-caret-left"></i>
	  		</a>
	  	</c:if>
	  	<!-- li, a tag 에 class 을 disabled 라고 붙이면 클릭이 안된다.(페이지 이동 불가) -->
		<c:if test="${pageObject.startPage == 1 }">
	  		<a href="#" class="page-link disabled"
	  		 ${noMove } ${tooltip }>
	  			<i class="fa fa-caret-left" style="color: ${noLinkColor};"></i>
	  		</a>
	  	</c:if>
  	</li>
	<c:forEach begin="${pageObject.startPage }" end="${pageObject.endPage }" var="cnt">
  	<li ${(pageObject.page == cnt)?"class=\"active page-item\"":" class=\"page-item\"" } 
  	 data-page=${cnt} >
  	 	<!-- 페이지와 cnt가 같으면 링크가 없음 -->
  	 	<c:if test="${pageObject.page == cnt }">
  			<a href="" onclick="return false" class="page-link"
  			 ${noMove } ${tooltip }>${cnt}</a>
  	 	</c:if>
  	 	<!-- 페이지와 cnt가 같지 않으면 링크가 있음 -->
  	 	<c:if test="${pageObject.page != cnt }">
  			<a href="${listURI }?page=${cnt }&${pageObject.notPageQuery}${query}"
	  		 title="click to move ${cnt } page" ${tooltip }
	  		 class="page-link">${cnt}</a>
  		</c:if>
  	</li>
	</c:forEach>
  	<li data-page="${pageObject.endPage + 1 }"  class="page-item">
	<c:if test="${pageObject.endPage < pageObject.totalPage }">
  		<a href="${listURI }?page=${pageObject.endPage + 1 }&${pageObject.notPageQuery}${query}"
  		  title="click to move next page group!" ${tooltip }
  		  class="page-link">
  			<i class="fa fa-caret-right"></i>
  		</a>
  	</c:if>
	<c:if test="${pageObject.endPage == pageObject.totalPage }">
  		<a href="" onclick="return false" class="page-link"
  		 ${noMove }  ${tooltip } >
  			<i class="fa fa-caret-right" style="color: ${noLinkColor};"></i>
  		</a>
  	</c:if>
  	</li>
  	<li data-page="${pageObject.totalPage }"  class="page-item">
	<c:if test="${pageObject.page < pageObject.totalPage }">
  		<a href="${listURI }?page=${pageObject.totalPage }&${pageObject.notPageQuery}${query}"
  		  title="click to move last page!" ${tooltip } class="page-link">
	  		<i class="fa fa-forward"></i>
  		</a>
  	</c:if>
	<c:if test="${pageObject.page == pageObject.totalPage }">
  		<a href="" onclick="return false"
  		 ${noMove }  ${tooltip } class="page-link">
	  		<i class="fa fa-forward" style="color: ${noLinkColor};"></i>
  		</a>
  	</c:if>
  	</li>
</ul> 

<script>
$(document).ready(function(){
	// Bootstrap 5 에 tooltip 적용하는 javascript 코드 - Bootstrap5가 jQuery를 사용하지 않는 버전이기 때문에
	var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
	var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
	  return new bootstrap.Tooltip(tooltipTriggerEl);
	});
  $(".pagination").mouseover(function(){
//   		$(".tooltip > *:last").css({"background-color": "red", "border": "1px dotted #444"});   
	});
});
</script>
