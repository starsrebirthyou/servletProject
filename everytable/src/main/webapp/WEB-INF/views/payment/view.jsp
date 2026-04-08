<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 상세 정보</title>
<style type="text/css">
    /* 1. 기본 테이블 설정: 모서리 둥글게 */
    .table {
        border-collapse: separate;
        border-spacing: 0;
        border-radius: 15px;
        overflow: hidden;
        border: 1px solid #dee2e6;
        width: 100%;
        margin-top: 20px;
    }

    /* 2. 세로형 테이블 제목(th) 스타일: 왼쪽 칸을 회색으로! */
    .table th {
        background-color: #f8f9fa !important; /* 은은한 회색 ㅋㅋㅋ */
        color: #333;
        width: 200px; /* 제목 칸 너비 고정 */
        padding: 15px;
        vertical-align: middle;
        border-right: 1px solid #dee2e6;
        border-bottom: 1px solid #dee2e6;
        text-align: center;
    }

    /* 3. 데이터 칸(td) 스타일 */
    .table td {
        padding: 15px;
        vertical-align: middle;
        border-bottom: 1px solid #dee2e6;
    }

    /* 4. 마지막 줄 테두리 제거 (둥근 모서리 유지용) */
    .table tr:last-child th, 
    .table tr:last-child td {
        border-bottom: none;
    }

    /* 5. 상태 배지: 아주 동글동글하게 */
    .badge {
        padding: 0.5em 1em;
        border-radius: 50rem !important; 
        font-weight: bold;
    }
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

            

			
			<c:if test="${vo.status == 'SUCCESS' && login.gradeNo != 9}">
			    <c:if test="${diffHours >= 12}">
			        <a href="/refund/refundForm.do?no=${vo.payment_id}" class="btn btn-danger">주문 취소 (환불신청)</a>
			    </c:if>
			    <c:if test="${diffHours < 12}">
			        <span class="text-muted ms-2">※ 픽업 12시간 이내이므로 취소가 불가합니다.</span>
			    </c:if>
			</c:if>
			
			<c:if test="${vo.status == 'REJECTED'}">
			    <div class="alert alert-warning border-0 d-inline-block p-2 ms-2 mb-0 shadow-sm" style="background-color: #fffbeb;">
			        <small class="text-warning-emphasis fw-bold">
			            📢 매장 사정으로 주문이 거절되었습니다. 결제 금액은 <span class="text-danger">전액 환불</span> 처리됩니다.
			        </small>
			    </div>
			</c:if>
            <c:if test="${vo.status == 'FAIL'}">
                <div class="alert alert-light border d-inline-block p-2 ms-2">
                    <small class="text-muted">결제 오류 발생. 매장(☎️ 010-1234-5678)으로 문의주세요.</small>
                </div>
            </c:if>

            <c:if test="${vo.status == 'REFUNDED'}">
                <span class="text-muted ms-2">이미 환불 처리가 완료된 주문입니다.</span>
            </c:if>
        </div>
    </div>
</body>
</html>