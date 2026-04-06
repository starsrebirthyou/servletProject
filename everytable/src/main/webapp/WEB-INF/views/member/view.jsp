<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 정보</title>

<style>
.info-card {
    background: #fff; border-radius: 14px;
    border: 1px solid #e8ebe6; overflow: hidden;
    max-width: 640px; margin: 0 auto;
}
.info-row {
    display: flex; align-items: center;
    padding: 14px 24px; border-bottom: 1px solid #f3f5f2;
}
.info-row:last-child { border-bottom: none; }
.info-label {
    width: 130px; font-weight: 600;
    font-size: 0.88rem; color: #666; flex-shrink: 0;
}
.info-value { flex: 1; font-size: 0.95rem; color: #333; }
.btn-edit {
    background: none; border: 1px solid #0f7a54; color: #0f7a54;
    border-radius: 6px; padding: 3px 12px; font-size: 0.8rem;
    cursor: pointer; white-space: nowrap; margin-left: 8px;
}
.btn-edit:hover { background: #0f7a54; color: #fff; }

/* 인라인 수정 폼 */
.edit-form {
    display: none; background: #f8faf7;
    border-top: 1px solid #e8ebe6; padding: 16px 24px;
}
.edit-form.active { display: block; }
.edit-form .form-control { font-size: 0.88rem; }
.edit-form .btn-sm { font-size: 0.82rem; }
</style>

<script type="text/javascript">
$(function(){

    // ── 수정 폼 토글 ──
    $(".btn-edit").click(function(){
        let target = $(this).data("target");
        $(".edit-form").not("#" + target).each(function(){
            $(this).removeClass("active");
            $(this).find("input").val("");           // 입력값 초기화
            $(this).find("input").prop("disabled", false);  // disabled 해제
            $(this).find("button").prop("disabled", false); // 버튼 disabled 해제
            $(this).find("#emailCodeArea").hide();   // 인증번호 영역 숨김
            $(this).find("#emailVerifiedMsg").hide(); // 인증 완료 메시지 숨김
        });
        
        // 대상 폼 토글
        let form = $("#" + target);
        if(form.hasClass("active")){
            // 닫힐 때도 초기화
            form.removeClass("active");
            form.find("input").val("");
            form.find("input").prop("disabled", false);
            form.find("button").prop("disabled", false);
            form.find("#emailCodeArea").hide();
            form.find("#emailVerifiedMsg").hide();
            emailVerified = false;
        } else {
            form.addClass("active");
        }
    });

    // ── 비밀번호 수정 ──
    $("#pwSaveBtn").click(function(){
        let curPw  = $("#curPw").val();
        let newPw  = $("#newPw").val();
        let newPw2 = $("#newPw2").val();

        if(!curPw || !newPw || !newPw2){
            alert("모든 항목을 입력해 주세요."); return;
        }
        if(newPw !== newPw2){
            alert("새 비밀번호와 확인이 일치하지 않습니다.");
            $("#newPw2").val("").focus(); return;
        }
        if(newPw.length < 4 || newPw.length > 20){
            alert("비밀번호는 4~20자로 입력해 주세요."); return;
        }

        $.ajax({
            url: "/member/changePw.do",
            method: "POST",
            data: { curPw: curPw, newPw: newPw },
            success: function(data){
                let result = $(data).find("#ajax-data-result").text().trim();
                if(result === "ok"){
                    alert("비밀번호가 변경되었습니다.");
                    $("#pwForm").removeClass("active");
                    $("#curPw, #newPw, #newPw2").val("");
                } else {
                    alert("현재 비밀번호가 일치하지 않습니다.");
                    $("#curPw").val("").focus();
                }
            },
            error: function(){ alert("서버 오류가 발생했습니다."); }
        });
    });
    
    $(".cancel-btn").click(function(){
        let target = $("#" + $(this).data("target"));
        target.removeClass("active");
        target.find("input").val("");
        target.find("input").prop("disabled", false);
        target.find("button").prop("disabled", false);
        target.find("#emailCodeArea").hide();
        target.find("#emailVerifiedMsg").hide();
        emailVerified = false;
    });

    // ── 전화번호 수정 ──
    $("#telSaveBtn").click(function(){
        let tel = $("#newTel").val().trim();
        let telPattern = /^0\d{1,2}-\d{3,4}-\d{4}$/;

        if(tel !== "" && !telPattern.test(tel)){
            alert("올바른 전화번호 형식으로 입력해 주세요. (예: 010-1234-5678)");
            return;
        }

        $.ajax({
            url: "/member/changeTel.do",
            method: "POST",
            data: { tel: tel },
            success: function(data){
                let result = $(data).find("#ajax-data-result").text().trim();
                if(result === "ok"){
                    alert("전화번호가 변경되었습니다.");
                    location.reload();
                } else if(result === "dup"){
                    alert("이미 가입된 전화번호입니다.");
                } else {
                    alert("변경에 실패했습니다.");
                }
            },
            error: function(){ alert("서버 오류가 발생했습니다."); }
        });
    });

    // ── 이메일 인증번호 발송 ──
    let emailVerified = false;

    $("#emailSendBtn").click(function(){
        let email = $("#newEmail").val().trim();
        if(!email || !email.includes("@")){
            alert("올바른 이메일을 입력해 주세요."); return;
        }

        $(this).prop("disabled", true).text("전송 중...");

        $.ajax({
            url: "/member/sendAuthCode.do",
            method: "POST",
            data: { email: email },
            success: function(data){
                let result = $(data).find("#ajax-data-result").text().trim();
                if(result === "ok"){
                    $("#emailCodeArea").show();
                    $("#emailSendBtn").text("재전송").prop("disabled", false);
                    emailVerified = false;
                } else {
                    alert("메일 발송에 실패했습니다.");
                    $("#emailSendBtn").text("인증번호 받기").prop("disabled", false);
                }
            },
            error: function(){
                alert("서버 오류가 발생했습니다.");
                $("#emailSendBtn").text("인증번호 받기").prop("disabled", false);
            }
        });
    });

    // ── 이메일 인증번호 확인 ──
    $("#emailVerifyBtn").click(function(){
        let code = $("#emailCode").val().trim();
        if(!code){ alert("인증번호를 입력해 주세요."); return; }

        $.ajax({
            url: "/member/verifyAuthCode.do",
            method: "POST",
            data: { code: code },
            success: function(data){
                let result = $(data).find("#ajax-data-result").text().trim();
                if(result === "ok"){
                    emailVerified = true;
                    $("#emailVerifiedMsg").show();
                    $("#emailCode").prop("disabled", true);
                    $("#emailVerifyBtn").prop("disabled", true);
                } else {
                    alert("인증번호가 일치하지 않습니다.");
                    $("#emailCode").val("").focus();
                }
            },
            error: function(){ alert("서버 오류가 발생했습니다."); }
        });
    });

    // ── 이메일 저장 ──
    $("#emailSaveBtn").click(function(){
        if(!emailVerified){
            alert("이메일 인증을 완료해 주세요."); return;
        }
        let email = $("#newEmail").val().trim();

        $.ajax({
            url: "/member/changeEmail.do",
            method: "POST",
            data: { email: email },
            success: function(data){
                let result = $(data).find("#ajax-data-result").text().trim();
                if(result === "ok"){
                    alert("이메일이 변경되었습니다.");
                    location.reload();
                } else if(result === "dup"){
                    alert("이미 가입된 이메일입니다.");
                } else {
                    alert("변경에 실패했습니다.");
                }
            },
            error: function(){ alert("서버 오류가 발생했습니다."); }
        });
    });

    // ── 회원탈퇴 ──
    $("#deleteBtn").click(function(){
        if(confirm("탈퇴하면 복구할 수 없습니다. 정말 탈퇴하시겠습니까?")){
            location.href = "/member/withdraw.do";
        }
    });
});
</script>
</head>
<body>

<div class="d-flex align-items-center mb-4 mt-3">
    <div class="me-3" style="width:54px;height:54px;background:#e8f5ee;border-radius:14px;
                              display:flex;align-items:center;justify-content:center;
                              font-size:1.5rem;color:#0f7a54;">
        <i class="fa fa-user"></i>
    </div>
    <div>
        <h2 class="fw-bold mb-0 text-dark" style="font-size:1.5rem;">내 정보</h2>
        <p class="text-muted mb-0" style="font-size:0.88rem;">회원 정보를 확인하고 수정할 수 있습니다.</p>
    </div>
</div>

<c:if test="${not empty sessionScope.msg}">
    <div class="alert alert-success">${sessionScope.msg}</div>
    <c:remove var="msg" scope="session"/>
</c:if>

<div class="info-card">

    <!-- 이름 -->
    <div class="info-row">
        <span class="info-label">이름</span>
        <span class="info-value">${vo.name}</span>
    </div>

    <!-- 아이디 -->
    <div class="info-row">
        <span class="info-label">아이디</span>
        <span class="info-value">${vo.id}</span>
    </div>

    <!-- 비밀번호 -->
    <div class="info-row">
        <span class="info-label">비밀번호</span>
        <span class="info-value">******</span>
        <button class="btn-edit" data-target="pwForm">변경</button>
    </div>
    <div class="edit-form" id="pwForm">
        <div class="mb-2">
            <input type="password" class="form-control form-control-sm" id="curPw"
                   placeholder="현재 비밀번호">
        </div>
        <div class="mb-2">
            <input type="password" class="form-control form-control-sm" id="newPw"
                   placeholder="새 비밀번호 (4~20자)">
        </div>
        <div class="mb-3">
            <input type="password" class="form-control form-control-sm" id="newPw2"
                   placeholder="새 비밀번호 확인">
        </div>
        <button class="btn btn-success btn-sm" id="pwSaveBtn">저장</button>
        <button class="btn btn-secondary btn-sm cancel-btn" data-target="pwForm">취소</button>
    </div>

    <!-- 생년월일 -->
    <div class="info-row">
        <span class="info-label">생년월일</span>
        <span class="info-value">${vo.birth}</span>
    </div>

    <!-- 전화번호 -->
    <div class="info-row">
        <span class="info-label">전화번호</span>
        <span class="info-value">${empty vo.tel ? '미등록' : vo.tel}</span>
        <button class="btn-edit" data-target="telForm">변경</button>
    </div>
    <div class="edit-form" id="telForm">
        <div class="mb-3">
            <input type="tel" class="form-control form-control-sm" id="newTel"
                   placeholder="예) 010-1234-5678 (비우면 삭제)"
                   value="${vo.tel}">
        </div>
        <button class="btn btn-success btn-sm" id="telSaveBtn">저장</button>
        <button class="btn btn-secondary btn-sm cancel-btn" data-target="telForm">취소</button>
    </div>

    <!-- 이메일 -->
    <div class="info-row">
        <span class="info-label">이메일</span>
        <span class="info-value">${vo.email}</span>
        <button class="btn-edit" data-target="emailForm">변경</button>
    </div>
    <div class="edit-form" id="emailForm">
        <div class="mb-2 d-flex gap-2">
            <input type="email" class="form-control form-control-sm" id="newEmail"
                   placeholder="새 이메일 입력">
            <button class="btn btn-outline-success btn-sm" id="emailSendBtn"
                    style="white-space:nowrap">인증번호 받기</button>
        </div>
        <div id="emailCodeArea" style="display:none;">
            <div class="mb-2 d-flex gap-2">
                <input type="text" class="form-control form-control-sm" id="emailCode"
                       placeholder="6자리 인증번호" maxlength="6">
                <button class="btn btn-outline-primary btn-sm" id="emailVerifyBtn"
                        style="white-space:nowrap">확인</button>
            </div>
            <div class="alert alert-success py-1 px-2 mb-2" id="emailVerifiedMsg"
                 style="display:none;font-size:0.82rem;">이메일이 인증되었습니다.</div>
        </div>
        <button class="btn btn-success btn-sm" id="emailSaveBtn">저장</button>
        <button class="btn btn-secondary btn-sm cancel-btn" data-target="emailForm">취소</button>
    </div>

    <!-- 등급 -->
    <div class="info-row">
        <span class="info-label">등급</span>
        <span class="info-value">${vo.gradeName}</span>
    </div>

    <!-- 가입일 -->
    <div class="info-row">
        <span class="info-label">가입일</span>
        <span class="info-value">${vo.joinDate}</span>
    </div>

    <!-- 최근 로그인 -->
    <div class="info-row">
        <span class="info-label">최근 로그인</span>
        <span class="info-value">${vo.lastLogin}</span>
    </div>

</div>

<div class="d-flex gap-2 mt-3" style="max-width:640px;margin:12px auto 0;">
    <button class="btn btn-danger btn-sm" id="deleteBtn">회원탈퇴</button>
</div>

</body>
</html>
