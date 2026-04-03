<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EveryTable - 기간별 매출조회</title>
    <style>
        body { margin: 0; padding: 0; font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; display: flex; height: 100vh; }
        
        /* 사이드바 스타일 (이미지와 동일) */
        .sidebar { width: 250px; background-color: #343a40; color: #fff; padding: 20px; display: flex; flex-direction: column; }
        .sidebar h2 { font-size: 24px; margin-bottom: 30px; font-weight: bold; }
        .sidebar ul { list-style: none; padding: 0; margin: 0; }
        .sidebar ul li { margin-bottom: 15px; }
        .sidebar ul li a { text-decoration: none; color: #adb5bd; font-size: 16px; transition: color 0.3s; }
        .sidebar ul li a:hover, .sidebar ul li a.active { color: #fff; font-weight: bold; }

        /* 메인 콘텐츠 영역 */
        .main-content { flex: 1; padding: 40px; overflow-y: auto; }
        .header-title { font-size: 28px; font-weight: bold; margin-bottom: 30px; color: #333; }

        /* 카드 스타일 (테이블을 감싸는 영역) */
        .card { background-color: #fff; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 30px; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #e9ecef; padding-bottom: 15px; }
        .card-title { font-size: 20px; font-weight: bold; color: #495057; }

        /* 테이블 스타일 */
        .sales-table { width: 100%; border-collapse: collapse; text-align: center; }
        .sales-table th { background-color: #f8f9fa; color: #495057; padding: 15px; border-bottom: 2px solid #dee2e6; }
        .sales-table td { padding: 15px; border-bottom: 1px solid #dee2e6; color: #212529; }
        .sales-table tr:hover { background-color: #f1f3f5; }
        
        /* 금액 강조 스타일 */
        .amount { font-weight: bold; color: #228be6; } /* 대시보드의 파란색 카드 색상 활용 */

        /* 데이터 없을 때 스타일 */
        .no-data { text-align: center; padding: 50px 0; color: #868e96; font-size: 18px; }
        
        /* 버튼 스타일 */
        .btn-back { background-color: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 5px; text-decoration: none; font-size: 14px; cursor: pointer; }
        .btn-back:hover { background-color: #5a6268; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>Seller Admin</h2>
        <ul>
            <li><a href="/stats/dashboard.do">대시보드 홈</a></li>
            <li><a href="/stats/sales.do" class="active">기간별 매출 조회</a></li>
            <li><a href="/stats/categorystats.do">카테고리 통계</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header-title">기간별 매출 상세 조회</div>

        <div class="card">
            <div class="card-header">
                <div class="card-title">매출 내역 목록</div>
                <a href="/stats/dashboard.do" class="btn-back">대시보드로 돌아가기</a>
            </div>

            <%-- Controller에서 넘겨준 데이터 이름이 'list'라고 가정합니다. --%>
            
            <c:if test="${empty list}">
                <div class="no-data">
                    <img src="https://img.icons8.com/ios/100/4d4d4d/data-configuration.png" alt="no data icon" style="width:50px; margin-bottom:15px;"><br>
                    선택하신 기간에 대한 매출 데이터가 존재하지 않습니다.
                </div>
            </c:if>

            <c:if test="${!empty list}">
                <table class="sales-table">
                    <thead>
                        <tr>
                            <th>순번</th>
                            <th>날짜</th>
                            <th>카테고리</th>
                            <th>판매 건수</th>
                            <th>총 매출액</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- PageObject의 startRow를 활용해 순번 계산 --%>
                        <c:forEach items="${list}" var="vo" varStatus="status">
                            <tr>
                                <td>${pageObject.startRow + status.index}</td>
                                <td>${vo.targetDate}</td> <%-- VO의 날짜 필드명 --%>
                                <td>${vo.categoryName}</td> <%-- VO의 카테고리 필드명 --%>
                                <td>${vo.saleCount} 건</td> <%-- VO의 건수 필드명 --%>
                                <td class="amount">
                                    <%-- 통화 형식 포맷팅 (원화 표시) --%>
                                    <fmt:formatNumber value="${vo.salesAmount}" type="currency" currencySymbol="₩"/>
                                </td> <%-- VO의 금액 필드명 --%>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <%-- 여기에 페이징 처리 HTML을 추가할 수 있습니다 (PageObject 활용) --%>
            </c:if>
        </div>
    </div>

</body>
</html>