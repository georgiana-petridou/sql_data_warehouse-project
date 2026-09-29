/*
=======================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=======================================================================
Script Puprose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Uses the 'BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
=======================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE @start_time AS DATETIME, @end_time AS DATETIME, @batch_start_time AS DATETIME, @batch_end_time AS DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '=============================================';
        PRINT 'Loading bronze layer...';
        PRINT '=============================================';
        PRINT '---------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '---------------------------------------------';
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>> Inserting Data Into Table: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info FROM '/var/opt/mssql/data/source_crm/cust_info.csv'
            WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Load Duretion: ' + CAST (DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>> ------------ ';
        PRINT '';
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>> Inserting Data Into Table: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info FROM '/var/opt/mssql/data/source_crm/prd_info.csv'
            WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Load Duretion: ' + CAST (DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>> ------------ ';
        PRINT '';
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT '>> Inserting Data Into Table: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details FROM '/var/opt/mssql/data/source_crm/sales_details.csv'
            WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Load Duretion: ' + CAST (DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>> ------------ ';
        PRINT '';
        PRINT '---------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '---------------------------------------------';
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_LOC_A101';
        TRUNCATE TABLE bronze.erp_LOC_A101;
        PRINT '>> Inserting Data Into Table: bronze.erp_LOC_A101';
        BULK INSERT bronze.erp_LOC_A101 FROM '/var/opt/mssql/data/source_erp/LOC_A101.csv'
            WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Load Duretion: ' + CAST (DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>> ------------ ';
        PRINT '';
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_CUST_AZ12';
        TRUNCATE TABLE bronze.erp_CUST_AZ12;
        PRINT '>> Inserting Data Into Table: bronze.erp_CUST_AZ12';
        BULK INSERT bronze.erp_CUST_AZ12 FROM '/var/opt/mssql/data/source_erp/CUST_AZ12.csv'
            WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Load Duretion: ' + CAST (DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>> ------------ ';
        PRINT '';
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_PX_CAT_G1V2';
        TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
        PRINT '>> Inserting Data Into Table: bronze.erp_PX_CAT_G1V2';
        BULK INSERT bronze.erp_PX_CAT_G1V2 FROM '/var/opt/mssql/data/source_erp/PX_CAT_G1V2.csv'
            WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK);
        SET @end_time = GETDATE();
        PRINT '>> Load Duretion: ' + CAST (DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>> ------------ ';
        SET @batch_end_time = GETDATE();
        PRINT '=============================================';
        PRINT 'Bronze layer load completed successfully!';
        PRINT 'Total Load Duration: ' + CAST (DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS VARCHAR) + ' seconds';
        PRINT '=============================================';
    END TRY
    BEGIN CATCH
        PRINT '=============================================';
        PRINT 'Error occurred while loading bronze layer:';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST (ERROR_NUMBER() AS VARCHAR (10));
        PRINT 'Error State: ' + CAST (ERROR_STATE() AS VARCHAR (10));
        PRINT '=============================================';
    END CATCH
END
