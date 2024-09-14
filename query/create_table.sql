SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS `project` ;
CREATE SCHEMA IF NOT EXISTS `project` DEFAULT CHARACTER SET utf8 ;
USE `project` ;

------------------------地址数据------------------------
CREATE TABLE `project`.`locations` (
	LOCATION_ID DECIMAL(4,0),                                        --地址ID
	ADDRESS_1 VARCHAR(100) NOT NULL,                              --地址
    ADDRESS_2 VARCHAR(100),
    POSTAL_CODE DECIMAL(12,0) NOT NULL,                                     --邮编
    CITY VARCHAR(30) NOT NULL,                                     --城市
    STATE_PROVINCE VARCHAR(25) NOT NULL,                           --省份/州
    COUNTRY VARCHAR(20) NOT NULL,                           --国家
    PRIMARY KEY (LOCATION_ID)
);

------------------------从供应商处进货数据------------------------
CREATE TABLE `project`.`purchase` (
    PURCHASE_ID DECIMAL(6, 0),   --ID (primary key)
    SUPPLIER_ID DECIMAL(6, 0),   --供应商ID (应设置为 reference key)
    PRODUCT_ID DECIMAL(6, 0),   --购买产品的ID (应设置为 reference key)
    PURCHASE_TIME DATETIME,
    PRODUCT_PRICE DECIMAL(5, 0),   --购买产品的价格
    PURCHASE_NUM DECIMAL(6, 0),   --购买数量
    TOTAL_COST DECIMAL(11, 0),   --总花费 (purchase_num*product_price)
    PRIMARY KEY (PURCHASE_ID),
    FOREIGN KEY (SUPPLIER_ID) REFERENCES `project`.`suppliers_basic_info` (SUPPLIER_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES `project`.`suppliers_products` (PRODUCT_ID)
);

------------------------供应商数据------------------------
CREATE TABLE `project`.`suppliers_basic_info` (
	SUPPLIER_ID DECIMAL(6,0),                                                      --供应商ID
    SUPPLIER_NAME VARCHAR(20) NOT NULL,                            --供应商名称 (index)
    FOUND_DATE DATETIME,                                                                    --供应商成立时间
    BUSINESS_LICENSE_NUMBER DECIMAL(30,0),                       --供应商营业执照
    CREDIT_RATING DECIMAL(1,0),                                                          --供应商信用评级(0-9)
    REGISTERED_CAPITAL DECIMAL(50,0) NOT NULL,                  --供应商注册资金(k, USD)
    REGISTERED_LOCATION_ID DECIMAL(10,0),                            --供应商注册地址
    FACTORY_LOCATION_ID DECIMAL(10,0),                                  --供应商生产地址
    LEGAL_PERSON_NAME DECIMAL(6,0) NOT NULL,                  --供应商法人代表
    LEGAL_PERSON_PHONE_NUMBER TEXT,                                 --供应商法人联系方式
    MAIN_BUSINESS TEXT,                                                               --供应商主营业务
    FAX VARCHAR(50) NOT NULL,                                                   --供应商传真编号
    LANDLINE VARCHAR(20),                                                           --供应商座机号码
    EMAIL VARCHAR(20),                                                                  --供应商邮箱
    WEBSITE VARCHAR(50),                                                             --供应商网站
    PRIMARY KEY (SUPPLIER_ID),
    FOREIGN KEY (REGISTERED_LOCATION_ID) REFERENCES `project`.`locations` (LOCATION_ID),
    FOREIGN KEY (FACTORY_LOCATION_ID) REFERENCES `project`.`locations` (LOCATION_ID)
);

CREATE TABLE `project`.`suppliers_financial_info` (
    SUPPLIER_ID DECIMAL(6,0),                                    --供应商ID
    NET_PROFIT_LAST_YEAR DECIMAL(50,0),           --供应商去年盈利
    TOTAL_NET_PROFIT DECIMAL(50,0),                      --供应商总盈利
    REVENUE_LAST_YEAR DECIMAL(50,0),                   --供应商去年销售额
    TOTAL_REVENUE DECIMAL(50,0),                           --供应商总销售额
    PRIMARY KEY (SUPPLIER_ID),
    FOREIGN KEY (SUPPLIER_ID) REFERENCES `project`.`suppliers_basic_info` (SUPPLIER_ID)
);

CREATE TABLE `project`.`suppliers_products` (
    PRODUCT_ID DECIMAL(6,0),                                         --产品ID
    SUPPLIER_ID DECIMAL(6,0),                                         --供应商ID
    PRODUCT_NAME VARCHAR(50) NOT NULL,               --产品名称 (index)
    PRODUCT_DESCRIPTION TEXT,                                    --产品描述
    CATEGORY VARCHAR(20),                                             --产品种类
    SUPPLIER_PRICE DECIMAL(5,0),                                   --供应商报价
    QUANTITY_THRESHOLD DECIMAL(10,0),                     --最低购买数量
    SUPPLIER_CUMULATIVE_SALES DECIMAL(50,0),        --该产品供应商累计销售额
    PRIMARY KEY (PRODUCT_ID),
    FOREIGN KEY (SUPPLIER_ID) REFERENCES `project`.`suppliers_basic_info` (SUPPLIER_ID)
);

------------------------库存数据------------------------
CREATE TABLE `project`.`inventories`(
	INV_ID DECIMAL(10,0),                                                      -- ID
    WAREHOUSE_LOCATION_ID DECIMAL(10,0),                   --仓库地址
    INV_NAME VARCHAR(255) NOT NULL,                              -- 物品名称
    INV_QUANTITY DECIMAL(10,0) NOT NULL DEFAULT 0, -- 物品数量
    INV_MAX DECIMAL(10,0),                                                  -- 物品最大储量
    INV_MIN DECIMAL(10,0) DEFAULT 0,                                                   -- 物品最小储量
    INV_RECORDER VARCHAR(255),                                      -- 物品备注
    PRIMARY KEY (INV_ID, WAREHOUSE_LOCATION_ID),
    FOREIGN KEY (INV_ID) REFERENCES `project`.`suppliers_products` (PRODUCT_ID),
    FOREIGN KEY (WAREHOUSE_LOCATION_ID) REFERENCES `project`.`locations` (LOCATION_ID)
);

------------------------顾客数据------------------------
CREATE TABLE `project`.`customer` (
    CUSTOMER_ID DECIMAL(32,0),                                                --顾客ID
    CUSTOMER_NAME VARCHAR(20),                                           --顾客名称 (index)
    CUSTOMER_GENDER VARCHAR(6),
    CUSTOMER_LOCATION_ID DECIMAL(10,0) NOT NULL,         --顾客地址
    CUSTOMER_PHONE DECIMAL(8,0),                                         --顾客联系方式
    CUSTOMER_EMAIL VARCHAR(20),                                           --顾客邮箱
    CUSTOMER_LEVEL DECIMAL(1,0) NOT NULL,  --顾客等级
    ORDER_LIST_ID DECIMAL(20,0),
    PRIMARY KEY(CUSTOMER_ID),
    FOREIGN KEY(CUSTOMER_LOCATION_ID) REFERENCES `project`.`locations` (LOCATION_ID)
);

------------------------网店商品详情页数据------------------------
CREATE TABLE `project`.`online_store_info` (
    ONLINE_STORE_ID DECIMAL(6,0),                                          --网店ID
    ONLINE_STORE_PLATFORM VARCHAR(30) NOT NULL,        --网店平台（淘宝、京东、抖音等）
    PRIMARY KEY (ONLINE_STORE_ID)
);

CREATE TABLE `project`.`online_store_product` (
    ONLINE_STORE_ID DECIMAL(6,0),                                                                   --网店ID
    PRODUCT_ID decimal(6,0) NOT NULL,                                                            --上架产品ID
    PRODUCT_NAME varchar(25) NOT NULL,                                                       --上架产品名称
    CATEGORY varchar(20) NOT NULL,                                                                 --上架产品类别
    UNIT_SELL_PRICE decimal(10,2) NOT NULL,                                                  --产品单位销售价格
    PRODUCT_PICTURE BLOB NOT NULL,                                                            --产品实物图
    PRODUCT_DESCRIPTION TEXT,                                                                        --商品详情
    PRODUCT_GUARANTEES TEXT,                                                                       --商品保障(退换货, 假一赔N)
    PRODUCT_LASTMONTH_SALES INT,                                                              --产品月销量
    PRODUCT_CUMULATIVE_SALES INT,                                                               --产品总销量
    PRODUCT_INVENTORY INT,                                                                              --产品上架库存
    FEEDBACK TEXT,                                                                                                 --用户评价
    WAREHOUSE_LOCATION_ID DECIMAL(10,0) NOT NULL,                                     --发货仓储地
    FACTORY_LOCATION_ID DECIMAL(10,0) NOT NULL,                                          --产地
    SUPPLIER_ID DECIMAL(6,0) NOT NULL,                                                               --生产厂家ID
    APPLICABLE_OCCASION TEXT NOT NULL,                                                      --产品适用范围
    PRIMARY KEY (ONLINE_STORE_ID, PRODUCT_ID),
    FOREIGN KEY (ONLINE_STORE_ID) REFERENCES `project`.`online_store_info` (ONLINE_STORE_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES `project`.`inventories` (INV_ID),
    FOREIGN KEY (WAREHOUSE_LOCATION_ID) REFERENCES `project`.`locations` (LOCATION_ID),
    FOREIGN KEY (FACTORY_LOCATION_ID) REFERENCES `project`.`suppliers_basic_info` (FACTORY_LOCATION_ID),
    FOREIGN KEY (SUPPLIER_ID) REFERENCES `project`.`suppliers_basic_info` (SUPPLIER_ID)
);

------------------------销售数据------------------------
CREATE TABLE `project`.`order_list` (
    ONLINE_STORE_ID DECIMAL(6,0),                                  --网店ID
    ORDER_ID DECIMAL(20,0),
    ORDER_DATE DATETIME,                                              --订单ID
    CUSTOMER_ID DECIMAL(32,0),                                      --顾客ID
    PRODUCT_ID DECIMAL(20,0),                                         --订单商品ID
    BUY_NUM DECIMAL(10,0),                                               --该商品购买数量
    UNIT_SALE_PRICE DECIMAL(10,0),                                 --该商品单位价格
    TOTAL_SALE_PRICE DECIMAL(15,0),                              --该商品总体价格
    PRIMARY KEY(ORDER_ID, PRODUCT_ID),
    FOREIGN KEY (ORDER_ID) REFERENCES `project`.`order_information` (ORDER_ID),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES `project`.`customer` (CUSTOMER_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES `project`.`online_store_product` (PRODUCT_ID),
    FOREIGN KEY (ONLINE_STORE_ID) REFERENCES `project`.`online_store_info` (ONLINE_STORE_ID)
);

CREATE TABLE `project`.`order_information`(
    ONLINE_STORE_ID DECIMAL(6,0),                   --网店ID
    ORDER_ID DECIMAL(20,0),                               --订单ID
    CUSTOMER_ID DECIMAL(32,0),                        --顾客ID
    TOTAL_VALUE DECIMAL(9,2),                            --订单总价格
    ORDER_DATE DATETIME DEFAULT NULL,         --订单日期 (index)
    PAYWAY INT,                                                       --支付方式（支付宝、微信、银行卡等）
    PRIMARY KEY(ORDER_ID),
    FOREIGN KEY (ONLINE_STORE_ID) REFERENCES `project`.`online_store_info` (ONLINE_STORE_ID),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES `project`.`customer` (CUSTOMER_ID)
);

------------------------在特定时间内访问商店的用户数据以及是否购买商品------------------------
CREATE TABLE `project`.`online_store_visit` (
    ONLINE_STORE_ID DECIMAL(6,0),                       --网店ID
    `DATE` DATETIME,                                                 --日期
    CUSTOMER_ID DECIMAL(32,0),                            --顾客ID
    IF_PURCHASE DECIMAL(1,0) NOT NULL,              --访问期间顾客是否下订单
    ORDER_ID DECIMAL(20,0) DEFAULT NULL,         --订单ID
    PRIMARY KEY (ONLINE_STORE_ID, `DATE`, CUSTOMER_ID),
    FOREIGN KEY (ONLINE_STORE_ID) REFERENCES `project`.`online_store_info` (ONLINE_STORE_ID),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES `project`.`customer` (CUSTOMER_ID),
    FOREIGN KEY (ORDER_ID) REFERENCES `project`.`order_information` (ORDER_ID)
);


----------Create index----------
CREATE INDEX SUPPLIER_NAME_INDEX ON `project`.`suppliers_basic_info` (SUPPLIER_NAME);
CREATE INDEX PURCHASE_TIME_INDEX ON `project`.`purchase` (PURCHASE_TIME);
CREATE INDEX PRODUCT_NAME_INDEX ON `project`.`suppliers_products` (PRODUCT_NAME);
CREATE INDEX CUSTOMER_NAME_INDEX ON `project`.`customer` (CUSTOMER_NAME);
CREATE INDEX ORDER_DATE_INDEX ON `project`.`order_list` (ORDER_DATE);