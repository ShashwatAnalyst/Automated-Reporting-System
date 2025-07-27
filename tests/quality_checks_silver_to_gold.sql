-- ========================================================
--  Gold Layer Quality Checks: Data Integrity & Integration
-- --------------------------------------------------------
-- Purpose:
-- This script performs validation checks on the Gold Layer
-- to ensure correct joins, no duplicates, and consistent 
-- dimension relationships for customer, product, and sales.
-- ========================================================

-- ========================================================
-- Quality Check: Customer Dimension Integration
-- ========================================================

-- Check for Duplicate Customer IDs after join
-- Expectation: No results (each customer should be unique)
SELECT cst_id, COUNT(*) 
FROM (
    SELECT 
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
        ci.cst_lastname,
        ci.cst_marital_status,
        ci.cst_gndr,
        ci.cst_create_date,
        ca.bdate,
        ca.gen,
        la.cntry
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid
) t
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Gender Inconsistency Check between CRM and ERP sources
-- Insight: We will use `cst_gndr` from CRM as the master source.
SELECT DISTINCT
    ci.cst_gndr AS crm_gender,
    ca.gen AS erp_gender
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.cid
ORDER BY 1, 2;

-- ========================================================
--  Quality Check: Product Dimension Integration
-- ========================================================

-- Check for Duplicate Product Keys
-- Expectation: No duplicates after join and filtering
SELECT prd_key, COUNT(*) 
FROM (
    SELECT 
        pn.prd_id,
        pn.cat_id,
        pn.prd_key,
        pn.prd_nm,
        pn.prd_cost,
        pn.prd_line,
        pn.prd_start_dt,
        pn.prd_end_dt,
        pc.cat,
        pc.subcat,
        pc.maintenance
    FROM silver.crm_prd_info pn
    LEFT JOIN silver.erp_px_cat_g1v2 pc ON pn.cat_id = pc.id
    WHERE prd_end_dt IS NULL
) t
GROUP BY prd_key
HAVING COUNT(*) > 1;

-- ========================================================
-- Quality Check: fact_sales Integrity
-- ========================================================

-- Ensure all fact records map to valid dimension keys
-- Expectation: No NULL foreign keys in fact table
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customer c ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;

-- ========================================================
-- All checks complete.
-- If all queries return expected results (or no rows), your 
-- Gold Layer views are clean and ready for analytics!
-- ========================================================
