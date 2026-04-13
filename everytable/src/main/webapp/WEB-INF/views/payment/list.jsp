<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 내역</title>
<style type="text/css">
    .table { border-collapse: separate; border-spacing: 0; border-radius: 15px; overflow: hidden; border: 1px solid #dee2e6; width: 100%; margin-top: 20px; }
    .table thead th { background-color: #f8f9fa !important; color: #333 !important; padding: 15px; border-bottom: 2px solid #dee2e6; text-align: center; font-weight: bold; }
    .table tbody td { padding: 12px; vertical-align: middle; text-align: center; border-top: 1px solid #dee2e6; }
    .dataRow:hover { cursor: pointer; background-color: #f1f3f5 !important; }
    .badge { padding: 0.5em 0.8em; border-radius: 50rem !important; font-size: 0.85em; }
</style>

<script type="text/javascript">
$(function(){
    $(".dataRow").click(function(){
        let no = $(this).find(".payment_id").text();
        location.href = "view.do?no=" + no 
                      + "&page=${pageObject.page}&perPageNum=${pageObject.perPageNum}"
                      + "&key=${pageObject.key}&word=${pageObject.word}";
    });

    <c:if test="${!empty pageObject.key && !empty pageObject.word }">
        $("#key").val("${pageObject.key}");
        $("#word").val("${pageObject.word}");
    </c:if>
});
</script>
</head>
<body>

    <h2 class="mb-1 fw-normal border-bottom pb-2">
        <c:choose>
            <c:when test="${login.gradeNo == 9}">결제 관리 (전체)</c:when>
            <c:otherwise>나의 결제 내역</c:otherwise>
        </c:choose>
    </h2>
    
    <%-- 검색창 영역: 관리자(9등급)만 보이게 처리 --%>
    <c:if test="${login.gradeNo == 9}">
    <div class="mb-3">
        <form action="list.do" method="get" class="d-inline-flex">
            <input type="hidden" name="perPageNum" value="${pageObject.perPageNum }">
            <select class="form-select me-2" name="key" id="key" style="width: auto;">
                <option value="m">결제수단</option>
                <option value="u">아이디</option>
                <option value="s">결제상태</option>
                <option value="mu">수단/아이디</option>
            </select>
            <div class="input-group">
                <input type="text" class="form-control" placeholder="검색어 입력" name="word" id="word">
                <button class="btn btn-success" type="submit">검색</button>
            </div>
        </form>
    </div>
    </c:if>
    
    <table class="table">
        <thead>
            <tr>
                <th>주문번호</th>
                <%-- 관리자일 때만 아이디 열 표시 --%>
                <c:if test="${login.gradeNo == 9}"><th>아이디</th></c:if>
                <th>결제수단</th>
                <th>결제금액</th>
                <th>상태</th>
                <th>결제일</th>
            </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty list}">
                <tr>
                    <td colspan="${login.gradeNo == 9 ? 6 : 5}" class="text-center">결제 내역이 존재하지 않습니다.</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach items="${list}" var="vo">
                    <tr class="dataRow">
                        <td>${vo.order_id}</td> 
                        <td class="payment_id" style="display:none;">${vo.payment_id}</td>
                        <%-- 관리자일 때만 아이디 데이터 표시 --%>
                        <c:if test="${login.gradeNo == 9}"><td>${vo.user_id}</td></c:if>
                        <td>${vo.method}</td>
                        <td class="fw-bold text-primary">
                            <fmt:formatNumber value="${vo.amount}" pattern="#,###" />원
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${vo.status == 'SUCCESS'}">
                                    <span class="badge bg-success">SUCCESS</span>
                                </c:when>
                                <c:when test="${vo.status == 'REFUNDED'}">
                                    <span class="badge bg-secondary">REFUNDED</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">${vo.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${vo.payDate}" pattern="yyyy-MM-dd HH:mm" /></td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
    
    <div class="d-flex justify-content-center">
        <pageNav:pageNav listURI="list.do" pageObject="${pageObject}" />
    </div>
    
    <div class="mt-3">
        <a href="list.do" class="btn btn-outline-success">새로고침</a>
    </div>

</body>
</html>