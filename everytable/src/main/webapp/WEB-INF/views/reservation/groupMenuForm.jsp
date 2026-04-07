<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
body { background-color: #f8f9fa; margin: 0; padding-bottom: 0 !important; }
.menu-item {
    border: 1px solid #eee;
    border-radius: 15px;
    padding: 20px;
    margin-bottom: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #fff;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}
.total-bar {
    position: relative;
    width: 100%;
    background: #ffffff;
    border-top: 3px solid #198754;
    padding: 30px 0;
    box-shadow: 0 -5px 15px rgba(0,0,0,0.05);
    margin-top: 40px;
}
.total-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 1140px;
    margin: 0 auto;
    padding: 0 15px;
}
</style>

<div class="container">
    <h3 class="my-4 fw-bold">🛒 메뉴 선택</h3>

    <form action="/reservation/groupOrderWrite.do" method="post" id="orderForm">
        <input type="hidden" name="resNo" value="${resNo}">

        <c:forEach items="${menuList}" var="mvo">
            <div class="menu-item" data-price="${mvo.price}">
                <div>
                    <strong>${mvo.menu_name}</strong>
                    <p class="text-muted mb-0">${mvo.description}</p>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="fw-bold text-success">
                        <fmt:formatNumber value="${mvo.price}" pattern="#,###"/>원
                    </span>
                    <div class="qty-control">
                        <input type="hidden" name="menuNos" value="${mvo.menu_no}">
                        <button type="button" class="btn-qty minus">-</button>
                        <input type="text" name="quantities" class="qty-num" value="0" readonly>
                        <button type="button" class="btn-qty plus">+</button>
                    </div>
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
                <button type="submit" class="btn btn-success btn-lg px-5 fw-bold"
                        style="border-radius: 12px; height: 60px;">
                    주문 완료
                </button>
            </div>
        </div>
    </form>
</div>

<script>
$(function() {
    $(".btn-qty").click(function() {
        let $item = $(this).closest(".menu-item");
        let $qtyInput = $item.find(".qty-num");
        let currentVal = parseInt($qtyInput.val());
        if ($(this).hasClass("plus")) {
            $qtyInput.val(currentVal + 1);
        } else {
            if (currentVal > 0) $qtyInput.val(currentVal - 1);
        }
        calculateTotal();
    });

    function calculateTotal() {
        let total = 0;
        $(".menu-item").each(function() {
            let price = parseInt($(this).data("price"));
            let qty = parseInt($(this).find(".qty-num").val());
            total += (price * qty);
        });
        $("#totalPriceDisplay").text(total.toLocaleString() + "원");
        $("#totalPriceInput").val(total);
    }
});
</script>
