<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="everytable.util.db.DB" %>
<%
    String resNo = request.getParameter("resNo");

    Connection conn = null;
    PreparedStatement ps = null;
    PreparedStatement ps2 = null;
    ResultSet rs = null;
    ResultSet rs2 = null;
    int total = 0;

    try {
        conn = DB.getConnection();

        // 메뉴별 취합 (같은 메뉴 수량 합산)
        ps = conn.prepareStatement(
            "SELECT M.MENU_NAME, SUM(OI.QUANTITY) AS TOTAL_QTY, OI.PRICE " +
            "FROM ORDER_ITEM OI JOIN MENU M ON OI.MENU_NO = M.MENU_NO " +
            "WHERE OI.RES_NO = ? " +
            "GROUP BY M.MENU_NAME, OI.PRICE " +
            "ORDER BY M.MENU_NAME");
        ps.setInt(1, Integer.parseInt(resNo));
        rs = ps.executeQuery();

        // 총합계
        ps2 = conn.prepareStatement(
            "SELECT NVL(SUM(PRICE * QUANTITY), 0) AS TOTAL FROM ORDER_ITEM WHERE RES_NO = ?");
        ps2.setInt(1, Integer.parseInt(resNo));
        rs2 = ps2.executeQuery();
        rs2.next();
        total = rs2.getInt("TOTAL");
%>
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
        <% while(rs.next()) { %>
        <tr>
            <td><%= rs.getString("MENU_NAME") %></td>
            <td><%= rs.getInt("TOTAL_QTY") %></td>
            <td><%= rs.getInt("PRICE") %>원</td>
            <td><%= rs.getInt("TOTAL_QTY") * rs.getInt("PRICE") %>원</td>
        </tr>
        <% } %>
    </table>

    <h3>총 합계: <%= total %>원</h3>

    <!-- 결제 페이지 연결 (담당 팀원이 만든 파일명으로 수정) -->
    <form action="payment.jsp" method="post">
        <input type="hidden" name="resNo" value="<%= resNo %>">
        <input type="hidden" name="totalAmount" value="<%= total %>">
        <button type="submit">결제하기</button>
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