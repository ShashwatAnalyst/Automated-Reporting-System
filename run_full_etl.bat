@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM  Data Warehouse ETL Orchestrator
REM  Runs Bronze -> Silver -> Gold load processes in sequence
REM ============================================================

REM Set working directory
cd /d "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project" || (
    echo [ERROR] Failed to change working directory.
    exit /b 1
)

REM Capture start time (Unix epoch seconds)
for /f %%a in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]''1970-01-01'').TotalSeconds"') do set START=%%a

echo.
echo ============================================================
echo  DATA WAREHOUSE ETL PIPELINE - START
echo  Date: %DATE%   Time: %TIME%
echo ============================================================

REM ------------------------------
REM STEP 1: Bronze Layer
REM ------------------------------
call :RunStep 1 "BRONZE LAYER" "Raw Data Ingestion" "scripts\01_bronze\load_to_bronze.bat" || exit /b 1

REM ------------------------------
REM STEP 2: Silver Layer
REM ------------------------------
call :RunStep 2 "SILVER LAYER" "Data Cleaning & Standardization" "scripts\02_silver\load_to_silver.bat" || exit /b 1

REM ------------------------------
REM STEP 3: Gold Layer
REM ------------------------------
call :RunStep 3 "GOLD LAYER" "Business Logic & Analytics Ready" "scripts\03_gold\load_to_gold.bat" || exit /b 1


REM Capture end time
for /f %%a in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]''1970-01-01'').TotalSeconds"') do set END=%%a
set /a DURATION=END-START

echo.
echo ============================================================
echo  DATA WAREHOUSE ETL PIPELINE - SUCCESS
echo  Completed: %DATE%   %TIME%
echo  Total Duration: %DURATION% seconds
echo ============================================================
echo.

exit /b 0


REM ============================================================
REM Subroutine: RunStep
REM Arguments:
REM   %1 = Step Number
REM   %2 = Layer Name
REM   %3 = Description
REM   %4 = Script Path
REM ============================================================
:RunStep
set "STEP=%~1"
set "LAYER=%~2"
set "DESC=%~3"
set "SCRIPT=%~4"

echo.
echo ------------------------------------------------------------
echo  [%STEP%/3] %LAYER% - %DESC%
echo ------------------------------------------------------------
echo  Running: %SCRIPT%
echo.

call "%SCRIPT%"

if errorlevel 1 (
    echo.
    echo [ERROR] %LAYER% failed.
    echo [INFO ] Review logs/output for details.
    echo.
    pause
    exit /b 1
)

echo [OK] %LAYER% completed successfully.
exit /b 0

