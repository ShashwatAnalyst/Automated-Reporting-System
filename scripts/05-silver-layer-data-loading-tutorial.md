# ⚙️ Silver Layer Data Loading Tutorial

This guide walks you through the setup and use of the automated `.bat` and `.sql` data loading from the Bronze Layer to the cleaned and transformed Silver Layer in your PostgreSQL data warehouse.

## 🗂 Prerequisites

- Bronze Layer tables are already loaded with raw data
- Silver Layer tables are created under the `silver` schema
- PostgreSQL installed and added to system PATH
- Your database credentials (username, password)

## 📊 Silver Layer Architecture

<p align="center">
  <img src="https://github.com/ShashwatAnalyst/SQL-Data-Warehouse-Project/blob/main/docs/silver-layer-diagram.png?raw=true" alt="Silver Layer Structure" width="650"/>
</p>

> This diagram shows how data flows from Bronze Layer into transformed, deduplicated, and clean Silver Layer tables — ready for analytics.

## 📝 Files Involved

<div align="center">

| File               | Purpose                                                                |
|--------------------|------------------------------------------------------------------------|
| `load_to_silver.sql` | Cleans and transforms data from Bronze to Silver using `TRUNCATE + INSERT` |
| `load_to_silver.bat`    | Runs the SQL file using the `psql` CLI                                |
| Bronze tables        | Source data already loaded using Bronze automation                   |

</div>

## 🚀 How to Use

1. Open the `load_silver.bat` file and update:
   - `PGUSER`, `PGPASSWORD`, `PGDB`
   - Make sure PostgreSQL `bin` path and SQL script path are correct

2. Double-click the `load_silver.bat` file

3. Wait for the terminal to show:
```bat
======================================================
 Starting Data Load into Silver Layer...
======================================================
TRUNCATE TABLE
INSERT 0 18494
...
======================================================
 Load completed successfully.
 Total time taken: 3 seconds.
======================================================
Press any key to continue . . .
```

4. ✅ Data is now ready for advanced modeling or Gold Layer generation!

## 💡 Notes

- This layer is ideal for semantic consistency, validation, and quality control.

- Use Silver Layer tables in Power BI/Tableau dashboards, ad hoc SQL analysis, or as inputs to Gold aggregations.

---
✅ That's it! You've now automated the transformation from raw Bronze Layer to clean Silver Layer.
