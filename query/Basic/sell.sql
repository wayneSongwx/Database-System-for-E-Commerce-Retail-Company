use `project`;

start transaction; 
insert into `order_information` (ONLINE_STORE_ID, ORDER_ID, CUSTOMER_ID, TOTAL_VALUE, ORDER_DATE, PAYWAY) value
(1,41,10001,13,'2022/04/28',2);
insert into `order_list` (ONLINE_STORE_ID, ORDER_ID, CUSTOMER_ID, PRODUCT_ID, BUY_NUM, UNIT_SALE_PRICE, TOTAL_SALE_PRICE) values
(1,41,10001,1,1,8,8),
(1,41,10001,2,1,5,5);
update `inventories`
set INV_QUANTITY = INV_QUANTITY-1
where INV_ID = 1;
update `inventories`
set INV_QUANTITY = INV_QUANTITY-1
where INV_ID = 2;
commit;
