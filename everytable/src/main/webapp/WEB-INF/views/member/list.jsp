<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 리스트</title>

<style type="text/css">
body { background-color: #f4f6f3; }

/* ── 검색/필터 카드 ── */
.filter-card {
    background: #fff;
    border-radius: 14px;
    padding: 20px 24px;
    border: 1px solid #e8ebe6;
    margin-bottom: 20px;
}
.search-wrap { position: relative; margin-bottom: 16px; }
.search-wrap .search-icon {
    position: absolute; left: 14px; top: 50%;
    transform: translateY(-50%); color: #aaa; font-size: 1rem;
}
.search-wrap input {
    padding-left: 40px; border-radius: 10px;
    border: 1px solid #dde0da; background: #f9faf8;
    height: 44px; font-size: 0.95rem; width: 100%;
}
.search-wrap input:focus {
    border-color: #0f7a54; outline: none;
    box-shadow: 0 0 0 3px rgba(15,122,84,0.1); background: #fff;
}
.filter-row { display: flex; gap: 14px; flex-wrap: wrap; align-items: flex-end; }
.filter-group { display: flex; flex-direction: column; gap: 4px; }
.filter-group label { font-size: 0.8rem; color: #777; font-weight: 500; }
.filter-row select,
.filter-row input[type="date"] {
    border-radius: 8px; border: 1px solid #dde0da;
    background: #f9faf8; height: 38px; padding: 0 10px;
    font-size: 0.88rem; color: #333; min-width: 110px;
}
.filter-row select:focus,
.filter-row input[type="date"]:focus {
    border-color: #0f7a54; outline: none;
    box-shadow: 0 0 0 3px rgba(15,122,84,0.1);
}
.btn-search {
    background-color: #0f7a54; color: #fff; border: none;
    border-radius: 8px; height: 38px; padding: 0 20px;
    font-size: 0.88rem; font-weight: 600; cursor: pointer;
}
.btn-search:hover { background-color: #0a5e3f; }
.btn-reset {
    background-color: #f1f3f0; color: #555; border: none;
    border-radius: 8px; height: 38px; padding: 0 16px;
    font-size: 0.88rem; cursor: pointer;
}
.btn-reset:hover { background-color: #e2e6e0; }

/* ── 테이블 카드 ── */
.table-card {
    background: #fff; border-radius: 14px;
    overflow: hidden; border: 1px solid #e8ebe6;
}
.total-count { font-size: 0.85rem; color: #777; padding: 14px 20px 0; }
.total-count strong { color: #0f7a54; }

.table { margin-bottom: 0; }
.table thead th {
    background-color: #f4f6f3; color: #555;
    font-weight: 600; font-size: 0.85rem;
    border-bottom: 1px solid #e8ebe6; padding: 12px 14px;
}
.table tbody td {
    vertical-align: middle; padding: 13px 14px;
    border-bottom: 1px solid #f3f5f2;
    font-size: 0.9rem; color: #333;
}
.dataRow { transition: background-color 0.15s; cursor: pointer; }
.dataRow:hover { background-color: #f0f7f4; }

/* ── 아바타 ── */
.avatar {
    width: 34px; height: 34px; border-radius: 50%;
    background-color: #0f7a54; color: #fff;
    font-size: 0.8rem; font-weight: 700;
    display: inline-flex; align-items: center; justify-content: center;
    flex-shrink: 0;
}

/* ── 등급/상태 뱃지 ── */
.badge-grade, .badge-status {
    display: inline-block; padding: 3px 10px;
    border-radius: 20px; font-size: 0.78rem; font-weight: 600;
}
.g1 { background:#e8f5ee; color:#0f7a54; }
.g2 { background:#fff3e0; color:#e65100; }
.g9 { background:#ede7f6; color:#512da8; }
.s-ok  { background:#e8f5ee; color:#0f7a54; }
.s-bad { background:#fce8e8; color:#c62828; }
.s-etc { background:#f5f5f5; color:#757575; }

/* ── 상세보기 링크 ── */
.btn-detail {
    color: #0f7a54; font-weight: 600; font-size: 0.85rem;
    cursor: pointer; text-decoration: none;
}
.btn-detail:hover { text-decoration: underline; }

/* ── 페이지네이션 영역 ── */
.page-wrap { padding: 16px 20px; border-top: 1px solid #f3f5f2; }

/* ── 상태/등급 변경 버튼 (기존 JS 로직 유지) ── */
.changeStatusBtn, .changeGradeNoBtn { display: none; }
</style>

<script type="text/javascript">
$(function(){

    /* 행 클릭 → 상세보기 (noMove 요소 제외) */
    $(".dataRow").click(function(){
        let id = $(this).find(".col-id").text().trim();
        location = "view.do?id=" + id + "&inc=1";
    });
    $(".dataRow").on("click", ".noMove", function(){ return false; });

    /* 상태 select 변경 → 수정 버튼 표시 */
    $(".status").on("change", function(){
        $(this).next(".changeStatusBtn").show();
    });
    /* 등급 select 변경 → 수정 버튼 표시 */
    $(".gradeNo").on("change", function(){
        $(this).next(".changeGradeNoBtn").show();
    });

    /* 상태 수정 버튼 클릭 */
    $(".changeStatusBtn").on("click", function(){
        let id     = $(this).closest(".dataRow").find(".col-id").text().trim();
        let status = $(this).closest(".dataRow").find(".status").val();
        location   = "changeStatus.do?id=" + id + "&status=" + status;
    });
    /* 등급 수정 버튼 클릭 */
    $(".changeGradeNoBtn").on("click", function(){
        let id      = $(this).closest(".dataRow").find(".col-id").text().trim();
        let gradeNo = $(this).closest(".dataRow").find(".gradeNo").val();
        location    = "changeGrade.do?id=" + id + "&gradeNo=" + gradeNo;
    });

    /* 검색 폼 제출 */
    $("#filterForm").on("submit", function(e){
        e.preventDefault();
        location = "list.do?" + $(this).serialize() + "&page=1&perPageNum=${pageObject.perPageNum}";
    });

    /* 초기화 */
    $("#btnReset").on("click", function(){
        location = "list.do";
    });
});
</script>
</head>
<body>

<!-- ── 헤더 ── -->
<div class="d-flex align-items-center mb-4 mt-3">
    <div class="me-3" style="width:54px;height:54px;background:#e8f5ee;border-radius:14px;
                              display:flex;align-items:center;justify-content:center;
                              font-size:1.5rem;color:#0f7a54;">
        <i class="fa fa-users"></i>
    </div>
    <div>
        <h2 class="fw-bold mb-0 text-dark" style="font-size:1.5rem;">회원 리스트</h2>
        <p class="text-muted mb-0" style="font-size:0.88rem;">전체 회원을 조회하고 관리합니다.</p>
    </div>
</div>

<!-- ── 세션 메시지 ── -->
<c:if test="${not empty sessionScope.msg}">
    <div class="alert alert-success">${sessionScope.msg}</div>
    <c:remove var="msg" scope="session"/>
</c:if>

<!-- ── 검색/필터 카드 ── -->
<form id="filterForm" class="filter-card">
    <div class="search-wrap">
        <span class="search-icon"><i class="fa fa-search"></i></span>
        <input type="text" name="keyword" value="${keyword}"
               placeholder="아이디, 이름, 연락처로 검색">
    </div>
    <div class="filter-row">
        <div class="filter-group">
            <label>상태</label>
            <select name="status">
                <option value="전체" ${empty status || status == '전체' ? 'selected' : ''}>전체</option>
                <option value="정상" ${status == '정상' ? 'selected' : ''}>정상</option>
                <option value="탈퇴" ${status == '탈퇴' ? 'selected' : ''}>탈퇴</option>
                <option value="정지" ${status == '정지' ? 'selected' : ''}>정지</option>
                <option value="휴면" ${status == '휴면' ? 'selected' : ''}>휴면</option>
            </select>
        </div>
        <div class="filter-group">
            <label>등급</label>
            <select name="gradeNo">
                <option value="전체" ${empty gradeNo || gradeNo == '전체' ? 'selected' : ''}>전체</option>
                <option value="1"   ${gradeNo == '1' ? 'selected' : ''}>일반회원</option>
                <option value="2"   ${gradeNo == '2' ? 'selected' : ''}>매장점주</option>
                <option value="9"   ${gradeNo == '9' ? 'selected' : ''}>관리자</option>
            </select>
        </div>
        <div class="filter-group">
            <label>가입일 (시작)</label>
            <input type="date" name="dateFrom" value="${dateFrom}">
        </div>
        <div class="filter-group">
            <label>가입일 (종료)</label>
            <input type="date" name="dateTo" value="${dateTo}">
        </div>
        <div class="filter-group">
            <label>&nbsp;</label>
            <div style="display:flex;gap:6px;">
                <button type="submit" class="btn-search">검색</button>
                <button type="button" class="btn-reset" id="btnReset">초기화</button>
            </div>
        </div>
    </div>
</form>

<!-- ── 테이블 카드 ── -->
<div class="table-card">
    <p class="total-count">총 <strong>${pageObject.totalRow}</strong>명</p>

    <table class="table">
        <thead>
            <tr>
                <th>번호</th>
                <th>아이디</th>
                <th>이름</th>
                <th>성별</th>
                <th>생년월일</th>
                <th>연락처</th>
                <th>등급</th>
                <th>상태</th>
                <th>최근접속일</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
        <c:if test="${empty list}">
            <tr>
                <td colspan="10" class="text-center text-muted py-4">데이터가 존재하지 않습니다.</td>
            </tr>
        </c:if>
        <c:forEach items="${list}" var="vo" varStatus="vs">
            <tr class="dataRow">
                <td>${pageObject.startRow + vs.index}</td>
                <td>
                    <div class="d-flex align-items-center gap-2">
                        <span class="avatar">${fn:substring(vo.name, 0, 1)}</span>
                        <span class="col-id">${vo.id}</span>
                    </div>
                </td>
                <td>${vo.name}</td>
                <td>${vo.gender}</td>
                <td>${vo.birth}</td>
                <td>${vo.tel}</td>
                <td>
                    <%-- 등급 뱃지 --%>
                    <c:choose>
                        <c:when test="${vo.gradeNo == 9}"><span class="badge-grade g9">관리자</span></c:when>
                        <c:when test="${vo.gradeNo == 2}"><span class="badge-grade g2">점주</span></c:when>
                        <c:otherwise><span class="badge-grade g1">일반</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <%-- 상태 뱃지 --%>
                    <c:choose>
                        <c:when test="${vo.status == '정상'}">
                            <span class="badge-status s-ok">활성</span></c:when>
                        <c:when test="${vo.status == '탈퇴' || vo.status == '정지' || vo.status == '강퇴'}">
                            <span class="badge-status s-bad">${vo.status}</span></c:when>
                        <c:otherwise>
                            <span class="badge-status s-etc">${vo.status}</span></c:otherwise>
                    </c:choose>
                </td>
                <td>${vo.lastLogin}</td>
                <td>
                    <span class="btn-detail noMove"
                          onclick="location='view.do?id=${vo.id}&inc=1'">상세보기</span>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- ── 페이지네이션 ── -->
    <div class="page-wrap">
        <pageNav:pageNav listURI="list.do" pageObject="${pageObject}"/>
    </div>
</div>

</body>
</html>
