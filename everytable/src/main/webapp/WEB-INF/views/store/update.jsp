<%-- (상단 CSS/Header 생략 - 기존 유지) --%>
<form action="update.do" method="post" id="updateForm">
    <input type="hidden" name="store_id" value="${vo.store_id}">
    <%-- 기본 정보/운영 정보 카드 유지 --%>

    <div class="section-card">
        <p class="section-title">환불 정책 수정</p>
        <div class="mb-3">
            <label class="form-label">픽업 24시간 전</label>
            <input type="text" name="refund_policy_24" class="form-control" value="${vo.refund_policy_24}">
        </div>
        <div class="mb-3">
            <label class="form-label">픽업 12시간 전</label>
            <input type="text" name="refund_policy_12" class="form-control" value="${vo.refund_policy_12}">
        </div>
        <div class="mb-0">
            <label class="form-label">픽업 12시간 이내</label>
            <input type="text" name="refund_policy_0" class="form-control" value="${vo.refund_policy_0}">
        </div>
    </div>

    <button type="submit" class="btn-save">변경사항 저장</button>
</form>