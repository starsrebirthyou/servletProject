<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제하기</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
<div class="container mt-5">
    <form action="write.do" method="post" id="paymentForm">
        <input type="hidden" name="order_id" value="${vo.order_id}">
        <input type="hidden" name="amount" value="${vo.amount}">
        <input type="hidden" name="user_id" value="${vo.user_id }">
        <input type="hidden" name="pickupDate" value="${vo.pickupDate}">

        <div class="card shadow-sm mx-auto" style="max-width: 500px; border-radius: 20px; border: none;">
            <div class="card-body p-4">
                <div class="text-center mb-4">
                    <div class="display-4 mb-2">💳</div>
                    <h4 class="fw-bold">결제하기</h4>
                    <p class="text-muted small">안전한 결제를 위해 본인 인증을 진행합니다</p>
                </div>
                
                <div class="mb-4 border-bottom pb-3">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">주문 금액</span>
                        <span class="fw-bold text-success">${vo.amount}원</span> 
                    </div>
                    <div class="d-flex justify-content-between">
                        <span class="text-muted">픽업일시</span>
                        <span class="text-dark fw-bold">${vo.pickupDate}</span>
                    </div>
                </div>
                
                <div class="mb-4">
                    <label class="form-label fw-bold mb-3">결제 수단 선택</label>
                    <div class="form-check border p-3 rounded-4 mb-2 shadow-sm">
                        <input class="form-check-input ms-0 me-2" type="radio" name="method" id="card" value="신용카드" checked>
                        <label class="form-check-label w-100" for="card">
                            <span class="fw-bold">신용/체크카드</span><br>
                            <span class="text-muted small">안전한 PG 결제</span>
                        </label>
                    </div>
                    <div class="form-check border p-3 rounded-4 shadow-sm">
                        <input class="form-check-input ms-0 me-2" type="radio" name="method" id="transfer" value="계좌이체">
                        <label class="form-check-label w-100" for="transfer">
                            <span class="fw-bold">계좌이체</span><br>
                            <span class="text-muted small">무통장 계좌이체</span>
                        </label>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-dark w-100 py-3 fw-bold shadow-sm" style="border-radius: 15px;">
                    ${param.totalPrice}원 결제하기
                </button>
                <button type="button" onclick="history.back();" class="btn btn-link text-muted w-100 mt-2 text-decoration-none">이전으로</button>
            </div>
        </div>
    </form>
</div>

<script type="text/javascript">
$(function() {
    $("#paymentForm").on("submit", function(event) {
        alert("주문이 완료되었습니다! 매장에서 승인하면 알림을 보내드립니다.");
    
    });
});
</script>

</body>
</html>