USE	KLEAGUE;
USE	COMPANY;

SELECT	*
FROM	SCHEDULE;

SELECT	*
FROM	EMPLOYEE;

-- CTE와 FROM절 서브쿼리는 서로 변환 가능함.
SELECT	TEAM_NAME, STADIUM_NAME
FROM	(
			SELECT	TEAM_NAME, STADIUM_NAME, STADIUM_ID
            FROM	TEAM JOIN STADIUM USING(STADIUM_ID)
		) AS TEMP;
        
WITH TEMP AS(
				SELECT	TEAM_NAME, STADIUM_NAME, STADIUM_ID
                FROM	TEAM JOIN STADIUM USING(STADIUM_ID)
			)
SELECT	TEAM_NAME, STADIUM_NAME
FROM	TEMP;


-- Recursive CTE: 초기값으로 주어진 한 개 투플을 이용해, 재귀적으로 연속해서 다음 투플을 생성
WITH RECURSIVE cte AS
(
	SELECT 	1 AS n		/* n 컬럼에 숫자 1을 집어넣을 때, 다른 테이블을 확인할 필요가 없어서 FROM절 안 씀 */
    UNION  	ALL
    SELECT 	n + 1 
    FROM 	cte 
    WHERE 	n < 5
)
SELECT	*
FROM 	cte;

WITH RECURSIVE cte(n) AS
(
	SELECT	1
    UNION 	ALL
    SELECT	n + 1 
    FROM 	cte 
    WHERE 	n < 5
)
SELECT	*
FROM	cte;


-- Recursive SELECT에서 컬럼의 데이터 타입은 non-recursive SELECT에서의 데이터 타입과 동일
-- 아래 예에서 str의 데이터 타입은 CHAR(3)
WITH RECURSIVE cte AS
(
	SELECT	1 AS n, 'abc' AS str
    UNION	ALL
    SELECT	n + 1, CONCAT(str, str)
    FROM	cte
    WHERE	n < 4
)
SELECT	*
FROM	cte;
-- str을 이어 붙이면 CHAR(3)보다 더 긴 데이터 타입이 필요함

-- 그래서 아래처럼 str의 데이터 타입을 임시로 변경함
WITH RECURSIVE cte AS
(
	SELECT	1 AS n, CAST('str' AS CHAR(30)) AS str
    UNION 	ALL
    SELECT	n + 1, CONCAT(str, str)
    FROM	cte
    WHERE	n < 4
)
SELECT	*
FROM	cte;

WITH RECURSIVE cte(n, str) AS
(
	SELECT 	1, CAST('str' AS CHAR(30))
    UNION	ALL
    SELECT	n + 1, CONCAT(str, str)
    FROM	cte
    WHERE	n < 4
)
SELECT	*
FROM	cte;


-- 날짜별 경기수를 검색 (경기가 없는 날의 경기수도 출력)
SELECT	SCHE_DATE 날짜, COUNT(*) 경기수
FROM	SCHEDULE
GROUP	BY SCHE_DATE
ORDER	BY SCHE_DATE;

-- 1.원하는 범위 내의 모든 날짜를 출력
WITH RECURSIVE DATES (DATE) AS
(
	SELECT	CAST(MIN(SCHE_DATE) AS DATE)
    FROM	SCHEDULE
    UNION 	ALL
    SELECT	DATE + INTERVAL 1 DAY
    FROM	DATES
    WHERE	DATE + INTERVAL 1 DAY <= '2012-03-31'
)
SELECT	*
FROM	DATES;

-- 2.Dates와 Schedule 테이블을 조인
WITH RECURSIVE DATES (DATE) AS
(
	SELECT	CAST(MIN(SCHE_DATE) AS DATE)
    FROM	SCHEDULE
    UNION 	ALL
    SELECT	DATE + INTERVAL 1 DAY
    FROM	DATES
    WHERE	DATE + INTERVAL 1 DAY <= '2012-03-31'
)
SELECT	*
FROM	DATES LEFT JOIN SCHEDULE ON DATES.DATE = SCHEDULE.SCHE_DATE
ORDER	BY DATES.DATE;

-- 날짜별로 GROUP BY한 후, 투플 개수 COUNT
WITH RECURSIVE DATES (DATE) AS
(
	SELECT	CAST(MIN(SCHE_DATE) AS DATE)
    FROM	SCHEDULE
    UNION 	ALL
    SELECT	DATE + INTERVAL 1 DAY
    FROM	DATES
    WHERE	DATE + INTERVAL 1 DAY <= '2012-03-31'
)
SELECT	DATES.DATE, COUNT(SCHE_DATE) AS NO_OF_GAMES
FROM	DATES LEFT JOIN SCHEDULE ON DATES.DATE = SCHEDULE.SCHE_DATE
GROUP	BY DATES.DATE
ORDER	BY DATES.DATE;
-- SELECT 절에서 “COUNT(*)”하면, 게임이 없었던 날의 NO_OF_GAMES가 1이 됨.
-- LEFT JOIN에 의해, 게임이 없던 날에도 하나의 투플이 생성되었음


-- 순환 관계를 갖는 테이블
-- 한 테이블에 자신의 PK를 참조하는 FK가 같이 존재.
-- 이 경우, 동일 테이블에 계층적으로 상위와 하위 데이터가 포함됨.

-- 계층형 질의
-- 상위/하위 데이터가 포함된 테이블을 self join하지 않고, 상위 혹은 하위 데이터부터 차례대로 검색하는 방법


-- 사원들을 사장부터 최하위 직급까지 직급별로 순서대로 검색 (상위부터 검색)
WITH RECURSIVE employee_anchor (Ssn, Fname, Minit, Lname, Level) AS
(
	SELECT	Ssn, Fname, Minit, Lname, 1
    FROM	EMPLOYEE
    WHERE	SUPER_SSN IS NULL			/* 사장 */
		UNION 	ALL
	SELECT	E.Ssn, E.Fname, E.Minit, E.Lname, Level+1
    FROM	employee_anchor EA 			/* 지금까지 재귀로 쌓아온 상사 목록. 첫 반복에서는 EA에 사장 한 명만 있다. */
			JOIN EMPLOYEE E ON E.SUPER_SSN = EA.SSN		/* employee 중에 상사의 ssn을 EA에서 찾음. 즉, 부하 직원을 찾음. */
)
    SELECT *
FROM employee_anchor; /* ORDER BY 없어도 레벨 순으로 출력됨 */