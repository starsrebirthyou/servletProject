<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- ✅ 로그인 모달 include --%>
<%@ include file="/WEB-INF/views/member/loginModal.jsp" %>

<style>
.alert-custom {
    background-color: #FFF9E6;
    border: 1px solid #FFE58F;
    border-radius: 12px;
    padding: 20px;
    color: #856404;
}
.policy-item {
    background: #fff;
    border: 1px solid #eee;
    border-radius: 16px;
    padding: 20px 25px;
    margin-bottom: 12px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-left: 6px solid #ccc;
    transition: 0.2s;
}
.policy-item:hover { transform: translateX(5px); }
.p-24  { border-left-color: #436551; }
.p-12  { border-left-color: #C48A45; }
.p-zero{ border-left-color: #E74C3C; }
.policy-text { font-weight: 700; font-size: 1.1rem; color: #333; }
.policy-badge { padding: 6px 15px; border-radius: 20px; font-weight: 800; font-size: 0.9rem; }
.b-24  { background: #E8F3ED; color: #436551; }
.b-12  { background: #FFF2E6; color: #C48A45; }
.b-zero{ background: #FEECEC; color: #E74C3C; }
</style>

<div class="container mt-5">
    <div class="row align-items-center mb-4">
        <div class="col-auto">
            <img src="/upload/store/${vo.filename}" class="rounded-circle"
                style="width: 120px; height: 120px; object-fit: cover;">
        </div>
        <div class="col">
            <span class="badge bg-secondary">${vo.store_cate}</span>
            <h1 class="fw-bold">${vo.store_name}</h1>
            <p class="text-muted">${vo.store_addr}</p>
            <h5 class="text-warning">
                ★ ${vo.avg_rating} <span class="text-muted">(${vo.review_count} 리뷰)</span>
            </h5>
        </div>
        <div class="col-auto text-center">
            <div class="d-grid gap-2">
                <button class="btn btn-outline-dark">${vo.store_tel}</button>
                <a href="#review-section" class="btn text-white"
                    style="background-color: #f08080; border-radius: 10px; padding: 10px 20px; text-decoration: none;">
                    <i class="fa-regular fa-pen-to-square"></i> 리뷰 보러가기
                </a>
            </div>
        </div>
    </div>

    <div class="row border rounded p-3 bg-light mb-4 text-center">
        <div class="col-4 border-end">
            <small>영업시간</small><br>
            <strong>${vo.open_time}</strong>
        </div>
        <div class="col-4 border-end">
            <small>최소 주문</small><br>
            <strong><fmt:formatNumber value="${vo.min_order_price}" />원</strong>
        </div>
        <div class="col-4">
            <small>준비시간</small><br>
            <strong>${vo.prepare_time}</strong>
        </div>
    </div>

    <%-- ✅ href 대신 onclick="requireLogin(...)" 으로 변경 --%>
    <button onclick="requireLogin('/reservation/writeForm.do?storeId=${vo.store_id}')"
        class="btn w-100 py-3 mb-5 fw-bold text-white"
        style="background-color: #c48a45; border-radius: 15px;">주문하기</button>

    <ul class="nav nav-tabs mb-4">
        <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#menu">메뉴</a></li>
        <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#refund-section">환불정책</a></li>
    </ul>

    <div class="tab-content">
        <%-- 메뉴 탭 --%>
        <div class="tab-pane fade show active" id="menu">
            <div class="row row-cols-1 row-cols-md-2 g-4">
                <c:forEach var="menu" items="${menuList}">
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden"
                            style="${menu.is_active == 0 ? 'opacity:0.5;' : ''}">
                            <div class="row g-0">
                                <div class="col-4">
                                    <img src="${menu.image_url}" class="img-fluid h-100"
                                        style="object-fit: cover;">
                                </div>
                                <div class="col-8">
                                    <div class="card-body">
                                        <h5 class="fw-bold">${menu.menu_name}${menu.is_active == 0 ? ' [품절]' : ''}</h5>
                                        <p class="text-muted small">${menu.description}</p>
                                        <p class="fw-bold text-success">₩ <fmt:formatNumber value="${menu.price}" /></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <%-- 환불정책 탭 --%>
        <div class="tab-pane fade" id="refund-section">
            <div class="p-3">
                <div class="alert-custom mb-4">
                    <h6 class="fw-bold">
                        <i class="fa-solid fa-triangle-exclamation me-2"></i>환불 정책을 꼭 확인하세요!
                    </h6>
                    <p class="small m-0">주문 취소 시 픽업 시간까지 남은 시간에 따라 환불 금액이 달라집니다.</p>
                </div>
                <div class="policy-item p-24">
                    <span class="policy-text">픽업 24시간 전</span>
                    <span class="policy-badge b-24">${vo.refund_policy_24}</span>
                </div>
                <div class="policy-item p-12">
                    <span class="policy-text">픽업 12시간 전</span>
                    <span class="policy-badge b-12">${vo.refund_policy_12}</span>
                </div>
                <div class="policy-item p-zero">
                    <span class="policy-text">픽업 12시간 이내</span>
                    <span class="policy-badge b-zero">${vo.refund_policy_0}</span>
                </div>
                <div class="mt-4 px-2">
                    <p class="small fw-bold text-dark mb-2">참고사항:</p>
                    <ul class="small text-muted">
                        <li>환불은 결제하신 수단으로 영업일 기준 3-5일 내 처리됩니다.</li>
                        <li>천재지변 등 불가피한 사유로 인한 취소는 별도 문의 바랍니다.</li>
                        <li>매장 사정으로 인한 주문 거절 시 전액 환불됩니다.</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
$(function() {
    $("a[href='#review-section']").click(function(e) {
        e.preventDefault();
        let storeId = "${vo.store_id}";
        if (!storeId || storeId === "") {
            alert("매장 정보를 찾을 수 없습니다.");
            return;
        }
        location.href = "/review/storeList.do?storeId=" + storeId;
    });
});
</script>