@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ============================================================
REM  Full ETL Orchestrator (Bronze -> Silver -> Gold)
REM ============================================================

REM Set working directory
cd /d "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project" || (
    echo ========================================================
    echo  ERROR: Failed to set working directory
    echo ========================================================
    pause
    exit /b 1
)

REM Capture start time (Unix epoch seconds)
for /f %%a in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]''1970-01-01'').TotalSeconds"') do set START=%%a


echo ========================================================
echo  Starting Full ETL Process...
echo ========================================================
echo.

REM ------------------------------
REM [1/3] Bronze Layer
REM ------------------------------
echo [1/3]  Loading Bronze Layer...
call "scripts\01_bronze\load_to_bronze.bat"
if errorlevel 1 (
    echo.
    echo Bronze Layer FAILED.
    echo ========================================================
    echo  ETL Process Terminated With Errors
    echo ========================================================
    pause
    exit /b 1
)
echo.
echo Load completed successfully.
echo.

REM ------------------------------
REM [2/3] Silver Layer
REM ------------------------------
echo [2/3] Loading Silver Layer...
call "scripts\02_silver\load_to_silver.bat"
if errorlevel 1 (
    echo.
    echo Silver Layer FAILED.
    echo ========================================================
    echo  ETL Process Terminated With Errors
    echo ========================================================
    pause
    exit /b 1
)
echo.
echo Silver Layer Transformation Completed Successfully.
echo.

REM ------------------------------
REM [3/3] Gold Layer
REM ------------------------------
echo [3/3] Loading Gold Layer...
call "scripts\03_gold\load_to_gold.bat"
if errorlevel 1 (
    echo.
    echo Gold Layer FAILED.
    echo ========================================================
    echo  ETL Process Terminated With Errors
    echo ========================================================
    pause
    exit /b 1
)
echo.
echo Gold Layer views created successfully.
echo.

REM Capture end time (epoch seconds)
for /f %%a in ('powershell -NoProfile -Command "(Get-Date).ToUniversalTime().Subtract([datetime]''1970-01-01'').TotalSeconds -as [int]"') do set END=%%a

set /a DURATION=END-START

echo ========================================================
echo  Full ETL Process Completed Successfully
echo  Total Time Taken: %DURATION% seconds
echo ========================================================

pause
exit /b 0



