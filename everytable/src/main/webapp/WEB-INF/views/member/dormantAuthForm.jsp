<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>휴면 계정 인증</title>
<style>
body { background-color: #f4f6f3; }
.wrap {
    max-width: 420px; margin: 60px auto 0; padding: 0 16px;
}
.card-box {
    background: #fff; border-radius: 16px;
    border: 1px solid #e8ebe6; padding: 32px 28px;
}
.card-header-area { text-align: center; margin-bottom: 24px; }
.card-header-area .icon-box {
    width: 56px; height: 56px; background: #fff8e1;
    border-radius: 14px; display: inline-flex;
    align-items: center; justify-content: center;
    font-size: 1.5rem; margin-bottom: 12px;
}
.card-header-area h4 { font-size: 1.2rem; font-weight: 700; margin-bottom: 4px; }
.card-header-area p  { font-size: 0.85rem; color: #888; margin: 0; }
.form-label { font-size: 0.85rem; font-weight: 600; color: #555; }
.form-control {
    border-radius: 10px; border: 1px solid #dde0da;
    background: #f9faf8; height: 44px; font-size: 0.92rem;
}
.form-control:focus {
    border-color: #0f7a54;
    box-shadow: 0 0 0 3px rgba(15,122,84,0.1); background: #fff;
}
.btn-main {
    width: 100%; height: 46px; background: #0f7a54; border: none;
    border-radius: 10px; color: #fff; font-size: 0.95rem;
    font-weight: 600; cursor: pointer;
}
.btn-main:hover { background: #0a5e3f; }
.alert-dormant {
    background: #fff8e1; border: 1px solid #ffe082;
    border-radius: 10px; padding: 12px 16px;
    font-size: 0.85rem; color: #795548; margin-bottom: 20px;
}
</style>
<script type="text/javascript">
$(function(){

    // ── 인증번호 확인 ──
    $("#verifyBtn").click(function(){
        let code = $("#code").val().trim();
        if(!code){ alert("인증번호를 입력해 주세요."); return; }

        $(this).prop("disabled", true).text("확인 중...");

        $.ajax({
            url: "/member/dormantVerify.do",
            method: "POST",
            data: { code: code },
            success: function(data){
                let result = $(data).find("#ajax-data-result").text().trim();
                if(result === "ok"){
                    $("#step1").hide();
                    $("#step2").fadeIn();
                    // 2초 후 자동 이동
                    setTimeout(function(){
                        let redirectUrl = "${sessionScope.dormantRedirectUrl}";
                        location.href = (redirectUrl && redirectUrl.trim() !== "")
                                        ? redirectUrl : "/main/main.do";
                    }, 2000);
                } else {
                    alert("인증번호가 일치하지 않습니다. 다시 확인해 주세요.");
                    $("#code").val("").focus();
                    $("#verifyBtn").prop("disabled", false).text("확인");
                }
            },
            error: function(){
                alert("서버 오류가 발생했습니다.");
                $("#verifyBtn").prop("disabled", false).text("확인");
            }
        });
    });

    $("#code").keydown(function(e){
        if(e.key === "Enter") $("#verifyBtn").click();
    });
});
</script>
</head>
<body>
<div class="wrap">
    <div class="card-box">

        <div class="card-header-area">
            <div class="icon-box">😴</div>
            <h4>휴면 계정 인증</h4>
            <p>가입하신 이메일로 인증번호를 발송했습니다.</p>
        </div>

        <%-- 1단계: 인증번호 입력 --%>
        <div id="step1">
            <div class="alert-dormant">
                ⚠️ 마지막 로그인으로부터 <strong>30일</strong>이 지나 휴면 상태로 전환되었습니다.<br>
                이메일 인증 후 정상 계정으로 복구됩니다.
            </div>
            <div class="mb-4">
                <label class="form-label">인증번호</label>
                <input type="text" class="form-control" id="code"
                       placeholder="6자리 숫자 입력" maxlength="6" autofocus>
            </div>
            <button type="button" class="btn-main" id="verifyBtn">확인</button>
        </div>

        <%-- 2단계: 완료 --%>
        <div id="step2" style="display:none;" class="text-center">
            <p style="font-size:2rem; margin-bottom:12px;">✅</p>
            <p class="fw-bold" style="color:#0f7a54; font-size:1rem;">
                휴면이 해제되었습니다. 잠시 후 이동합니다...
            </p>
        </div>

    </div>
</div>
</body>
</html>