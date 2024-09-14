use `project`;

start transaction; 
insert into `purchase` (PURCHASE_ID, SUPPLIER_ID, PRODUCT_ID, PURCHASE_TIME, PRODUCT_PRICE, PURCHASE_NUM, TOTAL_COST) value
(14,1,1,"2022/04/28",4,100,400);
update `inventories`
set INV_QUANTITY = INV_QUANTITY+100
where INV_ID = 1;
commit;