# ⚙️ Data Loading Tutorial

This guide walks you through the setup and use of the automated `.bat` and `.sql` data loading system for your PostgreSQL data warehouse.

## 🗂 Prerequisites

- PostgreSQL installed and added to PATH
- Tables created under the `bronze` schema
- CSV source files stored in the `datasets/` folder
- Your database credentials (username, password)

## 📝 Files Involved

| File | Purpose |
|------|---------|
| `load_all_data.sql` | Contains `TRUNCATE` and `\COPY` commands for all target tables |
| `load_all_data.bat` | Runs the SQL file using `psql` CLI with proper environment setup |
| `.csv` files | Source data to be loaded into staging tables |

## 🚀 How to Use

1. Open the `.bat` file and update:
   - `PGUSER`, `PGPASSWORD`, `PGDB`
   - Ensure the PostgreSQL `bin` path is correct
2. Double-click the `load_all_data.bat` file
3. Wait for the terminal to show:
```bat
  COPY 18494
  COPY 397
  ...
  Load completed.
  Press any key to continue . . .
```
5. Your data is now ready for querying or BI tools.

## 💡 Notes

- This is a full **truncate-and-load** strategy — great for fresh daily/weekly loads in local setups.
- Use this as a clean starting point for BI dashboards, data exploration, or analytics projects.

---

✅ That's it! You now have a repeatable, automated way to load data for your BI pipeline.

