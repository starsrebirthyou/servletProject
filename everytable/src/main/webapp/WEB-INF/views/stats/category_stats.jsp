<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>EveryTable - 카테고리 통계</title>
    <style>
        /* 기본 레이아웃 설정 */
        body { 
            margin: 0; 
            padding: 0; 
            font-family: 'Malgun Gothic', sans-serif; 
            background-color: #f4f7f6; 
        }

        /* 메인 콘텐츠 영역 (사이드바 제외 영역) */
        .main-content-area { 
            padding: 40px; 
            min-height: 80vh; 
        }
        
        /* 제목 스타일 */
        .header-title { 
            font-size: 28px; 
            font-weight: bold; 
            color: #333; 
        }

        /* [추가] 대시보드로 돌아가기 버튼 스타일 */
        .btn-back { 
            background-color: #6c757d; 
            color: white !important; 
            padding: 10px 20px; 
            border: none; 
            border-radius: 5px; 
            text-decoration: none; 
            font-size: 14px; 
            cursor: pointer; 
            transition: background 0.3s;
        }
        .btn-back:hover { 
            background-color: #5a6268; 
        }

        /* 카드 레이아웃 */
        .stats-container { 
            display: flex; 
            gap: 20px; 
            flex-wrap: wrap; 
        }
        .card { 
            background-color: #fff; 
            border-radius: 10px; 
            box-shadow: 0 4px 6px rgba(0,0,0,0.1); 
            padding: 25px; 
            flex: 1; 
            min-width: 400px; 
            border: none;
        }
        .card-title { 
            font-size: 18px; 
            font-weight: bold; 
            margin-bottom: 20px; 
            color: #495057; 
            border-left: 5px solid #87a372; /* 서비스 메인 컬러 */
            padding-left: 10px; 
        }

        /* 통계 요약 숫자 */
        .stat-summary { 
            display: flex; 
            justify-content: space-around; 
            margin-bottom: 20px; 
            text-align: center; 
        }
        .stat-item .label { font-size: 14px; color: #868e96; }
        .stat-item .value { font-size: 20px; font-weight: bold; color: #198754; margin-top: 5px; }

        /* 테이블 스타일 */
        .category-table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .category-table th { background-color: #f8f9fa; padding: 12px; border-bottom: 2px solid #dee2e6; font-size: 14px; }
        .category-table td { padding: 12px; border-bottom: 1px solid #dee2e6; text-align: center; font-size: 14px; }
        
        .badge-category { 
            background-color: #87a372; 
            color: white; 
            padding: 3px 8px; 
            border-radius: 4px; 
            font-size: 12px; 
        }
        .no-data { text-align: center; padding: 40px; color: #adb5bd; }
    </style>
</head>
<body>

    <div class="main-content-area">
        <!-- 상단 헤더 영역: 제목과 버튼 배치 -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <div class="header-title">카테고리별 통계 분석</div>
            <a href="/stats/dashboard.do" class="btn-back">대시보드로 돌아가기</a>
        </div>

        <div class="stats-container">
            <!-- 왼쪽 카드: 데이터 요약 및 테이블 -->
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
                                    <td><span class="badge-category">${vo.categoryName}</span></td>
                                    <td>${vo.saleCount} 건</td>
                                    <td><fmt:formatNumber value="${vo.salesAmount}" type="number"/>원</td>
                                    <td>${vo.ratio}%</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>

            <!-- 오른쪽 카드: 차트 시각화 영역 -->
            <div class="card" style="display: flex; flex-direction: column; justify-content: center; align-items: center; background-color: #f8f9fa; border: 1px dashed #dee2e6;">
                <p style="color: #adb5bd; font-weight: bold; margin-bottom: 10px;">[ 시각화 차트 ]</p>
                <p style="font-size: 13px; color: #ced4da; text-align: center; line-height: 1.6;">
                    Chart.js 등을 연동하면<br>이곳에 도넛 차트가 표시됩니다.
                </p>
            </div>
        </div>
    </div>

</body>
</html>