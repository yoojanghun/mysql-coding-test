USE classicmodels;

SELECT	*
FROM	OFFICES;

SELECT	*
FROM	EMPLOYEES;

SELECT	*
FROM	PRODUCTS;

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