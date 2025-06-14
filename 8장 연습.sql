USE KLEAGUE;

SELECT	*
FROM	SCHEDULE;

-- 집계 함수(aggregate function) + GROUP BY 절
SELECT	POSITION, AVG(HEIGHT) 평균키
FROM	PLAYER
WHERE	TEAM_ID = 'K10'
GROUP	BY POSITION;


-- 윈도우 함수 + PARTITION BY 절
-- PARTITION BY 절을 이용해 파트를 나눔.
-- 각 파트 별로 윈도우 함수를 각각 적용. 계산한 값은 투플마다 추가함.
-- 파티션 마다 하나의 투플을 리턴하지 않고, 파티션의 모든 투플들을 리턴함.
SELECT	PLAYER_NAME, POSITION, HEIGHT,
		AVG(HEIGHT) OVER (PARTITION BY POSITION) 평균키
FROM	PLAYER
WHERE	TEAM_ID = 'K10';


-- 선수들의 키 순서대로 일련번호를 출력. 단 키가 같은 경우는 이름의 오름차순으로 정렬함.
SELECT	PLAYER_NAME, HEIGHT,
		ROW_NUMBER() OVER (ORDER BY HEIGHT DESC, PLAYER_NAME) AS ROW_NUM
FROM	PLAYER
WHERE	TEAM_ID = 'K06' AND POSITION = 'MF';


-- 선수들의 키 순서대로 순위를 출력(동점자 처리) 단, 키가 같은 경우는 이름의 오름차순으로 정렬
SELECT	ROW_NUMBER() OVER (ORDER BY HEIGHT DESC, PLAYER_NAME) AS ROW_NUM,
		PLAYER_NAME, HEIGHT,
        RANK() OVER (ORDER BY HEIGHT DESC) AS ALL_RANK
FROM	PLAYER
WHERE	TEAM_ID = 'K06' AND POSITION = 'MF';


-- 참고로 아래처럼 하면, RANK()에서 동일한 POSITION에 대해 같은 순위(RANK)를 부여하고, 다음 순위는 건너뜀
SELECT	ROW_NUMBER() OVER (ORDER BY POSITION) ROW_NUM,
		PLAYER_NAME, HEIGHT,
        RANK() OVER (ORDER BY POSITION) ALL_RANK
FROM	PLAYER
WHERE	TEAM_ID = 'K06';


-- 선수들의 포지션 별로, 키 순서대로 순위를 출력(동점자 처리) 단, 키가 같은 경우는 이름의 오름차순으로 정렬
-- 참고로 아래처럼 하면 ROW_NUMBER에서 POSITION별로, POSITION이 같다면 HEIGHT와 PLAYER_NAME으로 번호를 붙였는데,
-- RANK()는 HEIGHT만을 기준으로 번호를 붙였으므로, ROW_NUM이 증가한다고 해서 ALL_RANK도 증가하는 경향을 보이진 않음.
SELECT	ROW_NUMBER() OVER (ORDER BY POSITION, HEIGHT DESC, PLAYER_NAME) ROW_NUM,
		PLAYER_NAME, POSITION, HEIGHT,
        RANK() OVER (ORDER BY HEIGHT DESC) ALL_RANK
FROM	PLAYER
WHERE	TEAM_ID = 'K06'
ORDER	BY ROW_NUM;


SELECT	ROW_NUMBER() OVER (ORDER BY POSITION, HEIGHT DESC, PLAYER_NAME) ROW_NUM,
		PLAYER_NAME, POSITION, HEIGHT,
        RANK() OVER (ORDER BY HEIGHT DESC) ALL_RANK,	/* 전체 순위 */
        RANK() OVER 
        (
			PARTITION BY POSITION
            ORDER BY HEIGHT DESC
		) AS POSITION_RANK								/* 포지션 내부에서의 순위 */
FROM	PLAYER
WHERE	TEAM_ID = 'K06'
ORDER	BY ROW_NUM;


-- 선수들의 키 순서대로 순위를 출력(동점자 처리). 단, 순위는 갭 없이 이어지고, 키가 같은 경우는 이름의 오름차순으로 정렬
SELECT	ROW_NUMBER() OVER (ORDER BY HEIGHT DESC, PLAYER_NAME) ROW_NUM,
		PLAYER_NAME, HEIGHT,
        DENSE_RANK() OVER (ORDER BY HEIGHT DESC) ALL_RANK
FROM	PLAYER
WHERE	TEAM_ID = 'K06' AND POSITION = 'MF';


-- TOP-N QUERY
-- 정렬 순서에 따라, 앞에서 N개 투플을 검색: ORDER BY절 + LIMIT 절, ROW_NUMBER()함수
-- 계산 순위에 따라, 상위 N번째까지 검색 (동점자 처리): RANK()함수, DENSE_RANK 함수


-- K04팀에서 포지션 별로 키가 큰 5명씩 검색(상위 5위가 아님). 단 키가 같은 경우는 이름의 오름차순으로 정렬
WITH TEMP AS
(
	SELECT	PLAYER_NAME, POSITION, HEIGHT,
			ROW_NUMBER() OVER
            (
				PARTITION BY POSITION
                ORDER BY HEIGHT DESC, PLAYER_NAME
			) POSITION_ROW_NUM
	FROM	PLAYER
    WHERE	TEAM_ID = 'K04'
)
SELECT	PLAYER_NAME, POSITION, HEIGHT, POSITION_ROW_NUM
FROM	TEMP
WHERE	POSITION_ROW_NUM <= 5;


-- 참고로 아래처럼 하면 마치 ORDER BY POSITION 한 것처럼 파트가 POSITION 별로 묶어서 출력됨.
SELECT 	PLAYER_NAME, POSITION, HEIGHT,
		ROW_NUMBER() OVER
		(
			PARTITION BY POSITION
			ORDER BY HEIGHT DESC, PLAYER_NAME ASC
		) AS POSITION_ROW_NUM /* 컬럼 별칭 */
FROM 	PLAYER
WHERE 	TEAM_ID = 'K04';


-- K04 팀에서 포지션 별로 상위 5위까지 검색. (동점자 처리) 단, 키가 같은 경우는 이름의 오름차순으로 정렬함.
WITH TEMP AS
(
	SELECT	PLAYER_NAME, POSITION, HEIGHT,
			ROW_NUMBER() OVER
            (
				PARTITION BY POSITION
                ORDER BY HEIGHT DESC, PLAYER_NAME
			) POSITION_ROW_NUM,
            RANK() OVER
            (
				PARTITION BY POSITION
                ORDER BY HEIGHT DESC
			) POSITION_RANK
	FROM	PLAYER
    WHERE	TEAM_ID = 'K04'
)
SELECT	PLAYER_NAME, POSITION, HEIGHT, POSITION_ROW_NUM, POSITION_RANK
FROM	TEMP
WHERE	POSITION_RANK <= 5;


-- 팀별로 홈경기 점수의 합을 구하여, 각 경기의 정보(팀명, 경기날짜, 구분, 홈경기 점수)와 함께 출력하세요.
SELECT	TEAM_NAME, SCHE_DATE, GUBUN, HOME_SCORE,
		SUM(HOME_SCORE) OVER (PARTITION BY TEAM_ID) HOME_SCORE_SUM
FROM	TEAM T JOIN SCHEDULE SC 
		ON T.TEAM_ID = SC.HOMETEAM_ID
WHERE	GUBUN = 'Y' AND TEAM_ID <= 'K03';


-- ROLLUP() 함수는 GRUOP BY 절의 기능을 확장(GROUP BY 절에서만 사용)
SELECT	TEAM_NAME, POSITION, 
		COUNT(*) 'TOTAL PLAYERS', AVG(HEIGHT) 'AVG_HEIGHT'
FROM	TEAM JOIN PLAYER USING(TEAM_ID)
WHERE	TEAM_ID <= 'K03'
GROUP	BY TEAM_NAME, POSITION WITH ROLLUP;


-- IF(조건, THEN_RESULT, ELSE_RESULT)
SELECT	IF(TEAM_NAME IS NULL, 'ALL TEAMS', TEAM_NAME) AS 'TEAM NAME',
		IF(POSITION IS NULL, 'ALL POSITIONS', POSITION) AS 'POSITION',
        COUNT(*) 'TOTAL PLAYERS', AVG(HEIGHT) 'AVG HEIGHT'
FROM	TEAM JOIN PLAYER USING(TEAM_ID)
WHERE	TEAM_ID <= 'K03'
GROUP	BY TEAM_NAME, POSITION WITH ROLLUP;