<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 상세 정보</title>
<style type="text/css">
#cancelDiv { display: none; }
.table th {
    width: 35%;
    background-color: #f8f9fa;
    vertical-align: middle;
}
.section-title {
    font-size: 1.1rem;
    font-weight: bold;
    border-left: 4px solid #198754;
    padding-left: 10px;
    margin-bottom: 15px;
}
.order-item-row td { vertical-align: middle; }
.total-row { background-color: #f8f9fa; font-weight: bold; font-size: 1.05rem; }
</style>
<script type="text/javascript">
$(function() {
    $("#cancelBtn").click(function() {
        $("#cancelReason").val("");
        $("#cancelDiv").toggle();
        if ($("#cancelDiv").is(":visible")) {
            $('html, body').animate({ scrollTop: $(document).height() }, 500);
        }
    });
});
</script>
</head>
<body>
<div class="container-fluid px-4">
    <h2 class="my-4 fw-bold">예약 상세 내역</h2>

    <div class="row g-4">

        <%-- ===== 왼쪽: 예약 정보 ===== --%>
        <div class="col-12 col-md-6">
            <div class="section-title">예약 정보</div>
            <table class="table table-bordered">
                <tbody>
                    <tr>
                        <th>예약 번호</th>
                        <td>${vo.resNo}</td>
                    </tr>
                    <tr>
                        <th>매장명</th>
                        <td class="fw-bold">${vo.storeName}</td>
                    </tr>
                    <tr>
                        <th>예약 상태</th>
                        <td>
                            <c:choose>
                                <c:when test="${vo.resStatus == 1}"><span class="text-warning fw-bold">매장 확인 중</span></c:when>
                                <c:when test="${vo.resStatus == 2}"><span class="text-primary fw-bold">예약 확정</span></c:when>
                                <c:when test="${vo.resStatus == 3}"><span class="text-success fw-bold">이용 완료</span></c:when>
                                <c:when test="${vo.resStatus == 4}"><span class="text-danger fw-bold">취소됨</span></c:when>
                                <c:otherwise><span>상태코드: ${vo.resStatus}</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <th>예약자 ID</th>
                        <td>${vo.userId}</td>
                    </tr>
                    <tr>
                        <th>연락처</th>
                        <td>${vo.resPhone}</td>
                    </tr>
                    <tr>
                        <th>방문 예정 일시</th>
                        <td class="text-success fw-bold">${vo.resDate} / ${vo.resTime}</td>
                    </tr>
                    <tr>
                        <th>예약 인원</th>
                        <td>${vo.resCount}명</td>
                    </tr>
                    <tr>
                        <th>예약 타입</th>
                        <td>${vo.resType}</td>
                    </tr>
                    <c:if test="${vo.resStatus == 4 && not empty vo.cancelReason}">
                        <tr>
                            <th>취소 사유</th>
                            <td class="text-muted">${vo.cancelReason}</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <%-- ===== 오른쪽: 메뉴 주문 + 최종 금액 ===== --%>
        <div class="col-12 col-md-6">
            <div class="section-title">주문 메뉴</div>
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>메뉴명</th>
                        <th class="text-center">수량</th>
                        <th class="text-end">금액</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- 주문 메뉴 리스트 (orderList는 Controller에서 넘겨줘야 해요) --%>
                    <c:choose>
                        <c:when test="${not empty orderList}">
                            <c:forEach items="${orderList}" var="item">
                                <tr class="order-item-row">
                                    <td>${item.menuName}</td>
                                    <td class="text-center">${item.quantity}개</td>
                                    <td class="text-end">${item.price}원</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="3" class="text-center text-muted py-4">주문 메뉴 정보가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
                <tfoot>
                    <tr class="total-row">
                        <td colspan="2" class="text-end">최종 결제 금액</td>
                        <td class="text-end text-success">
                            <c:choose>
                                <c:when test="${not empty vo.totalPrice}">${vo.totalPrice}원</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>

    </div><%-- row 끝 --%>

    <%-- 버튼 영역 --%>
    <div class="mb-4 text-center">
        <c:if test="${vo.resStatus == 1 || vo.resStatus == 2}">
            <a href="updateForm.do?no=${vo.resNo}&page=${param.page}&perPageNum=${param.perPageNum}"
               class="btn btn-primary px-4">예약 수정</a>
            <button id="cancelBtn" class="btn btn-danger px-4">예약 취소</button>
        </c:if>
        <a href="list.do?page=${param.page}&perPageNum=${param.perPageNum}"
           class="btn btn-outline-secondary px-4">목록으로</a>
    </div>

    <%-- 예약 취소 폼 --%>
    <div id="cancelDiv" class="card card-body bg-light mb-5">
        <form action="cancel.do" method="post">
            <input type="hidden" name="resNo" value="${vo.resNo}">
            <input type="hidden" name="page" value="${param.page}">
            <input type="hidden" name="perPageNum" value="${param.perPageNum}">
            <div class="mb-3">
                <label for="cancelReason" class="form-label text-danger">
                    <strong>취소 사유를 입력해주세요.</strong>
                </label>
                <textarea class="form-control" id="cancelReason" name="cancelReason" rows="3" required></textarea>
            </div>
            <div class="text-end">
                <button type="submit" class="btn btn-danger px-4">취소 확정</button>
                <button type="button" onclick="$('#cancelDiv').hide();" class="btn btn-light border px-4">닫기</button>
            </div>
        </form>
    </div>

</div>
</body>
</html>