USE	CLASSICMODELS;


SELECT	*
FROM	OFFICES;

SELECT	*
FROM	EMPLOYEES;

SELECT	*
FROM	PRODUCTS;

SELECT	*
FROM	ORDERS;

-- 1. 대륙별 지점의 수를 검색
SELECT	TERRITORY, COUNT(*) '지점 수'
FROM	OFFICES
GROUP	BY TERRITORY;


-- 2. 직책이 'Sales Rep'가 아닌 직원의 성명과 직책을 검색
SELECT	CONCAT(FIRSTNAME, ' ', LASTNAME) 성명, JOBTITLE 직책
FROM	EMPLOYEES
WHERE	JOBTITLE <> 'Sales Rep';


-- 3. 재고 개수가 9,000개 이상인 상품의 상품명, 재고 개수, 구매단가, 권장 소비자가를 검색
SELECT	NAME 상품명, QUANTITYINSTOCK '재고 개수', 
		CONCAT('USD ', BUYPRICE) 구매단가, 
        CONCAT('USD ', MSRP) '권장 소비자가'
FROM	PRODUCTS
WHERE	QUANTITYINSTOCK >= 9000;


-- 4. 상품라인이 'Classic Cars' 혹은 'Vintage Cars'이고, 제조사가 'Studio M Art Models'이며, 
--    권장 소비자가가 50에서 100 사이인 상품을 검색
SELECT	PRODUCTCODE, NAME, VENDOR, MSRP, PRODUCTLINE
FROM	PRODUCTS
WHERE	PRODUCTLINE IN ('Classic Cars', 'Vintage Cars') AND 
		VENDOR = 'Studio M Art Models' AND
        MSRP BETWEEN 50 AND 100;


-- 5. 상품라인별로 상품수와 최대, 최소, 평균 구매단가를 검색
SELECT	PRODUCTLINE, COUNT(*) 상품수, MAX(BUYPRICE) 최대, 
		MIN(BUYPRICE) 최소, ROUND(AVG(BUYPRICE), 2) 평균
FROM	PRODUCTS
GROUP	BY PRODUCTLINE;


-- 6. 'Ships'와 'Trains' 상품라인의 상품수를 검색
SELECT	PRODUCTLINE 상품라인, COUNT(*) 상품수
FROM	PRODUCTS
GROUP	BY PRODUCTLINE
HAVING	PRODUCTLINE IN ('Ships', 'Trains');


-- 7. 2005년 5월의 주문 정보를 검색. 단, 상태(status)는 한글로 출력함
SELECT	ORDERNO, ORDERDATE, 
		CASE
			WHEN STATUS = 'Shipped'		THEN '배송중'
            WHEN STATUS = 'Disputed'	THEN '문제해결중'
            WHEN STATUS = 'In Process'	THEN '처리중'
            WHEN STATUS = 'Resolved'	THEN '완료'
            WHEN STATUS = 'On Hold'		THEN '보류'
            WHEN STATUS = 'Cancelled'	THEN '취소'
            ELSE '없음'
		END status
FROM	ORDERS
WHERE	YEAR(ORDERDATE) = 2005 AND
		MONTH(ORDERDATE) = 05;
        

-- 8. 가장 최근에 이뤄진 10개 주문을 검색. (10위까지가 아님)
SELECT	ORDERNO, ORDERDATE, STATUS, CUSTOMERID	
FROM	ORDERS
ORDER	BY ORDERDATE DESC
LIMIT	10;


-- 9. 주문번호 10,100에 포함된 각 상품의 상품코드, 개수, 주문단가를 검색
SELECT	ORDERNO 주문번호, PRODUCTCODE 상품코드, 
		QUANTITY 개수, PRICEEACH 주문단가
FROM	ORDERDETAILS
WHERE	ORDERNO = 10100;


-- 10. 주문번호 10,100에서 주문액이 2,000불 이상인 상품을 검색
SELECT	ORDERNO 주문번호, PRODUCTCODE 상품코드, 
		QUANTITY 개수, PRICEEACH 주문단가,
        QUANTITY * PRICEEACH 주문액
FROM	ORDERDETAILS
WHERE	ORDERNO = 10100 AND
		QUANTITY * PRICEEACH >= 2000;
        

/* 다시 */
-- 11. 국가별 고객수의 평균을 검색
WITH TEMP AS
(
	SELECT	COUNT(*) 고객수
    FROM	CUSTOMERS
    GROUP	BY COUNTRY
)
SELECT	AVG(고객수)
FROM	TEMP;


-- 12. 직책이 'Sales Manager'인 직원의 직원번호, 성명, 직책, 근무 지점명을 검색
SELECT	E.EMPLOYEEID 직원번호, CONCAT(E.LASTNAME, ' ', E.FIRSTNAME) 성명,
		E.JOBTITLE 직책, O.TERRITORY
FROM	OFFICES O JOIN EMPLOYEES E ON O.OFFICECODE = E.OFFICECODE
WHERE	E.JOBTITLE LIKE '%Sales Manager%';


-- 'USA'에 있는 지점에서 근무하는 직원이 관리하는 고객
SELECT	CUSTOMERID, NAME 고객,
		EMPLOYEEID, CONCAT(FIRSTNAME, ' ', LASTNAME) 직원,
		O.OFFICECODE, O.CITY 지점
FROM	OFFICES O 
		JOIN EMPLOYEES E USING(OFFICECODE)
        JOIN CUSTOMERS C ON E.EMPLOYEEID = C.SALESREPID
WHERE	O.COUNTRY = 'USA'
ORDER	BY O.OFFICECODE, EMPLOYEEID, CUSTOMERID;


/* 다시 */
-- 14. 'USA'에 있는 지점에서 주문된 상품의 상품명과 주문개수를 검색
SELECT	productCode, P.name, SUM(quantity) AS CNT
FROM	OFFICES O 
		JOIN EMPLOYEES E USING(OFFICECODE)
        JOIN CUSTOMERS C ON E.EMPLOYEEID = C.SALESREPID
        JOIN ORDERS  	 USING(CUSTOMERID)
        JOIN ORDERDETAILS OD USING (ORDERNO)
        JOIN PRODUCTS P  USING(PRODUCTCODE)
WHERE	O.COUNTRY = 'USA'
GROUP	BY PRODUCTCODE
ORDER 	BY 3 DESC;


-- 15. 고객과 고객의 담당 직원을 검색. 단, 담당 직원이 없는 고객도 포함.
SELECT	customerId, C.name, city,
		employeeId, CONCAT(firstName, ' ', lastName) AS name
FROM	EMPLOYEES E RIGHT JOIN CUSTOMERS C ON E.EMPLOYEEID = C.SALESREPID
ORDER 	BY name, C.name;


-- 16. 고객과 고객의 담당 직원을 검색. 단, 담당 직원이 없는 고객과 담당 고객이 없는 직원도 포함.
SELECT	customerId, C.name, city,
		employeeId, CONCAT(firstName, ' ', lastName) AS name
FROM	EMPLOYEES E RIGHT JOIN CUSTOMERS C ON E.EMPLOYEEID = C.SALESREPID
UNION
SELECT	customerId, C.name, city,
		employeeId, CONCAT(firstName, ' ', lastName) AS name
FROM	EMPLOYEES E LEFT JOIN CUSTOMERS C ON E.EMPLOYEEID = C.SALESREPID;


-- 17. 직원과 직원의 상급자를 검색, 단, 상급자가 없는 직원도 포함
SELECT	emp.employeeId,
		CONCAT(emp.firstName, ' ', emp.lastName) AS employee, emp.jobTitle, 
        mgr.employeeId AS managerId,
        CONCAT(mgr.firstName, ' ', mgr.lastName) AS manager
FROM	EMPLOYEES EMP LEFT JOIN EMPLOYEES MGR ON EMP.MANAGERID = MGR.EMPLOYEEID;


-- 18. 권장 소비자 가격이 권장 소비자가격 평균의 2배 이상인 상품을 검색
SELECT	name 상품명, MSRP '권장 소비자가격'
FROM	PRODUCTS
WHERE	MSRP >= (
					SELECT	2*AVG(MSRP)
                    FROM	PRODUCTS
				);
                

/* 다시 */
-- 19. 성이 'Patterson'인 직원이 근무하는 지점을 검색
SELECT	officeCode, city 
FROM	OFFICES
WHERE	OFFICECODE IN (
							SELECT	OFFICECODE	
							FROM	EMPLOYEES
							WHERE	LASTNAME = 'Patterson'
					  )
ORDER 	BY officeCode;        


-- 20. 각 상품라인에서 권장 소비자가격이 가장 저렴한 상품을 검색
SELECT	productLine 상품라인, name 상품명, MSRP 소비자가격
FROM	PRODUCTS P1
WHERE	MSRP = (
					SELECT	MIN(MSRP)
                    FROM	PRODUCTS P2
                    WHERE	P2.PRODUCTLINE = P1.PRODUCTLINE
				)
ORDER 	BY productLine, name;


/* 다시 */
-- 21. 상태가 'Cancelled' 혹은 'On Hold'인 주문을 한 고객을 검색
SELECT	name
FROM	CUSTOMERS
WHERE	CUSTOMERID IN (
							SELECT	CUSTOMERID
                            FROM	ORDERS O
									JOIN CUSTOMERS C USING(CUSTOMERID)
							WHERE	O.STATUS IN ('Cancelled', 'On Hold')
					  );

SELECT NAME
FROM	CUSTOMERS C
WHERE	CUSTOMERID IN (
							SELECT	CUSTOMERID
                            FROM	ORDERS O
                            WHERE	O.STATUS IN ('Cancelled', 'On Hold') AND
									O.CUSTOMERID = C.CUSTOMERID
					  );
  

/* 다시 */
-- 22. 2003년 1월에 주문한 고객을 검색
SELECT	NAME
FROM	CUSTOMERS C
WHERE	CUSTOMERID IN (
							SELECT	CUSTOMERID
                            FROM	ORDERS O
                            WHERE	YEAR(ORDERDATE) = 2003 AND
									MONTH(ORDERDATE) = 1   AND
                                    O.CUSTOMERID = C.CUSTOMERID
					  );
                      
SELECT	NAME
FROM	CUSTOMERS C
WHERE	EXISTS (
						SELECT	*
						FROM	ORDERS O
						WHERE	YEAR(ORDERDATE) = 2003 AND
								MONTH(ORDERDATE) = 1   AND
								O.CUSTOMERID = C.CUSTOMERID
			   );
               
               
/* 다시 */ 
-- 23. 지점명과 지점에 근무하는 직원의 수를 검색
SELECT	CITY 지점명,
		(
			SELECT	COUNT(*)
            FROM	EMPLOYEES E
            WHERE	E.OFFICECODE = O.OFFICECODE	
		) 직원수
FROM	OFFICES O;


/* 다시 */ 
-- 24. 직원들을 사장부터 하위 직급별로 순서대로 검색. 단, 출력에 직원의 레벨과 보고라인(path)을 포함. 
-- 보고 라인은 직원 아이디를 사장부터 나열함.
WITH RECURSIVE employeeAnchor(id, name, title, level, path) AS
(
	SELECT	EMPLOYEEID, CONCAT(FIRSTNAME, ' ', LASTNAME), JOBTITLE,
			1, CAST(EMPLOYEEID AS CHAR(50))
	FROM	EMPLOYEES
    WHERE	MANAGERID IS NULL
		UNION	ALL
	SELECT	EMPLOYEEID, CONCAT(E.FIRSTNAME, ' ', E.LASTNAME), JOBTITLE,
			level + 1, CONCAT(A.path, ':', E.employeeId)
    FROM	employeeAnchor A JOIN EMPLOYEES E ON A.ID = E.MANAGERID
)
SELECT	*
FROM	employeeAnchor;


/* 다시 */
--  25. 2004년, 고객의 국가별/월별 주문횟수 검색. (세로축: 국가, 가로축: 월)
SELECT	COUNTRY,
		COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 1 THEN 1 END), 0) AS '1월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 2 THEN 1 END), 0) AS '2월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 3 THEN 1 END), 0) AS '3월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 4 THEN 1 END), 0) AS '4월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 5 THEN 1 END), 0) AS '5월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 6 THEN 1 END), 0) AS '6월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 7 THEN 1 END), 0) AS '7월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 8 THEN 1 END), 0) AS '8월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 9 THEN 1 END), 0) AS '9월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 10 THEN 1 END), 0) AS '10월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 11 THEN 1 END), 0) AS '11월',
        COALESCE(SUM(CASE WHEN MONTH(ORDERDATE) = 12 THEN 1 END), 0) AS '12월',
        COUNT(ORDERNO) 주문회수
FROM	CUSTOMERS C LEFT JOIN ORDERS O USING(CUSTOMERID)
WHERE	YEAR(O.ORDERDATE) = 2004
GROUP	BY COUNTRY
ORDER	BY COUNTRY;


-- 27. 상품라인별로, 상품의 평균 재고개수, 평균 판매가격, 평균 권장소비자가격을 검색
-- 그리고 마지막 줄에 전체 상품라인의 평균 재고개수, 평균 판매가격, 평균 권장소비자가격을 추가.
SELECT	IF(PRODUCTLINE IS NULL, '평균', PRODUCTLINE) AS PRODUCTLINE,
		AVG(quantityInStock), AVG(BUYPRICE), AVG(MSRP)
FROM	PRODUCTS
GROUP	BY PRODUCTLINE WITH ROLLUP;
