<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    /* 메뉴판 전체 배경 */
    body { background-color: #f8f9fa; padding-bottom: 150px; /* ★ 중요: 하단바 높이만큼 바닥 여백을 줌 */ }
    
    .menu-item { 
        border: 1px solid #eee; border-radius: 15px; padding: 20px; 
        margin-bottom: 15px; display: flex; justify-content: space-between; 
        align-items: center; background: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .menu-info h5 { font-weight: bold; margin-bottom: 5px; }
    .price-text { color: #198754; font-weight: bold; font-size: 1.1rem; }
    
    /* 수량 조절 */
    .qty-control { display: flex; align-items: center; gap: 15px; }
    .btn-qty { border: 1px solid #198754; background: white; color: #198754; border-radius: 5px; width: 35px; height: 35px; font-weight: bold; cursor: pointer; }
    .btn-qty:hover { background: #198754; color: white; }
    .qty-num { font-weight: bold; width: 30px; text-align: center; border: none; background: none; outline: none; font-size: 1.1rem; }
    
    /* ★ 하단 고정 바 (지우지 않고 절대 고정) */
    .total-bar { 
        position: fixed; 
        bottom: 0; 
        left: 0; 
        width: 100%; 
        background: #ffffff; 
        border-top: 3px solid #198754; 
        padding: 20px 0; 
        box-shadow: 0 -10px 20px rgba(0,0,0,0.1); 
        z-index: 9999; /* 메뉴보다 항상 위에 있게 함 */
    }
    
    .total-container { display: flex; justify-content: space-between; align-items: center; max-width: 1140px; margin: 0 auto; padding: 0 15px; }
</style>

<script>
$(function(){
    // 수량 변경
    $(".btn-qty").click(function(){
        let $item = $(this).closest(".menu-item");
        let $qtyInput = $item.find(".qty-num");
        let currentVal = parseInt($qtyInput.val());

        if($(this).hasClass("plus")) {
            $qtyInput.val(currentVal + 1);
        } else {
            if(currentVal > 0) $qtyInput.val(currentVal - 1);
        }
        calculateTotal();
    });

    function calculateTotal() {
        let total = 0;
        $(".menu-item").each(function(){
            let price = parseInt($(this).data("price"));
            let qty = parseInt($(this).find(".qty-num").val());
            total += (price * qty);
        });
        $("#totalPriceDisplay").text(total.toLocaleString() + "원");
        $("#totalPriceInput").val(total);
    }
});
</script>

<div class="container">
    <h3 class="my-4 fw-bold">🛒 메뉴 선택</h3>

    <form action="write.do" method="post" id="orderForm">
        <input type="hidden" name="storeId" value="${storeId}">

        <c:forEach items="${menuList}" var="mvo">
            <div class="menu-item" data-price="${mvo.price}">
                <div class="menu-info">
                    <h5>${mvo.menuName}</h5>
                    <p class="text-muted small">${mvo.menuContent}</p>
                    <span class="price-text"><fmt:formatNumber value="${mvo.price}" pattern="#,###"/>원</span>
                </div>
                
                <div class="qty-control">
                    <input type="hidden" name="menuNos" value="${mvo.menuNo}">
                    <button type="button" class="btn-qty minus">-</button>
                    <input type="text" name="quantities" class="qty-num" value="0" readonly>
                    <button type="button" class="btn-qty plus">+</button>
                </div>
            </div>
        </c:forEach>

        <div class="total-bar">
            <div class="total-container">
                <div>
                    <span class="text-muted small">총 주문 금액</span>
                    <h2 class="fw-bold mb-0" id="totalPriceDisplay" style="color: #198754;">0원</h2>
                    <input type="hidden" name="totalPrice" id="totalPriceInput" value="0">
                </div>
                <button type="submit" class="btn btn-success btn-lg px-5 fw-bold" style="border-radius: 12px; height: 60px;">
                    주문하기
                </button>
            </div>
        </div>
    </form>
</div>