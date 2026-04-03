<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>EveryTable - 기간별 매출조회</title>
    <style>
        /* [중요] body의 height: 100vh와 display: flex를 제거했습니다. */
        body { 
            margin: 0; 
            padding: 0; 
            font-family: 'Malgun Gothic', sans-serif; 
            background-color: #f4f7f6; 
        }

        /* 메인 콘텐츠 영역: 사이드바 너비(250px)만큼 왼쪽 마진을 줍니다. */
        .main-content-area { 
            padding: 40px; 
            min-height: 80vh; /* 컨텐츠가 적어도 푸터가 너무 올라오지 않게 */
        }
        
        .header-title { font-size: 28px; font-weight: bold; margin-bottom: 30px; color: #333; }

        /* 카드 스타일 */
        .card { background-color: #fff; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); padding: 30px; border:none; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #e9ecef; padding-bottom: 15px; }
        .card-title { font-size: 20px; font-weight: bold; color: #495057; }

        /* 테이블 스타일 */
        .sales-table { width: 100%; border-collapse: collapse; text-align: center; }
        .sales-table th { background-color: #f8f9fa; color: #495057; padding: 15px; border-bottom: 2px solid #dee2e6; }
        .sales-table td { padding: 15px; border-bottom: 1px solid #dee2e6; color: #212529; }
        .sales-table tr:hover { background-color: #f1f3f5; }
        
        .amount { font-weight: bold; color: #228be6; }
        .no-data { text-align: center; padding: 50px 0; color: #868e96; font-size: 18px; }
        .btn-back { background-color: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 5px; text-decoration: none; font-size: 14px; cursor: pointer; }
    </style>
</head>
<body>

    <!-- 
       [알림] 사이드바는 Decorator에서 그려주므로 
       이 페이지 내부에 있는 <div class="sidebar"> 코드는 삭제하시거나 
       Decorator 설정을 확인하신 후 제외해야 레이아웃이 겹치지 않습니다.
    -->

    <div class="main-content-area">
        <div class="header-title">기간별 매출 상세 조회</div>

        <div class="card">
            <div class="card-header">
                <div class="card-title">매출 내역 목록</div>
                <a href="/stats/dashboard.do" class="btn-back">대시보드로 돌아가기</a>
            </div>
            
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
                        <c:forEach items="${list}" var="vo" varStatus="status">
                            <tr>
                                <td>${status.count}</td>
                                <td>${vo.targetDate}</td>
                                <td>${vo.categoryName}</td>
                                <td>${vo.saleCount} 건</td>
                                <td class="amount">
                                    <fmt:formatNumber value="${vo.salesAmount}" type="currency" currencySymbol="₩"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>

</body>
</html>