-- ================================================================
--  Bronze Layer: Data Quality and Cleaning Checks
-- ----------------------------------------------------------------
--  Purpose:
--  This script identifies potential data quality issues in the
--  Bronze Layer tables. It helps validate assumptions, check
--  for inconsistencies, and guide the necessary transformations
--  before loading into the Silver Layer.
-- ================================================================


-- ================================================================
-- CHECKS: bronze.crm_cust_info
-- ================================================================

-- 1. Check for duplicate primary keys (cst_id)
SELECT cst_id, COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Reason: Old records may cause duplication.
-- Solution: Retain only the latest record using cst_create_date.


-- 2. Check for unwanted spaces
SELECT COUNT(*) 
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT COUNT(*) 
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Solution: Use TRIM() for cleaning names.

SELECT COUNT(*) 
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Observation: Gender column seems clean.


-- 3. Check for non-standard gender/marital status values
SELECT DISTINCT cst_gndr 
FROM bronze.crm_cust_info;

-- Solution: Standardize using CASE WHEN → 'Male', 'Female', 'Unknown'

SELECT DISTINCT cst_marital_status 
FROM bronze.crm_cust_info;

-- Solution: Convert 'M' → 'Married', 'S' → 'Single', NULL → 'Unknown'



-- ================================================================
-- CHECKS: bronze.crm_prd_info
-- ================================================================

-- 1. Duplicate key check
SELECT prd_id, COUNT(*) 
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;

-- Observation: No duplication found.


-- 2. Integration check with erp_px_cat_g1v2
SELECT prd_key 
FROM bronze.crm_prd_info
WHERE prd_key IN (SELECT id FROM bronze.erp_px_cat_g1v2);

-- Observation: Format mismatch — consider transforming prd_key via SUBSTRING/REPLACE.


-- 3. Unwanted spaces in product name
SELECT prd_nm 
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- 4. Null or negative values in cost
SELECT prd_cost 
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;


-- 5. Check for inconsistent product line codes
SELECT DISTINCT prd_line 
FROM bronze.crm_prd_info;

-- Solution: Use CASE WHEN to replace short codes with full category names.



-- ================================================================
-- CHECKS: bronze.crm_sales_details
-- ================================================================

-- 1. Unwanted spaces in order number
SELECT sls_ord_num 
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);


-- 2. Integration check with cleaned dimension tables
SELECT sls_prd_key 
FROM bronze.crm_sales_details
WHERE sls_prd_key IN (SELECT prd_key FROM silver.crm_prd_info);

SELECT sls_cust_id 
FROM bronze.crm_sales_details
WHERE sls_cust_id IN (SELECT cst_id FROM silver.crm_cust_info);


-- 3. Invalid dates (zeroes or incorrect format)
SELECT sls_order_dt 
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LENGTH(sls_order_dt::text) <> 8;

SELECT sls_ship_dt 
FROM bronze.crm_sales_details
WHERE LENGTH(sls_ship_dt::text) <> 8;

SELECT sls_due_dt 
FROM bronze.crm_sales_details
WHERE LENGTH(sls_due_dt::text) <> 8;


-- 4. Chronological validation
SELECT * 
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_ship_dt > sls_due_dt;


-- 5. Sales consistency check: sales = quantity × price
SELECT DISTINCT sls_sales, sls_quantity, sls_price 
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL 
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
   OR sls_sales != sls_quantity * sls_price;

-- Solution: Use CASE WHEN to recalculate missing or invalid sales.



-- ================================================================
-- CHECKS: bronze.erp_cust_az12
-- ================================================================

-- 1. Key alignment with crm_cust_info
SELECT * 
FROM bronze.erp_cust_az12
WHERE cid IN (
    SELECT cst_key 
    FROM bronze.crm_cust_info 
    WHERE cst_key LIKE 'NAS%'
);

-- Solution: Apply SUBSTRING to remove 'NAS' from cid.


-- 2. Check for future or invalid birthdates
SELECT DISTINCT bdate 
FROM bronze.erp_cust_az12
WHERE bdate > CURRENT_DATE OR bdate < '1925-01-01';

-- Solution: Use CASE WHEN to nullify invalid entries.


-- 3. Non-standard gender values
SELECT DISTINCT gen 
FROM bronze.erp_cust_az12;

-- Solution: Standardize values to 'Male', 'Female', 'Unknown'



-- ================================================================
-- CHECKS: bronze.erp_loc_a101
-- ================================================================

-- 1. Integration check with customer info
SELECT cid, cntry 
FROM bronze.erp_loc_a101
WHERE cid IN (SELECT cst_key FROM bronze.crm_cust_info);

-- Observation: Format inconsistency due to hyphens
-- Solution: REPLACE(cid, '-', '')


-- 2. Non-standard country values
SELECT DISTINCT cntry 
FROM bronze.erp_loc_a101;

-- Solution: Use CASE WHEN to convert 'DE' → 'Germany', 'US' → 'United States', etc.



-- ================================================================
-- CHECKS: bronze.erp_px_cat_g1v2
-- ================================================================

-- 1. Trim unnecessary spaces
SELECT * 
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);


-- 2. Value exploration
SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2;
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2;
SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2;

-- Observation: Values appear consistent — no changes required.

