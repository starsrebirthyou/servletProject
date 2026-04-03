<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="container mt-5">
    <div class="row align-items-center mb-4">
        <div class="col-auto">
            <img src="/upload/store/${vo.filename}" class="rounded-circle" style="width:120px; height:120px; object-fit:cover;">
        </div>
        <div class="col">
            <span class="badge bg-secondary">${vo.store_cate}</span>
            <h1 class="fw-bold">${vo.store_name}</h1>
            <p class="text-muted">${vo.store_addr}</p>
            <h5 class="text-warning">★ ${vo.avg_rating} <span class="text-muted">(${vo.review_count} 리뷰)</span></h5>
        </div>
        <div class="col-auto text-center">
            <div class="d-grid gap-2">
                <button class="btn btn-outline-dark">${vo.store_tel}</button>
                <a href="#review-section" class="btn text-white" style="background-color: #f08080; border-radius: 10px; padding: 10px 20px; text-decoration:none;">
                    <i class="fa-regular fa-pen-to-square"></i> 리뷰 보러가기
                </a>
            </div>
        </div>
    </div>

    <div class="row border rounded p-3 bg-light mb-4 text-center">
        <div class="col-4 border-end"><small>영업시간</small><br><strong>${vo.open_time}</strong></div>
        <div class="col-4 border-end"><small>최소 주문</small><br><strong><fmt:formatNumber value="${vo.min_order_price}"/>원</strong></div>
        <div class="col-4"><small>준비시간</small><br><strong>${vo.prepare_time}</strong></div>
    </div>

    <button class="btn w-100 py-3 mb-5 fw-bold text-white" style="background-color: #c48a45; border-radius:15px;">주문하기</button>

    <ul class="nav nav-tabs mb-4">
        <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#menu">메뉴</a></li>
        <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#review-section">리뷰</a></li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade show active" id="menu">
            <div class="row row-cols-1 row-cols-md-2 g-4">
                <c:forEach var="menu" items="${menuList}"> <%-- ✅ 수정 --%>
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden" style="${menu.is_active == 0 ? 'opacity:0.5;' : ''}">
                            <div class="row g-0">
                                <div class="col-4">
                                    <img src="${menu.image_url}" class="img-fluid h-100" style="object-fit:cover;">
                                </div>
                                <div class="col-8">
                                    <div class="card-body">
                                        <h5 class="fw-bold">${menu.menu_name} ${menu.is_active == 0 ? '[품절]' : ''}</h5>
                                        <p class="text-muted small">${menu.description}</p>
                                        <p class="fw-bold text-success">₩<fmt:formatNumber value="${menu.price}"/></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <div class="tab-pane fade" id="review-section">
            <p class="text-center py-5">리뷰 데이터가 로딩됩니다...</p>
        </div>
    </div>
</div>