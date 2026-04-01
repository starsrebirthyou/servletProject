<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 리스트</title>
<style type="text/css">
    /* 전체 배경을 살짝 어둡게 하여 테이블을 돋보이게 함 */
    body { background-color: #f8f9fa; }
    
    /* 리스트 카드 스타일 */
    .table {
        background-color: #ffffff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        border: none;
    }
    
    .table thead th {
        background-color: #212529;
        color: #fff;
        border-bottom: none;
        padding: 15px 10px;
    }

    .table tbody td {
        vertical-align: middle;
        padding: 12px 10px;
        border-bottom: 1px solid #f1f3f5;
    }

    /* 데이터 행 마우스 오버 효과 */
    .dataRow {
        transition: background-color 0.2s ease, transform 0.2s ease;
    }
    .dataRow:hover {
        background-color: #f8f9fa;
        transform: translateY(-2px);
        cursor: pointer;
    }

    /* =========================================
       새로 추가된 상단 헤더 및 필터 버튼 디자인 
       ========================================= */
    /* 상단 헤더 아이콘 박스 */
    .header-icon-box {
        width: 60px;
        height: 60px;
        background-color: #e8f3ee; /* 연한 녹색 배경 */
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.6rem;
        color: #0f7a54; /* 짙은 녹색 아이콘 */
    }

    /* 카테고리 필터 컨테이너 (흰색 박스) */
    .category-filter-card {
        background-color: #ffffff;
        border-radius: 12px;
        padding: 12px 18px;
        border: 1px solid #eaeaea;
        display: flex;
        gap: 8px; /* 버튼 사이 간격 */
        margin-bottom: 25px;
    }

    /* 필터 버튼 기본 스타일 (비활성) */
    .filter-btn {
        border: none;
        border-radius: 8px;
        padding: 8px 18px;
        font-weight: 500;
        background-color: #f1f3f5;
        color: #495057;
        transition: all 0.2s;
    }

    /* 필터 버튼 호버 & 활성 상태 */
    .filter-btn:hover { background-color: #e2e6ea; }
    .filter-btn.active {
        background-color: #0f7a54; /* 짙은 녹색 */
        color: #ffffff;
    }
</style>
  
<script type="text/javascript">
$(function(){
    // 카드 클릭 시 모달 띄우기
    $(".dataRow").click(function(){
        let no = $(this).data("no");
        let url = "view.do?no=" + no + "&inc=1&page=${pageObject.page}&perPageNum=${pageObject.perPageNum}&key=${pageObject.key} #modalInner";
        
        $("#noticeModalBody").load(url, function() {
            $("#noticeModal").modal("show");
        });
    });

    // 카테고리 버튼 클릭
    $(".filter-btn").click(function(e){
        e.preventDefault();  
        let key = $(this).val(); 
        location = "list.do?key=" + key + "&perPageNum=${pageObject.perPageNum}";
    });

    // 현재 선택된 카테고리 버튼 활성화 유지
    $(".filter-btn").each(function(){
        $(this).removeClass("active");
        if($(this).val() == "${pageObject.key}"){
            $(this).addClass("active");
        }
    });
});
</script>
</head>
<body>

    <div class="d-flex align-items-center mb-4 mt-3">
        <div class="header-icon-box me-3">
            <i class="fa fa-bell-o"></i>
        </div>
        <div>
            <h2 class="fw-bold mb-1 text-dark" style="border: none; margin: 0; padding: 0;">공지사항</h2>
            <p class="text-muted mb-0" style="font-size: 0.95rem;">에브리테이블의 최신 소식과 공지를 확인하세요</p>
        </div>
    </div>
  
	<form class="category-filter-card" name="key" id="key">
        <button class="filter-btn ${empty pageObject.key || pageObject.key == '0' ? 'active' : ''}" value="0">전체</button>
        <button class="filter-btn ${pageObject.key == '1' ? 'active' : ''}" value="1">공지사항</button>
        <button class="filter-btn ${pageObject.key == '3' ? 'active' : ''}" value="3">이벤트</button>
        <button class="filter-btn ${pageObject.key == '4' ? 'active' : ''}" value="4">업데이트</button>
        <button class="filter-btn ${pageObject.key == '2' ? 'active' : ''}" value="2">시스템</button>
    </form>

    <div class="notice-list mt-3">
        <c:if test="${empty list}">
            <div class="alert alert-secondary text-center">공지가 존재하지 않습니다.</div>
        </c:if>
        <c:if test="${!empty list}">
            <c:forEach items="${list}" var="vo">
                <div class="card mb-3 dataRow" data-no="${vo.no}" style="border-radius: 12px; border: 1px solid #d1e7dd;">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-2">
                            <span class="badge text-success bg-success bg-opacity-10 border border-success me-2 px-2 py-1">
                                ${vo.cateName}
                            </span>
                        </div>
                        
                        <h5 class="card-title fw-bold text-dark mb-3">${vo.title}</h5>
                        
                        <div class="text-secondary d-flex align-items-center" style="font-size: 0.85rem;">
                            <span class="me-3"><i class="fa fa-calendar"></i> ${vo.writeDate}</span>
                            <span class="me-3"><i class="fa fa-eye"></i> ${vo.hit}</span>
                            <span><i class="fa fa-user"></i> 에브리테이블 관리자</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
    </div>
    
    <div>
        <pageNav:pageNav listURI="list.do" pageObject="${pageObject}"/>
    </div>
    
    <c:if test="${!empty login && login.gradeNo == 9}">
        <div class="text-end mt-3 mb-5">
            <a href="writeForm.do?perPageNum=${pageObject.perPageNum}" class="btn text-white fw-bold px-4" style="background-color: #0f7a54; border-radius: 8px;">공지 등록</a>
        </div>
    </c:if>

    <div class="modal fade" id="noticeModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content" id="noticeModalBody" style="border-radius: 16px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1);">
            </div>
        </div>
    </div>
</body>
</html>