<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 예약 상세 관리</title>
<style type="text/css">
/* 사용자용(list) 상세 페이지와 동일한 세련된 스타일 적용 */
body { background-color: #f8f9fa; font-family: 'Pretendard', sans-serif; }
* { box-sizing: border-box; }

.page-wrap { max-width: 900px; margin: 0 auto; padding: 40px 20px; }

.page-header { margin-bottom: 24px; display: flex; justify-content: space-between; align-items: flex-end; }
.page-header h2 { font-size: 24px; font-weight: 700; color: #111; letter-spacing: -0.5px; margin: 0; }
.page-header p { font-size: 14px; color: #888; margin-top: 5px; }

/* 카드 레이아웃 */
.detail-card {
    background: #fff;
    border-radius: 20px;
    border: 1px solid #ebebeb;
    padding: 32px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}

/* 배지 스타일 */
.status-badge {
    display: inline-block;
    font-size: 13px;
    font-weight: 600;
    padding: 6px 14px;
    border-radius: 100px;
}
.badge-wait   { background: #fff8e1; color: #b7791f; } /* 대기 */
.badge-ok     { background: #e8f4fd; color: #1a56db; } /* 승인 */
.badge-done   { background: #f0fdf4; color: #166534; } /* 완료 */
.badge-cancel { background: #fff1f1; color: #b91c1c; } /* 거절 */

/* 섹션 타이틀 */
.section-title {
    font-size: 14px;
    font-weight: 700;
    color: #888;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 20px;
    padding-bottom: 8px;
    border-bottom: 1px solid #f0f0f0;
}

/* 정보 테이블 */
.info-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
.info-table th {
    width: 40%;
    padding: 12px 0;
    font-size: 14px;
    color: #888;
    font-weight: 500;
    text-align: left;
}
.info-table td {
    padding: 12px 0;
    font-size: 15px;
    color: #111;
    font-weight: 600;
}
.text-highlight { color: #16a34a; }

/* 메뉴 리스트 테이블 */
.menu-table { width: 100%; border-collapse: collapse; }
.menu-table th {
    padding: 10px 0;
    font-size: 12px;
    color: #aaa;
    border-bottom: 1px solid #f0f0f0;
}
.menu-table td { padding: 14px 0; font-size: 14px; border-bottom: 1px solid #fafafa; }

/* 최종 금액 섹션 */
.total-row {
    margin-top: 15px;
    padding-top: 15px;
    border-top: 2px solid #f0f0f0;
    display: flex;
    justify-content: space-between;
    font-weight: 700;
    font-size: 16px;
}
.total-price { color: #16a34a; font-size: 20px; }

/* 버튼 그룹 */
.action-bar {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid #f0f0f0;
}
.btn-custom {
    padding: 12px 28px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    text-decoration: none;
    transition: all 0.2s;
    border: none;
    cursor: pointer;
}
.btn-success-custom { background: #16a34a; color: #fff; }
.btn-danger-custom { background: #fff; color: #b91c1c; border: 1px solid #fca5a5; }
.btn-ghost-custom { background: #fff; color: #666; border: 1px solid #ddd; }
.btn-success-custom:hover { background: #15803d; }
.btn-danger-custom:hover { background: #fff1f1; }
</style>

<script type="text/javascript">
$(function() {
    // 거절 모달 열기
    $("#rejectBtn").click(function() {
        $("#cancelResNo").val("${vo.resNo}");
        var myModal = new bootstrap.Modal(document.getElementById('rejectModal'));
        myModal.show();
    });

    // 거절 사유 '직접 입력' 시 텍스트 영역 표시
    $("select[name='cancelReason']").change(function() {
        if ($(this).val() === "직접 입력") {
            $("textarea[name='cancelReasonDirect']").show().attr("required", true);
        } else {
            $("textarea[name='cancelReasonDirect']").hide().val("").attr("required", false);
        }
    });
});
</script>
</head>
<body>
<div class="page-wrap">

    <div class="page-header">
        <div>
            <h2>매장 주문 관리</h2>
            <p>접수된 예약 정보를 확인하고 승인 또는 거절 처리를 진행하세요.</p>
        </div>
    </div>

    <div class="detail-card">
        <div class="row g-5">
            
            <%-- 왼쪽: 예약자 및 방문 정보 섹션 --%>
            <div class="col-12 col-md-6">
                <div class="section-title">Customer & Visit Info</div>
                <table class="info-table">
                    <tr>
                        <th>예약 번호</th>
                        <td>No.${vo.resNo}</td>
                    </tr>
                    <tr>
                        <th>예약자 ID</th>
                        <td style="font-size: 17px;">${vo.userId}</td>
                    </tr>
                    <tr>
                        <th>연락처</th>
                        <td>${vo.resPhone}</td>
                    </tr>
                    <tr>
                        <th>예약 상태</th>
                        <td>
                            <c:choose>
                                <c:when test="${vo.resStatus == 1}"><span class="status-badge badge-wait">신규 접수</span></c:when>
                                <c:when test="${vo.resStatus == 2}"><span class="status-badge badge-ok">예약 확정</span></c:when>
                                <c:when test="${vo.resStatus == 3}"><span class="status-badge badge-done">이용 완료</span></c:when>
                                <c:when test="${vo.resStatus == 4}"><span class="status-badge badge-cancel">거절됨</span></c:when>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>방문 예정 일시</th>
                        <td class="text-highlight">${vo.resDate} / ${vo.resTime}</td>
                    </tr>
                    <tr>
                        <th>인원 / 유형</th>
                        <td>${vo.resCount}명 (${vo.resType})</td>
                    </tr>
                    <tr>
                        <th>요청 사항</th>
                        <td>${vo.orderAdd}</td>
                    </tr>
                    <c:if test="${vo.resStatus == 4 && not empty vo.cancelReason}">
                        <tr>
                            <th>거절 사유</th>
                            <td class="text-danger">${vo.cancelReason}</td>
                        </tr>
                    </c:if>
                </table>
            </div>

            <%-- 오른쪽: 주문 메뉴 내역 섹션 --%>
            <div class="col-12 col-md-6">
                <div class="section-title">Order Details</div>
                <table class="menu-table">
                    <thead>
                        <tr>
                            <th class="text-start">메뉴명</th>
                            <th class="text-center">수량</th>
                            <th class="text-end">금액</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty orderList}">
                                <c:forEach items="${orderList}" var="item">
                                    <tr>
                                        <td class="fw-bold">${store.menuName}</td>
                                        <td class="text-center text-muted">${order_item.quantity}개</td>
                                        <td class="text-end"><fmt:formatNumber value="${order_item.price}" />원</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="3" class="text-center text-muted py-5">주문 메뉴 정보가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                
                <div class="total-row">
                    <span>총 주문 금액</span>
                    <span class="total-price">
                        <c:choose>
                            <c:when test="${not empty vo.totalPrice}"><fmt:formatNumber value="${vo.totalPrice}" />원</c:when>
                            <c:otherwise>0원</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>

        <%-- 하단 관리자 액션 바 --%>
        <div class="action-bar">
            <c:if test="${vo.resStatus == 1}">
                <%-- 승인 처리 (adminUpdate.do 호출) --%>
                <a href="adminUpdate.do?resNo=${vo.resNo}&resStatus=2"
                   class="btn-custom btn-success-custom px-4"
                   onclick="return confirm('이 예약을 승인하시겠습니까?')">주문 승인</a>
                
                <%-- 거절 모달 트리거 --%>
                <button id="rejectBtn" class="btn-custom btn-danger-custom px-4">주문 거절</button>
            </c:if>
            
            <%-- 관리자 목록으로 (adminList.do) --%>
            <a href="adminList.do?page=${param.page}&perPageNum=${param.perPageNum}"
               class="btn-custom btn-ghost-custom px-4">목록으로</a>
        </div>
    </div>
</div>

<div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 20px; border: none; padding: 10px;">
            <div class="modal-header" style="border-bottom: none;">
                <h5 class="modal-title fw-bold">주문 거절 사유 입력</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="adminUpdate.do" method="post">
                <input type="hidden" name="resNo" id="cancelResNo">
                <input type="hidden" name="resStatus" value="4">
                <div class="modal-body">
                    <p class="text-muted small mb-3">사용자에게 노출될 거절 사유를 선택해주세요.</p>
                    <select name="cancelReason" class="form-select mb-2" 
                            style="border-radius: 10px; padding: 10px;" required>
                        <option value="">사유 선택 (필수)</option>
                        <option value="재료 소진으로 인한 주문 불가">재료 소진</option>
                        <option value="해당 시간대 예약 만석">예약 만석</option>
                        <option value="개인 사정으로 인한 임시 휴무">임시 휴무</option>
                        <option value="직접 입력">기타 (직접 입력)</option>
                    </select>
                    
                    <textarea name="cancelReasonDirect" class="form-control" rows="3" 
                              style="border-radius: 10px; background: #fafafa; resize: none; display:none;" 
                              placeholder="상세 사유를 입력해주세요."></textarea>
                </div>
                <div class="modal-footer" style="border-top: none;">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal" style="border-radius: 10px;">취소</button>
                    <button type="submit" class="btn btn-danger px-4" style="border-radius: 10px; background: #b91c1c;">거절 확정</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>