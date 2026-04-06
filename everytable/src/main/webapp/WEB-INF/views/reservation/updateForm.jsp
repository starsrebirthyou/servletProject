<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 정보 수정</title>
<style type="text/css">
body { background-color: #f8f9fa; font-family: 'Pretendard', sans-serif; }
.page-wrap { max-width: 900px; margin: 0 auto; padding: 40px 20px; }
.detail-card { background: #fff; border-radius: 20px; border: 1px solid #ebebeb; padding: 32px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03); }
.section-title { font-size: 14px; font-weight: 700; color: #888; text-transform: uppercase; border-bottom: 1px solid #f0f0f0; margin-bottom: 20px; padding-bottom: 8px; }
.form-control, .form-select { border-radius: 12px; border: 1px solid #ddd; padding: 12px; margin-bottom: 15px; width: 100%; }
.read-only-input { background-color: #f1f3f5; color: #888; cursor: not-allowed; }
.menu-table { width: 100%; border-collapse: collapse; }
.menu-table th { font-size: 12px; color: #aaa; border-bottom: 1px solid #f0f0f0; padding: 10px 0; }
.menu-table td { padding: 14px 0; border-bottom: 1px solid #fafafa; }
.total-row { margin-top: 15px; padding-top: 15px; border-top: 2px solid #f0f0f0; display: flex; justify-content: space-between; font-weight: 700; }
.total-price { color: #16a34a; font-size: 18px; }
.btn-custom { padding: 12px 28px; border-radius: 10px; font-weight: 600; cursor: pointer; border: none; font-size: 14px; text-decoration: none; }
.btn-primary-custom { background: #111; color: #fff; }
.btn-add { background: #f1f3f5; color: #333; padding: 10px; border-radius: 10px; font-size: 12px; border: 1px solid #dee2e6; margin-bottom: 15px; width: 100%; }
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
	$(function() {
		// [1] 수량 변경 시 즉시 계산 (동적 생성된 요소에도 적용하기 위해 위임 사용)
		$(document).on("input", ".qty-input", function() {
			updateTotal();
		});

		// [2] 메뉴 추가 버튼 클릭 이벤트
		$("#addMenuBtn").on("click", function() {
			const select = $("#menuSelect option:selected");
			const menuNo = select.val();
			const menuName = select.data("name");
			const price = parseInt(select.data("price"));

			if (!menuNo) {
				alert("추가할 메뉴를 선택해주세요.");
				return;
			}

			// 이미 리스트에 있는지 확인
			let exists = false;
			$(".menu-row").each(function() {
				if ($(this).find("input[name='menuNos']").val() == menuNo) {
					alert("이미 리스트에 있는 메뉴입니다. 수량을 조절해 주세요.");
					exists = true;
					return false;
				}
			});
			if (exists) return;

			// 테이블에 행 추가
			const newRow = `
				<tr class="menu-row">
					<td class="fw-bold">` + menuName + `</td>
					<td class="text-center">
						<input type="number" name="quantities" class="qty-input" value="1" min="0"
							style="width: 50px; text-align: center; border: 1px solid #ddd; border-radius: 6px;">
						<input type="hidden" name="menuNos" value="` + menuNo + `">
						<input type="hidden" class="unit-price" value="` + price + `">
					</td>
					<td class="text-end subtotal-text">` + price.toLocaleString() + `원</td>
				</tr>`;

			$(".menu-table tbody").append(newRow);
			updateTotal();
		});

		// [3] 총 금액 계산 함수
		function updateTotal() {
			let total = 0;
			$(".menu-row").each(function() {
				const price = parseInt($(this).find(".unit-price").val()) || 0;
				const qty = parseInt($(this).find(".qty-input").val()) || 0;
				const subtotal = price * qty;

				$(this).find(".subtotal-text").text(subtotal.toLocaleString() + "원");
				total += subtotal;
			});
			$("#displayTotalPrice").text(total.toLocaleString() + "원");
			$("#totalPriceInput").val(total);
		}
	});
</script>
</head>
<body>
	<div class="page-wrap">
		<div class="detail-card">
			<form action="update.do" method="post">
				<input type="hidden" name="resNo" value="${vo.resNo}"> 
				<input type="hidden" name="totalPrice" id="totalPriceInput" value="${vo.totalPrice}">

				<div class="row" style="display: flex; gap: 40px;">
					<div style="flex: 1;">
						<div class="section-title">Reservation Info</div>
						<label class="small text-muted">매장명</label> 
						<input type="text" class="form-control read-only-input" value="${vo.storeName}" readonly> 
						
						<label class="small text-muted">연락처</label>
						<input type="text" class="form-control" value="${vo.resPhone}">
						
						<label class="small text-muted">방문 예정 일시</label>
						<div style="display: flex; gap: 10px;">
							<input type="date" name="resDate" class="form-control" value="${vo.resDate}"> 
							<input type="time" name="resTime" class="form-control" value="${vo.resTime}">
						</div>

						<label class="small text-muted">예약 인원</label> 
						<input type="number" name="resCount" class="form-control" value="${vo.resCount}" min="1"> 
						
						<label class="small text-muted">예약 유형</label> 
						<select class="form-select" name="resType">
							<option value="단체" ${vo.resType == '단체'?'selected':''}>단체</option>
							<option value="픽업" ${vo.resType == '픽업'?'selected':''}>픽업</option>
						</select>
					</div>

					<div style="flex: 1;">
						<div class="section-title">Order Menu</div>
						<table class="menu-table">
							<thead>
								<tr>
									<th class="text-start">메뉴명</th>
									<th class="text-center">수량</th>
									<th class="text-end">금액</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${vo.orderList}" var="item">
									<tr class="menu-row">
										<td class="fw-bold">${item.menuName}</td>
										<td class="text-center">
											<input type="number" name="quantities" class="qty-input" value="${item.quantity}" min="0"
												style="width: 50px; text-align: center; border: 1px solid #ddd; border-radius: 6px;">
											<input type="hidden" name="menuNos" value="${item.menuNo}">
											<input type="hidden" class="unit-price" value="${item.price}">
										</td>
										<td class="text-end subtotal-text">
											<fmt:formatNumber value="${item.price * item.quantity}" />원
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>

						<div class="section-title" style="margin-top: 30px;">Add New Menu</div>
						<div style="display: flex; gap: 5px;">
							<select id="menuSelect" class="form-select" style="flex: 3; font-size: 13px;">
								<option value="">-- 추가할 메뉴 선택 --</option>
								<c:forEach items="${vo.storeMenuList}" var="menu">
									<option value="${menu.menuNo}" data-name="${menu.menuName}" data-price="${menu.price}">
										${menu.menuName} (<fmt:formatNumber value="${menu.price}" />원)
									</option>
								</c:forEach>
							</select>
							<button type="button" id="addMenuBtn" class="btn-custom" 
								style="flex: 1; background: #333; color: #fff; padding: 0 15px; height: 45px; font-size: 12px;">추가</button>
						</div>

						<div class="total-row">
							<span>최종 결제 금액</span> 
							<span class="total-price" id="displayTotalPrice"> 
								<fmt:formatNumber value="${vo.totalPrice}" />원
							</span>
						</div>
					</div>
				</div>

				<div style="text-align: center; margin-top: 30px; border-top: 1px solid #f0f0f0; padding-top: 20px; display: flex; justify-content: center; gap: 10px;">
					<button type="submit" class="btn-custom btn-primary-custom">수정 완료</button>
					<button type="button" class="btn-custom" style="background: #fff; color: #666; border: 1px solid #ddd;" onclick="history.back()">취소</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>