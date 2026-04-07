<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${vo.store_name} - 상세 정보</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    /* 탭 디자인 */
    .nav-tabs { border-bottom: 2px solid #f1f3f5; }
    .nav-tabs .nav-link { 
        border: none; color: #868e96; font-weight: 600; padding: 12px 25px; 
    }
    .nav-tabs .nav-link.active { 
        color: #0d6efd; border: none; border-bottom: 3px solid #0d6efd; background: none; 
    }
    
    /* 환불정책 아코디언/토글 스타일 */
    .refund-section { background: #fff; border-radius: 15px; }
    .policy-card { 
        border: 1px solid #eee; border-radius: 12px; margin-bottom: 10px; overflow: hidden; 
    }
    .policy-header { 
        padding: 15px 20px; background: #f8f9fa; cursor: pointer; display: flex; 
        justify-content: space-between; align-items: center; font-weight: 700;
    }
    .policy-body { padding: 20px; border-top: 1px solid #eee; display: none; color: #666; font-size: 0.95rem; }
    
    /* 메뉴 카드 스타일 */
    .menu-card { border: 0; shadow: 0 4px 12px rgba(0,0,0,0.05); border-radius: 20px; }
    .btn-order { background-color: #c48a45; border-radius: 15px; transition: 0.3s; }
    .btn-order:hover { background-color: #a67336; transform: translateY(-2px); }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function(){
    // 환불정책 내부 토글 기능
    $(".policy-header").click(function(){
        $(this).next(".policy-body").slideToggle(300);
        $(this).find("i.fa-chevron-down").toggleClass("rotate-180");
    });

    // 상단 '환불정책 확인' 버튼 클릭 시 탭 전환 및 스크롤
    $(".go-refund").click(function(e){
        e.preventDefault();
        $('#refund-tab').tab('show'); // 부트스트랩 탭 전환 메서드
        $('html, body').animate({
            scrollTop: $("#storeTab").offset().top - 100
        }, 500);
    });
});
</script>
<style>
    .rotate-180 { transform: rotate(180deg); transition: 0.3s; }
</style>
</head>
<body>

<div class="container mt-5">
    <div class="row align-items-center mb-4">
        <div class="col-auto">
            <img src="/upload/store/${vo.filename}" class="rounded-circle shadow-sm" style="width:120px; height:120px; object-fit:cover;">
        </div>
        <div class="col">
            <span class="badge bg-secondary mb-1">${vo.store_cate}</span>
            <h1 class="fw-bold m-0">${vo.store_name}</h1>
            <p class="text-muted mb-2">${vo.store_addr}</p>
            <h5 class="text-warning m-0">★ ${vo.avg_rating} <span class="text-muted" style="font-size:0.9rem;">(${vo.review_count} 리뷰)</span></h5>
        </div>
        <div class="col-auto">
            <div class="d-grid gap-2">
                <button class="btn btn-outline-dark btn-sm">${vo.store_tel}</button>
                <a href="#" class="btn text-white go-refund" style="background-color: #f08080; border-radius: 10px;">
                    <i class="fa-regular fa-paper-plane me-1"></i> 환불정책 보기
                </a>
            </div>
        </div>
    </div>

    <div class="row border rounded-4 p-3 bg-light mb-4 text-center mx-0 shadow-sm">
        <div class="col-4 border-end"><small class="text-muted">영업시간</small><br><strong>${vo.open_time}</strong></div>
        <div class="col-4 border-end"><small class="text-muted">최소 주문</small><br><strong><fmt:formatNumber value="${vo.min_order_price}"/>원</strong></div>
        <div class="col-4"><small class="text-muted">준비시간</small><br><strong>${vo.prepare_time}</strong></div>
    </div>

    <button class="btn w-100 py-3 mb-5 fw-bold text-white btn-order shadow">주문하기</button>

    <ul class="nav nav-tabs mb-4" id="storeTab">
        <li class="nav-item">
            <a class="nav-link active" id="menu-tab" data-bs-toggle="tab" href="#menu">메뉴</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="refund-tab" data-bs-toggle="tab" href="#refund-section">환불정책</a>
        </li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane fade show active" id="menu">
            <div class="row row-cols-1 row-cols-md-2 g-4">
                <c:forEach var="menu" items="${menuList}">
                    <div class="col">
                        <div class="card h-100 menu-card shadow-sm overflow-hidden" style="${menu.is_active == 0 ? 'opacity:0.5;' : ''}">
                            <div class="row g-0">
                                <div class="col-4">
                                    <img src="${menu.image_url}" class="img-fluid h-100" style="object-fit:cover; min-height:130px;">
                                </div>
                                <div class="col-8 d-flex align-items-center">
                                    <div class="card-body">
                                        <h5 class="fw-bold mb-1">${menu.menu_name} ${menu.is_active == 0 ? '<span class="text-danger" style="font-size:0.8rem;">[품절]</span>' : ''}</h5>
                                        <p class="text-muted small mb-2 text-truncate-2">${menu.description}</p>
                                        <p class="fw-bold text-success m-0">₩<fmt:formatNumber value="${menu.price}"/></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="tab-pane fade" id="refund-section">
            <div class="refund-section p-2">
                <h4 class="fw-bold mb-4 px-2">서비스 이용 및 환불 규정</h4>
                
                <div class="policy-card">
                    <div class="policy-header">
                        <span>1. 주문 취소는 언제까지 가능한가요?</span>
                        <i class="fa-solid fa-chevron-down"></i>
                    </div>
                    <div class="policy-body">
                        매장에서 주문을 수락하기 전(대기 중) 상태에서는 즉시 취소가 가능합니다. 
                        단, 매장에서 조리를 시작한 이후에는 식자재 손실 등의 사유로 취소가 제한될 수 있으니 신속히 매장으로 연락 부탁드립니다.
                    </div>
                </div>

                <div class="policy-card">
                    <div class="policy-header">
                        <span>2. 음식에 문제가 있는 경우 어떻게 하나요?</span>
                        <i class="fa-solid fa-chevron-down"></i>
                    </div>
                    <div class="policy-body">
                        수령하신 음식이 주문 내용과 다르거나 위생상 문제가 발견된 경우, 즉시 사진을 촬영하신 후 매장으로 전화 주시기 바랍니다. 
                        확인 절차를 거쳐 재배달 또는 100% 환불 처리를 도와드립니다.
                    </div>
                </div>

                <div class="policy-card">
                    <div class="policy-header">
                        <span>3. 환불은 얼마나 걸리나요?</span>
                        <i class="fa-solid fa-chevron-down"></i>
                    </div>
                    <div class="policy-body">
                        카드 결제 취소 시 카드사에 따라 영업일 기준 3~7일 정도 소요됩니다. 
                        간편결제(카카오페이, 네이버페이 등)는 당일 또는 익일까지 처리가 완료됩니다.
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>