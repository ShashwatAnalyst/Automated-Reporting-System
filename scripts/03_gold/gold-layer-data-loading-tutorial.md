# ⚙️ Gold Layer Data Loading Tutorial

This guide walks you through the setup and use of the automated `.bat` and `.sql` data loading from the Silver Layer to the final Gold Layer views in your PostgreSQL data warehouse.

## 🗂 Prerequisites

- Silver Layer tables must be loaded and cleaned
- Gold schema should be created (contains only views)
- PostgreSQL installed and added to system PATH
- Your database credentials (username, password)

## 🏗️ Gold Layer Architecture

<p align="center">
  <img src="https://github.com/ShashwatAnalyst/SQL-Data-Warehouse-Project/blob/main/docs/gold-layer-diagram.png?raw=true" alt="Gold Layer Structure" width="650"/>
</p>

> The Gold Layer consolidates and joins Silver tables into dimensional views (facts and dimensions), ideal for BI and reporting tools.

## 📝 Files Involved

<div align="center">

| File                | Purpose                                                                       |
|---------------------|-------------------------------------------------------------------------------|
| `load_to_gold.sql`  | Creates `gold` views (dim_customer, dim_products, fact_sales) from Silver Layer |
| `load_to_gold.bat`  | Executes the SQL script using `psql` CLI                                       |
| Silver Tables        | Serve as the cleaned and transformed source layer for Gold Views             |

</div>

## 🚀 How to Use

1. Open the `load_to_gold.bat` file and update:
   - `PGUSER`, `PGPASSWORD`, `PGDB`
   - Ensure the paths for `psql.exe` and `load_to_gold.sql` are correct

2. Double-click the `load_to_gold.bat` file

3. Wait for the terminal to show:
```bat
======================================================
 Starting Data Load into Gold Layer...
======================================================
DROP VIEW
CREATE VIEW
...
======================================================
 Load completed successfully.
 Total time taken: 2 seconds.
======================================================
Press any key to continue . . .
```

✅ **You now have analytical views ready for BI dashboards, aggregations, or data storytelling.**

## 💡 Notes

- This layer contains **read-only views** — ideal for star schemas, visualization layers, and business metrics.
- Views are dropped and recreated each time to reflect the latest Silver Layer state.
- You can now connect **Power BI**, **Tableau**, or **Python scripts** directly to Gold views for analysis.

---

✅ **That's it!** You’ve just completed an automated end-to-end data modeling flow from **Bronze → Silver → Gold**.
