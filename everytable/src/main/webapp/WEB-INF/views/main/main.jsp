<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>에브리테이블</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Myeongjo:wght@400;700;800&family=Pretendard:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

body {
    font-family: 'Pretendard', 'Apple SD Gothic Neo', sans-serif;
    background: #f7f6f2;
    color: #2a2a2a;
    overflow-x: hidden;
}

/* ── 히어로 ── */
.hero {
    min-height: 94vh;
    background: #3d5c35;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    overflow: hidden;
    padding: 120px 40px 80px;
}
.hero-bg-circle1 {
    position: absolute;
    width: 700px; height: 700px;
    border-radius: 50%;
    border: 1px solid rgba(255,255,255,0.06);
    top: -180px; right: -180px;
    pointer-events: none;
}
.hero-bg-circle2 {
    position: absolute;
    width: 400px; height: 400px;
    border-radius: 50%;
    background: rgba(255,255,255,0.03);
    bottom: -120px; left: -60px;
    pointer-events: none;
}
.hero-inner {
    max-width: 960px;
    width: 100%;
    position: relative;
    z-index: 1;
    display: grid;
    grid-template-columns: 1.1fr 0.9fr;
    gap: 70px;
    align-items: center;
}
.hero-eyebrow {
    font-size: 0.75rem;
    font-weight: 500;
    letter-spacing: 0.2em;
    text-transform: uppercase;
    color: rgba(255,255,255,0.45);
    margin-bottom: 20px;
    animation: fadeUp 0.6s ease both;
}
.hero-title {
    font-family: 'Nanum Myeongjo', serif;
    font-size: clamp(2.6rem, 5vw, 3.8rem);
    font-weight: 800;
    line-height: 1.18;
    color: #fff;
    margin-bottom: 24px;
    word-break: keep-all;
    animation: fadeUp 0.6s ease 0.1s both;
}
.hero-title em {
    font-style: normal;
    color: #c5d990;
}
.hero-desc {
    font-size: 0.93rem;
    font-weight: 300;
    line-height: 1.9;
    color: rgba(255,255,255,0.6);
    margin-bottom: 40px;
    word-break: keep-all;
    animation: fadeUp 0.6s ease 0.2s both;
}
.hero-actions {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    animation: fadeUp 0.6s ease 0.3s both;
}
.btn-primary-hero {
    display: inline-block;
    background: #c5d990;
    color: #2a3d1f;
    font-size: 0.88rem;
    font-weight: 600;
    padding: 13px 28px;
    border-radius: 50px;
    text-decoration: none;
    transition: background 0.18s, transform 0.15s;
}
.btn-primary-hero:hover {
    background: #b4ca7a;
    transform: translateY(-2px);
    text-decoration: none;
    color: #2a3d1f;
}
.btn-ghost-hero {
    display: inline-block;
    border: 1px solid rgba(255,255,255,0.26);
    color: rgba(255,255,255,0.78);
    font-size: 0.88rem;
    font-weight: 400;
    padding: 13px 28px;
    border-radius: 50px;
    text-decoration: none;
    transition: border-color 0.18s, color 0.18s;
}
.btn-ghost-hero:hover {
    border-color: rgba(255,255,255,0.5);
    color: #fff;
    text-decoration: none;
}

/* 히어로 우측 — 서비스 포인트 카드 */
.hero-card {
    background: rgba(255,255,255,0.07);
    border: 1px solid rgba(255,255,255,0.11);
    border-radius: 20px;
    padding: 30px 26px;
    animation: fadeUp 0.6s ease 0.4s both;
}
.hc-title {
    font-size: 0.75rem;
    font-weight: 500;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: rgba(255,255,255,0.4);
    margin-bottom: 22px;
}
.hc-list {
    list-style: none;
    display: flex;
    flex-direction: column;
    gap: 0;
}
.hc-item {
    display: flex;
    align-items: flex-start;
    gap: 14px;
    padding: 16px 0;
    border-bottom: 1px solid rgba(255,255,255,0.07);
}
.hc-item:last-child { border-bottom: none; }
.hc-icon {
    width: 38px; height: 38px;
    background: rgba(197,217,144,0.14);
    border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem;
    flex-shrink: 0;
    margin-top: 1px;
}
.hc-item-title {
    font-size: 0.88rem;
    font-weight: 600;
    color: #fff;
    margin-bottom: 3px;
}
.hc-item-desc {
    font-size: 0.78rem;
    color: rgba(255,255,255,0.48);
    line-height: 1.5;
    word-break: keep-all;
}

/* ── 서비스 흐름 섹션 ── */
.flow-section {
    background: #fff;
    padding: 88px 40px;
}
.flow-inner {
    max-width: 960px;
    margin: 0 auto;
}
.section-label {
    font-size: 0.73rem;
    font-weight: 600;
    letter-spacing: 0.16em;
    text-transform: uppercase;
    color: #87a372;
    margin-bottom: 10px;
}
.section-title {
    font-family: 'Nanum Myeongjo', serif;
    font-size: clamp(1.6rem, 3vw, 2.2rem);
    font-weight: 700;
    color: #1e2820;
    margin-bottom: 8px;
    word-break: keep-all;
    line-height: 1.3;
}
.section-sub {
    font-size: 0.88rem;
    color: #aaa;
    font-weight: 300;
    margin-bottom: 54px;
    word-break: keep-all;
    line-height: 1.7;
}
.flow-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 0;
    position: relative;
}
.flow-grid::after {
    content: '';
    position: absolute;
    top: 30px; left: 12.5%; right: 12.5%;
    height: 1px;
    background: repeating-linear-gradient(to right, #d4dece 0, #d4dece 6px, transparent 6px, transparent 14px);
    z-index: 0;
}
.flow-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: 0 16px;
    position: relative;
    z-index: 1;
}
.flow-num {
    width: 60px; height: 60px;
    border-radius: 50%;
    background: #f0f4ec;
    border: 1.5px solid #d4dece;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.3rem;
    margin-bottom: 18px;
}
.flow-item-title {
    font-size: 0.9rem;
    font-weight: 600;
    color: #2a3d1f;
    margin-bottom: 6px;
}
.flow-item-desc {
    font-size: 0.78rem;
    color: #aaa;
    line-height: 1.65;
    word-break: keep-all;
}

/* ── 가치 섹션 ── */
.value-section {
    background: #f7f6f2;
    padding: 88px 40px;
}
.value-inner {
    max-width: 960px;
    margin: 0 auto;
}
.value-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
}
.value-card {
    background: #fff;
    border-radius: 16px;
    border: 1px solid #eae8e2;
    padding: 32px 28px;
    transition: transform 0.2s;
}
.value-card:hover { transform: translateY(-3px); }
.value-card-icon {
    font-size: 1.8rem;
    margin-bottom: 18px;
}
.value-card-title {
    font-size: 1rem;
    font-weight: 600;
    color: #1e2820;
    margin-bottom: 10px;
}
.value-card-desc {
    font-size: 0.83rem;
    color: #999;
    line-height: 1.75;
    word-break: keep-all;
}

/* ── CTA ── */
.cta-section {
    background: #2a3d1f;
    padding: 80px 40px;
    text-align: center;
}
.cta-section h2 {
    font-family: 'Nanum Myeongjo', serif;
    font-size: clamp(1.5rem, 3vw, 2.1rem);
    font-weight: 700;
    color: #fff;
    margin-bottom: 12px;
    word-break: keep-all;
}
.cta-section p {
    font-size: 0.88rem;
    color: rgba(255,255,255,0.5);
    margin-bottom: 32px;
    font-weight: 300;
}
.btn-cta {
    display: inline-block;
    background: #c5d990;
    color: #2a3d1f;
    font-size: 0.9rem;
    font-weight: 700;
    padding: 14px 36px;
    border-radius: 50px;
    text-decoration: none;
    transition: background 0.18s;
    margin: 0 6px;
}
.btn-cta:hover {
    background: #b4ca7a;
    text-decoration: none;
    color: #2a3d1f;
}
.btn-cta-ghost {
    display: inline-block;
    border: 1px solid rgba(255,255,255,0.24);
    color: rgba(255,255,255,0.7);
    font-size: 0.88rem;
    font-weight: 400;
    padding: 14px 30px;
    border-radius: 50px;
    text-decoration: none;
    transition: border-color 0.18s, color 0.18s;
    margin: 0 6px;
}
.btn-cta-ghost:hover {
    border-color: rgba(255,255,255,0.5);
    color: #fff;
    text-decoration: none;
}

/* ── 반응형 ── */
@media (max-width: 900px) {
    .hero-inner { grid-template-columns: 1fr; gap: 40px; }
    .hero-card { display: none; }
    .flow-grid { grid-template-columns: repeat(2, 1fr); gap: 36px; }
    .flow-grid::after { display: none; }
    .value-grid { grid-template-columns: 1fr; }
}
@media (max-width: 560px) {
    .flow-grid { grid-template-columns: 1fr; }
    .hero { padding: 100px 24px 60px; }
    .flow-section, .value-section { padding: 60px 24px; }
}

@keyframes fadeUp {
    from { opacity: 0; transform: translateY(22px); }
    to   { opacity: 1; transform: translateY(0); }
}
</style>
</head>
<body>

<!-- ── 히어로 배너 ── -->
<section class="hero">
    <div class="hero-bg-circle1"></div>
    <div class="hero-bg-circle2"></div>
    <div class="hero-inner">
        <div class="hero-text">
            <p class="hero-eyebrow">EveryTable · 에브리테이블</p>
            <h1 class="hero-title">
                매일의 식사를<br>
                <em>특별하게</em>
            </h1>
            <p class="hero-desc">
                원하는 매장을 찾고, 메뉴를 보고,<br>
                간편하게 주문까지. 에브리테이블이<br>
                식사의 모든 순간을 함께합니다.
            </p>
            <div class="hero-actions">
                <a href="/store/list.do" class="btn-primary-hero">매장 둘러보기</a>
                <c:if test="${empty login}">
                    <a href="/member/writeTypeSelect.do" class="btn-ghost-hero">회원가입</a>
                </c:if>
                <c:if test="${!empty login}">
                    <a href="/reservation/list.do" class="btn-ghost-hero">내 주문 보기</a>
                </c:if>
            </div>
        </div>

        <div class="hero-card">
            <p class="hc-title">서비스 특징</p>
            <ul class="hc-list">
                <li class="hc-item">
                    <div class="hc-icon">🍽️</div>
                    <div>
                        <div class="hc-item-title">다양한 매장</div>
                        <div class="hc-item-desc">한식, 양식, 카페까지 다양한 카테고리의 매장을 한눈에</div>
                    </div>
                </li>
                <li class="hc-item">
                    <div class="hc-icon">📋</div>
                    <div>
                        <div class="hc-item-title">간편한 주문</div>
                        <div class="hc-item-desc">메뉴 확인부터 주문까지 몇 번의 클릭으로 완료</div>
                    </div>
                </li>
                <li class="hc-item">
                    <div class="hc-icon">⭐</div>
                    <div>
                        <div class="hc-item-title">솔직한 리뷰</div>
                        <div class="hc-item-desc">실제 이용자의 생생한 후기로 현명한 선택</div>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</section>

<!-- ── 이용 흐름 ── -->
<section class="flow-section">
    <div class="flow-inner">
        <p class="section-label">How it works</p>
        <h2 class="section-title">이렇게 이용하세요</h2>
        <p class="section-sub">가입부터 주문까지, 4단계면 충분합니다.</p>

        <div class="flow-grid">
            <div class="flow-item">
                <div class="flow-num">👤</div>
                <div class="flow-item-title">회원가입</div>
                <div class="flow-item-desc">간단한 정보 입력으로 빠르게 가입</div>
            </div>
            <div class="flow-item">
                <div class="flow-num">🔍</div>
                <div class="flow-item-title">매장 탐색</div>
                <div class="flow-item-desc">원하는 음식 종류의 매장을 검색</div>
            </div>
            <div class="flow-item">
                <div class="flow-num">📋</div>
                <div class="flow-item-title">메뉴 선택</div>
                <div class="flow-item-desc">메뉴판을 보고 원하는 메뉴 선택</div>
            </div>
            <div class="flow-item">
                <div class="flow-num">✅</div>
                <div class="flow-item-title">주문 완료</div>
                <div class="flow-item-desc">간편하게 주문하고 리뷰까지</div>
            </div>
        </div>
    </div>
</section>

<!-- ── 가치 카드 ── -->
<section class="value-section">
    <div class="value-inner">
        <p class="section-label">Why EveryTable</p>
        <h2 class="section-title">에브리테이블을 선택하는 이유</h2>
        <p class="section-sub">매장 점주와 고객 모두를 위한 플랫폼입니다.</p>

        <div class="value-grid">
            <div class="value-card">
                <div class="value-card-icon">🗺️</div>
                <div class="value-card-title">한눈에 보이는 매장 정보</div>
                <div class="value-card-desc">매장 소개, 메뉴, 운영 시간을 한 페이지에서 확인하세요. 방문 전 모든 것을 미리 파악할 수 있습니다.</div>
            </div>
            <div class="value-card">
                <div class="value-card-icon">⚡</div>
                <div class="value-card-title">빠르고 간편한 주문</div>
                <div class="value-card-desc">복잡한 절차 없이 클릭 몇 번으로 주문 완료. 점주도 손쉽게 주문을 관리할 수 있습니다.</div>
            </div>
            <div class="value-card">
                <div class="value-card-icon">💬</div>
                <div class="value-card-title">진짜 리뷰 문화</div>
                <div class="value-card-desc">실제 이용자만 작성할 수 있는 리뷰. 신뢰할 수 있는 후기로 더 나은 선택을 도와드립니다.</div>
            </div>
        </div>
    </div>
</section>

<!-- ── CTA ── -->
<section class="cta-section">
    <h2>지금 바로 시작해보세요</h2>
    <p>회원가입은 무료입니다. 매장 점주라면 입점도 환영합니다.</p>
    <c:choose>
        <c:when test="${empty login}">
            <a href="/member/writeTypeSelect.do" class="btn-cta">무료 회원가입</a>
            <a href="/store/list.do" class="btn-cta-ghost">매장 둘러보기</a>
        </c:when>
        <c:otherwise>
            <a href="/store/list.do" class="btn-cta">매장 둘러보기</a>
            <a href="/reservation/list.do" class="btn-cta-ghost">내 주문 보기</a>
        </c:otherwise>
    </c:choose>
</section>

</body>
</html>
