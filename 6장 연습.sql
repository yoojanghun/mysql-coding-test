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


-- 선수들의 평균 키보다 작은 선수들을 검색
SELECT	PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 등번호
FROM	PLAYER
WHERE	HEIGHT <= (
						SELECT	AVG(HEIGHT)
                        FROM	PLAYER
					)
ORDER	BY	PLAYER_NAME;


-- 정현수 선수의 소속팀 정보를 검색(정현수 선수는 동명이인)
SELECT	REGION_NAME 연고지명, TEAM_NAME 팀명, E_TEAM_NAME 영문팀명
FROM	PLAYER P JOIN TEAM T USING(TEAM_ID)
WHERE	P.PLAYER_NAME = '정현수'
ORDER BY TEAM_NAME; 

SELECT	REGION_NAME 연고지명, TEAM_NAME 팀명, E_TEAM_NAME 영문팀명
FROM	TEAM
WHERE	TEAM_ID IN (
						SELECT	TEAM_ID
                        FROM	PLAYER
                        WHERE	PLAYER_NAME = '정현수'
					)
ORDER BY TEAM_NAME; 
                    
                    
-- 각 팀에서 가장 키가 작은 선수를 검색
SELECT	TEAM_ID 팀코드, PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키
FROM	PLAYER
WHERE	(TEAM_ID, HEIGHT) IN (
								SELECT	TEAM_ID, MIN(HEIGHT)
                                FROM	PLAYER
                                GROUP	BY TEAM_ID
								)
ORDER BY TEAM_ID, PLAYER_NAME;

/* 아래처럼 하면 안됨. 키의 최소값을 구하긴 하는데, 여러 팀들의 최소 키가 서브쿼리 안에 들어 있음. */
SELECT	TEAM_ID 팀코드, PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키
FROM	PLAYER
WHERE	HEIGHT IN (
						SELECT	MIN(HEIGHT)
                        FROM	PLAYER
                        GROUP	BY TEAM_ID
					)
ORDER BY TEAM_ID, PLAYER_NAME;


-- 전체 선수들의 평균 키보다 작은 키를 가진 선수 정보 출력
SELECT 	PLAYER_NAME 선수명, HEIGHT 키,
		(
			SELECT	ROUND(AVG(HEIGHT))
            FROM	PLAYER
        ) '전체 평균키'
FROM	PLAYER
WHERE	HEIGHT < (
						SELECT	ROUND(AVG(HEIGHT))
                        FROM	PLAYER
					)
ORDER	BY 선수명;


-- 정현수 선수의 소속팀 정보를 검색
SELECT	REGION_NAME 연고지명, TEAM_NAME 팀명, E_TEAM_NAME 영문팀명
FROM	TEAM
WHERE	TEAM_ID IN (
						SELECT	TEAM_ID
						FROM	PLAYER
                        WHERE	PLAYER_NAME = '정현수'
					)
ORDER	BY TEAM_NAME;


-- 각 팀에서 제일 키가 작은 선수를 검색
SELECT	TEAM_ID 팀코드, PLAYER_NAME 선수명, POSITION 포지션
FROM	PLAYER P1
WHERE	HEIGHT = (
						SELECT	MIN(HEIGHT)
                        FROM	PLAYER P2
                        WHERE	P2.TEAM_ID = P1.TEAM_ID
					)
ORDER BY TEAM_ID, PLAYER_NAME;
                    
SELECT	TEAM_ID 팀코드, PLAYER_NAME 선수명, POSITION 포지션
FROM	PLAYER
WHERE	(TEAM_ID, HEIGHT) IN (
									SELECT	TEAM_ID, MIN(HEIGHT)
									FROM	PLAYER
									GROUP	BY	TEAM_ID
								)
ORDER BY TEAM_ID, PLAYER_NAME;


-- 각 팀에서 제일 키가 큰 선수들을 검색
SELECT	TEAM_ID, PLAYER_NAME, HEIGHT
FROM 	PLAYER	P1
WHERE	HEIGHT = (
						SELECT	MAX(HEIGHT)
                        FROM	PLAYER P2
						WHERE	P2.TEAM_ID = P1.TEAM_ID
					)
ORDER	BY TEAM_ID;


-- 소속 팀의 평균 키보다 작은 선수들을 검색
SELECT	TEAM_ID, PLAYER_NAME, POSITION, BACK_NO, HEIGHT
FROM	PLAYER P1
WHERE	HEIGHT < (
						SELECT	AVG(HEIGHT)
                        FROM	PLAYER P2
                        WHERE	P2.TEAM_ID = P1.TEAM_ID
					)
ORDER	BY P1.TEAM_ID, HEIGHT, PLAYER_NAME;


-- 브라질 혹은 러시아 선수가 있는 팀을 검색
SELECT	TEAM_ID, TEAM_NAME
FROM	TEAM T
WHERE	TEAM_ID IN (
						SELECT	TEAM_ID
                        FROM	PLAYER P
                        WHERE	P.NATION IN ('브라질', '러시아')
					);
                    
                    
-- 20120501부터 20120502 사이에 경기가 열렸던 경기장을 조회
SELECT	STADIUM_ID ID, STADIUM_NAME 경기장명
FROM	STADIUM ST
WHERE	ST.STADIUM_ID = (
							SELECT	SC.STADIUM_ID
                            FROM	SCHEDULE SC
                            WHERE	SC.STADIUM_ID = ST.STADIUM_ID AND
									SC.SCHE_DATE BETWEEN '2012-05-01' AND '2012-05-02'
							);


SELECT	STADIUM_ID ID, STADIUM_NAME 경기장명
FROM	STADIUM ST
WHERE	EXISTS (
					SELECT	1
					FROM	SCHEDULE SC
                    WHERE	SC.STADIUM_ID = ST.STADIUM_ID AND
							SC.SCHE_DATE BETWEEN '2012-05-01' AND '2012-05-02'
				);


-- K02 팀 소속이면서, 포지션이 GK인 선수들을 검색. (교집합)
SELECT 	TEAM_ID 팀코드, PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키
FROM	PLAYER P1
WHERE	EXISTS (
					SELECT	1
                    FROM	PLAYER P2
                    WHERE	P2.PLAYER_ID = P1.PLAYER_ID AND
							P2.TEAM_ID = 'K02' AND
                            P2.POSITION = 'GK'
				);
                
SELECT 	TEAM_ID 팀코드, PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키
FROM	PLAYER P1
WHERE	P2.TEAM_ID = 'K02' AND
		EXISTS (
					SELECT	1
                    FROM	PLAYER P2
                    WHERE	P2.PLAYER_ID = P1.PLAYER_ID AND
                            P2.POSITION = 'GK'
				);
					
-- 조인 : 두 테이블의 투플을 연결함

-- 연관 서브쿼리 : 메인쿼리 테이블을 필터링함 (메인쿼리 테이블의 투플 개수만큼 실행됨)
-- 메인쿼리의 최종 결과는 메인쿼리 테이블의 부분 집합을 리턴함
-- 메인쿼리 질의 결과에 서브쿼리 테이블의 컬럼을 포함해야 한다면, 서브쿼리 대신 조인을 사용해야 함.


-- 선수 정보와 소속 팀의 평균 키를 함께 검색
SELECT	TEAM_ID, PLAYER_NAME 선수명, HEIGHT 키,
		(
			SELECT	AVG(HEIGHT)
            FROM	PLAYER P2
			WHERE	P2.TEAM_ID = P1.TEAM_ID
		) 팀평균키
FROM	PLAYER P1
ORDER	BY TEAM_ID, 선수명;


-- 팀명과 소속 선수의 인원수를 검색
SELECT	TEAM_ID, TEAM_NAME,
		(
			SELECT	COUNT(*)
            FROM	PLAYER P
            WHERE	P.TEAM_ID = T.TEAM_ID
		) 탐인원수
FROM	TEAM T
ORDER	BY	TEAM_ID;


-- 각 팀의 마지막 경기가 진행된 날짜를 검색
SELECT	TEAM_ID, TEAM_NAME,
		(
			SELECT	MAX(SCHE_DATE)
            FROM	SCHEDULE SC
            WHERE	GUBUN = 'Y' AND
					(SC.HOMETEAM_ID = T.TEAM_ID OR
                    SC.AWAYTEAM_ID = T.TEAM_ID)
        ) '최종 경기일' 
FROM	TEAM T;


-- K09 팀의 선수 이름, 포지션, 백넘버를 검색
SELECT	PLAYER_NAME, POSITION, BACK_NO
FROM	PLAYER
WHERE	TEAM_ID = 'K09';

SELECT	PLAYER_NAME, POSITION, BACK_NO
FROM	(
			SELECT	TEAM_ID, PLAYER_ID, PLAYER_NAME, POSITION, BACK_NO
            FROM	PLAYER
            ORDER	BY PLAYER_ID DESC
		) AS PLAYER_TEMP
WHERE	TEAM_ID = 'K09';

-- 가독성을 개선한 코드(위의 코드와 실행 결과가 동일)
WITH PLAYER_TEMP AS
(
	SELECT	TEAM_ID, PLAYER_ID, PLAYER_NAME, POSITION, BACK_NO
	FROM	PLAYER
	ORDER	BY PLAYER_ID DESC
)
SELECT	PLAYER_NAME, POSITION, BACK_NO
FROM	PLAYER_TEMP
WHERE	TEAM_ID = 'K09';


-- 포지션이 MF인 선수들의 소속팀명 및 선수 정보를 검색
SELECT	TEAM_NAME 팀명, PLAYER_NAME 선수명, BACK_NO 백넘버
FROM	PLAYER JOIN TEAM USING(TEAM_ID)
WHERE	PLAYER.POSITION = 'MF'
ORDER BY 팀명, 선수명; 

SELECT	T.TEAM_NAME 팀명, P.PLAYER_NAME 선수명, P.BACK_NO 백넘버
FROM	(
			SELECT	TEAM_ID, PLAYER_NAME, BACK_NO
            FROM	PLAYER
            WHERE	POSITION = 'MF'
		) P, TEAM T
WHERE	P.TEAM_ID = T.TEAM_ID
ORDER	BY 팀명, 선수명;

WITH PLAYER_TEMP AS
(
	SELECT TEAM_ID, PLAYER_NAME, BACK_NO
	FROM PLAYER
	WHERE POSITION = 'MF'
)
SELECT 	TEAM_NAME 팀명, PLAYER_NAME 선수명, BACK_NO 백넘버
FROM 	PLAYER_TEMP JOIN TEAM USING (TEAM_ID)
ORDER 	BY 팀명, 선수명;


-- 키가 제일 큰 선수 5 명의 정보를 검색
SELECT	PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키
FROM	PLAYER
ORDER	BY HEIGHT DESC
LIMIT	5;

WITH PLAYER_TEMP AS
(
	SELECT	PLAYER_NAME, POSITION, BACK_NO, HEIGHT
    FROM	PLAYER
    WHERE	HEIGHT IS NOT NULL
    ORDER	BY	HEIGHT DESC
)
SELECT	PLAYER_NAME, POSITION, BACK_NO, HEIGHT
FROM	PLAYER_TEMP
LIMIT	5;


