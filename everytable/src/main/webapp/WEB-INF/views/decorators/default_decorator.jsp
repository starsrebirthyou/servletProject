<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator"
	prefix="decorator"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>everytable <decorator:title /></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.14.2/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.14.2/jquery-ui.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<style type="text/css">
body {
    font-family: 'Pretendard', 'Apple SD Gothic Neo', sans-serif;
}

.footer-green { background-color: #87a372 !important; }

/* ── 커스텀 모달 ── */
#msgModal .modal-dialog {
    max-width: 380px;
}
#msgModal .modal-content {
    border: none;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.12);
    overflow: hidden;
}
#msgModal .modal-header {
    background: #fff;
    border-bottom: none;
    padding: 28px 28px 0;
    display: flex;
    align-items: center;
    gap: 12px;
}
.modal-icon-wrap {
    width: 44px; height: 44px;
    background: #e8f5ee;
    border-radius: 12px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.2rem;
    color: #0f7a54;
    flex-shrink: 0;
}
#msgModal .modal-title {
    font-size: 1rem;
    font-weight: 700;
    color: #1a1a1a;
    margin: 0;
}
#msgModal .btn-close {
    margin-left: auto;
    opacity: 0.3;
    font-size: 0.8rem;
}
#msgModal .btn-close:hover { opacity: 0.6; }

#msgModal .modal-body {
    padding: 16px 28px 28px;
    font-size: 0.92rem;
    color: #555;
    line-height: 1.7;
    word-break: keep-all;
    border-bottom: none;
}

#msgModal .modal-footer {
    background: #f9faf8;
    border-top: 1px solid #f0f2ee;
    padding: 16px 28px;
    justify-content: flex-end;
}
#msgModal .btn-confirm {
    background: #0f7a54;
    color: #fff;
    border: none;
    border-radius: 10px;
    padding: 9px 24px;
    font-size: 0.88rem;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.15s;
}
#msgModal .btn-confirm:hover { background: #0a5e3f; }
</style>

<script type="text/javascript">
$(function(){
    var msg = "${msg}";
    if(msg.trim()) $('#msgModal').modal('show');
});
</script>
<decorator:head />
</head>
<body>
    <%@ include file="../inc/mainMenu.jsp"%>

    <div class="container-fluid" style="margin-top: 80px; margin-bottom: 80px;">
        <div class="container mt-3 mb-3">
            <decorator:body />
            <%@ include file="/WEB-INF/views/member/loginModal.jsp" %>
        </div>
    </div>

    <footer style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; padding: 40px 0; margin-top: 50px; padding-bottom: 120px;">
        <div class="container" style="text-align: center; color: #6c757d; font-size: 0.8rem; line-height: 1.8;">
            <p style="margin-bottom: 5px;">
                (주)에브리테이블 | 대표: 홍윤정 | 사업자등록번호: 123-45-67890 | 통신판매업신고: 2026-한양여대-12345
            </p>
            <p style="margin-bottom: 5px;">
                주소: 서울특별시 성동구 살곶이길 200 pc22, 2층 | 이메일: cute@everytable.kr
            </p>
            <p style="margin-bottom: 0;">
                호스팅 서비스: Amazon Web Services (AWS) | <strong>Everytable.com</strong>
            </p>
        </div>
    </footer>

    <!-- Message Modal -->
    <div class="modal fade" id="msgModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-icon-wrap">
                        <i class="fa fa-check"></i>
                    </div>
                    <h5 class="modal-title">알림</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">${msg}</div>
                <div class="modal-footer">
                    <button type="button" class="btn-confirm" data-bs-dismiss="modal">확인</button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
<%
session.removeAttribute("msg");
%>
