<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="container mt-5">
    <div class="row align-items-center mb-4">
        <div class="col-auto">
            <img src="/upload/store/${vo.fileName}" class="rounded-circle" style="width:120px; height:120px; object-fit:cover;">
        </div>
        <div class="col">
            <span class="badge bg-secondary">${vo.category}</span>
            <h1 class="fw-bold">${vo.name}</h1>
            <p class="text-muted">${vo.address}</p>
            <h5 class="text-warning">★ ${vo.avg_rating} <span class="text-muted">(${vo.review_count} 리뷰)</span></h5>
        </div>
        <div class="col-auto">
            <button class="btn btn-outline-dark">${vo.tel}</button>
        </div>
    </div>

    <div class="row border rounded p-3 bg-light mb-4 text-center">
        <div class="col-4 border-end">
            <small>영업시간</small><br><strong>${vo.openTime}</strong>
        </div>
        <div class="col-4 border-end">
            <small>최소 주문</small><br><strong><fmt:formatNumber value="${vo.minOrderPrice}"/>원</strong>
        </div>
        <div class="col-4">
            <small>준비시간</small><br><strong>${vo.deliveryTime}</strong>
        </div>
    </div>

    <button class="btn btn-warning w-100 py-3 mb-5 fw-bold text-white" style="background-color: #c48a45;">주문하기</button>

    <ul class="nav nav-tabs mb-4">
        <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#menu">메뉴</a></li>
        <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#refund">환불정책</a></li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade show active" id="menu">
            <div class="row row-cols-1 row-cols-md-2 g-4">
                <c:forEach var="menu" items="${menuList}">
                    <div class="col">
                        <div class="card h-100 shadow-sm border-0">
                            <div class="row g-0">
                                <div class="col-4">
                                    <img src="${menu.image_url}" class="img-fluid rounded-start h-100" style="object-fit:cover;">
                                </div>
                                <div class="col-8">
                                    <div class="card-body">
                                        <h5 class="card-title fw-bold">${menu.menu_name}</h5>
                                        <p class="card-text text-muted small">${menu.description}</p>
                                        <p class="fw-bold">₩<fmt:formatNumber value="${menu.price}"/></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>