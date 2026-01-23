@echo off
setlocal EnableDelayedExpansion

:: Set working directory
cd /d "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project"

:: Capture start time
for /f %%a in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set START=%%a

echo.
echo ========================================================
echo  🚀 DATA WAREHOUSE ETL PIPELINE STARTED
echo  📅 %DATE% at %TIME%
echo ========================================================

:: Step 1: Load Bronze Layer
echo.
echo ════════════════════════════════════════════════════════
echo [1/4] 🥉 BRONZE LAYER - Raw Data Ingestion
echo ════════════════════════════════════════════════════════
echo 📥 Loading raw data from source systems...
call "scripts\01_bronze\load_to_bronze.bat"
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ BRONZE LAYER FAILED
    echo 🚨 Raw data ingestion encountered errors
    echo 💡 Check source connections and data availability
    pause
    exit /b 1
)
echo ✅ Bronze layer completed successfully
echo 📊 Raw data ingested and staged

:: Step 2: Load Silver Layer  
echo.
echo ════════════════════════════════════════════════════════
echo [2/4] 🥈 SILVER LAYER - Data Cleaning & Standardization
echo ════════════════════════════════════════════════════════
echo 🧹 Cleaning and validating data...
call "scripts\02_silver\load_to_silver.bat"
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ SILVER LAYER FAILED
    echo 🚨 Data cleaning and validation encountered errors
    echo 💡 Check data quality rules and transformation logic
    pause
    exit /b 1
)
echo ✅ Silver layer completed successfully
echo 🔧 Data cleaned, validated, and standardized

:: Step 3: Load Gold Layer
echo.
echo ════════════════════════════════════════════════════════
echo [3/4] 🥇 GOLD LAYER - Business Logic & Analytics Ready
echo ════════════════════════════════════════════════════════
echo 💼 Applying business rules and creating analytics tables...
call "scripts\03_gold\load_to_gold.bat"
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ GOLD LAYER FAILED
    echo 🚨 Business logic application encountered errors
    echo 💡 Check business rules and aggregation logic
    pause
    exit /b 1
)
echo ✅ Gold layer completed successfully
echo 📈 Analytics-ready data prepared

