<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
  [사용 방법]
  1. 공통 header 또는 로그인 체크가 필요한 JSP 상단에 include
     <%@ include file="/WEB-INF/views/member/loginModal.jsp" %>

  2. 로그인이 필요한 버튼/링크에 onclick 추가
     <button onclick="requireLogin('/order/orderForm.do')">주문하기</button>
     <button onclick="requireLogin('/review/writeForm.do')">리뷰 작성</button>
--%>

<!-- 로그인 모달 (Bootstrap 5 기준) -->
<div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title" id="loginModalLabel">로그인</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>

      <div class="modal-body">
        <p class="text-muted mb-3">이 기능은 로그인 후 이용할 수 있습니다.</p>

        <form id="modalLoginForm">
          <%-- 로그인 성공 후 돌아갈 URL을 JS로 세팅 --%>
          <input type="hidden" id="modalRedirectUrl" name="redirectUrl" value="">

          <div class="mb-3">
            <label for="modalId" class="form-label">아이디</label>
            <input type="text" class="form-control" id="modalId" name="id"
                   placeholder="아이디를 입력하세요." autocomplete="off" maxlength="20">
          </div>

          <div class="mb-3">
            <label for="modalPw" class="form-label">비밀번호</label>
            <input type="password" class="form-control" id="modalPw" name="pw"
                   placeholder="비밀번호를 입력하세요." autocomplete="off" maxlength="20">
          </div>

          <%-- 로그인 실패 메시지 출력 영역 --%>
          <div id="modalLoginMsg" class="alert alert-danger d-none"></div>
        </form>
      </div>

      <div class="modal-footer justify-content-between">
        <button type="button" class="btn btn-outline-secondary"
                onclick="location.href='${pageContext.request.contextPath}/member/writeTypeSelect.do'">
          회원가입
        </button>
        <div>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
          <button type="button" class="btn btn-primary" onclick="modalLogin()">로그인</button>
        </div>
      </div>

    </div>
  </div>
</div>

<script type="text/javascript">
  // ---------------------------------------------------------------
  // requireLogin(targetUrl)
  //   - 로그인 상태면 바로 targetUrl 로 이동
  //   - 비로그인 상태면 모달을 띄우고 redirectUrl 세팅
  // ---------------------------------------------------------------
  function requireLogin(targetUrl) {
    // JSP EL로 서버 세션 값을 JS 변수에 주입
    const isLogin = ${ sessionScope.login != null ? 'true' : 'false' };
    if (isLogin) {
      location.href = targetUrl;
      return;
    }
    // 모달에 목적지 URL 저장
    document.getElementById('modalRedirectUrl').value = targetUrl;
    // 모달 입력 초기화
    document.getElementById('modalId').value = '';
    document.getElementById('modalPw').value = '';
    document.getElementById('modalLoginMsg').classList.add('d-none');
    // Bootstrap 5 모달 열기
    new bootstrap.Modal(document.getElementById('loginModal')).show();
    // 모달이 열리면 아이디 input에 포커스
    document.getElementById('loginModal').addEventListener('shown.bs.modal', function(){
      document.getElementById('modalId').focus();
    }, { once: true });
  }

  // ---------------------------------------------------------------
  // modalLogin()
  //   - 모달 내 로그인 폼을 서버에 Ajax로 전송
  //   - 성공: redirectUrl 로 이동 / 실패: 모달 내 오류 메시지 표시
  // ---------------------------------------------------------------
  function modalLogin() {
    const id  = document.getElementById('modalId').value.trim();
    const pw  = document.getElementById('modalPw').value;
    const redirectUrl = document.getElementById('modalRedirectUrl').value;

    if (!id || !pw) {
      showModalMsg('아이디와 비밀번호를 입력해 주세요.');
      return;
    }

    $.ajax({
      url: '${pageContext.request.contextPath}/member/login.do',
      method: 'POST',
      data: { id: id, pw: pw, redirectUrl: redirectUrl },
      success: function(response) {
        // login.do 가 redirect 를 반환하면 실제 응답 URL 로 이동
        // 서버에서 redirect 처리를 하므로 responseURL 확인
        const finalUrl = response.responseURL || (redirectUrl || '${pageContext.request.contextPath}/main/main.do');
        location.href = (redirectUrl && redirectUrl.trim() !== '')
                          ? redirectUrl
                          : '${pageContext.request.contextPath}/main/main.do';
      },
      error: function() {
        showModalMsg('아이디 또는 비밀번호가 일치하지 않거나 이용이 제한된 계정입니다.');
      }
    });
  }

  function showModalMsg(msg) {
    const el = document.getElementById('modalLoginMsg');
    el.textContent = msg;
    el.classList.remove('d-none');
  }

  // Enter 키로 로그인 가능하게
  document.addEventListener('DOMContentLoaded', function(){
    ['modalId', 'modalPw'].forEach(function(id){
      const el = document.getElementById(id);
      if (el) el.addEventListener('keydown', function(e){
        if (e.key === 'Enter') modalLogin();
      });
    });
  });
</script>
