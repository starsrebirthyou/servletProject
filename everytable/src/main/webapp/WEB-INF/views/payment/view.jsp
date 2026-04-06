<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 상세 정보</title>

<style type="text/css">
    th { width: 200px; background-color: #f8f9fa; }
    .container { margin-top: 50px; }
</style>

</head>
<body>
    <div class="container">
        <h2 class="mb-4">결제 상세 정보</h2>
        
        <table class="table table-bordered">
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
                        <c:if test="${vo.status == 'SUCCESS'}">
                            <span class="badge bg-success">결제 완료</span>
                        </c:if>
                        <c:if test="${vo.status == 'FAIL'}">
                            <span class="badge bg-danger">결제 실패</span>
                        </c:if>
                        <c:if test="${vo.status == 'REFUNDED'}">
                            <span class="badge bg-secondary">환불 완료</span>
                        </c:if>
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
                <c:if test="${!empty vo.pickupDate}">
                <tr>
                    <th>픽업 예정일</th>
                    <td class="fw-bold text-primary">
                        <fmt:formatDate value="${vo.pickupDate}" pattern="yyyy-MM-dd HH:mm" />
                    </td>
                </tr>
                </c:if>
            </tbody>
        </table>
        
        <div class="mt-4">
            <a href="list.do?page=${pageObject.page}&perPageNum=${pageObject.perPageNum}&key=${pageObject.key}&word=${pageObject.word}" 
               class="btn btn-warning">리스트</a>

            <c:if test="${login.gradeNo == 9}">
                <a href="updateForm.do?no=${vo.payment_id}" class="btn btn-primary">결제정보 수정</a> 
            </c:if>

            <c:if test="${vo.status == 'SUCCESS' && login.gradeNo != 9}">
                <c:if test="${diffHours >= 12}">
                    <a href="/refund/refundForm.do?no=${vo.payment_id}" class="btn btn-danger">주문 취소 (환불신청)</a>
                </c:if>
                <c:if test="${diffHours < 12}">
                    <span class="text-muted ms-2">※ 픽업 12시간 이내이므로 취소가 불가합니다.</span>
                </c:if>
            </c:if>

            <c:if test="${vo.status == 'FAIL'}">
                <div class="alert alert-light border d-inline-block p-2 ms-2">
                    <small class="text-muted">결제 오류 발생. 매장(010-1234-5678)으로 문의주세요.</small>
                </div>
            </c:if>

            <c:if test="${vo.status == 'REFUNDED'}">
                <span class="text-muted ms-2">이미 환불 처리가 완료된 주문입니다.</span>
            </c:if>
        </div>
    </div>
</body>
</html>