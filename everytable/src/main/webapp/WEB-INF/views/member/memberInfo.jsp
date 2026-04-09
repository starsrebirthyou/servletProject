<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세 정보</title>

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
    // 초기화 버튼 → 폼 토글
    $(".btn-edit[data-target='pwForm']").click(function(){
        $("#pwForm").toggleClass("active");
    });

    // 비밀번호 초기화 저장
    $("#pwResetBtn").click(function(){
        let newPw = $("#resetPw").val().trim();
        if(!newPw){ alert("초기화할 비밀번호를 입력해 주세요."); return; }
        if(newPw.length < 4 || newPw.length > 20){
            alert("비밀번호는 4~20자로 입력해 주세요."); return;
        }
        if(!confirm("정말 비밀번호를 초기화하시겠습니까?")){ return; }

        $.ajax({
            url: "/member/adminResetPw.do",
            method: "POST",
            data: {
                id: "${vo.id}",
                newPw: newPw
            },
            success: function(data){
                let result = $(data).find("#ajax-data-result").text().trim();
                if(result === "ok"){
                    alert("비밀번호가 초기화되었습니다.");
                    $("#pwForm").removeClass("active");
                    $("#resetPw").val("");
                } else {
                    alert("초기화에 실패했습니다.");
                }
            },
            error: function(){ alert("서버 오류가 발생했습니다."); }
        });
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
        <h2 class="fw-bold mb-0 text-dark" style="font-size:1.5rem;">회원 상세 정보</h2>
        <p class="text-muted mb-0" style="font-size:0.88rem;">회원의 상세 정보를 확인하고 관리할 수 있습니다.</p>
    </div>
</div>

<c:if test="${not empty sessionScope.msg}">
    <div class="alert alert-success">${sessionScope.msg}</div>
    <c:remove var="msg" scope="session"/>
</c:if>

<div class="info-card">

    <!-- 회원번호 -->
    <div class="info-row">
        <span class="info-label">회원번호</span>
        <span class="info-value">${vo.no}</span>
    </div>
    
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
        <c:if test="${vo.status != '파기'}">
        		<button class="btn-edit" data-target="pwForm">초기화</button>
        </c:if>
    </div>
    <div class="edit-form" id="pwForm">
    <div class="mb-2">
        <input type="password" class="form-control form-control-sm" id="resetPw"
               placeholder="초기화할 비밀번호 입력 (4~20자)">
    </div>
    <button class="btn btn-danger btn-sm" id="pwResetBtn">초기화 적용</button>
    <button class="btn btn-secondary btn-sm ms-1"
            onclick="$('#pwForm').removeClass('active'); $('#resetPw').val('');">취소</button>
</div>

    <!-- 전화번호 -->
    <div class="info-row">
        <span class="info-label">연락처</span>
        <span class="info-value">${empty vo.tel ? '미등록' : vo.tel}</span>
    </div>

    <!-- 이메일 -->
    <div class="info-row">
        <span class="info-label">이메일</span>
        <span class="info-value">${vo.email}</span>
    </div>

    <!-- 성별 -->
    <div class="info-row">
        <span class="info-label">성별</span>
        <span class="info-value">${vo.gender}</span>
    </div>

    <!-- 생년월일 -->
    <div class="info-row">
        <span class="info-label">생년월일</span>
        <span class="info-value">${vo.birth}</span>
    </div>

    <!-- 상태 -->
    <div class="info-row">
        <span class="info-label">상태</span>
        <span class="info-value">${vo.status}</span>
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
        <span class="info-label">최근 접속일</span>
        <span class="info-value">${vo.lastLogin}</span>
    </div>
    
    <c:if test="${!empty vo.withdraw}">
	    <!-- 탈퇴일 -->
	    <div class="info-row">
	        <span class="info-label">탈퇴일</span>
	        <span class="info-value">${vo.withdraw}</span>
	    </div>
	</c:if>
	
    <c:if test="${!empty vo.suspensionEndDate}">
	    <!-- 정지해제일 -->
	    <div class="info-row">
	        <span class="info-label">정지해제일</span>
	        <span class="info-value">${vo.suspensionEndDate}</span>
	    </div>
	</c:if>

</div>

<%-- 정지 내역 --%>
<c:if test="${not empty suspensionList}">
<div style="max-width:640px; margin:20px auto 0;">
    <h6 class="fw-bold mb-2" style="color:#333; font-size:0.95rem;">
        ⛔ 정지 내역 <span style="color:#aaa; font-weight:400; font-size:0.82rem;">
            (총 ${fn:length(suspensionList)}건)
        </span>
    </h6>
    <div style="background:#fff; border-radius:14px; border:1px solid #e8ebe6; overflow:hidden;">
        <table class="table mb-0" style="font-size:0.85rem;">
            <thead>
                <tr style="background:#f4f6f3;">
                    <th style="padding:10px 14px; color:#555; font-weight:600;">정지 시작일</th>
                    <th style="padding:10px 14px; color:#555; font-weight:600;">정지 해제일</th>
                    <th style="padding:10px 14px; color:#555; font-weight:600;">사유</th>
                    <th style="padding:10px 14px; color:#555; font-weight:600;">처리 관리자</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${suspensionList}" var="sh">
                <tr>
                    <td style="padding:10px 14px; vertical-align:middle;">${sh.startDate}</td>
                    <td style="padding:10px 14px; vertical-align:middle;">${sh.endDate}</td>
                    <td style="padding:10px 14px; vertical-align:middle;">${sh.reason}</td>
                    <td style="padding:10px 14px; vertical-align:middle;">${sh.adminId}</td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</c:if>

<div class="d-flex gap-2 mt-3" style="max-width:640px;margin:12px auto 0;">
	<a type="button" href="list.do?page=${param.page}&perPageNum=${param.perPageNum}&keyword=${param.keyword}
		&status=${param.status}&gradeNo=${param.gradeNo}&dateFrom=${param.dateFrom}&dateTo=${param.dateTo}" 
	    class="btn btn-success btn-sm">리스트</a>
</div>

</body>
</html>
