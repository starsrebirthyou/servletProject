<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 내역 리스트</title>

<style type="text/css">
.dataRow:hover {
    cursor: pointer;
}
</style>

<script type="text/javascript">
 $(function(){
     $(".dataRow").click(function(){
         // 1. 주문번호 가져오기
         let no = $(this).find(".order_id").text();
         
         // 2. [수정] 상세 보기 페이지로 이동하는 코드가 반드시 있어야 합니다!
         // 클릭했을 때 브라우저 주소창에 ?no=번호 가 붙어서 넘어가게 해줘요.
         location.href = "view.do?no=" + no 
                       + "&page=${pageObject.page}&perPageNum=${pageObject.perPageNum}"
                       + "&key=${pageObject.key}&word=${pageObject.word}";
                       
     }).mouseover(function(){
         $(this).addClass("table-success");
     }).mouseout(function(){
         $(this).removeClass("table-success");
     });
 });
</script>

<%-- 검색 데이터 세팅 스크립트 --%>
<c:if test="${!empty pageObject.key && !empty pageObject.word }">
    <script type="text/javascript">
        $(function(){
            $("#key").val("${pageObject.key}");
            $("#word").val("${pageObject.word}");
        });
    </script>
</c:if>

</head>
<body>

    <h2>결제 내역 리스트</h2>
    
    <div>
        <form action="list.do" method="get">
            <input type="hidden" name="perPageNum" value="${pageObject.perPageNum }">
            
            <div class="d-inline-flex">
              <select class="form-select" name="key" id="key">
                <option value="m">결제수단</option>
                <option value="u">아이디</option>
                <option value="s">결제상태</option>
                <option value="mu">수단/아이디</option>
              </select>
                <div class="input-group mb-3">
                  <input type="text" class="form-control" placeholder="검색어 입력" name="word" id="word">
                  <button class="btn btn-success" type="submit">검색</button>
                </div>
            </div>
        </form>
    </div>
    
    <table class="table">
        <thead class="table-dark">
            <tr>
                <th>주문번호</th>
                <th>아이디</th>
                <th>결제수단</th>
                <th>결제금액</th>
                <th>상태</th>
                <th>결제일</th>
            </tr>
        </thead>
        <tbody>
        <c:if test="${empty list }">
            <tr>
                <td colspan="6" class="text-center">결제 내역이 존재하지 않습니다.</td>
            </tr>
        </c:if>
        <c:if test="${!empty list }">
            <c:forEach items="${list }" var="vo" >
                <tr class="dataRow">
                    <td class="order_id">${vo.order_id }</td>
                    <td>${vo.user_id }</td>
                    <td>${vo.method }</td>
                    <td>${vo.amount }원</td>
                    <td>
                        <span class="badge ${vo.status == 'SUCCESS' ? 'bg-success' : 'bg-danger'}">
                            ${vo.status }
                        </span>
                    </td>
                    <td>${vo.payDate }</td>
                </tr>
            </c:forEach>
        </c:if>
        </tbody>
    </table>
    
    <div>
        <pageNav:pageNav listURI="list.do" pageObject="${pageObject }" />
    </div>
    
    <div class="mt-3">
        <a href="list.do" class="btn btn-success">새로고침</a>
    </div>

</body>
</html>