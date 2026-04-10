<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
/* ── 로그인 모달 커스텀 스타일 ── */
#loginModal .modal-content {
    border: 1px solid #e8ebe6;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 8px 32px rgba(0,0,0,0.10);
}
#loginModal .modal-header {
    background: #fff;
    border-bottom: 1px solid #f0f3ef;
    padding: 20px 28px 16px;
    flex-direction: column;
    align-items: center;
    text-align: center;
    gap: 0;
}
#loginModal .modal-header .logo-box {
    width: 52px; height: 52px;
    background: #e8f5ee;
    border-radius: 14px;
    display: inline-flex;
    align-items: center; justify-content: center;
    font-size: 1.4rem; color: #0f7a54;
    margin-bottom: 10px;
}
#loginModal .modal-title {
    font-size: 1.2rem;
    font-weight: 700;
    color: #1a1a1a;
    margin-bottom: 2px;
}
#loginModal .modal-subtitle {
    font-size: 0.82rem;
    color: #999;
    margin: 0;
}
#loginModal .btn-close {
    position: absolute;
    top: 14px; right: 16px;
    opacity: 0.4;
}
#loginModal .modal-body {
    background: #fff;
    padding: 24px 28px 8px;
}
#loginModal .form-label {
    font-size: 0.85rem;
    font-weight: 600;
    color: #555;
    margin-bottom: 6px;
}
#loginModal .form-control {
    border-radius: 10px;
    border: 1px solid #dde0da;
    background: #f9faf8;
    height: 44px;
    font-size: 0.92rem;
}
#loginModal .form-control:focus {
    border-color: #0f7a54;
    box-shadow: 0 0 0 3px rgba(15,122,84,0.1);
    background: #fff;
}
#loginModal .modal-footer {
    background: #fff;
    border-top: 1px solid #f0f3ef;
    padding: 16px 28px 22px;
    flex-direction: column;
    gap: 10px;
}
#loginModal .btn-login-modal {
    width: 100%; height: 46px;
    background: #0f7a54;
    border: none; border-radius: 10px;
    color: #fff; font-size: 0.95rem;
    font-weight: 600; cursor: pointer;
    transition: background 0.2s;
}
#loginModal .btn-login-modal:hover { background: #0a5e3f; }

#loginModal .modal-divider {
    display: flex; align-items: center; gap: 12px;
    color: #bbb; font-size: 0.78rem; width: 100%;
}
#loginModal .modal-divider::before,
#loginModal .modal-divider::after {
    content: ''; flex: 1; height: 1px; background: #eee;
}
#loginModal .btn-group-row {
    display: flex; gap: 8px; width: 100%;
}
#loginModal .btn-group-row button {
    flex: 1; height: 38px; border-radius: 10px;
    border: 1px solid #dde0da; background: #f9faf8;
    color: #555; font-size: 0.8rem; font-weight: 500;
    cursor: pointer; transition: all 0.15s;
}
#loginModal .btn-group-row button:hover {
    border-color: #0f7a54; color: #0f7a54; background: #f0f7f4;
}
#loginModal .btn-group-row .btn-signup {
    background: #e8f5ee; border-color: #0f7a54;
    color: #0f7a54; font-weight: 600;
}
#loginModal .btn-group-row .btn-signup:hover { background: #d4eddf; }
</style>

<!-- 로그인 모달 (Bootstrap 5 기준) -->
<div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width:420px;">
    <div class="modal-content">

      <div class="modal-header">
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
        <div class="logo-box"><i class="fa fa-cutlery"></i></div>
        <h5 class="modal-title" id="loginModalLabel">에브리테이블</h5>
        <p class="modal-subtitle">서비스 이용을 위해 로그인해 주세요.</p>
      </div>

      <div class="modal-body">
        <form id="modalLoginForm">
          <input type="hidden" id="modalRedirectUrl" name="redirectUrl" value="">

          <div class="mb-3">
            <label for="modalId" class="form-label">아이디</label>
            <input type="text" class="form-control" id="modalId" name="id"
                   placeholder="아이디를 입력하세요." autocomplete="off" maxlength="20">
          </div>
          <div class="mb-2">
            <label for="modalPw" class="form-label">비밀번호</label>
            <input type="password" class="form-control" id="modalPw" name="pw"
                   placeholder="비밀번호를 입력하세요." autocomplete="off" maxlength="20">
          </div>

          <div id="modalLoginMsg" class="alert alert-danger d-none mt-2"
               style="font-size:0.84rem; padding:8px 12px; border-radius:8px;"></div>
        </form>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn-login-modal" onclick="modalLogin()">로그인</button>

        <div class="modal-divider">또는</div>

        <div class="btn-group-row">
          <button class="btn-signup"
                  onclick="location.href='${pageContext.request.contextPath}/member/writeTypeSelect.do'">
            회원가입
          </button>
          <button onclick="location.href='${pageContext.request.contextPath}/member/searchIdForm.do'">
            아이디 찾기
          </button>
          <button onclick="location.href='${pageContext.request.contextPath}/member/searchPwForm.do'">
            비밀번호 찾기
          </button>
        </div>
      </div>

    </div>
  </div>
</div>

<script type="text/javascript">
  function requireLogin(targetUrl) {
    const isLogin = ${ sessionScope.login != null ? 'true' : 'false' };
    if (isLogin) {
      location.href = targetUrl;
      return;
    }
    document.getElementById('modalRedirectUrl').value = targetUrl;
    document.getElementById('modalId').value = '';
    document.getElementById('modalPw').value = '';
    document.getElementById('modalLoginMsg').classList.add('d-none');
    new bootstrap.Modal(document.getElementById('loginModal')).show();
    document.getElementById('loginModal').addEventListener('shown.bs.modal', function(){
      document.getElementById('modalId').focus();
    }, { once: true });
  }

  function modalLogin() {
    const id  = document.getElementById('modalId').value.trim();
    const pw  = document.getElementById('modalPw').value;
    const redirectUrl = document.getElementById('modalRedirectUrl').value;

    if (!id || !pw) {
      showModalMsg('아이디와 비밀번호를 입력해 주세요.');
      return;
    }

    $.ajax({
      url: '${pageContext.request.contextPath}/member/loginAjax.do',
      method: 'POST',
      data: { id: id, pw: pw, redirectUrl: redirectUrl },
      success: function() {
        const modalEl = document.getElementById('loginModal');
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        if (modalInstance) modalInstance.hide();
        location.href = (redirectUrl && redirectUrl.trim() !== '')
                          ? redirectUrl
                          : '${pageContext.request.contextPath}/store/list.do';
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

  document.addEventListener('DOMContentLoaded', function(){
    ['modalId', 'modalPw'].forEach(function(id){
      const el = document.getElementById(id);
      if (el) el.addEventListener('keydown', function(e){
        if (e.key === 'Enter') modalLogin();
      });
    });
  });
</script>

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
      url: '${pageContext.request.contextPath}/member/loginAjax.do',
      method: 'POST',
      data: { id: id, pw: pw, redirectUrl: redirectUrl },
      success: function(data) {
    	    const result = $(data).find("#ajax-data-result").text().trim();
    	    if (result !== "ok") {
    	        showModalMsg('아이디 또는 비밀번호가 일치하지 않거나 이용이 제한된 계정입니다.');
    	        return;
    	    }
    	    const modalEl = document.getElementById('loginModal');
    	    const modalInstance = bootstrap.Modal.getInstance(modalEl);
    	    if (modalInstance) modalInstance.hide();
    	    location.href = (redirectUrl && redirectUrl.trim() !== '')
    	                      ? redirectUrl
    	                      : '${pageContext.request.contextPath}/store/list.do';
    	},
    	error: function() {
    	    showModalMsg('서버 오류가 발생했습니다.');
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
