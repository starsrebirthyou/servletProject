<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 예약 내역</title>
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }

.page-wrap { max-width: 860px; margin: 0 auto; padding: 48px 24px; }

.page-header { margin-bottom: 32px; }
.page-header h1 { font-size: 22px; font-weight: 600; letter-spacing: -0.5px; color: #111; }
.page-header p  { font-size: 14px; color: #888; margin-top: 4px; }

/* 필터 탭 */
.filter-bar { display: flex; gap: 6px; margin-bottom: 28px; flex-wrap: wrap; }
.filter-btn {
    padding: 7px 16px;
    border-radius: 100px;
    border: 1.5px solid #ddd;
    background: #fff;
    font-size: 13px;
    font-weight: 500;
    color: #555;
    cursor: pointer;
    transition: all 0.15s;
}
.filter-btn:hover { border-color: #111; color: #111; }
.filter-btn.active { background: #111; color: #fff; border-color: #111; }

/* 카드 */
.order-card {
    background: #fff;
    border-radius: 16px;
    border: 1px solid #ebebeb;
    padding: 24px;
    margin-bottom: 16px;
    cursor: pointer;
    transition: box-shadow 0.2s;
}
.order-card:hover { box-shadow: 0 4px 20px rgba(0,0,0,0.07); }

.card-top {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 18px;
}
.store-name { font-size: 17px; font-weight: 600; color: #111; margin-bottom: 3px; }
.card-meta  { font-size: 12px; color: #aaa; }

/* 배지 */
.badge {
    display: inline-block;
    font-size: 12px;
    font-weight: 600;
    padding: 5px 12px;
    border-radius: 100px;
    white-space: nowrap;
    flex-shrink: 0;
}
.badge-wait  { background: #fff8e1; color: #b7791f; border: 1px solid #f6e05e; }
.badge-ok    { background: #e8f4fd; color: #1a56db; border: 1px solid #bfdbfe; }
.badge-done  { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
.badge-cancel{ background: #fff1f1; color: #b91c1c; border: 1px solid #fecaca; }

/* 정보 그리드 */
.info-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1px;
    background: #f0f0f0;
    border-radius: 12px;
    overflow: hidden;
    margin-bottom: 18px;
}
.info-cell { background: #fafafa; padding: 14px 16px; }
.info-cell .lbl { font-size: 11px; color: #aaa; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
.info-cell .val { font-size: 15px; font-weight: 600; color: #111; }
.info-cell .val.green { color: #16a34a; }

/* 진행 단계 */
.step-bar {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 18px;
    padding: 0 2px;
}
.step-item {
    font-size: 13px;
    font-weight: 600;
    color: #16a34a;
}
.step-item.dim { color: #d1d5db; }
.step-arrow { font-size: 11px; color: #16a34a; }
.step-arrow.dim { color: #d1d5db; }
.step-cancel {
    font-size: 13px;
    font-weight: 600;
    color: #b91c1c;
    width: 100%;
    text-align: center;
    margin-bottom: 18px;
}

/* 버튼 */
.card-actions { display: flex; gap: 8px; justify-content: flex-end; }
.btn {
    padding: 8px 18px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    border: 1.5px solid transparent;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    transition: all 0.15s;
}
.btn-ghost  { background: #fff; border-color: #ddd; color: #555; }
.btn-ghost:hover  { border-color: #999; color: #111; }
.btn-dark   { background: #111; color: #fff; border-color: #111; }
.btn-dark:hover   { background: #333; }
.btn-cancel { background: #fff; border-color: #fca5a5; color: #b91c1c; }
.btn-cancel:hover { background: #fff1f1; }

/* 빈 상태 */
.empty-state {
    text-align: center;
    padding: 64px 24px;
    background: #fff;
    border-radius: 16px;
    border: 1px solid #ebebeb;
}
.empty-state p { color: #aaa; font-size: 15px; }

/* 하단 */
.bottom-actions { margin-top: 32px; display: flex; gap: 8px; }
.pagination-wrap { display: flex; justify-content: center; margin-top: 32px; }
</style>
</head>
<body>

<div class="page-wrap">

    <div class="page-header">
        <h1>내 예약 내역</h1>
        <p>예약 상태를 확인하고 관리하세요.</p>
    </div>

    <%-- 필터 탭 --%>
    <div class="filter-bar" id="filterKey">
        <button class="filter-btn" value="0">전체</button>
        <button class="filter-btn" value="1">대기</button>
        <button class="filter-btn" value="2">승인</button>
        <button class="filter-btn" value="3">완료</button>
        <button class="filter-btn" value="4">취소·환불</button>
    </div>

    <%-- 빈 상태 --%>
    <c:if test="${empty list}">
        <div class="empty-state">
            <p>예약 데이터가 존재하지 않습니다.</p>
        </div>
    </c:if>

    <%-- 카드 목록 --%>
    <c:forEach items="${list}" var="vo">
        <div class="order-card" data-no="${vo.resNo}">

            <%-- 상단: 매장명 + 배지 --%>
            <div class="card-top">
                <div>
                    <div class="store-name">${vo.storeName}</div>
                    <div class="card-meta">예약번호 ${vo.resNo}</div>
                </div>
                <c:choose>
                    <c:when test="${vo.resStatus == 1}"><span class="badge badge-wait">매장 확인 중</span></c:when>
                    <c:when test="${vo.resStatus == 2}"><span class="badge badge-ok">예약 확정</span></c:when>
                    <c:when test="${vo.resStatus == 3}"><span class="badge badge-done">이용 완료</span></c:when>
                    <c:when test="${vo.resStatus == 4}"><span class="badge badge-cancel">취소·환불</span></c:when>
                </c:choose>
            </div>

            <%-- 정보 그리드 --%>
            <div class="info-grid">
                <div class="info-cell">
                    <div class="lbl">방문 예정일</div>
                    <div class="val green">${vo.resDate} ${vo.resTime}</div>
                </div>
                <div class="info-cell">
                    <div class="lbl">예약 인원</div>
                    <div class="val">${vo.resCount}명 (${vo.resType})</div>
                </div>
            </div>

            <%-- 진행 단계 --%>
            <c:choose>
                <c:when test="${vo.resStatus == 4}">
                    <div class="step-cancel">취소 · 환불 처리됨</div>
                </c:when>
                <c:otherwise>
                    <div class="step-bar">
                        <span class="step-item">대기</span>
                        <span class="step-arrow ${vo.resStatus >= 2 ? '' : 'dim'}">▶</span>
                        <span class="step-item ${vo.resStatus >= 2 ? '' : 'dim'}">승인</span>
                        <span class="step-arrow ${vo.resStatus >= 3 ? '' : 'dim'}">▶</span>
                        <span class="step-item ${vo.resStatus >= 3 ? '' : 'dim'}">완료</span>
                    </div>
                </c:otherwise>
            </c:choose>

            <%-- 버튼 --%>
            <div class="card-actions">
                <c:if test="${vo.resStatus == 1 || vo.resStatus == 2}">
                    <button class="btn btn-cancel" onclick="event.stopPropagation()">주문 취소</button>
                </c:if>
                <button class="btn btn-dark" onclick="event.stopPropagation()">상세보기</button>
            </div>

        </div>
    </c:forEach>

    <%-- 페이지네이션 --%>
    <div class="pagination-wrap">
        <pageNav:pageNav listURI="list.do" pageObject="${pageObject}" />
    </div>

    <%-- 하단 액션 --%>
    <div class="bottom-actions">
        <a href="writeForm.do" class="btn btn-dark">새 예약하기</a>
        <a href="list.do" class="btn btn-ghost">목록 새로고침</a>
    </div>

</div>

<script>
(function(){
    var filterKey  = "${pageObject.key}" || "0";
    var perPageNum = "${pageObject.perPageNum}";
    var pageQuery  = "${pageObject.pageQuery}";

    document.querySelectorAll("#filterKey .filter-btn").forEach(function(btn){
        if(btn.value === filterKey) btn.classList.add("active");
        btn.addEventListener("click", function(){
            location.href = "list.do?page=1&perPageNum=" + perPageNum + "&key=" + btn.value;
        });
    });

    document.querySelectorAll(".order-card").forEach(function(card){
        card.addEventListener("click", function(){
            location.href = "view.do?no=" + card.dataset.no + "&" + pageQuery;
        });
    });
})();
</script>
</body>
</html>
