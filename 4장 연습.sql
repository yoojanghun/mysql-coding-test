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
SELECT	DATE('2024-12-26') + INTERVAL 7 DAY AS DIFF;
SELECT	DATE('2025-01-23') - INTERVAL 6 DAY AS DIFF;

SELECT	TIME('12:25:37') - INTERVAL 2 HOUR AS DIFF;
SELECT	TIME('12:25:37') + INTERVAL 30 MINUTE AS DIFF;


-- 해결 방법 2: TIMESTAMPDIFF(unit, begin, end) 함수
SELECT	TIMESTAMPDIFF(DAY, '2024-12-22', '2024-12-26') AS DIFF;
SELECT	TIMESTAMPDIFF(DAY, '2024-10-22', '2024-12-26') AS DIFF;


-- 만나이 구하기
SELECT	PLAYER_NAME, TIMESTAMPDIFF(YEAR, BIRTH_DATE, DATE(NOW())) 만나이
FROM	PLAYER;


-- DATE_FORMAT(): 입력 날짜형, 출력 문자형
SELECT	PLAYER_NAME 선수명, BIRTH_DATE 생일, 
		DATE_FORMAT(BIRTH_DATE, '%y-%m-%d') 포맷1,
        DATE_FORMAT(BIRTH_DATE, '%Y-%M-%D') 포맷2
FROM	PLAYER;


-- STR_TO_DATE(): 입력 문자형, 출력 날짜형
SELECT	STR_TO_DATE('21,5,2013', '%d,%m,%Y');
SELECT	STR_TO_DATE('113005', '%h%i%s');
SELECT	STR_TO_DATE('11', '%h');
SELECT	STR_TO_DATE('20130101 1130', '%Y%m%d %h%i');


SELECT	NOW();					/* DATETIME 자료형 */
SELECT	DATE(NOW());			/* DATE     자료형 */
SELECT	TIME(NOW());			/* TIME	    자료형 */

-- CAST(): 특정 데이터 타입의 데이터를 다른 데이터 타입으로 변환
SELECT	CONCAT('DATE: ', CAST(NOW() AS DATE));