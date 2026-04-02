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

  $("#writeForm").submit(function(){
    if($("#pw").val() != $("#pw2").val()){
      alert("비밀번호와 비밀번호 확인이 같지 않습니다. 다시 입력해 주세요.");
      $("#pw, #pw2").val("");
      $("#pw").focus();
      return false;
    }
    if(!idCheck){
      alert("아이디 중복 확인을 해주세요.");
      $("#id").focus();
      return false;
    }
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
});
</script>
</head>
<body>

<h2>일반회원 가입</h2>

<form action="write.do" method="post" id="writeForm">

  <!-- 등급 번호: 일반회원 = 1 (Controller에서 사용, 화면에는 표시 안 함) -->
  <input type="hidden" name="gradeNo" value="1">

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
  </div>

  <button type="submit" class="btn btn-primary">가입</button>
  <button type="reset"  class="btn btn-warning">리셋</button>
  <button type="button" class="cancelBtn btn btn-secondary">취소</button>

</form>
</body>
</html>
