<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String resNo = request.getParameter("resNo");
    String shareUrl = "http://10.15.21.232:8080/everytable/menuSelect.jsp?resNo=" + resNo;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>링크 공유</title>
</head>
<body>
    <h2>팀원들에게 링크를 공유하세요</h2>

    <input type="text" value="<%= shareUrl %>" id="shareUrl" readonly style="width:400px">
    <button onclick="copyUrl()">링크 복사</button>

    <br><br>
    <a href="orderStatus.jsp?resNo=<%= resNo %>">취합 현황 보기 →</a>

    <script>
    function copyUrl() {
        var input = document.getElementById("shareUrl");
        input.select();
        document.execCommand("copy");
        alert("링크가 복사되었습니다!");
    }
    </script>
</body>
</html>