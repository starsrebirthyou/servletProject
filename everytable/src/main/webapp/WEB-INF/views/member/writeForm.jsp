<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<style>
body { background-color: #f4f6f3; }

.wrap {
    max-width: 480px; margin: 40px auto 60px; padding: 0 16px;
}
.page-header {
    display: flex; align-items: center; gap: 14px; margin-bottom: 24px;
}
.page-header .logo-box {
    width: 48px; height: 48px; background: #e8f5ee;
    border-radius: 12px; display: flex; align-items: center;
    justify-content: center; font-size: 1.2rem; color: #0f7a54;
    flex-shrink: 0;
}
.page-header h2 {
    font-size: 1.3rem; font-weight: 700; color: #1a1a1a; margin: 0 0 3px;
}
.page-header p { font-size: 0.82rem; color: #888; margin: 0; }

.form-card {
    background: #fff; border-radius: 16px;
    border: 1px solid #e8ebe6; padding: 28px 24px;
}
.form-card .form-label {
    font-size: 0.83rem; font-weight: 600; color: #555; margin-bottom: 5px;
}
.form-card .form-control,
.form-card .form-select {
    border-radius: 10px; border: 1px solid #dde0da;
    background: #f9faf8; height: 42px; font-size: 0.9rem;
}
.form-card .form-control:focus,
.form-card .form-select:focus {
    border-color: #0f7a54;
    box-shadow: 0 0 0 3px rgba(15,122,84,0.1);
    background: #fff;
}
/* 아이디 메시지 */
.id-msg {
    font-size: 0.8rem; padding: 6px 10px;
    border-radius: 6px; margin-top: 4px;
}

/* 성별 라디오 */
.gender-row { display: flex; gap: 8px; }
.gender-btn {
    flex: 1; height: 40px; border-radius: 10px;
    border: 1px solid #dde0da; background: #f9faf8;
    color: #555; font-size: 0.88rem; cursor: pointer;
    transition: all 0.15s; display: flex;
    align-items: center; justify-content: center; gap: 6px;
}
.gender-btn input { display: none; }
.gender-btn.selected {
    border-color: #0f7a54; background: #e8f5ee; color: #0f7a54; font-weight: 600;
}

/* 이메일 인증 영역 */
.email-auth-box {
    background: #f0f7f4; border-radius: 10px;
    border: 1px solid #c8e6d4; padding: 14px 16px; margin-top: 8px;
}
.email-auth-box p {
    font-size: 0.82rem; color: #0f7a54; margin: 0 0 10px;
}

/* 섹션 구분선 */
.section-divider {
    border: none; border-top: 1px solid #f0f0f0; margin: 20px 0;
}
.section-title {
    font-size: 0.8rem; font-weight: 700; color: #0f7a54;
    text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 14px;
}

/* 버튼 */
.btn-submit {
    width: 100%; height: 46px; background: #0f7a54;
    border: none; border-radius: 10px; color: #fff;
    font-size: 0.95rem; font-weight: 600; cursor: pointer;
    transition: background 0.2s; margin-top: 8px;
}
.btn-submit:hover { background: #0a5e3f; }
.btn-row { display: flex; gap: 8px; margin-top: 10px; }
.btn-row button {
    flex: 1; height: 40px; border-radius: 10px;
    border: 1px solid #dde0da; background: #f9faf8;
    color: #666; font-size: 0.85rem; cursor: pointer;
}
.btn-row button:hover { background: #e2e6e0; }

/* 인증번호 받기 버튼 */
.btn-send-code {
    height: 42px; padding: 0 14px; background: #e8f5ee;
    border: 1px solid #0f7a54; color: #0f7a54; border-radius: 10px;
    font-size: 0.82rem; font-weight: 600; cursor: pointer; white-space: nowrap;
}
.btn-send-code:hover { background: #d4eddf; }
.btn-send-code:disabled { opacity: 0.6; cursor: not-allowed; }
</style>

<script type="text/javascript">
$(function(){
  let idCheck = false;
  let emailCheck = false;

  // 성별 버튼 토글
  $(".gender-btn").click(function(){
    $(".gender-btn").removeClass("selected");
    $(this).addClass("selected");
    $(this).find("input").prop("checked", true);
  });

  $("#writeForm").submit(function(e){
    e.preventDefault();
    let form = this;

    if($("#pw").val() != $("#pw2").val()){
      alert("비밀번호와 비밀번호 확인이 같지 않습니다. 다시 입력해 주세요.");
      $("#pw, #pw2").val(""); $("#pw").focus();
      return;
    }
    if(!idCheck){
      alert("아이디 중복 확인을 해주세요.");
      $("#id").focus();
      return;
    }
    if(!emailCheck){
      alert("이메일 인증을 완료해 주세요.");
      $("#email").focus();
      return;
    }

    let tel   = $("#tel").val().trim();
    let email = $("#email").val().trim();

    let telPromise = $.Deferred();
    if(tel === ""){
      telPromise.resolve(true);
    } else {
      $.ajax({
        url: "checkTel.do?tel=" + tel,
        success: function(result){ telPromise.resolve(!result.trim()); },
        error: function(){ telPromise.resolve(false); }
      });
    }

    let emailPromise = $.Deferred();
    $.ajax({
      url: "checkEmail.do?email=" + email,
      success: function(result){ emailPromise.resolve(!result.trim()); },
      error: function(){ emailPromise.resolve(false); }
    });

    $.when(telPromise, emailPromise).done(function(telOk, emailOk){
      if(!telOk){ alert("이미 가입된 연락처입니다."); $("#tel").focus(); return; }
      if(!emailOk){ alert("이미 가입된 이메일입니다."); $("#email").focus(); return; }
      form.submit();
    });
  });

  $(".cancelBtn").click(function(){ history.back(); });

  // 아이디 중복 체크
  $("#id").keyup(function(){
    idCheck = false;
    let id = $(this).val();
    let len = id.length;
    if(len == 0){
      setIdMsg("danger", "아이디를 반드시 입력하셔야 합니다.");
    } else if(len < 4){
      setIdMsg("danger", "아이디를 4자 이상 입력하셔야 합니다.");
    } else {
      $.ajax({
        url: "checkId.do?id=" + id,
        success: function(result){
          if(result){
            setIdMsg("danger", "<" + result + ">는 중복된 아이디입니다. 사용할 수 없습니다.");
          } else {
            setIdMsg("success", "<" + id + ">는 사용 가능한 아이디입니다.");
            idCheck = true;
          }
        },
        error: function(xhr, status, error){ console.log(xhr, status, error); }
      });
    }
  });

  function setIdMsg(type, msg){
    let el = $("#idMsg");
    el.removeClass("alert-danger alert-success").addClass("alert-" + type).text(msg);
    el.css("display", "block");
  }

  // 이메일 인증번호 발송
  $("#nextBtn").click(function(){
    let email = $("#email").val().trim();
    if(!email){ alert("이메일을 입력해 주세요."); return; }

    $(this).prop("disabled", true).text("전송 중...");

    $.ajax({
      url: "/member/sendAuthCode.do",
      method: "POST",
      data: { email: email },
      success: function(data){
        let result = $(data).find("#ajax-data-result").text().trim();
        if(result === "ok"){
          $(".emailAuthDiv").show();
          $("#nextBtn").text("재전송").prop("disabled", false);
        } else {
          alert("메일 발송에 실패했습니다. 잠시 후 다시 시도해 주세요.");
          $("#nextBtn").prop("disabled", false).text("인증번호 받기");
        }
      },
      error: function(){
        alert("서버 오류가 발생했습니다.");
        $("#nextBtn").prop("disabled", false).text("인증번호 받기");
      }
    });
  });

  // 인증번호 확인
  $("#verifyBtn").click(function(){
    let code = $("#code").val().trim();
    if(!code){ alert("인증번호를 입력해 주세요."); return; }

    $.ajax({
      url: "/member/verifyAuthCode.do",
      method: "POST",
      data: { code: code },
      success: function(data){
        let result = $(data).find("#ajax-data-result").text().trim();
        if(result === "ok"){
          emailCheck = true;
          $("#emailMsg").show();
          $("#code").prop("disabled", true);
          $("#verifyBtn").prop("disabled", true);
          $("#nextBtn").prop("disabled", true);
        } else {
          alert("인증번호가 일치하지 않습니다.");
          $("#code").val("").focus();
        }
      },
      error: function(){ alert("서버 오류가 발생했습니다."); }
    });
  });
});
</script>
</head>
<body>

<div class="wrap">

    <div class="page-header">
        <div class="logo-box"><i class="fa fa-user-plus"></i></div>
        <div>
            <h2>일반회원 가입</h2>
            <p>서비스 이용을 위한 계정을 만들어 드릴게요.</p>
        </div>
    </div>

    <div class="form-card">
        <form action="write.do" method="post" id="writeForm">
            <input type="hidden" name="gradeNo" value="${param.gradeNo}">

            <%-- 계정 정보 --%>
            <p class="section-title">계정 정보</p>

            <div class="mb-3">
                <label for="id" class="form-label">아이디</label>
                <input type="text" class="form-control" id="id" name="id"
                       placeholder="영문자로 시작하는 영문/숫자 4~20자" required autofocus
                       maxlength="20" pattern="[a-zA-Z][a-zA-Z0-9]{3,19}">
                <div class="alert id-msg alert-danger mt-1" id="idMsg">
                    아이디를 반드시 입력하셔야 합니다.
                </div>
            </div>

            <div class="mb-3">
                <label for="pw" class="form-label">비밀번호</label>
                <input type="password" class="form-control" id="pw" name="pw"
                       placeholder="4~20자 이내" required pattern=".{4,20}">
            </div>

            <div class="mb-3">
                <label for="pw2" class="form-label">비밀번호 확인</label>
                <input type="password" class="form-control" id="pw2"
                       placeholder="비밀번호를 한 번 더 입력하세요." required pattern=".{4,20}">
            </div>

            <hr class="section-divider">
            <p class="section-title">개인 정보</p>

            <div class="mb-3">
                <label for="name" class="form-label">이름</label>
                <input type="text" class="form-control" id="name" name="name"
                       placeholder="한글 2~10자" required maxlength="10"
                       pattern="[가-힣]{2,10}">
            </div>

            <div class="mb-3">
                <label class="form-label">성별</label>
                <div class="gender-row">
                    <label class="gender-btn selected">
                        <input type="radio" name="gender" value="여자" checked>
                        여성
                    </label>
                    <label class="gender-btn">
                        <input type="radio" name="gender" value="남자">
                        남성
                    </label>
                    <label class="gender-btn">
                        <input type="radio" name="gender" value="선택안함">
                        선택안함
                    </label>
                </div>
            </div>

            <div class="mb-3">
                <label for="birth" class="form-label">생년월일</label>
                <input type="date" class="form-control" id="birth" name="birth"
                       required min="1940-01-01" max="2015-12-31">
            </div>

            <div class="mb-3">
                <label for="tel" class="form-label">
                    연락처 <span class="text-muted" style="font-weight:400">(선택)</span>
                </label>
                <input type="tel" class="form-control" id="tel" name="tel"
                       placeholder="예) 010-1234-5678"
                       pattern="0\d{1,2}-\d{3,4}-\d{4}">
            </div>

            <hr class="section-divider">
            <p class="section-title">이메일 인증</p>

            <div class="mb-2">
                <label for="email" class="form-label">이메일</label>
                <div class="d-flex gap-2">
                    <input type="email" class="form-control" id="email" name="email"
                           placeholder="이메일을 입력하세요." required maxlength="50">
                    <button type="button" class="btn-send-code" id="nextBtn">인증번호 받기</button>
                </div>
            </div>

            <div class="emailAuthDiv" style="display:none;">
                <div class="email-auth-box">
                    <p><i class="fa fa-envelope"></i> 입력하신 이메일로 6자리 인증번호를 발송했습니다.</p>
                    <div class="d-flex gap-2 mb-2">
                        <input type="text" class="form-control" id="code"
                               placeholder="6자리 숫자 입력" maxlength="6"
                               style="height:40px;font-size:0.9rem;">
                        <button type="button" class="btn-send-code" id="verifyBtn">확인</button>
                    </div>
                    <div class="alert alert-success py-2 px-3 mb-0" id="emailMsg"
                         style="display:none;font-size:0.82rem;">
                        <i class="fa fa-check-circle"></i> 이메일이 인증되었습니다.
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-submit mt-4">가입하기</button>
            <div class="btn-row">
                <button type="reset">초기화</button>
                <button type="button" class="cancelBtn">취소</button>
            </div>

        </form>
    </div>
</div>

</body>
</html>
