<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="main-content-area" style="padding: 20px;">
    <h2>기간별 매출 상세 조회</h2>

    <!-- 검색 바 -->
    <div class="card" style="margin-bottom: 20px; padding: 15px; background: #fff; border: 1px solid #ddd;">
        <form action="sales.do" method="get">
            <input type="date" name="startDate" value="${startDate}"> ~ 
            <input type="date" name="endDate" value="${endDate}">
            <button type="submit" style="background: #198754; color: white; border: none; padding: 5px 15px; cursor: pointer;">조회</button>
        </form>
    </div>

    <!-- 매출 목록 리스트 -->
    <div class="card" style="padding: 15px; background: #fff; border: 1px solid #ddd;">
        <div style="margin-bottom: 15px; display: flex; justify-content: space-between;">
            <strong>매출 내역 (총 합계: <fmt:formatNumber value="${totalSum}" pattern="₩#,###"/>)</strong>
            <a href="/stats/dashboard.do" style="text-decoration: none; color: #666; font-size: 14px;">대시보드로 돌아가기</a>
        </div>

        <table style="width: 100%; border-collapse: collapse; text-align: center;">
            <thead style="background: #f8f9fa;">
                <tr>
                    <th style="padding: 10px; border-bottom: 2px solid #dee2e6;">순번</th>
                    <th style="padding: 10px; border-bottom: 2px solid #dee2e6;">날짜</th>
                    <th style="padding: 10px; border-bottom: 2px solid #dee2e6;">매장번호</th>
                    <th style="padding: 10px; border-bottom: 2px solid #dee2e6;">판매건수</th>
                    <th style="padding: 10px; border-bottom: 2px solid #dee2e6;">총 매출액</th>
                </tr>
            </thead>
            <tbody>
                <!-- 리스트가 있으면 반복문 실행 -->
                <c:forEach items="${list}" var="vo" varStatus="status">
                    <tr>
                        <td style="padding: 10px; border-bottom: 1px solid #eee;">${status.count}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #eee;">${vo.statsDate}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #eee;">${vo.storeName}</td>
                        <td style="padding: 10px; border-bottom: 1px solid #eee;">${vo.orderCount} 건</td>
                        <td style="padding: 10px; border-bottom: 1px solid #eee; font-weight: bold; color: #228be6;">
                            <fmt:formatNumber value="${vo.totalSales}" pattern="₩#,###"/>
                        </td>
                    </tr>
                </c:forEach>
                
                <!-- 만약 리스트가 비어있을 경우를 대비한 최소한의 메시지 -->
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="5" style="padding: 40px; color: #999;">데이터가 없습니다. 날짜를 다시 선택하거나 DB를 확인해주세요.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>