# 🥈 Silver Layer Loading Tutorial

This guide explains how to clean and transform Bronze Layer data into a structured **Silver Layer** using a `.sql` + `.bat` automation combo. This layer improves quality, consistency, and readiness for analytical use.


## 🖼 Architecture Snapshot

![Silver Layer Structure](https://github.com/ShashwatAnalyst/SQL-Data-Warehouse-Project/blob/main/docs/silver-layer-diagram.png?raw=true)

> 📌 This image illustrates how raw CRM/ERP sources move into the Bronze Layer and then transform into clean, ready-for-analytics Silver Layer tables.



## 🗂 Files Involved

| File               | Purpose                                                                 |
|--------------------|-------------------------------------------------------------------------|
| `load_to_silver.sql` | Cleans and inserts data from Bronze to Silver tables using `TRUNCATE + INSERT` |
| `load_silver.bat`    | Executes the SQL file using the `psql` CLI                            |
| Bronze tables        | Source data (already loaded via Bronze ETL)                          |


## ⚙️ How It Works

Each Silver table is:
- **Truncated** before insert (ensures a clean slate)
- **Transformed** using SQL expressions:
  - Fix nulls and formats
  - Normalize gender, country, marital status
  - Derive surrogate keys, fix prices/dates, etc.
- Populated only with clean, latest, and deduplicated data


## 🚀 How to Run

1. Make sure:
   - Bronze Layer has already been populated
   - PostgreSQL is installed and added to your system PATH
   - Tables for the Silver Layer already exist in the schema

2. Update and run the `.bat` file:
   ```bat
   load_silver.bat
   ```
3.Wait for terminal to show:

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
```

4. ✅ Data is now ready for advanced modeling or Gold Layer generation!


💡 Notes
This layer is ideal for semantic consistency, validation, and quality control.

Use Silver Layer tables in Power BI/Tableau dashboards, ad hoc SQL analysis, or as inputs to Gold aggregations.
