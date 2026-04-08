<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
body {
	background-color: #f8f9fa;
	margin: 0;
	padding-bottom: 0 !important;
}

.menu-item {
	border: 1px solid #eee;
	border-radius: 15px;
	padding: 20px;
	margin-bottom: 15px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	background: #fff;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.qty-control {
	display: flex;
	align-items: center;
	gap: 10px;
}

.btn-qty {
	width: 30px;
	height: 30px;
	border-radius: 50%;
	border: 1px solid #ddd;
	background: #fff;
	cursor: pointer;
}

.qty-num {
	width: 40px;
	text-align: center;
	border: none;
	font-weight: bold;
	background: transparent;
}

.total-bar {
	position: sticky; /* 하단에 고정 */
	bottom: 0;
	width: 100%;
	background: #ffffff;
	border-top: 3px solid #198754;
	padding: 20px 0;
	box-shadow: 0 -5px 15px rgba(0, 0, 0, 0.05);
	z-index: 1000;
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

<div class="container mb-5">
	<h3 class="my-4 fw-bold">🛒 메뉴 선택 (${vo.storeName})</h3>

	<%-- 폼 태그 시작 --%>
	<form action="/reservation/groupOrderWrite.do" method="post"
		id="orderForm">

		<%-- [핵심 수정] vo 객체 안에 있는 resNo를 정확히 가져옵니다. --%>
		<input type="hidden" name="resNo" value="${vo.resNo}">

		<c:forEach items="${menuList}" var="mvo">
			<div class="menu-item" data-price="${mvo.price}">
				<div>
					<strong class="fs-5">${mvo.menu_name}</strong>
					<p class="text-muted mb-0 small">${mvo.description}</p>
				</div>
				<div class="d-flex align-items-center gap-3">
					<span class="fw-bold text-success fs-5"> <fmt:formatNumber
							value="${mvo.price}" pattern="#,###" />원
					</span>
					<div class="qty-control">
						<input type="hidden" name="menuNos" value="${mvo.menu_no}">
						<button type="button" class="btn-qty minus">-</button>
						<input type="text" name="quantities" class="qty-num" value="0"
							readonly>
						<button type="button" class="btn-qty plus">+</button>
					</div>
				</div>
			</div>
		</c:forEach>
		
		<div class="card border-0 shadow-sm rounded-4 p-4 mb-5">
            <label for="orderAdd" class="form-label fw-bold">
                <i class="fa-solid fa-comment-dots me-2"></i>매장 요청 사항
            </label>
            <textarea name="orderAdd" id="orderAdd" class="form-control border-0 bg-light" 
                      rows="3" placeholder="예) 아기가 있어요, 오이는 빼주세요 등 요청사항을 적어주세요."
                      style="border-radius: 15px; resize: none;">${vo.orderAdd}</textarea>
            <div class="form-text text-end mt-2">※ 매장 상황에 따라 요청 사항 반영이 어려울 수 있습니다.</div>
        </div>

		<%-- 하단 고정 바 --%>
		<div class="total-bar">
			<div class="total-container">
				<div>
					<span class="text-muted small">총 주문 금액</span>
					<h2 class="fw-bold mb-0" id="totalPriceDisplay"
						style="color: #198754;">0원</h2>
					<input type="hidden" name="totalPrice" id="totalPriceInput"
						value="0">
				</div>
				<button type="submit" class="btn btn-success btn-lg px-5 fw-bold"
					style="border-radius: 12px; height: 60px;">주문 완료</button>
			</div>
		</div>
	</form>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	$(function() {
		// 수량 조절 버튼 클릭 이벤트
		$(".btn-qty").click(function() {
			let $item = $(this).closest(".menu-item");
			let $qtyInput = $item.find(".qty-num");
			let currentVal = parseInt($qtyInput.val());

			if ($(this).hasClass("plus")) {
				$qtyInput.val(currentVal + 1);
			} else {
				if (currentVal > 0)
					$qtyInput.val(currentVal - 1);
			}
			calculateTotal();
		});

		// 총 금액 계산 함수
		function calculateTotal() {
			let total = 0;
			$(".menu-item").each(function() {
				let price = parseInt($(this).data("price")) || 0;
				let qty = parseInt($(this).find(".qty-num").val()) || 0;
				total += (price * qty);
			});
			$("#totalPriceDisplay").text(total.toLocaleString() + "원");
			$("#totalPriceInput").val(total);
		}
	});
</script>