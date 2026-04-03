<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일반회원 가입</title>
<!-- Bootstrap 라이브러리 등록 -->

<script type="text/javascript">
$(function(){
  let idCheck = false;

  $("#writeForm").submit(function(e){
	    e.preventDefault();  // 일단 무조건 막음
	    let form = this;

	    // pw 체크
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

	    let tel   = $("#tel").val().trim();
	    let email = $("#email").val().trim();

	    // tel 체크 (값 있을 때만)
	    let telPromise = $.Deferred();
	    if(tel === ""){
	        telPromise.resolve(true);
	    } else {
	        $.ajax({
	            url: "checkTel.do?tel=" + tel,
	            success: function(result){
	                telPromise.resolve(!result.trim());  // 중복 없으면 true
	            },
	            error: function(){ telPromise.resolve(false); }
	        });
	    }

	    // email 체크
	    let emailPromise = $.Deferred();
	    $.ajax({
	        url: "checkEmail.do?email=" + email,
	        success: function(result){
	            emailPromise.resolve(!result.trim());  // 중복 없으면 true
	        },
	        error: function(){ emailPromise.resolve(false); }
	    });

	    // 둘 다 응답 오면 그때 판단
	    $.when(telPromise, emailPromise).done(function(telOk, emailOk){
	        if(!telOk){
	            alert("이미 가입된 연락처입니다.");
	            $("#tel").focus();
	            return;
	        }
	        if(!emailOk){
	            alert("이미 가입된 이메일입니다.");
	            $("#email").focus();
	            return;
	        }
	        form.submit();  // 모든 검증 통과 → 실제 제출
	    });
	});

  $(".cancelBtn").click(function(){
    history.back();
  });

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
        error: function(xhr, status, error){
          console.log("xhr=" + xhr + ", status=" + status + ", error=" + error);
        }
      });
    }
  });
  
  function setIdMsg(type, msg){
    $("#idMsg").removeClass("alert-danger alert-success")
               .addClass("alert-" + type)
               .text(msg);
  }
  
  $.ajax({
      url: "/member/sendAuthCode.do",
      method: "POST",
      data: { id: id, email: email },
      success: function(data){
          // ajaxResult.jsp에서 <span id="ajax-data-result"> 안의 텍스트를 가져옴
          let result = $(data).find("#ajax-data-result").text().trim();
          
          if(result === "ok"){
              $("#authCode").fadeIn();
          } else {
              alert("아이디 또는 이메일이 일치하지 않습니다.");
              $("#nextBtn").prop("disabled", false).text("인증번호 받기");
          }
      }
  });
  
  // ── 인증번호 확인 ──
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
              if(data.result !== "ok"){
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
  
});
</script>
</head>
<body>

<h2>회원가입</h2>

<form action="write.do" method="post" id="writeForm">
  <input type="hidden" name="gradeNo" value="${param.gradeNo}">

  <div class="mb-3 mt-3">
    <label for="id" class="form-label">아이디</label>
    <input type="text" class="form-control" id="id" name="id"
           placeholder="아이디를 입력하세요." required autofocus maxlength="20"
           title="영문자로 시작하는 영문/숫자 4~20자"
           pattern="[a-zA-Z][a-zA-Z0-9]{3,19}">
    <div class="alert alert-danger mt-1" id="idMsg">아이디를 반드시 입력하셔야 합니다.</div>
  </div>

  <div class="mb-3">
    <label for="pw" class="form-label">비밀번호</label>
    <input type="password" class="form-control" id="pw" name="pw"
           placeholder="비밀번호를 입력하세요." required
           title="4~20자 이내" pattern=".{4,20}">
  </div>

  <div class="mb-3">
    <label for="pw2" class="form-label">비밀번호 확인</label>
    <input type="password" class="form-control" id="pw2"
           placeholder="비밀번호를 한 번 더 입력하세요." required pattern=".{4,20}">
  </div>

  <div class="mb-3">
    <label for="name" class="form-label">이름</label>
    <input type="text" class="form-control" id="name" name="name"
           placeholder="이름을 입력하세요." required maxlength="10"
           title="한글 2~10자" pattern="[가-힣]{2,10}">
  </div>

  <div class="mb-3">
    <label class="form-label">성별</label>
    <div class="d-flex p-1">
      <div class="form-check m-3">
        <label class="form-check-label" for="gender1">
          <input type="radio" class="form-check-input" id="gender1" name="gender" value="여자" checked>여자
        </label>
      </div>
      <div class="form-check m-3">
        <label class="form-check-label" for="gender2">
          <input type="radio" class="form-check-input" id="gender2" name="gender" value="남자">남자
        </label>
      </div>
    </div>
  </div>

  <div class="mb-3">
    <label for="birth" class="form-label">생년월일</label>
    <input type="date" class="form-control" id="birth" name="birth"
           required min="1940-01-01" max="2015-12-31">
  </div>

  <div class="mb-3">
    <label for="tel" class="form-label">연락처</label>
    <input type="tel" class="form-control" id="tel" name="tel"
           placeholder="예) 010-1234-5678"
           title="010-xxxx-xxxx 형식" pattern="0\d{1,2}-\d{3,4}-\d{4}">
  </div>

  <div class="mb-3">
    <label for="email" class="form-label">이메일</label>
    <input type="email" class="form-control" id="email" name="email"
           placeholder="이메일을 입력하세요." required maxlength="50">
    <button type="button" class="btn btn-success w-100" id="nextBtn">인증번호 받기</button>
  </div>
  
  <div>
  	<p class="text-primary text-center mb-4">
       입력하신 이메일로 6자리 인증번호를 발송했습니다.
   	</p>
   	<div class="mb-4">
       <label class="form-label fw-bold">인증번호</label>
       <input type="text" class="form-control" id="code"
              placeholder="6자리 숫자 입력" maxlength="6">
   	</div>
   	<button type="button" class="btn btn-primary w-100" id="verifyBtn">확인</button>
    <div class="alert alert-success mt-1" id="emailMsg">이메일이 인증되었습니다.</div>
  </div>

  <button type="submit" class="btn btn-primary">가입</button>
  <button type="reset"  class="btn btn-warning">리셋</button>
  <button type="button" class="cancelBtn btn btn-secondary">취소</button>

</form>
</body>
</html>
