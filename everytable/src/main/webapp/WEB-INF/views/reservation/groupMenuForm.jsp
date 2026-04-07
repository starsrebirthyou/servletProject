<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>메뉴 선택</title></head>
<body>
    <h2>메뉴를 선택해주세요</h2>

    <form action="/reservation/groupOrderWrite.do" method="post">
        <input type="hidden" name="resNo" value="${resNo}">

        <table border="1">
            <tr><th>선택</th><th>메뉴명</th><th>가격</th><th>설명</th></tr>
            <c:forEach var="menu" items="${menuList}">
            <tr>
                <td><input type="checkbox" name="menuNo" value="${menu.menu_no}"></td>
                <td>${menu.menu_name}</td>
                <td>${menu.price}원</td>
                <td>${menu.description}</td>
            </tr>
            </c:forEach>
        </table>
        <br>
        <button type="submit">확인 (주문 완료)</button>
    </form>
</body>
</html>
