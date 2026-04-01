<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .menu-item { border: 1px solid #eee; border-radius: 15px; padding: 20px; margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center; background: #fff; }
    .menu-info h5 { font-weight: bold; margin-bottom: 5px; }
    .menu-info p { color: #666; font-size: 0.9rem; margin-bottom: 5px; }
    .price-text { color: #198754; font-weight: bold; font-size: 1.1rem; }
    
    /* 수량 조절 버튼 */
    .qty-control { display: flex; align-items: center; gap: 15px; }
    .btn-qty { border: 1px solid #198754; background: white; color: #198754; border-radius: 5px; width: 30px; height: 30px; font-weight: bold; }
    .btn-qty:hover { background: #198754; color: white; }
    .qty-num { font-weight: bold; width: 20px; text-align: center; border: none; background: none; outline: none; }
    
    /* 하단 고정 바 (총 금액) */
    .total-bar { position: fixed; bottom: 0; left: 0; width: 100%; background: #fff; border-top: 2px solid #198754; padding: 20px; box-shadow: 0 -5px 15px rgba(0,0,0,0.1); }
</style>

<script>
$(function(){
    // 수량 변경 함수
    $(".btn-qty").click(function(){
        let $item = $(this).closest(".menu-item");
        let $qtyInput = $item.find(".qty-num");
        let currentVal = parseInt($qtyInput.val());

        if($(this).hasClass("plus")) {
            $qtyInput.val(currentVal + 1);
        } else {
            if(currentVal > 0) $qtyInput.val(currentVal - 1);
        }
        
        calculateTotal(); // 금액 재계산
    });

    // 총 금액 계산 로직
    function calculateTotal() {
        let total = 0;
        $(".menu-item").each(function(){
            let price = parseInt($(this).data("price"));
            let qty = parseInt($(this).find(".qty-num").val());
            total += (price * qty);
        });

        // 화면 표시 및 hidden input에 값 저장
        $("#totalPriceDisplay").text(total.toLocaleString() + "원");
        $("#totalPriceInput").val(total);
    }
});
</script>

<div class="container" style="margin-bottom: 150px;">
    <h3 class="my-4 fw-bold">메뉴 선택</h3>

    <form action="write.do" method="post" id="orderForm">
        <input type="hidden" name="storeId" value="${storeId}">

        <c:forEach items="${menuList}" var="mvo">
            <div class="menu-item" data-price="${mvo.price}">
                <div class="menu-info">
                    <h5>${mvo.menuName}</h5>
                    <p>${mvo.menuContent}</p>
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
            <div class="container d-flex justify-content-between align-items-center">
                <div>
                    <span class="text-muted">총 주문 금액</span>
                    <h2 class="fw-bold mb-0" id="totalPriceDisplay">0원</h2>
                    <input type="hidden" name="totalPrice" id="totalPriceInput" value="0">
                </div>
                <button type="submit" class="btn btn-success btn-lg px-5 fw-bold">주문하기</button>
            </div>
        </div>
    </form>
</div>