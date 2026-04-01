<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제하기</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <form action="write.do" method="post">
    <input type="hidden" name="order_id" value="1">
	<input type="hidden" name="user_id" value="admin">
	<input type="hidden" name="amount" value="300000">

        <div class="card shadow-sm mx-auto" style="max-width: 500px;">
            <div class="card-body">
                <div class="text-center mb-4">
                    <img src="https://via.placeholder.com/50" class="rounded-circle mb-2" alt="icon">
                    <h4 class="fw-bold">결제하기</h4>
                    <p class="text-muted small">안전한 결제를 위해 본인 인증을 진행합니다</p>
                </div>
                
                <div class="mb-4 border-bottom pb-3">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">주문 금액</span>
                        <span class="fw-bold">300,000원</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span class="text-muted">픽업일시</span>
                        <span class="text-dark">2026-04-12 15:30</span>
                    </div>
                    <input type="hidden" name="amount" value="300000">
                </div>
                
                <div class="mb-4">
                    <label class="form-label fw-bold mb-3">결제 수단 선택</label>
                    <div class="form-check border p-3 rounded mb-2 shadow-sm">
                        <input class="form-check-input" type="radio" name="method" id="card" value="신용카드" checked>
                        <label class="form-check-label w-100" for="card">
                            <span class="fw-bold">신용/체크카드</span><br>
                            <span class="text-muted small">안전한 PG 결제</span>
                        </label>
                    </div>
                    <div class="form-check border p-3 rounded shadow-sm">
                        <input class="form-check-input" type="radio" name="method" id="transfer" value="계좌이체">
                        <label class="form-check-label w-100" for="transfer">
                            <span class="fw-bold">계좌이체</span><br>
                            <span class="text-muted small">무통장 계좌이체</span>
                        </label>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-warning w-100 py-3 fw-bold text-dark shadow">300,000원 결제하기</button>
                <button type="button" onclick="history.back();" class="btn btn-light w-100 mt-2 py-2">이전으로</button>
            </div>
        </div>
    </form>
</div>
</body>
</html>