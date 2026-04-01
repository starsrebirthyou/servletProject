<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 날짜와 숫자 포맷을 위해 fmt 태그 추가 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 상세 정보</title>

<style type="text/css">
    th { width: 200px; background-color: #f8f9fa; }
</style>

<script type="text/javascript">
 $(function(){
     $("")
 });
</script>

</head>
<body>
    <div class="container">
        <h2 class="mt-4 mb-4">결제 상세 정보</h2>
        
        <table class="table">
            <tbody>
                <tr>
                    <th>주문번호</th>
                    <td>${vo.order_id}</td>
                </tr>
                <tr>
                    <th>사용자 아이디</th>
                    <td>${vo.user_id}</td>
                </tr>
                <tr>
                    <th>결제수단</th>
                    <td><span class="badge bg-info text-dark">${vo.method}</span></td>
                </tr>
                <tr>
                    <th>결제금액</th>
                    <td class="text-danger fw-bold">
                        <fmt:formatNumber value="${vo.amount}" />원
                    </td>
                </tr>
                <tr>
                    <th>결제상태</th>
                    <td>
                        <span class="badge ${vo.status == 'SUCCESS' ? 'bg-success' : 'bg-danger'}">
                            ${vo.status}
                        </span>
                    </td>
                </tr>
                <tr>
                    <th>결제일</th>
                    <td><fmt:formatDate value="${vo.payDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
                <c:if test="${!empty vo.updateDate}">
                <tr>
                    <th>최종 수정일</th>
                    <td><fmt:formatDate value="${vo.updateDate}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                </tr>
                </c:if>
            </tbody>
        </table>
        
        <div class="mt-3">
            <a href="list.do?page=${pageObject.page}&perPageNum=${pageObject.perPageNum}&key=${pageObject.key}&word=${pageObject.word}" 
               class="btn btn-warning">리스트</a>
          	
            <a href="updateForm.do?no=${vo.order_id}" class="btn btn-primary">수정</a> 
            <button type="button" class="btn btn-danger" onclick="alert('결제 취소는 관리자에게 문의하세요.')">결제 취소 요청</button>
        
        
        </div>
    </div>
</body>
</html>