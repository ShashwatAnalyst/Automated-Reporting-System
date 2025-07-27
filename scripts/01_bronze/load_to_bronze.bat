@echo off
setlocal EnableDelayedExpansion

:: ========================================================
::  Bronze Layer Automation Script (Batch Executable)
:: --------------------------------------------------------
:: Purpose:
:: This script triggers the SQL data loading process using
:: psql CLI. It loads CSVs into the Bronze Layer of the
:: PostgreSQL data warehouse using a truncate-and-load 
:: strategy. Ideal for repeatable batch ETL in local setups.
:: ========================================================

:: Set PostgreSQL credentials
set PGUSER=postgres
set PGPASSWORD=password
set PGDB=datawarehouse

:: Set path to psql.exe
cd /d "C:\Program Files\PostgreSQL\17\bin"

:: Capture start time in seconds
for /f %%a in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set START=%%a

echo =====================================================
echo  Starting Data Load into Bronze Layer...
echo =====================================================

:: Execute SQL script
psql -U %PGUSER% -d %PGDB% -f "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project\scripts\01_bronze\load_to_bronze.sql"

IF %ERRORLEVEL% NEQ 0 (
    echo  Error: Failed to load bronze layer data. Please check your .sql script or CSV paths.
    pause
    exit /b 1
) ELSE (
    :: Capture end time
    for /f %%b in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set END=%%b

    :: Calculate duration
    set /a ELAPSED=!END! - !START!
echo ======================================================
echo  Load completed successfully.
echo  Total time taken: !ELAPSED! seconds.
echo ======================================================
)

exit /b 0

