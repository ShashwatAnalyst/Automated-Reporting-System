@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Initialize durations
set BRONZE_TIME=0
set SILVER_TIME=0
set GOLD_TIME=0

echo ========================================================
echo  Starting Full ETL Process...
echo ========================================================
echo.

REM ------------------------------
REM [1/3] Bronze Layer
REM ------------------------------
echo [1/3]  Loading Bronze Layer...

for /f %%a in ('powershell -NoProfile -Command "(Get-Date).ToUniversalTime().Ticks"') do set B_START=%%a
call "scripts\01_bronze\load_to_bronze.bat"
for /f %%a in ('powershell -NoProfile -Command "(Get-Date).ToUniversalTime().Ticks"') do set B_END=%%a

if errorlevel 1 (
    echo.
    echo Bronze Layer FAILED.
    pause
    exit /b 1
)

set /a BRONZE_TIME=(B_END-B_START)/10000000
echo.
echo Load completed successfully.
echo.

REM ------------------------------
REM [2/3] Silver Layer
REM ------------------------------
echo [2/3] Loading Silver Layer...

for /f %%a in ('powershell -NoProfile -Command "(Get-Date).ToUniversalTime().Ticks"') do set S_START=%%a
call "scripts\02_silver\load_to_silver.bat"
for /f %%a in ('powershell -NoProfile -Command "(Get-Date).ToUniversalTime().Ticks"') do set S_END=%%a

if errorlevel 1 (
    echo.
    echo Silver Layer FAILED.
    pause
    exit /b 1
)

set /a SILVER_TIME=(S_END-S_START)/10000000
echo.
echo Silver Layer Transformation Completed Successfully.
echo.

REM ------------------------------
REM [3/3] Gold Layer
REM ------------------------------
echo [3/3] Loading Gold Layer...

for /f %%a in ('powershell -NoProfile -Command "(Get-Date).ToUniversalTime().Ticks"') do set G_START=%%a
call "scripts\03_gold\load_to_gold.bat"
for /f %%a in ('powershell -NoProfile -Command "(Get-Date).ToUniversalTime().Ticks"') do set G_END=%%a

if errorlevel 1 (
    echo.
    echo Gold Layer FAILED.
    pause
    exit /b 1
)

set /a GOLD_TIME=(G_END-G_START)/10000000
echo.
echo Gold Layer views created successfully.
echo.

REM ------------------------------
REM Total = Sum of all 3 loads
REM ------------------------------
set /a TOTAL_TIME=BRONZE_TIME+SILVER_TIME+GOLD_TIME

echo ========================================================
echo  Full ETL Process Completed Successfully
echo  Total Time Taken: %TOTAL_TIME% seconds
echo ========================================================

pause
exit /b 0




