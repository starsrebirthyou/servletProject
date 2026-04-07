<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 내역 리스트</title>

<style type="text/css">
    /* 1. 테이블 전체 모서리 둥글게 */
    .table {
        border-collapse: separate; 
        border-spacing: 0;
        border-radius: 15px;
        overflow: hidden;
        border: 1px solid #dee2e6;
        width: 100%;
        margin-top: 20px;
    }

    /* 2. 제목 줄 스타일 (기존 table-dark 대신 적용됨) */
    .table thead th {
        background-color: #f8f9fa !important;
        color: #333 !important;
        padding: 15px;
        border-bottom: 2px solid #dee2e6;
        text-align: center;
        font-weight: bold;
    }

    /* 3. 데이터 줄 스타일 */
    .table tbody td {
        padding: 12px;
        vertical-align: middle;
        text-align: center;
        border-top: 1px solid #dee2e6;
    }

    /* 4. 마우스 오버 효과 */
    .dataRow:hover {
        cursor: pointer;
        background-color: #f1f3f5 !important;
    }

    /* 5. 상태 배지 동글동글 */
    .badge {
        padding: 0.5em 0.8em;
        border-radius: 50rem !important; 
        font-size: 0.85em;
    }
</style>

<script type="text/javascript">
$(function(){
    // 1. 행 클릭 시 상세보기 이동
    $(".dataRow").click(function(){
        let no = $(this).find(".payment_id").text();
        location.href = "view.do?no=" + no 
                      + "&page=${pageObject.page}&perPageNum=${pageObject.perPageNum}"
                      + "&key=${pageObject.key}&word=${pageObject.word}";
    });

    // 2. 검색 데이터 자동 세팅
    <c:if test="${!empty pageObject.key && !empty pageObject.word }">
        $("#key").val("${pageObject.key}");
        $("#word").val("${pageObject.word}");
    </c:if>
});
</script>
</head>
<body>

    <h2 class="mb-1 fw-normal border-bottom pb-2">💳 결제 내역 리스트</h2>
    
    <%-- 검색창 영역 --%>
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
    
    <%-- 리스트 테이블 --%>
    <table class="table">
        <thead>
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
        <c:choose>
            <c:when test="${empty list}">
                <tr>
                    <td colspan="6" class="text-center">결제 내역이 존재하지 않습니다.</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach items="${list}" var="vo">
                    <tr class="dataRow">
                        <td>${vo.order_id}</td> 
                        <td class="payment_id" style="display:none;">${vo.payment_id}</td>
                        <td>${vo.user_id}</td>
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
                        <td>${vo.payDate}</td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
    
    <%-- 페이지네이션 --%>
    <div class="d-flex justify-content-center">
        <pageNav:pageNav listURI="list.do" pageObject="${pageObject}" />
    </div>
    
    <div class="mt-3">
        <a href="list.do" class="btn btn-outline-success">새로고침</a>
    </div>

</body>
</html>