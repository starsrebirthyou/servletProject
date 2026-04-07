<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 취합 현황</title>
    <meta http-equiv="refresh" content="5">
</head>
<body>
    <h2>주문 취합 현황</h2>
    <p>※ 5초마다 자동 갱신됩니다</p>

    <table border="1">
        <tr><th>메뉴명</th><th>수량</th><th>단가</th><th>소계</th></tr>
        <c:forEach var="item" items="${orderList}">
        <tr>
            <td>${item.menu_name}</td>
            <td>${item.quantity}</td>
            <td>${item.price}원</td>
            <td>${item.quantity * item.price}원</td>
        </tr>
        </c:forEach>
    </table>

    <h3>총 합계: ${total}원</h3>

    <form action="/payment/write.do" method="post">
        <input type="hidden" name="resNo" value="${resNo}">
        <input type="hidden" name="totalAmount" value="${total}">
        <button type="submit">결제하기</button>
    </form>
</body>
</html>
