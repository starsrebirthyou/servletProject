<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
body { background-color: #f8f9fa; }
.status-box {
    max-width: 700px;
    margin: 40px auto;
    background: #fff;
    border-radius: 15px;
    padding: 40px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
}
.action-area {
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px dashed #ddd;
}
/* 추가 요청사항 스타일 */
.order-add-section {
    background: #fff9db;
    padding: 15px;
    border-radius: 10px;
    margin-bottom: 20px;
}
</style>

<div class="status-box">
    <h3 class="fw-bold mb-1">📋 주문 취합 현황</h3>
    <p class="text-muted small mb-4">※ 10초마다 자동 갱신됩니다. 모든 인원이 선택을 마치면 아래 버튼을 눌러주세요.</p>

    <table class="table table-bordered text-center">
        <thead class="table-success">
            <tr><th>메뉴명</th><th>수량</th><th>단가</th><th>소계</th></tr>
        </thead>
        <tbody>
            <c:if test="${empty orderList}">
                <tr><td colspan="4" class="py-4 text-muted">아직 선택된 메뉴가 없습니다.</td></tr>
            </c:if>
            <c:forEach var="item" items="${orderList}">
            <tr>
                <td class="text-start ps-3">${item.menu_name}</td>
                <td>${item.quantity}</td>
                <td><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</td>
                <td class="fw-bold"><fmt:formatNumber value="${item.quantity * item.price}" pattern="#,###"/>원</td>
            </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="text-end mt-3 mb-4">
        <h4 class="fw-bold">
            총 합계: <span class="text-success" id="displayTotal">
                <fmt:formatNumber value="${total}" pattern="#,###"/>원
            </span>
        </h4>
    </div>

    <div class="order-add-section">
        <label for="orderAdd" class="fw-bold mb-2">📢 매장 요청사항</label>
        <textarea name="orderAdd" id="orderAdd" class="form-control" rows="3" 
                  placeholder="예: 아기 의자 2개 부탁드립니다. 알레르기가 있어요."></textarea>
    </div>

    <div class="action-area text-center">
        <form action="/reservation/finalOrder.do" method="post" id="finalOrderForm">
            <input type="hidden" name="resNo" value="${resNo}">
            <input type="hidden" name="storeId" value="${storeId}">
            
            <button type="button" onclick="confirmFinalOrder()" class="btn btn-success btn-lg w-100 py-3 fw-bold shadow-sm" style="border-radius: 10px;">
                ✅ 취합 완료 및 결제하기
            </button>
        </form>
        <p class="mt-2 text-danger small">* 버튼을 누르면 더 이상 메뉴 수정이 불가능합니다.</p>
    </div>
</div>

<meta http-equiv="refresh" content="10">

<script>
function confirmFinalOrder() {
    const orderAdd = document.getElementById("orderAdd").value;
    const resNo = "${resNo}";
    const storeId = "${storeId}";

    if(!storeId) {
        alert("매장 정보가 없습니다. 다시 시도해주세요.");
        return;
    }

    if(confirm("정말로 주문을 확정하시겠습니까?\n취합된 메뉴와 요청사항이 저장됩니다.")) {
        const form = document.getElementById("finalOrderForm");
        
        // 자동 갱신 중단
        window.stop(); 
        
        // [중요] 폼 전송 시 '결제 폼'으로 바로 가는 게 아니라, 
        // '최종 금액/요청사항 저장 서비스'를 거쳐서 redirect 되게 해야 합니다.
        // 만약 컨트롤러에서 redirect 처리를 해두셨다면 아래와 같이 submit만 하면 됩니다.
        form.submit();
    }
}
</script>