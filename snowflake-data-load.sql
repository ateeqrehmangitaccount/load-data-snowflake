--use addountadmin role to create database level object
--this is default role in snowflake
USE ROLE accountadmin;


--use warehouse 
--warehouse is compute resource in snowflake
USE WAREHOUSE compute_wh;


--create database
CREATE OR REPLACE DATABASE tasty_bytes_sample_data;

--create schema
CREATE OR REPLACE SCHEMA tasty_bytes_sample_data.raw_pos;

--create table in database
CREATE OR REPLACE TABLE tasty_bytes_sample_data.raw_pos.menu
(
    menu_id NUMBER(19,0),
    menu_type_id NUMBER(38,0),
    menu_type VARCHAR(16777216),
    truck_brand_name VARCHAR(16777216),
    menu_item_id NUMBER(38,0),
    menu_item_name VARCHAR(16777216),
    item_category VARCHAR(16777216),
    item_subcategory VARCHAR(16777216),
    cost_of_goods_usd NUMBER(38,4),
    sale_price_usd NUMBER(38,4),
    menu_item_health_metrics_obj VARIANT
);



--check table is created
SELECT * FROM tasty_bytes_sample_data.raw_pos.menu;


--create stage 
--stage is a location where datafile is stored
CREATE OR REPLACE STAGE tasty_bytes_sample_data.public.blob_stage
url = 's3://sfquickstarts/tastybytes/'
file_format = (type = csv);

--query stage to find files
LIST @tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/;


--copy file into the Menu table
COPY INTO tasty_bytes_sample_data.raw_pos.menu
FROM @tasty_bytes_sample_data.public.blob_stage/raw_pos/menu/;

--check data in table
SELECT COUNT(*) AS row_count FROM tasty_bytes_sample_data.raw_pos.menu;


--query data with select statement
SELECT menu_item_name
FROM tasty_bytes_sample_data.raw_pos.menu
WHERE truck_brand_name = 'Freezing Point';

--data has been loaded successfully 


