SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

USE project;

CREATE VIEW user_remain_view AS SELECT
a.ORDER_DATE,
count( DISTINCT a.CUSTOMER_ID ) AS user_count,
count( DISTINCT ( IF ( DATEDIFF( b.ORDER_DATE, a.ORDER_DATE ) = 1, a.CUSTOMER_ID, NULL ) ) ) AS remain1,
-- 1日留存数
count( DISTINCT ( IF ( DATEDIFF( b.ORDER_DATE, a.ORDER_DATE ) = 2, a.CUSTOMER_ID, NULL ) ) ) AS remain2,
-- 2日留存数
count( DISTINCT ( IF ( DATEDIFF( b.ORDER_DATE, a.ORDER_DATE ) = 3, a.CUSTOMER_ID, NULL ) ) ) AS remain3,
-- 3日留存数
count( DISTINCT ( IF ( DATEDIFF( b.ORDER_DATE, a.ORDER_DATE ) = 4, a.CUSTOMER_ID, NULL ) ) ) AS remain4,
-- 4日留存数
count( DISTINCT ( IF ( DATEDIFF( b.ORDER_DATE, a.ORDER_DATE ) = 5, a.CUSTOMER_ID, NULL ) ) ) AS remain5,
-- 5日留存数
count( DISTINCT ( IF ( DATEDIFF( b.ORDER_DATE, a.ORDER_DATE ) = 6, a.CUSTOMER_ID, NULL ) ) ) AS remain6,
-- 6日留存数
count( DISTINCT ( IF ( DATEDIFF( b.ORDER_DATE, a.ORDER_DATE ) = 7, a.CUSTOMER_ID, NULL ) ) ) AS remain7,
-- 7日留存数
count( DISTINCT ( IF ( DATEDIFF( b.ORDER_DATE, a.ORDER_DATE ) = 15, a.CUSTOMER_ID, NULL ) ) ) AS remain15,
-- 15日留存数
count( DISTINCT ( IF ( DATEDIFF( b.ORDER_DATE, a.ORDER_DATE ) = 30, a.CUSTOMER_ID, NULL ) ) ) AS remain30 
-- 30日留存数
FROM
	( SELECT CUSTOMER_ID, ORDER_DATE FROM `order_information` GROUP BY CUSTOMER_ID, ORDER_DATE ) a
	LEFT JOIN ( SELECT CUSTOMER_ID, ORDER_DATE FROM `order_information` GROUP BY CUSTOMER_ID, ORDER_DATE ) b 
    ON a.CUSTOMER_ID = b.CUSTOMER_ID 
WHERE
	b.ORDER_DATE >= a.ORDER_DATE
GROUP BY
	a.ORDER_DATE;

SELECT
	ORDER_DATE,
	user_count,
	concat( round( remain1 / user_count * 100, 2 ), '%' ) AS day1,
-- 1日留存率
	concat( round( remain2 / user_count * 100, 2 ), '%' ) AS day2,
-- 2日留存率
	concat( round( remain3 / user_count * 100, 2 ), '%' ) AS day3,
-- 3日留存率
	concat( round( remain4 / user_count * 100, 2 ), '%' ) AS day4,
-- 4日留存率
	concat( round( remain5 / user_count * 100, 2 ), '%' ) AS day5,
-- 5日留存率
	concat( round( remain6 / user_count * 100, 2 ), '%' ) AS day6,
-- 6日留存率
	concat( round( remain7 / user_count * 100, 2 ), '%' ) AS day7,
-- 7日留存率
	concat( round( remain15 / user_count * 100, 2 ), '%' ) AS day15,
-- 15日留存率
	concat( round( remain30 / user_count * 100, 2 ), '%' ) AS day30 
-- 30日留存率	
FROM
	user_remain_view;