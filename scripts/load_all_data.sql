
-- ========================================================
--  Bronze Layer Loading Script (Truncate and Reload)
-- --------------------------------------------------------
-- Purpose:
-- This script loads raw CSV data from the source folders
-- into the Bronze Layer of the PostgreSQL data warehouse.
-- It uses a truncate-and-load strategy to ensure clean,
-- fresh data for each run — ideal for batch ETL pipelines.
-- =========================================================


TRUNCATE TABLE bronze.crm_cust_info;
\COPY bronze.crm_cust_info FROM 'C:/Users/fusio/Desktop/Data_warehouse_project/SQL-Data-Warehouse-Project/datasets/source_crm/cust_info.csv' WITH (FORMAT csv, HEADER true);

TRUNCATE TABLE bronze.crm_prd_info;
\COPY bronze.crm_prd_info FROM 'C:/Users/fusio/Desktop/Data_warehouse_project/SQL-Data-Warehouse-Project/datasets/source_crm/prd_info.csv' WITH (FORMAT csv, HEADER true);

TRUNCATE TABLE bronze.crm_sales_details;
\COPY bronze.crm_sales_details FROM 'C:/Users/fusio/Desktop/Data_warehouse_project/SQL-Data-Warehouse-Project/datasets/source_crm/sales_details.csv' WITH (FORMAT csv, HEADER true);

TRUNCATE TABLE bronze.erp_cust_az12;
\COPY bronze.erp_cust_az12 FROM 'C:/Users/fusio/Desktop/Data_warehouse_project/SQL-Data-Warehouse-Project/datasets/source_erp/CUST_AZ12.csv' WITH (FORMAT csv, HEADER true);

TRUNCATE TABLE bronze.erp_loc_a101;
\COPY bronze.erp_loc_a101 FROM 'C:/Users/fusio/Desktop/Data_warehouse_project/SQL-Data-Warehouse-Project/datasets/source_erp/LOC_A101.csv' WITH (FORMAT csv, HEADER true);

TRUNCATE TABLE bronze.erp_px_cat_g1v2;
\COPY bronze.erp_px_cat_g1v2 FROM 'C:/Users/fusio/Desktop/Data_warehouse_project/SQL-Data-Warehouse-Project/datasets/source_erp/PX_CAT_G1V2.csv' WITH (FORMAT csv, HEADER true);

