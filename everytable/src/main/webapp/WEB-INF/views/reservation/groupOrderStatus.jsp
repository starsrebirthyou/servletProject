<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
body { background-color: #f8f9fa; }
.status-box {
    max-width: 700px;
    margin: 40px auto;
    background: #fff;
    border-radius: 15px;
    padding: 40px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
}
</style>

<div class="status-box">
    <h3 class="fw-bold mb-1">📋 주문 취합 현황</h3>
    <p class="text-muted small mb-4">※ 5초마다 자동 갱신됩니다</p>

    <table class="table table-bordered">
        <thead class="table-success">
            <tr><th>메뉴명</th><th>수량</th><th>단가</th><th>소계</th></tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${orderList}">
            <tr>
                <td>${item.menu_name}</td>
                <td>${item.quantity}</td>
                <td><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</td>
                <td><fmt:formatNumber value="${item.quantity * item.price}" pattern="#,###"/>원</td>
            </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="text-end mt-3">
        <h4 class="fw-bold">
            총 합계: <span class="text-success">
                <fmt:formatNumber value="${total}" pattern="#,###"/>원
            </span>
        </h4>
    </div>
</div>

<meta http-equiv="refresh" content="5">
