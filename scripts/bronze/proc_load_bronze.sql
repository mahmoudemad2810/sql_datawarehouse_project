-- ==============================================================================
-- Stored Procedure: Load Bronze Layer (ETL Process)
-- Description: Truncates existing tables and bulk-loads raw CSV data from 
--              CRM and ERP source systems into the Bronze layer. 
--              Includes error handling and load execution time logging.
-- ==============================================================================

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		print  'loadind bronze layer'
		SET @start_time = GETDATE();
		print'-----------------------------------------------------------------'
		print'truncating table:bronze.crm_cust_info'

		TRUNCATE TABLE bronze.crm_cust_info;

		print'-----------------------------------------------------------------'
		print'insert data into:bronze.crm_cust_info'

		BULK INSERT bronze.crm_cust_info
		FROM 'E:\mahmoud\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		print'-----------------------------------------------------------------'
		print'truncating table:bronze.crm_prd_info'

		TRUNCATE TABLE  bronze.crm_prd_info;
		print'-----------------------------------------------------------------'
		print'insert data into:bronze.crm_prd_info'

		BULK INSERT bronze.crm_prd_info
		FROM 'E:\mahmoud\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		print'-----------------------------------------------------------------'
		print'truncating table:bronze.crm_sales_details'

		TRUNCATE TABLE  bronze.crm_sales_details;
		print'-----------------------------------------------------------------'
		print'insert data into:bronze.crm_sales_details'

		BULK INSERT bronze.crm_sales_details
		FROM 'E:\mahmoud\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		print'-----------------------------------------------------------------'
		print'truncating table:bronze.erp_cust_az12'

		TRUNCATE TABLE  bronze.erp_cust_az12;

		print'-----------------------------------------------------------------'
		print'insert data into:bronze.erp_cust_az12'

		BULK INSERT bronze.erp_cust_az12
		FROM 'E:\mahmoud\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		print'-----------------------------------------------------------------'
		print'truncating table:bronze.erp_loc_a101'

		TRUNCATE TABLE  bronze.erp_loc_a101;

		print'-----------------------------------------------------------------'
		print'insert data into:bronze.erp_loc_a101'

		BULK INSERT bronze.erp_loc_a101
		FROM 'E:\mahmoud\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @start_time = GETDATE();
		print'-----------------------------------------------------------------'
		print'truncating table:bronze.erp_px_cat_g1v2'

		TRUNCATE TABLE  bronze.erp_px_cat_g1v2;

		print'-----------------------------------------------------------------'
		print'insert data into:bronze.erp_px_cat_g1v2'

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'E:\mahmoud\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',' ,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
	END TRY

	BEGIN CATCH
			PRINT'ERROR_MASSEGE ' + ERROR_MESSAGE();
			PRINT'ERROR_MASSEGE ' + CAST(ERROR_NUMBER() AS NVARCHAR);
			PRINT'ERROR_MASSEGE ' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END
