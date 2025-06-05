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