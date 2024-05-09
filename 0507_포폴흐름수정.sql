/*
R > 일자별 구매수량, 최근일자별 구매자수
F > 유저별 평균 방문회수 - 구매회수, 구매주기 
M > 전체 판매량, 시계열 판매량, 제품별 판매량, 제일 많이 구매한 고객 
*/

USE bootcamp_final;

SELECT 
	`주문일시` AS purchase_date,
	`총 주문금액` AS purchase_amount,
    `주문상품명` AS product_name,
    `수량` AS purchase_count,
	CONCAT(`주문자 주소`, `주문자 상세 주소`) AS user_id
FROM orderdata_0417;

#일자별 구매인원
SELECT purchase_date, COUNT(user_id) AS user_count
FROM(
	SELECT 
        CONCAT(YEAR(`주문일시`), MONTH(`주문일시`), DAY(`주문일시`)) AS purchase_date,
		`총 주문금액` AS purchase_amount,
		`주문상품명` AS product_name,
		`수량` AS purchase_count,
		CONCAT(`주문자 주소`, `주문자 상세 주소`) AS user_id
	FROM orderdata_0417
	) AS sub1
GROUP BY purchase_date
;

CREATE TABLE orderdata_new (
    purchase_date VARCHAR(8),
    purchase_amount DECIMAL(10, 2),
    product_name VARCHAR(255),
    purchase_count INT,
    user_id VARCHAR(255)
);

-- 데이터 삽입
INSERT INTO orderdata_new (purchase_date, purchase_amount, product_name, purchase_count, user_id)
SELECT 
    CONCAT(YEAR(`주문일시`), LPAD(MONTH(`주문일시`), 2, '0'), LPAD(DAY(`주문일시`), 2, '0')) AS purchase_date,
    `총 주문금액` AS purchase_amount,
    `주문상품명` AS product_name,
    `수량` AS purchase_count,
    CONCAT(`주문자 주소`, `주문자 상세 주소`) AS user_id
FROM orderdata_0417;

SELECT *
FROM orderdata_new;

#F > 유저별 평균 방문회수 - 구매회수, 구매주기

SELECT user_id, COUNT(DISTINCT purchase_date) AS frequency
FROM orderdata_new
GROUP BY user_id
ORDER BY frequency DESC
;

