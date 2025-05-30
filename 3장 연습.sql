USE KLEAGUE;

DESCRIBE PLAYER;

-- 선수의 모든 정보를 검색
SELECT *
FROM PLAYER;


-- ‘K06’ 팀 선수의 이름, 팀 아이디, 백넘버, 포지션, 키, 몸무게를 검색
SELECT	PLAYER_NAME, TEAM_ID, BACK_NO, POSITION, HEIGHT, WEIGHT
FROM	PLAYER
WHERE	TEAM_ID = 'K06';


-- ‘K06’ 팀 선수의 이름, 팀 아이디, 백넘버, 포지션, 키, 몸무게, 그리고 비만도를 검색
SELECT	PLAYER_NAME, TEAM_ID, BACK_NO, POSITION, HEIGHT, WEIGHT, ROUND(WEIGHT / ((HEIGHT/100)*(HEIGHT/100)), 2) 비만도
FROM	PLAYER
WHERE	TEAM_ID = 'K06';


-- FROM 절의 생략
SELECT LENGTH('SQL EXPERT') AS ColumnLength;
SELECT LOWER('SQL EXPERT') AS 소문자;


-- SELECT ALL(기본값) DISTINCT
SELECT DISTINCT POSITION
FROM PLAYER; 


-- CONCAT(string1,string2, … , stringN): 컬럼과 컬럼, 혹은 컬럼과 문자열을 연결하여, 새로운 컬럼을 생성.
SELECT CONCAT(PLAYER_NAME, '선수,', HEIGHT, 'cm,', WEIGHT, 'kg') 체격정보
FROM PLAYER; 


-- 비교 연산자(=, >, <, >=, <=, <>)
SELECT PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키
FROM PLAYER
WHERE TEAM_ID IN ('K02', 'K07') AND
		POSITION = 'MF' AND
		HEIGHT BETWEEN 170 AND 180;
	
SELECT PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키
FROM PLAYER
WHERE TEAM_ID IN ('K02', 'K07') AND
		POSITION <> 'MF' AND
		HEIGHT NOT BETWEEN 170 AND 180;
        

-- IN 연산자에 속성의 조합(n-tuple) 사용
SELECT 	PLAYER_NAME, TEAM_ID, POSITION, NATION
FROM 	PLAYER
WHERE 	(POSITION, NATION) IN (('MF','브라질'), ('FW', '러시아')); 

SELECT 	PLAYER_NAME, TEAM_ID, POSITION, NATION
FROM 	PLAYER
WHERE 	(POSITION, NATION) = ('MF','브라질') OR 
		(POSITION, NATION) = ('FW','러시아');
        
SELECT 	PLAYER_NAME, TEAM_ID, POSITION, NATION
FROM 	PLAYER
WHERE 	POSITION IN ('MF', 'FW') AND NATION IN ('브라질', '러시아');

SELECT 	PLAYER_NAME, TEAM_ID, POSITION, NATION
FROM 	PLAYER
WHERE 	(POSITION = 'MF' OR POSITION = 'FW') AND
		(NATION = '브라질' OR NATION = '러시아');
        
        
-- [NOT] LIKE 연산자
SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키
FROM 	PLAYER
WHERE 	POSITION LIKE 'MF'; 		/* exact match */

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키
FROM 	PLAYER
WHERE 	PLAYER_NAME LIKE '장%'; /* partial match */


-- IS [NOT] NULL 연산자
SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, TEAM_ID
FROM 	PLAYER
WHERE 	POSITION IS NULL; /* TRUE 혹은 FALSE 리턴 */


-- PK에 있는 값의 수 = 저장된 투플의 개수
SELECT 	COUNT(PLAYER_ID), COUNT(*)
FROM	PLAYER;


-- COUNT는 NULL값은 세지 않는다
SELECT	COUNT(TEAM_ID) '팀 아이디', COUNT(POSITION) 포지션, COUNT(BACK_NO) 백넘버, COUNT(HEIGHT) 키
FROM	PLAYER;


-- COUNT는 ALL(중복된 값도 카운트, 기본값) 또는 DISTINCT(중복된 값 제거)
SELECT	COUNT(DISTINCT TEAM_ID) '팀 아이디', COUNT(DISTINCT POSITION) 포지션,
		COUNT(DISTINCT BACK_NO) 백넘버, COUNT(DISTINCT HEIGHT) 키
FROM	PLAYER;


-- GROUP BY절로 그룹별로 묶은 후, SELECT절에서 집계 함수 적용
SELECT	POSITION, AVG(HEIGHT) '평균 키'
FROM	PLAYER
WHERE	TEAM_ID = 'K10'
GROUP 	BY	POSITION;	/*POSITION 그룹 수만큼 투플 생성*/

SELECT	POSITION 포지션, COUNT(*) 인원수, COUNT(HEIGHT) 키대상, MAX(HEIGHT) 최대키, MIN(HEIGHT) 최소키, ROUND(AVG(HEIGHT), 2) 평균키
FROM	PLAYER
GROUP 	BY	POSITION;	


-- HAVING절은 GROUP BY로 만든 그룹의 조건식이 TRUE인 그룹만 선택
SELECT	POSITION
FROM	PLAYER
GROUP 	BY POSITION
HAVING	POSITION IN ('DF', 'MF');

SELECT	TEAM_ID 팀아이디, COUNT(*) 인원수
FROM	PLAYER
GROUP	BY	TEAM_ID
HAVING	TEAM_ID IN ('K09', 'K14');


-- 하지만 위처럼 하는 것보다 WHERE절에서 조건을 적용해서 대상 투플 수를 줄이는 것이 더 좋음
SELECT	TEAM_ID 팀아이디, COUNT(*) 인원수
FROM	PLAYER
WHERE	TEAM_ID IN ('K09', 'K14')
GROUP	BY TEAM_ID;


-- 동명이인 구하기
SELECT	PLAYER_NAME 선수명, COUNT(PLAYER_NAME) 선수수
FROM	PLAYER
GROUP	BY	PLAYER_NAME
HAVING	COUNT(PLAYER_NAME) >= 2;
