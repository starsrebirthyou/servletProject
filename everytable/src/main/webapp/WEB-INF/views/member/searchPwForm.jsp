<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<script type="text/javascript">
$(function(){

    // ── 1단계: 아이디 + 이메일 확인 → 인증번호 발송 ──
    $("#nextBtn").click(function(){
        let id    = $("#id").val().trim();
        let email = $("#email").val().trim();

        if(!id || !email){
            alert("아이디와 이메일을 모두 입력해 주세요.");
            return;
        }

        $("#nextBtn").prop("disabled", true).text("전송 중...");

        $.ajax({
            url: "/member/sendAuthCode.do",
            method: "POST",
            data: { id: id, email: email },
            success: function(data){
                // ajaxResult.jsp에서 <span id="ajax-data-result"> 안의 텍스트를 가져옴
                let result = $(data).find("#ajax-data-result").text().trim();
                
                if(result === "ok"){
                    $("#step1").hide();
                    $("#step2").fadeIn();
                } else {
                    alert("아이디 또는 이메일이 일치하지 않습니다.");
                    $("#nextBtn").prop("disabled", false).text("인증번호 받기");
                }
            }
        });
    });

    // ── 2단계: 인증번호 확인 ──
    $("#verifyBtn").click(function(){
        let code = $("#code").val().trim();

        if(!code){
            alert("인증번호를 입력해 주세요.");
            return;
        }

        $.ajax({
            url: "/member/verifyAuthCode.do",
            method: "POST",
            data: { code: code },
            dataType: "json",
            success: function(data){
                if(data.result === "ok"){
                    $("#step2").hide();
                    $("#step3").fadeIn();
                } else {
                    alert("인증번호가 일치하지 않습니다. 다시 확인해 주세요.");
                    $("#code").val("").focus();
                }
            },
            error: function(){
                alert("서버 오류가 발생했습니다.");
            }
        });
    });

    // ── 3단계: 비밀번호 재설정 ──
    $("#resetBtn").click(function(){
        let pw  = $("#pw").val();
        let pw2 = $("#pw2").val();

        if(!pw || !pw2){
            alert("비밀번호를 입력해 주세요.");
            return;
        }
        if(pw !== pw2){
            alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            $("#pw2").val("").focus();
            return;
        }
        if(pw.length < 4 || pw.length > 20){
            alert("비밀번호는 4~20자로 입력해 주세요.");
            return;
        }

        $.ajax({
            url: "/member/resetPw.do",
            method: "POST",
            data: { newPw: pw },
            dataType: "json",
            success: function(data){
                if(data.result === "ok"){
                    $("#step3").hide();
                    $("#step4").fadeIn();
                } else {
                    alert(data.msg || "오류가 발생했습니다. 처음부터 다시 시도해 주세요.");
                    location.href = "/member/searchPwForm.do";
                }
            },
            error: function(){
                alert("서버 오류가 발생했습니다.");
            }
        });
    });

    // Enter 키 지원
    $("#code").keydown(function(e){
        if(e.key === "Enter") $("#verifyBtn").click();
    });
});
</script>
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow-sm">
                <div class="card-header bg-white text-center py-3">
                    <h4 class="mb-0 fw-bold">비밀번호 찾기</h4>
                </div>
                <div class="card-body p-4">

                    <%-- 1단계: 아이디 + 이메일 --%>
                    <div id="step1">
                        <p class="text-muted text-center mb-4">가입하신 아이디와 이메일을 입력해 주세요.</p>
                        <div class="mb-3">
                            <label class="form-label fw-bold">아이디</label>
                            <input type="text" class="form-control" id="id" placeholder="아이디 입력">
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-bold">이메일</label>
                            <input type="email" class="form-control" id="email" placeholder="가입한 이메일 입력">
                        </div>
                        <button type="button" class="btn btn-success w-100" id="nextBtn">인증번호 받기</button>
                    </div>

                    <%-- 2단계: 인증번호 입력 --%>
                    <div id="step2" style="display:none;">
                        <p class="text-primary text-center mb-4">
                            입력하신 이메일로 6자리 인증번호를 발송했습니다.
                        </p>
                        <div class="mb-4">
                            <label class="form-label fw-bold">인증번호</label>
                            <input type="text" class="form-control" id="code"
                                   placeholder="6자리 숫자 입력" maxlength="6">
                        </div>
                        <button type="button" class="btn btn-primary w-100" id="verifyBtn">확인</button>
                    </div>

                    <%-- 3단계: 비밀번호 재설정 --%>
                    <div id="step3" style="display:none;">
                        <p class="text-muted text-center mb-4">새로운 비밀번호를 입력해 주세요.</p>
                        <div class="mb-3">
                            <label class="form-label fw-bold">새 비밀번호</label>
                            <input type="password" class="form-control" id="pw"
                                   placeholder="4~20자 입력">
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-bold">비밀번호 확인</label>
                            <input type="password" class="form-control" id="pw2"
                                   placeholder="비밀번호 재입력">
                        </div>
                        <button type="button" class="btn btn-success w-100" id="resetBtn">비밀번호 변경</button>
                    </div>

                    <%-- 4단계: 완료 --%>
                    <div id="step4" style="display:none;" class="text-center">
                        <p class="text-success fw-bold mb-3">비밀번호가 변경되었습니다.</p>
                        <a href="/member/loginForm.do" class="btn btn-outline-primary w-100">로그인하러 가기</a>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>