USE		KLEAGUE;


-- 좌석수 기준, 규모가 11번째부터 15번째까지의 경기장 (11, 15위가 아님)
SELECT 	STADIUM_ID, STADIUM_NAME, SEAT_COUNT
FROM 	STADIUM
ORDER 	BY SEAT_COUNT DESC, STADIUM_NAME
LIMIT 	10, 5;


-- 전화번호 파싱: 전화번호에서 첫번째 파트인 국번호를 추출. 단, 국번호의 길이는 가변임.
SELECT	STADIUM_NAME, TEL,
		SUBSTR(TEL, 1, INSTR(TEL, '-') - 1) 국번호
FROM	STADIUM;

/* SUBSTR과 INSTR 모두 어떤 문자열에 대해 함수를 적용할 지 먼저 써 둠(TEL) */
-- INSTR(TEL, '-'), SUBSTR(TEL, 1, 3)


-- TRUNCATE는 버림 함수
SELECT	TRUNCATE(SUM(HEIGHT)/COUNT(HEIGHT), 3) '평균키(셋째 자리까지만)'
FROM	PLAYER;


-- NOW의 데이터 타입은 DATETIME
SELECT	TIMESTAMP(NOW()),		/* DATETIME */
		DATE(NOW()),			/* DATE */
        YEAR(NOW()),			/* 숫자형 */
        MONTH(NOW()),			/* 숫자형 */
        DAY(NOW()),				/* 숫자형 */
        HOUR(NOW()),			/* 숫자형 */
        MINUTE(NOW()),			/* 숫자형 */
        SECOND(NOW()),			/* 숫자형 */
        TIME(NOW());			/* TIME */
        
        
-- INTERVAL을 이용해서 시간 덧셈 뻴샘을 할 수 있다.
SELECT	NOW(),
		DATE(NOW()) + INTERVAL 1 YEAR AS TEST1,
        DATE(NOW()) + INTERVAL 1 MONTH AS TEST2,
        DATE(NOW()) + INTERVAL 1 DAY AS TEST3,
        TIME(NOW()) + INTERVAL 1 HOUR AS TEST4,
        TIME(NOW()) + INTERVAL 5 MINUTE AS TEST5,
        TIME(NOW()) + INTERVAL 5 SECOND AS TEST6;
        
        
-- CAST(): 데이터 타입의 데이터를 다른 데이터 타입으로 변환
SELECT	CONCAT('DATE: ', CAST(NOW() AS DATE));


-- COALESCE(): NULL 아닌 최초의 값을 리턴
SELECT	COALESCE(NULL, 1);
SELECT	COALESCE(NULL, NULL, NULL);


-- CASE를 한번 쓰면 하나의 COLUMN이 생성됨
SELECT	PLAYER_NAME,
		CASE
			WHEN POSITION = 'FW' 	THEN 'FORWARD'
            WHEN POSITION = 'DF'	THEN 'DEFENSE'
            WHEN POSITION = 'MF'	THEN 'MID-FIELD'
            WHEN POSITION = 'GL'	THEN 'GOALKEEPER'
            ELSE 'UNDEFINED'
		END AS 포지션
FROM	PLAYER;


-- 키 별로 등급을 나눔
SELECT	PLAYER_NAME, HEIGHT,
		CASE
			WHEN HEIGHT >= 185 THEN 'A'
            ELSE (
						CASE 
							WHEN HEIGHT >= 175 THEN 'B'
                            WHEN HEIGHT < 175 THEN 'C'
                            WHEN HEIGHT IS NULL THEN 'X'
						END
				)
		END AS 키등급
FROM	PLAYER;


/* 서브 쿼리 복습 */
-- 선수들의 평균 키보다 작은 선수들을 검색
SELECT	PLAYER_NAME, POSITION, BACK_NO, HEIGHT
FROM	PLAYER
WHERE	HEIGHT <= (
						SELECT	AVG(HEIGHT)
                        FROM	PLAYER
				  )
ORDER	BY PLAYER_NAME;


-- 각 팀에서 가장 키가 작은 선수
SELECT	TEAM_ID, PLAYER_NAME, HEIGHT
FROM	PLAYER P1
WHERE	HEIGHT = (
						SELECT	MAX(HEIGHT)
                        FROM	PLAYER P2
                        WHERE	P2.TEAM_ID = P1.TEAM_ID
				 )
ORDER 	BY TEAM_ID;


-- 브라질 혹은 러시아 출신 선수가 있는 팀을 검색
SELECT	TEAM_ID, TEAM_NAME
FROM	TEAM T
WHERE	TEAM_ID IN (
						SELECT	TEAM_ID
                        FROM	PLAYER P 
                        WHERE	P.TEAM_ID = T.TEAM_ID AND
								(P.NATION IN ('브라질', '러시아'))
					);