<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="everytable.util.db.DB" %>
<%
    String resNo = request.getParameter("resNo");

    Connection conn = null;
    PreparedStatement ps0 = null;
    PreparedStatement ps = null;
    ResultSet rs0 = null;
    ResultSet rs = null;

    try {
        conn = DB.getConnection();

        // 해당 예약의 STORE_ID 가져오기
        ps0 = conn.prepareStatement(
            "SELECT STORE_ID FROM RESERVATION WHERE RES_NO = ?");
        ps0.setInt(1, Integer.parseInt(resNo));
        rs0 = ps0.executeQuery();
        rs0.next();
        int storeId = rs0.getInt("STORE_ID");

        // 그 가게 메뉴만 가져오기
        ps = conn.prepareStatement(
            "SELECT MENU_NO, MENU_NAME, PRICE, DESCRIPTION, IMAGE_URL " +
            "FROM MENU WHERE STORE_ID = ? AND IS_ACTIVE = 'Y'");
        ps.setInt(1, storeId);
        rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메뉴 선택</title>
</head>
<body>
    <h2>메뉴를 선택해주세요</h2>

    <form action="OrderServlet" method="post">
        <input type="hidden" name="resNo" value="<%= resNo %>">

        <table border="1">
            <tr><th>선택</th><th>메뉴명</th><th>가격</th><th>설명</th></tr>
            <% while(rs.next()) { %>
            <tr>
                <td>
                    <input type="checkbox"
                           name="menuNo"
                           value="<%= rs.getInt("MENU_NO") %>">
                </td>
                <td><%= rs.getString("MENU_NAME") %></td>
                <td><%= rs.getInt("PRICE") %>원</td>
                <td><%= rs.getString("DESCRIPTION") %></td>
            </tr>
            <% } %>
        </table>
        <br>
        <button type="submit">확인 (주문 완료)</button>
    </form>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DB.close(conn, ps, rs);
    }
%>
</body>
</html>