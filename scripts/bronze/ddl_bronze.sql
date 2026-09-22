-- ==============================================================================
-- DDL Script: Create Bronze Layer Tables
-- Description: This script drops existing tables if they exist and creates 
--              the raw staging (Bronze) tables for CRM and ERP source systems.
-- Author: Data Warehouse Project
-- ==============================================================================

USE DataWarehouse
GO

DROP TABLE IF EXISTS bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE

);
Go

DROP TABLE IF EXISTS bronze.crm_prd_info;
GO
CREATE TABLE bronze.crm_prd_info (
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);
DROP TABLE IF EXISTS bronze.crm_sales_details;
GO
create table bronze.crm_sales_details (
	sls_ord_num nvarchar(50) ,
	sls_prd_key nvarchar(50) ,
	sls_cust_id int ,
	sls_order_dt INT,
	sls_ship_dt INT ,
	sls_due_dt INT,
	sls_sales int,
	sls_quantity int,
	sls_price int
);
iF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),
    bdate  DATE,
    gen    NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50)
);
GO
