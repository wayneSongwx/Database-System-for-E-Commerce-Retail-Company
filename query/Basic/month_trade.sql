select PRODUCT_ID, ORDER_MONTH, a 'SALES' from  #按月列出当月所有交易（包括物品id，月份，以及售出额）
    (select PRODUCT_ID, MONTH(ORDER_DATE) AS ORDER_MONTH,TOTAL_SALE_PRICE a, 0 e from order_list
         union 
     select 'MONTH_SUM'PRODUCT_ID ,MONTH(ORDER_DATE) AS ORDER_MONTH, sum(TOTAL_SALE_PRICE) a ,2 e from order_list group by MONTH(ORDER_DATE))  #月合计收入（所有item的deal price相加得到月总收入）
lb order by ORDER_MONTH, e; #按照月份排序