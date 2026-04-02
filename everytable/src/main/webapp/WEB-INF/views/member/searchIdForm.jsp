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
				$(function() {
				    // 1단계 -> 2단계 이동 (이름/이메일 체크)
				    $("#nextBtn").click(function() {
				        let name = $("#name").val();
				        let email = $("#email").val();
				
				        $.ajax({
				            url: "/member/checkMemberInfo.do",
				            data: { name: name, email: email },
				            success: function(res) {
				                let result = res.trim();
				                console.log("서버 응답: " + result); 
				
				                // 결과가 "no"가 아니고 내용이 있으면 (아이디를 가져왔으면)
				                if(result !== "no" && result.length > 0) {
				                    $("#step1").hide();
				                    $("#step2").fadeIn();
				                    // 찾아온 아이디를 히든 필드에 저장
				                    $("#foundId").val(result); 
				                } else {
				                    alert("일치하는 정보가 없습니다.");
				                }
				            }
				        });
				    });
				
				 // 2단계 -> 최종 확인 (비밀번호 체크 후 아이디 공개)
				    $("#findIdBtn").click(function() {
				        let id = $("#foundId").val(); // 1단계에서 뽑아둔 아이디
				        let pw = $("#pw").val();

				        if(!pw) {
				            alert("비밀번호를 입력해주세요.");
				            $("#pw").focus();
				            return;
				        }

				        $.ajax({
				            url: "/member/checkPwForId.do", // 전용 체크 주소로 변경
				            data: { id: id, pw: pw },
				            success: function(res) {
				                let result = res.trim();
				                console.log("비밀번호 체크 결과: " + result);

				                if(result === "match") {
				                    // 성공! 아이디 공개
				                    $("#step2").hide();
				                    $("#showId").text(id); // 보관했던 아이디 출력
				                    $("#resultStep").fadeIn();
				                } else {
				                    // 실패!
				                    alert("비밀번호가 일치하지 않습니다. 다시 확인해 주세요.");
				                    $("#pw").val("").focus();
				                }
				            },
				            error: function() {
				                alert("서버 통신 중 오류가 발생했습니다.");
				            }
				        });
				    });
				});
				</script>
			</div>
        </div>
    </div>
</div>
</body>
</html>