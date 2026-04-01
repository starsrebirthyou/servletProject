<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<!-- Bootstrap 라이브러리 등록 -->
  
<script type="text/javascript">
$(function(){
	// id check 변수
	let idCheck = false;
	
	// 데이터 넘기는(submit()) 처리 - form 데이터에 대한 submit
	$("#writeForm").submit(function(){
		// alert("데이터 전송하기 실행");
		// 비밀번호와 비밀번호 확인이 같은지 확인
		if($("#pw").val() != $("#pw2").val()){
			alert("비밀번호와 비밀번호 확인이 같지 않습니다. 다시 입력해 주세요.");
			$("#pw, #pw2").val("");
			$("#pw").focus();
			return false;
		}
		
		// 반드시 중복 아이디 체크를 한 아이디만 사용 가능처리
		if(!idCheck){
			alert("사용 가능한 아이디를 입력해 주세요");
			$("#id").focus();
			return false;
		}
	});
	
	$(".cancelBtn").click(function(){
		history.back();
	});
	
	$("#id").keyup(function(){
		idCheck = false;
		// alert($("#id").val());
		let id = $(this).val();
		let len = id.length;
		// alert(len);
		if(len == 0) {  // 아무 것도 입력 안 한 경우
			$("#idMsg").removeClass("alert-danger alert-success");
			$("#idMsg").addClass("alert-danger");
			$("#idMsg").text("아이디를 반드시 입력하셔야 합니다.");
		} else if(len < 4) {  // 1~3까지의 처리
			$("#idMsg").removeClass("alert-danger alert-success");
			$("#idMsg").addClass("alert-danger");
			$("#idMsg").text("아이디를 4자 이상 입력하셔야 합니다.");
		} else {  // 4자 이상이므로 서버에 갔다가 와야 한다. - ajax(비동식) 처리를 한다.
			$.ajax(
			  // JSON 데이터{key:value}
			  {url: "checkId.do?id=" + id,
				// (succeess)서버가 정상적으로 동작했을 때 처리 메서드
				success: function(result){
					// 데이터를 확인하기 위해 출력하는 방법 2가지. alert() - 경고창, console.log() - F12 : 콘솔탭 출력
					// alert(result);
					console.log("[" + result + "]");
					if(result){  // id가 중복된 경우 length가 0보다 크다
						$("#idMsg").removeClass("alert-danger alert-success");
						$("#idMsg").addClass("alert-danger");
						$("#idMsg").text("<" + result + ">는 중복된 아이디입니다. 사용할 수 없습니다.");
					} else {  // 중복되지 않은 id인 경우 length가 0이 나온다.
						$("#idMsg").removeClass("alert-danger alert-success");
						$("#idMsg").addClass("alert-success");
						$("#idMsg").text("<" + id + ">는 사용 가능한 아이디입니다.");
						idCheck = true;
					}
				},  // success 끝
				error: function(xhr, status, error){
					console.log("xhr=" + xhr + ", status=" + status + ", error=" + error);
				}  // error 끝
			}  // JSON 데이터 끝
		  );  // $.ajax 끝
		}  // if else 끝
	});  // keyup() 끝
});  // $(function(){}) 끝
</script>
  
</head>
<body>
	<h2>회원가입</h2>
	<!-- URL & Header & body(data)로 넘기는 방식 : post -- 넘어가는 데이터가 보이지 않는다. -->
	<form action="write.do" method="post" id="writeForm">
	
	  <div class="mb-3 mt-3">
	    <label for="id" class="form-label">아이디</label>
	    <!-- required : 필수, autofocus : 페이지가 열리면 커서를 위치시킨다.
	    		아이디는 맨 앞자는 영문자로 하고 뒤에는 숫자나 영문자를 사용할 수 있다. 4~20자 -->
	    <input type="text" class="form-control" id="id" placeholder="아이디를 입력하세요." name="id" 
	    		title="아이디는 영문부터 영문/숫자만 4~20자 이내로 입력하실 수 있습니다." required autofocus maxlength="20"
	    		pattern="[a-zA-Z][a-zA-Z0-9]{3,19}">
	    	<div class="alert alert-danger" id="idMsg">
	  	  아이디를 반드시 입력하셔야 합니다.
	  	</div>
	  </div>
	  
	  <div class="mb-3">
	    <label for="pw" class="form-label">비밀번호</label>
	    <input type="password" class="form-control" id="pw" placeholder="비밀번호를 입력하세요." name="pw"
	    		title="비밀번호는 4~20자 이내로 입력하실 수 있습니다." required pattern=".{4,20}">
	  </div>
	  <div class="mb-3">
	    <label for="pw" class="form-label">비밀번호 확인</label>
	    <input type="password" class="form-control" id="pw2" placeholder="비밀번호를 한 번 더 입력하세요."
	    		title="입력하신 비밀번호와 일치해야 합니다." required pattern=".{4,20}">
	  </div>
	  
	  <div class="mb-3 mt-3">
	    <label for="name" class="form-label">이름</label>
	    <input type="text" class="form-control" id="writer" placeholder="이름을 입력하세요." name="name" 
	    		title="이름은 2~10자 이내에서 한글로 입력해야 합니다." pattern="[가-힣]{2,10}" maxlength="10" required>
	  </div>
	  
	  <!-- 성별 항목에 대한 div 시작 -->
	  <div class="mb-3 mt-3">
	    <label class="form-label">성별</label>
	    <!-- 항목을 한 줄로 하기 위한 div -->
	    <div class="d-flex p-1">
		  <div class="form-check m-3">
		    <!-- radio 또는 check box 버튼인 input tag를 label로 감싸면 글자를 클릭해도 동작된다 -->
		    <label class="form-check-label" for="gender1">
		      <input type="radio" class="form-check-input" id="gender1" name="gender" value="남자" checked>남자
		    </label>
		  </div>
		  <div class="form-check m-3">
		    <label class="form-check-label" for="gender2">
		      <input type="radio" class="form-check-input" id="gender2" name="gender" value="여자">여자
		    </label>
		  </div>
		</div>
	  </div>
	  <!-- 성별 항목에 대한 div 끝 -->
	  
	  <div class="mb-3 mt-3">
	    <label for="birth" class="form-label">생년월일</label>
	    <!-- 숫자나 날짜같은 크기를 나타내는 데이터인 경우 min과 max를 선언할 수 있다. -->
	    <input type="date" class="form-control" id="birth" placeholder="생년월일을 입력하세요." name="birth" 
	    		required min="1940-01-01" maxlength="2015-12-31">
	  </div>
	  
	  <div class="mb-3 mt-3">
	    <label for="tel" class="form-label">연락처</label>
	    <!-- 숫자나 날짜같은 크기를 나타내는 데이터인 경우 min과 max를 선언할 수 있다. -->
	    <input type="tel" class="form-control" id="tel" placeholder="연락처를 입력하세요." name="tel"
	    		title="xx(x)-xxxx-xxxx 형식으로 입력해야 합니다." pattern="0\d{1,2}-\d{3,4}-\d{4}">
	  </div>
	  
	  <div class="mb-3 mt-3">
	    <label for="email" class="form-label">이메일</label>
	    <input type="email" class="form-control" id="email" placeholder="이메일을 입력하세요." name="email"
	    		required maxlength="50"
	    		pattern="/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i">
	  </div>

	  <button type="submit" class="btn btn-primary">가입</button>
	  <button type="reset" class="btn btn-warning">리셋</button>
	  <button type="button" class="cancelBtn btn btn-secondary">취소</button>
	</form>
</body>
</html>