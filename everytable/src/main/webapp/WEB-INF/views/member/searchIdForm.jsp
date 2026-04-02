<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
<!-- 부트스트랩 CSS나 공통 헤더가 있다면 여기에 인클루드 해주세요 -->
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow-sm">
                <div class="card-header bg-white text-center py-3">
                    <h4 class="mb-0 fw-bold">아이디 찾기</h4>
                </div>
				<div class="card-body p-4">
				    <div id="step1">
				        <p class="text-muted text-center mb-4">가입 시 등록한 이름과 이메일을 입력해 주세요.</p>
				        <div class="mb-3">
				            <label class="form-label fw-bold">이름</label>
				            <input type="text" class="form-control" id="name" name="name" required>
				        </div>
				        <div class="mb-4">
				            <label class="form-label fw-bold">이메일</label>
				            <input type="email" class="form-control" id="email" name="email" required>
				        </div>
				        <button type="button" class="btn btn-success w-100" id="nextBtn">다음 단계</button>
				    </div>
				
				    <!-- 비밀번호 입력 (처음엔 숨김) -->
				    <div id="step2" style="display:none;">
				    		<input type="hidden" id="foundId">
				        <p class="text-primary text-center mb-4">정보가 일치합니다! <br>본인 확인을 위해 비밀번호를 입력해 주세요.</p>
				        <div class="mb-4">
				            <label class="form-label fw-bold">비밀번호</label>
				            <input type="password" class="form-control" id="pw" name="pw" required>
				        </div>
				        <button type="button" class="btn btn-primary w-100" id="findIdBtn">아이디 확인</button>
				    </div>
				
				    <!-- 결과 출력 -->
				    <div id="resultStep" style="display:none;" class="text-center">
				        <div class="alert alert-info">
				            회원님의 아이디는 <br><strong id="showId" class="fs-4"></strong> 입니다.
				        </div>
				        <a href="/member/loginForm.do" class="btn btn-outline-primary w-100">로그인하러 가기</a>
				    </div>
				</div>
				
				<script>
				// 1단계 -> 2단계 이동 부분 수정
				$("#nextBtn").click(function() {
				    let name = $("#name").val();
				    let email = $("#email").val();

				    $.ajax({
				        url: "/member/checkMemberInfo.do",
				        data: { name: name, email: email },
				        success: function(res) {
				            // 🔥 핵심: res(HTML 덩어리) 안에서 우리가 심어놓은 span의 텍스트만 추출
				            let result = $(res).find("#ajax-data-result").text().trim();
				            
				            // 혹시 find로 안 잡히면 filter로 재시도 (SiteMesh 구조에 따라 다름)
				            if(!result) result = $(res).filter("#ajax-data-result").text().trim();

				            console.log("정제된 아이디: [" + result + "]"); 

				            if(result !== "no" && result.length > 0) {
				                $("#step1").hide();
				                $("#step2").fadeIn();
				                $("#foundId").val(result); // 이제 깨끗한 'user01'만 들어감!
				            } else {
				                alert("일치하는 정보가 없습니다.");
				            }
				        }
				    });
				});

				// 2단계 -> 최종 확인 부분 수정
				$("#findIdBtn").click(function() {
				    let id = $("#foundId").val();
				    let pw = $("#pw").val();

				    $.ajax({
				        url: "/member/checkPwForId.do",
				        data: { id: id, pw: pw },
				        success: function(res) {
				            // 🔥 여기서도 똑같이 정제 작업 필요!
				            let result = $(res).find("#ajax-data-result").text().trim();
				            if(!result) result = $(res).filter("#ajax-data-result").text().trim();
				            
				            console.log("비밀번호 체크 결과: " + result);

				            if(result === "match") {
				                $("#step2").hide();
				                $("#showId").text(id); 
				                $("#resultStep").fadeIn();
				            } else {
				                alert("비밀번호가 일치하지 않습니다.");
				                $("#pw").val("").focus();
				            }
				        }
				    });
				});
				</script>
			</div>
        </div>
    </div>
</div>
</body>
</html>