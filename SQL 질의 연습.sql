USE classicmodels;

SELECT	*
FROM	OFFICES;

SELECT	*
FROM	EMPLOYEES;

SELECT	*
FROM	PRODUCTS;

SELECT	*
FROM	ORDERS;

SELECT	*
FROM	ORDERDETAILS;

SELECT	*
FROM	CUSTOMERS;

-- 대륙별 지점의 수 검색
SELECT	TERRITORY, COUNT(*)
FROM	OFFICES
GROUP	BY TERRITORY;


-- 직책이 'Sales Rep'가 아닌 직원의 성명과 직책을 검색
SELECT	CONCAT(LASTNAME, ' ', FIRSTNAME) 성명, JOBTITLE 직책
FROM	EMPLOYEES
WHERE	JOBTITLE <> 'Sales Rep';


-- 재고 개수가 9000개 이상인 상품의 상품명, 재고 개수, 구매단가, 권장 소비자가를 검색
SELECT	NAME 상품명, QUANTITYINSTOCK '재고 개수', 
		CONCAT('USD ', BUYPRICE) 구매단가,
        CONCAT('USD ', MSRP) '권장 소비자가'
FROM	PRODUCTS
WHERE	QUANTITYINSTOCK >= 9000;


-- 상품라인이 'Classic Cars' 혹은 'Vintage Cars'이고, 제조사가 'Studio M Art Models'이며,
-- 권장 소비자가가 50에서 100 사이인 상품을 검색
SELECT	productCode, name, vendor, MSRP, productLine
FROM	PRODUCTS
WHERE	PRODUCTLINE IN ('Classic Cars', 'Vintage Cars') AND
		VENDOR = 'Studio M Art Models' AND
        MSRP BETWEEN 50 AND 100;
        
        
-- 상품라인별로 상품수와 최대, 최소, 평균 구매 단가를 검색
SELECT	PRODUCTLINE, COUNT(*) 상품수, MAX(BUYPRICE) '최대 구매단가', 
		MIN(BUYPRICE) '최소 구매단가', ROUND(AVG(BUYPRICE), 2) '평균 구매단가'
FROM	PRODUCTS
GROUP	BY PRODUCTLINE;


-- 'Ships'와 'Trains' 상품라인의 상품수를 검색
SELECT	PRODUCTLINE 상품라인, COUNT(*) 상품수
FROM	PRODUCTS
WHERE	PRODUCTLINE IN ('Ships', 'Trains')
GROUP	BY PRODUCTLINE;

SELECT	PRODUCTLINE 상품라인, COUNT(*) 상품수
FROM	PRODUCTS
GROUP	BY PRODUCTLINE
HAVING	PRODUCTLINE IN ('Ships', 'Trains');


-- 2005년 5월의 주문 정보를 검색. 단, 상태(status)는 한글로 출력함
SELECT	ORDERNO, ORDERDATE, 
		CASE
			WHEN STATUS = 'In Process'	THEN '처리중'
            WHEN STATUS = 'Shipped'		THEN '배송중'
            WHEN STATUS = 'Resolved'	THEN '완료'
            WHEN STATUS = 'Disputed'	THEN '문제해결중'
            WHEN STATUS = 'On Hold'		THEN '보류'
            WHEN STATUS = 'Cancelled'	THEN '취소'
            ELSE '없음'
		END STATUS
FROM	ORDERS
WHERE	ORDERDATE LIKE '2005-05%';

SELECT	ORDERNO, ORDERDATE, 
		CASE
			WHEN STATUS = 'In Process'	THEN '처리중'
            WHEN STATUS = 'Shipped'		THEN '배송중'
            WHEN STATUS = 'Resolved'	THEN '완료'
            WHEN STATUS = 'Disputed'	THEN '문제해결중'
            WHEN STATUS = 'On Hold'		THEN '보류'
            WHEN STATUS = 'Cancelled'	THEN '취소'
            ELSE '없음'
		END STATUS
FROM	ORDERS
WHERE	YEAR(ORDERDATE) = 2005 AND MONTH(ORDERDATE) = 5;


-- 가장 최근에 이뤄진 10개 주문을 검색. (10위까지가 아님)
SELECT	*
FROM	ORDERS
ORDER	BY ORDERDATE DESC
LIMIT	10;


-- 주문번호 10,100에 포함된 각 상품의 상품코드, 개수, 주문단가를 검색
SELECT	ORDERNO 주문번호, PRODUCTCODE 상품코드, 
		QUANTITY 개수, PRICEEACH 주문단가
FROM	ORDERDETAILS
WHERE	ORDERNO = 10100;


-- 주문번호 10,100에서 주문액이 2,000불 이상인 상품을 검색
SELECT	orderNo, productCode, quantity, priceEach, quantity * priceEach 주문액
FROM	ORDERDETAILS
WHERE	ORDERNO = 10100 AND
		QUANTITY * PRICEEACH >= 2000;
        
        
-- 국가별 고객수의 평균을 검색
WITH TEMP AS(
				SELECT	COUNTRY, COUNT(*)
				FROM	CUSTOMERS
				GROUP	BY COUNTRY
			)
SELECT	AVG(COUNT(*)) '평균 고객수'
FROM	TEMP;               
-- 위처럼 하면 안됨. TEMP는 이미 COUNTRY 별 고객 수를 담고 있는 테이블인데 거기에 COUNT(*)를 하려고 하면 안됨

WITH TEMP AS(
				SELECT	COUNTRY, COUNT(*) 고객수
				FROM	CUSTOMERS
				GROUP	BY COUNTRY
			)
SELECT	AVG(고객수) '평균 고객수'
FROM	TEMP;    


-- 직책이 'Sales Manager'인 직원의 직원번호, 성명, 직책, 근무 지점명을 검색
SELECT	E.EMPLOYEEID 직원번호, CONCAT(LASTNAME, ' ', FIRSTNAME) 성명,
		E.JOBTITLE 직책, O.CITY
FROM	OFFICES O JOIN EMPLOYEES E USING(OFFICECODE)
WHERE	E.JOBTITLE LIKE '%Sales Manager%';


-- 'USA'에 있는 지점에서 근무하는 직원이 관리하는 고객을 검색
SELECT	C.CUSTOMERID, C.NAME 고객명,
		E.EMPLOYEEID, CONCAT(FIRSTNAME, ' ', LASTNAME) 직원,
        O.OFFICECODE, O.CITY 지점
FROM	OFFICES O
		JOIN EMPLOYEES E USING(OFFICECODE)
        JOIN CUSTOMERS C ON E.EMPLOYEEID = C.SALESREPID
WHERE	O.COUNTRY = 'USA'
ORDER	BY O.OFFICECODE, E.EMPLOYEEID, C.CUSTOMERID;


-- 'USA'에 있는 지점에서 주문된 상품의 상품명과 주문개수를 검색
SELECT	PRODUCTCODE, P.NAME 상품명, SUM(OD.QUANTITY) 주문개수
FROM	OFFICES O
		JOIN EMPLOYEES E      USING (OFFICECODE)
        JOIN CUSTOMERS C      ON    E.EMPLOYEEID = C.SALESREPID
        JOIN ORDERS           USING (CUSTOMERID)
        JOIN ORDERDETAILS OD  USING (ORDERNO)
        JOIN PRODUCTS P		  USING (PRODUCTCODE)
WHERE	O.COUNTRY = 'USA'
GROUP	BY PRODUCTCODE
ORDER	BY 3 DESC;
-- ORDERDETAILS에서 PRODCUTCODE가 중복되는 것은 여러개일 수 있다.(PRODCUTCODE는 PK의 일부임)
-- 그래서 GROUP BY로 묶어준 다음, QUANTITY의 SUM을 구해야 한다.


-- 고객과 고객의 담당 직원을 검색. 단, 담당 직원이 없는 고객도 포함
SELECT	CUSTOMERID, C.NAME, CITY,
		EMPLOYEEID, CONCAT(FIRSTNAME, ' ', LASTNAME) 이름
FROM	EMPLOYEES E
		RIGHT OUTER JOIN CUSTOMERS C ON E.EMPLOYEEID = C.SALESREPID
ORDER	BY 이름, C.NAME;


-- 고객과 고객의 담당 직원을 검색. 단, 담당 직원이 없는 고객과 담당 고객이 없는 직원도 포함
SELECT	CUSTOMERID, C.NAME, CITY,
		EMPLOYEEID, CONCAT(FIRSTNAME, ' ', LASTNAME) 이름
FROM	EMPLOYEES E
		LEFT OUTER JOIN CUSTOMERS C ON E.EMPLOYEEID = C.SALESREPID
UNION
SELECT	CUSTOMERID, C.NAME, CITY,
		EMPLOYEEID, CONCAT(FIRSTNAME, ' ', LASTNAME) 이름
FROM	EMPLOYEES E
		RIGHT OUTER JOIN CUSTOMERS C ON E.EMPLOYEEID = C.SALESREPID;


-- 직원과 직원의 상급자를 검색. 단, 상급자가 없는 직원도 포함
SELECT	EMP.EMPLOYEEID 직원번호,
		CONCAT(EMP.FIRSTNAME, ' ', EMP.LASTNAME) 직원, EMP.JOBTITLE 직업,
        MGR.EMPLOYEEID 상급자번호, 
        CONCAT(MGR.FIRSTNAME, ' ', MGR.LASTNAME) 상급자
FROM	EMPLOYEES EMP 
		LEFT OUTER JOIN EMPLOYEES MGR ON EMP.MANAGERID = MGR.EMPLOYEEID;
        
        
-- 권장 소비자 가격이 권장 소비자가격 평균의 2배 이상인 상품을 검색
SELECT	NAME 상품명, MSRP '권장 소비자가격'
FROM	PRODUCTS
WHERE	MSRP >= (
					SELECT	2 * AVG(MSRP) 
                    FROM	PRODUCTS
				)
ORDER	BY MSRP;


-- 성이 'Patterson'인 직원이 근무하는 지점을 검색
SELECT	officeCode, city
FROM	OFFICES JOIN EMPLOYEES USING(OFFICECODE)
WHERE	LASTNAME = 'Patterson'
ORDER	BY OFFICECODE;

WITH TEMP AS(
				SELECT	officeCode, CITY
                FROM	OFFICES JOIN EMPLOYEES USING(officeCode)
			)
SELECT	officeCode, CITY
FROM	TEMP
WHERE	LASTNAME = 'Patterson'
ORDER	BY officeCode;
/* 위처럼 하면 오류이다. TEMP로 만들어진 테이블에 LASTNAME 컬럼이 없기 때문이다. TEMP테이블 안에 LASTNAME 컬럼을 추가해야 한다. */

