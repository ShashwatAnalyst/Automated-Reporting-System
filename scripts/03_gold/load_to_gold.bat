:: ========================================================
::  Gold Layer Automation Script (Batch Executable)
:: --------------------------------------------------------
:: Purpose:
:: This script executes the SQL file that creates gold layer
:: reporting views in your PostgreSQL data warehouse.
:: Views are built from the cleaned silver layer and are 
:: optimized for reporting and BI consumption.
:: ========================================================

@echo off
setlocal EnableDelayedExpansion

:: Set PostgreSQL credentials
set PGUSER=postgres
set PGPASSWORD=password
set PGDB=datawarehouse

:: Set path to psql.exe
cd /d "C:\Program Files\PostgreSQL\17\bin"

:: Capture start time
for /f %%a in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set START=%%a

echo =======================================================
echo  Starting Gold Layer View Creation...
echo =======================================================

:: Execute SQL to create views
psql -U %PGUSER% -d %PGDB% -f "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project\scripts\03_gold\load_to_gold.sql"

IF %ERRORLEVEL% NEQ 0 (
    echo  Error: Failed to create Gold Layer views. Please check your SQL script.
    pause
    exit /b 1
) ELSE (
    for /f %%b in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set END=%%b
    set /a ELAPSED=!END! - !START!

    echo =======================================================
    echo  Gold Layer views created successfully.
    echo  Total time taken: !ELAPSED! seconds.
    echo =======================================================
)

pause
endlocal
