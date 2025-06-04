USE Kleague;

DESCRIBE PLAYER;
DESCRIBE TEAM;
DESCRIBE SCHEDULE;

SELECT	*
FROM	PLAYER;

SELECT	*
FROM	STADIUM;

SELECT	*
FROM	SCHEDULE;


-- 문자열 연결
SELECT	PLAYER_ID, CONCAT(PLAYER_NAME, ' 선수') 선수명
FROM	PLAYER;


-- 전화번호에서 '-'의 위치를 RETURN한다
SELECT	INSTR('010-1234-4567', '-');		/* 4 */


-- 'abcdefg'에서 1부터 4번째 위치까지의 문자열을 RETURN 한다
SELECT	SUBSTR('abcdefg', 1, 4);			/* abcd */


-- 전화번호 파싱: 전화번호에서 첫번째 파트인 국번호를 추출. 단, 국번호의 길이는 가변
SELECT	STADIUM_NAME, TEL, SUBSTR(TEL, 1, INSTR(TEL, '-') - 1) 국번호
FROM	STADIUM;


-- player들의 평균키(소수 넷째자리 반올림), 평균키(소수 넷째자리 버림)
SELECT	ROUND(AVG(HEIGHT), 3) '평균키(소수 넷째자리 반올림)',
		TRUNCATE(AVG(HEIGHT), 3) '평균키(소수 넷째자리 버림)'
FROM	PLAYER;


-- 컨텍스트가 문자형일 경우(기본값), 컨텍스트가 숫자형일 경우
SELECT	NOW();
SELECT	NOW() + 0;


-- SYSDATE(): 현재 시간
-- NOW(): 명령어가 실행된 시간
SELECT	SYSDATE(), SLEEP(5), SYSDATE();
SELECT	NOW(), SLEEP(5), NOW();


-- DATE(), TIME(), TIMESTAMP()
SELECT	DATE(NOW()), TIME(NOW()), TIMESTAMP(NOW());


-- 두 개의 날짜형 컬럼(DATE, TIME, TIMESTAMP)컬럼 혹은 값을 직접 더하거나 빼지 않아야 함.
-- 컨텍스트에 의해 산술 연산으로 해석한다.
-- 즉, 날짜를 문자열이 아닌 일반 숫자(정수)로 변환하여 계산한다.
SELECT	DATE('2024-12-26') - DATE('2024-12-22');
SELECT	DATE('2024-12-26') - DATE('2024-10-22');


-- 해결 방법 1: INTERVAL 표현식 사용
