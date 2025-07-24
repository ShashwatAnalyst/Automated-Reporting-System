# ⚙️ Bronze Layer Data Loading Tutorial

This guide walks you through the setup and use of the automated `.bat` and `.sql` data loading to the bronze layer for your PostgreSQL data warehouse.

## 🗂 Prerequisites

- PostgreSQL installed and added to PATH
- Tables created under the `bronze` schema
- CSV source files stored in the `datasets/` folder
- Your database credentials (username, password)


## 📊 Bronze Layer Architecture

<p align="center">
  <img src="https://github.com/ShashwatAnalyst/SQL-Data-Warehouse-Project/blob/main/docs/bronze-layer-diagram.png.png?raw=true" alt="Bronze Layer Structure" width="500"/>
</p>


> This diagram shows how raw source data (CRM and ERP CSVs) are mapped directly into PostgreSQL tables inside the `bronze` schema using automation.


## 📝 Files Involved

<div align = "center">
  
| File | Purpose |
|------|---------|
| `load_all_data.sql` | Contains `TRUNCATE` and `\COPY` commands for all target tables |
| `load_all_data.bat` | Runs the SQL file using `psql` CLI with proper environment setup |
| `.csv` files | Source data to be loaded into staging tables |

</div>

## 🚀 How to Use

1. Open the `.bat` file and update:
   - `PGUSER`, `PGPASSWORD`, `PGDB`
   - Ensure the PostgreSQL `bin` file & `load_all_data.sql` file path are correct
2. Double-click the `load_all_data.bat` file
3. Wait for the terminal to show:
```bat
=====================================================
 Starting Data Load into Bronze Layer...
=====================================================
TRUNCATE TABLE
COPY 18494
TRUNCATE TABLE
COPY 397
  ...
======================================================
 Load completed successfully.
 Total time taken: 4 seconds.
======================================================
Press any key to continue . . .
```
5. Your data is now loaded to the bronze layer.

## 💡 Notes

- This is a full **truncate-and-load** strategy — great for fresh daily/weekly loads in local setups.
- Use this as a clean starting point for BI dashboards, data exploration, or analytics projects.

---

✅ That's it! You now have a repeatable, automated way to load raw data to the database.

