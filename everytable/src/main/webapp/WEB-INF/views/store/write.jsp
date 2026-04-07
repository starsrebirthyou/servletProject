<%-- (상단 CSS/Header 생략 - 기존 유지) --%>
<form action="write.do" method="post" enctype="multipart/form-data" id="writeForm">
    <%-- 1, 2, 3 섹션 유지 --%>

    <div class="form-card">
        <h4 class="section-title"><span class="section-num">4</span> 환불 정책 설정</h4>
        <p class="text-muted small mb-4">픽업 시간 기준 환불 규정을 입력해주세요.</p>
        
        <div class="label-group mb-3">
            <label>픽업 24시간 전 <span class="badge bg-success ms-2">100% 환불 권장</span></label>
            <input type="text" name="refund_policy_24" class="form-control" placeholder="예: 100% 환불" required>
        </div>
        <div class="label-group mb-3">
            <label>픽업 12시간 전 <span class="badge bg-warning ms-2">50% 환불 권장</span></label>
            <input type="text" name="refund_policy_12" class="form-control" placeholder="예: 50% 환불" required>
        </div>
        <div class="label-group mb-3">
            <label>픽업 12시간 이내 <span class="badge bg-danger ms-2">환불 불가 권장</span></label>
            <input type="text" name="refund_policy_0" class="form-control" placeholder="예: 환불 불가" required>
        </div>
    </div>

    <button type="submit" class="btn-submit">매장 등록하기</button>
</form>