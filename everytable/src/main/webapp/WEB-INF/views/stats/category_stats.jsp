<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>EveryTable - 카테고리 통계</title>
    <style>
        body { margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; display: flex; height: 100vh; }
        
        /* 사이드바 */
        .sidebar { width: 250px; background-color: #343a40; color: #fff; padding: 20px; display: flex; flex-direction: column; }
        .sidebar h2 { font-size: 24px; margin-bottom: 30px; font-weight: bold; }
        .sidebar ul { list-style: none; padding: 0; margin: 0; }
        .sidebar ul li { margin-bottom: 15px; }
        .sidebar ul li a { text-decoration: none; color: #adb5bd; font-size: 16px; }
        .sidebar ul li a:hover, .sidebar ul li a.active { color: #fff; font-weight: bold; }

        /* 메인 콘텐츠 */
        .main-content { flex: 1; padding: 40px; overflow-y: auto; }
        .header-title { font-size: 28px; font-weight: bold; margin-bottom: 30px; color: #333; }

        /* 레이아웃: 차트와 테이블 나란히 배치 */
        .stats-container { display: flex; gap: 20px; flex-wrap: wrap; }
        .card { background-color: #fff; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 25px; flex: 1; min-width: 400px; }
        .card-title { font-size: 18px; font-weight: bold; margin-bottom: 20px; color: #495057; border-left: 5px solid #28a745; padding-left: 10px; }

        /* 통계 요약 숫자 */
        .stat-summary { display: flex; justify-content: space-around; margin-bottom: 20px; text-align: center; }
        .stat-item .label { font-size: 14px; color: #868e96; }
        .stat-item .value { font-size: 20px; font-weight: bold; color: #28a745; margin-top: 5px; }

        /* 테이블 스타일 */
        .category-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .category-table th { background-color: #f8f9fa; padding: 12px; border-bottom: 2px solid #dee2e6; font-size: 14px; }
        .category-table td { padding: 12px; border-bottom: 1px solid #dee2e6; text-align: center; font-size: 14px; }
        
        /* 색상 포인트 (이미지의 카테고리 색상 참고) */
        .badge-korean { background-color: #ff6b81; color: white; padding: 3px 8px; border-radius: 4px; font-size: 12px; }
        .badge-japanese { background-color: #339af0; color: white; padding: 3px 8px; border-radius: 4px; font-size: 12px; }
        
        .no-data { text-align: center; padding: 40px; color: #adb5bd; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>Seller Admin</h2>
        <ul>
            <li><a href="/stats/dashboard.do">대시보드 홈</a></li>
            <li><a href="/stats/sales.do">기간별 매출 조회</a></li>
            <li><a href="/stats/category.do" class="active">카테고리 통계</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header-title">카테고리별 통계 분석</div>

        <div class="stats-container">
            <div class="card">
                <div class="card-title">판매 비중 요약</div>
                <div class="stat-summary">
                    <div class="stat-item">
                        <div class="label">최다 판매 카테고리</div>
                        <div class="value">한식</div>
                    </div>
                    <div class="stat-item">
                        <div class="label">카테고리 총 매출</div>
                        <div class="value">₩1,250,000</div>
                    </div>
                </div>
                
                <%-- 실제 데이터 리스트 출력 --%>
                <c:if test="${empty list}">
                    <div class="no-data">데이터가 없습니다.</div>
                </c:if>
                
                <c:if test="${!empty list}">
                    <table class="category-table">
                        <thead>
                            <tr>
                                <th>카테고리</th>
                                <th>판매량</th>
                                <th>매출액</th>
                                <th>비중</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${list}" var="vo">
                                <tr>
                                    <td><span class="badge-korean">${vo.categoryName}</span></td>
                                    <td>${vo.saleCount} 건</td>
                                    <td><fmt:formatNumber value="${vo.salesAmount}" type="number"/>원</td>
                                    <td>${vo.ratio}%</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>

            <div class="card" style="display: flex; flex-direction: column; justify-content: center; align-items: center; background-color: #f8f9fa;">
                <p style="color: #adb5bd;">[ 차트 영역 ]</p>
                <p style="font-size: 13px; color: #ced4da;">Chart.js 등을 연동하여 도넛 차트를 시각화할 수 있습니다.</p>
            </div>
        </div>
    </div>

</body>
</html>