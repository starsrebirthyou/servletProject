<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="pageNav" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>매장 주문 관리 (관리자)</title>
<style type="text/css">
    body { background-color: #f8f9fa; }
    .res-card {
        border: 1px solid #e9ecef;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 20px;
        background-color: #fff;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }
    .status-badge { font-size: 0.85rem; padding: 6px 15px; border-radius: 50px; font-weight: bold; }
    
    /* 관리자용 정보 박스 스타일 */
    .admin-info-box { background-color: #f1f3f5; border-radius: 10px; padding: 15px; margin: 15px 0; border-left: 5px solid #198754; }
    .user-info { font-size: 1.1rem; font-weight: bold; color: #333; }
    .res-details { font-size: 0.95rem; color: #495057; }
    
    /* 버튼 스타일 */
    .btn-action { font-weight: bold; padding: 10px 25px; border-radius: 8px; }
</style>

<script type="text/javascript">
    $(function() {
        // 필터 버튼 클릭
        $("#filterKey .btn").click(function() {
            location = "list.do?page=1&perPageNum=${pageObject.perPageNum}&key=" + $(this).val();
        });

        // 현재 필터 활성화
        let currentKey = "${pageObject.key}" || "0";
        $("#filterKey .btn[value='" + currentKey + "']").removeClass("btn-outline-dark").addClass("btn-dark active");

        // [거절 버튼 클릭 시] 모달에 데이터 세팅
        $(".btn-reject-modal").click(function() {
            let no = $(this).data("no");
            $("#modalResNo").val(no);
        });
    });
</script>
</head>
<body>

<div class="container mb-5">
    <div class="d-flex justify-content-between align-items-center my-4">
        <h2 class="fw-bold mb-0">🏪 매장 주문 관리</h2>
        <div class="btn-group" id="filterKey">
            <button type="button" class="btn btn-outline-dark" value="0">전체</button>
            <button type="button" class="btn btn-outline-dark" value="1">신규대기</button>
            <button type="button" class="btn btn-outline-dark" value="2">승인됨</button>
            <button type="button" class="btn btn-outline-dark" value="4">거절/취소</button>
        </div>
    </div>

    <c:if test="${empty list}">
        <div class="text-center py-5 border rounded bg-white">
            <p class="text-muted fs-5 mb-0">접수된 주문이 없습니다.</p>
        </div>
    </c:if>

    <c:forEach items="${list}" var="vo">
        <div class="res-card">
            <div class="d-flex justify-content-between align-items-start">
                <div>
                    <span class="text-muted small">No.${vo.resNo} | 접수일시: ${vo.resCreatedAt}</span>
                    <div class="user-info mt-1">예약자: ${vo.userId} (${vo.resPhone})</div>
                </div>
                
                <%-- 상태 표시 배지 --%>
                <c:choose>
                    <c:when test="${vo.resStatus == 1}"><span class="status-badge bg-warning text-dark">신규 대기</span></c:when>
                    <c:when test="${vo.resStatus == 2}"><span class="status-badge bg-primary text-white">승인 완료</span></c:when>
                    <c:when test="${vo.resStatus == 3}"><span class="status-badge bg-success text-white">이용 완료</span></c:when>
                    <c:when test="${vo.resStatus == 4}"><span class="status-badge bg-danger text-white">거절/취소</span></c:when>
                </c:choose>
            </div>

            <%-- 방문 정보 박스 --%>
            <div class="admin-info-box row g-0 align-items-center">
                <div class="col-md-4 border-end border-secondary-subtle">
                    <div class="small text-muted">방문 예정일</div>
                    <div class="fw-bold fs-5 text-success">${vo.resDate} ${vo.resTime}</div>
                </div>
                <div class="col-md-4 border-end border-secondary-subtle ps-md-4">
                    <div class="small text-muted">인원 및 유형</div>
                    <div class="fw-bold fs-5">${vo.resCount}명 / ${vo.resType}</div>
                </div>
                <div class="col-md-4 ps-md-4">
                    <div class="small text-muted">주문 금액</div>
                    <div class="fw-bold fs-5 text-primary"><fmt:formatNumber value="${vo.totalPrice}" pattern="#,###"/>원</div>
                </div>
            </div>

            <%-- 거절 사유 표시 (상태가 4일 때만) --%>
            <c:if test="${vo.resStatus == 4 && not empty vo.cancelReason}">
                <div class="alert alert-secondary py-2 small">
                    <strong>거절 사유:</strong> ${vo.cancelReason}
                </div>
            </c:if>

            <%-- 관리자 액션 버튼 --%>
            <div class="d-flex justify-content-end gap-2 mt-3">
                <a href="view.do?no=${vo.resNo}" class="btn btn-outline-secondary btn-sm px-3">상세보기</a>
                
                <c:if test="${vo.resStatus == 1}">
                    <%-- 승인 시 status=2 전송 --%>
                    <a href="updateStatus.do?resNo=${vo.resNo}&resStatus=2" 
                       class="btn btn-success btn-action" onclick="return confirm('이 예약을 승인하시겠습니까?')">승인하기</a>
                    
                    <%-- 거절 시 모달 띄우기 --%>
                    <button type="button" class="btn btn-danger btn-action btn-reject-modal" 
                            data-no="${vo.resNo}" data-bs-toggle="modal" data-bs-target="#rejectModal">
                        거절하기
                    </button>
                </c:if>
            </div>
        </div>
    </c:forEach>

    <%-- 페이지 네이션 --%>
    <div class="d-flex justify-content-center mt-4">
        <pageNav:pageNav listURI="list.do" pageObject="${pageObject}" />
    </div>
</div>

<div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="updateStatus.do" method="post">
                <input type="hidden" name="resNo" id="modalResNo">
                <input type="hidden" name="resStatus" value="4"> <div class="modal-header">
                    <h5 class="modal-title fw-bold">주문 거절 사유 입력</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted small">사용자에게 전달될 거절 사유를 선택하거나 직접 입력해주세요.</p>
                    <select name="cancelReason" class="form-select mb-3" required>
                        <option value="">사유 선택 (필수)</option>
                        <option value="재료 소진으로 인한 주문 불가">재료 소진</option>
                        <option value="해당 시간대 예약 만석">예약 만석</option>
                        <option value="개인 사정으로 인한 임시 휴무">임시 휴무</option>
                        <option value="직접 입력">기타 (직접 입력)</option>
                    </select>
                    <textarea name="cancelReasonDirect" class="form-control" rows="3" placeholder="기타 사유 입력 시 작성"></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="submit" class="btn btn-danger px-4">거절 처리</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>