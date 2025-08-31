@echo off
setlocal EnableDelayedExpansion

:: ========================================================
::  Full ETL Pipeline Runner - Bronze → Silver → Gold → Report
:: ========================================================

:: Capture start time
for /f %%a in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set START=%%a

echo ========================================================
echo  Starting Full ETL Process...
echo ========================================================

:: Step 1: Load Bronze Layer
echo.
echo [1/4] Loading Bronze Layer...
call "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project\scripts\01_bronze\load_to_bronze.bat"
IF %ERRORLEVEL% NEQ 0 (
    echo Bronze Layer loading failed. Aborting.
    pause
    exit /b 1
)

:: Step 2: Load Silver Layer
echo.
echo [2/4] Loading Silver Layer...
call "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project\scripts\02_silver\load_to_silver.bat"
IF %ERRORLEVEL% NEQ 0 (
    echo Silver Layer loading failed. Aborting.
    pause
    exit /b 1
)

:: Step 3: Load Gold Layer
echo.
echo [3/4] Loading Gold Layer...
call "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project\scripts\03_gold\load_to_gold.bat"
IF %ERRORLEVEL% NEQ 0 (
    echo Gold Layer loading failed. Aborting.
    pause
    exit /b 1
)

:: Step 4: Run the Completed Report Notebook
echo.
echo [4/4] Running Analysis & Report Notebook...
call jupyter nbconvert --to notebook --execute "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project\Automated Reports\Analysis_&_Report.ipynb" --output "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project\Automated Reports\Analysis_&_Report_Executed.ipynb"
IF %ERRORLEVEL% NEQ 0 (
    echo Report Notebook execution failed. Aborting.
    pause
    exit /b 1
)

:: Capture end time
for /f %%b in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set END=%%b

set /a ELAPSED=!END! - !START!
echo.
echo ========================================================
echo  Full ETL Process Completed Successfully!
echo  Total Time Taken: !ELAPSED! seconds
echo ========================================================
pause
endlocal
