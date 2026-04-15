🍽️ 에브리테이블 (EveryTable)
단체 예약 및 선결제 기반 카페·식당 픽업 주문 플랫폼 > 기존의 번거로운 전화 단체 주문 방식을 온라인으로 전환하여, 메뉴 선택부터 사전 결제까지 한 번에 관리하는 운영형 커머스 시스템입니다.

1. 📅 프로젝트 개요
개발 기간: 2026.03.23 ~ 2026.04.12

주요 목적:

예약 기반의 단체 주문 링크 생성 및 공유 기능 제공

구매자의 사전 결제 및 매장의 주문 승인/거절 시스템 구축

환불 정책에 따른 자동 환불 및 상태 관리 자동화

관리자를 위한 실시간 매출 및 판매 통계 대시보드 제공

2. 🛠️ 기술 스택
Language: Java (JDK 17)

Framework: Spring MVC (또는 JSP/Servlet 기반 DispatcherServlet 구조)

Database: Oracle Database

Server: Apache Tomcat 10

Frontend: HTML5, CSS3, JavaScript, Bootstrap, SiteMesh

Library: JDBC, SLF4J (Logging), Jakarta Servlet

3. ✨ 핵심 기능
👤 사용자 (Client)
단체 주문 생성: 예약 날짜/시간 지정 및 공유 링크 생성

메뉴 선택 및 결제: 공유받은 링크를 통해 각자 메뉴 선택 후 구매자 통합 결제

마이페이지: 주문 내역 확인 및 예약 상태 조회

🏪 매장 및 관리자 (Admin)
주문 관리: 단체 주문 접수 시 승인 또는 거절 처리

실시간 대시보드: 오늘 기준 실시간 매출액 및 주문 건수 요약 정보 제공

통계 분석: 기간별 매출 추이 그래프 및 일별 상세 판매 통계 리포트 제공

검색 및 필터: 기간 설정(startDate ~ endDate)을 통한 정밀 데이터 조회 및 초기화 기능

4. 📈 데이터베이스 구조 (ERD)
프로젝트는 크게 Orders(실시간 주문), Store(매장), Store_Stats_Daily(일일 통계) 테이블 등으로 구성되어 있습니다.

실시간성 보장: Orders 테이블을 직접 조회하여 '오늘의 현황'을 실시간으로 집계

성능 최적화: 과거 데이터는 Store_Stats_Daily 테이블에 정산 데이터를 누적하여 대량 조회 성능 향상

5. 🔍 핵심 코드 및 트러블슈팅
✅ 실시간 매출 집계 로직
단순 통계 조회가 아닌 SYSDATE를 활용하여 매일 자정마다 자동으로 초기화되는 실시간 매출 집계 쿼리를 구현했습니다.

SQL
SELECT NVL(SUM(TOTAL_PRICE), 0) as sales, COUNT(ORDER_ID) as cnt 
FROM orders 
WHERE STORE_ID = ? 
AND TO_CHAR(CREATED_AT, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD');
✅ 트러블슈팅: 데이터 불일치 해결
문제: 대시보드 상단 요약(실시간)과 하단 리스트(통계 장부)의 수치가 일치하지 않는 현상 발생

원인: 상단은 주문 원장(orders)을 보고, 하단은 정산 테이블(store_stats_daily)을 참조하는 물리적 차이 확인

해결: 테스트 및 개발 단계에서 UPDATE 쿼리를 통한 데이터 동기화와 실제 운영을 고려한 '일일 마감 배치 로직' 설계의 필요성을 도출함

6. 🚀 차후 업데이트 예정
[ ] 쿠폰 발급 및 사용 처리 시스템

[ ] 매장/메뉴 카테고리별 매출 통계 세분화

[ ] 인기 매장 랭킹 리스트 구현

[ ] 예약 정보 수정 및 사용자 프로필 강화

👩‍💻 팀원 정보
홍윤정(조장): 프로젝트 총괄, 시스템 설계

이혜원, 정시은, 원주현, 주연오: 기능 구현 및 UI/UX 설계, DB 모델링
