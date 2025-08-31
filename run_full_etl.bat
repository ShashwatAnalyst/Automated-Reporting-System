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

:: Step 4: Generate Analysis Report
echo.
echo ════════════════════════════════════════════════════════
echo [4/4] 📊 AUTOMATED REPORT GENERATION
echo ════════════════════════════════════════════════════════

echo 🔧 Initializing report environment...
call conda activate shashwatenv
if %ERRORLEVEL% EQU 0 (
    echo ✅ Python environment 'shashwatenv' activated
) else (
    echo ❌ Failed to activate conda environment
    echo 💡 Ensure 'shashwatenv' environment exists
    pause
    exit /b 1
)

echo 🔍 Locating analysis notebook...
if exist "Automated Reports\Analysis_&_Report.ipynb" (
    echo ✅ Found: Analysis_&_Report.ipynb
    echo.
    echo 🏃‍♂️ Executing notebook cells...
    echo ⏳ This process may take several minutes depending on data volume
    echo ┌─────────────────────────────────────────────────────────┐
    echo │                 JUPYTER EXECUTION LOG                   │
    echo └─────────────────────────────────────────────────────────┘
    
    jupyter nbconvert ^
        --to notebook ^
        --execute ^
        --output "Analysis_Report_Executed.ipynb" ^
        --output-dir "Automated Reports" ^
        "Automated Reports\Analysis_&_Report.ipynb"
    
    echo ┌─────────────────────────────────────────────────────────┐
    echo │                   EXECUTION COMPLETE                    │
    echo └─────────────────────────────────────────────────────────┘
    
    IF !ERRORLEVEL! EQU 0 (
        echo.
        echo ✅ REPORT GENERATION SUCCESSFUL!
        echo 📄 Output: Analysis_Report_Executed.ipynb
        
        :: Display file size for confirmation
        if exist "Automated Reports\Analysis_Report_Executed.ipynb" (
            for %%F in ("Automated Reports\Analysis_Report_Executed.ipynb") do (
                set "filesize=%%~zF"
                set /a filekb=!filesize!/1024
            )
            echo 📏 Report size: !filekb! KB (!filesize! bytes)
        )
    ) else (
        echo.
        echo ⚠️  REPORT GENERATION COMPLETED WITH ISSUES
        echo 📝 The report file may contain error details
        echo 💡 Check Analysis_Report_Executed.ipynb for error messages
        pause
        exit /b 1
    )
) else (
    echo ❌ Notebook file not found!
    echo 📂 Expected: Automated Reports\Analysis_&_Report.ipynb
    echo 💡 Please verify the file exists in the correct location
    pause
    exit /b 1
)

:: Calculate elapsed time
for /f %%b in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set END=%%b
set /a ELAPSED=!END! - !START!
set /a MINUTES=!ELAPSED!/60
set /a SECONDS=!ELAPSED!%%60

echo.
echo ========================================================
echo                 🎉 PIPELINE COMPLETED! 🎉
echo ========================================================
echo.
echo  📊 EXECUTION SUMMARY:
echo  ├─ ✅ BRONZE: Raw data ingested
echo  ├─ ✅ SILVER: Data cleaned ^& validated  
echo  ├─ ✅ GOLD: Business logic applied
echo  └─ ✅ REPORT: Analytics ^& visualizations generated
echo.
echo  📁 FINAL REPORT LOCATION:
echo     Automated Reports\Analysis_Report_Executed.ipynb
echo.
echo  ⏱️  EXECUTION TIME: !MINUTES! minutes !SECONDS! seconds
echo  🕐 COMPLETED: %TIME% on %DATE%
echo ========================================================

echo.
echo 🎯 What's Next?
echo   • Open the generated report to view results
echo   • Review data quality metrics and insights
echo   • Share findings with stakeholders
echo.
echo 📂 Press any key to open the reports folder...
pause >nul
explorer "Automated Reports"

endlocal
