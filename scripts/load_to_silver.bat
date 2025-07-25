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

echo =====================================================
echo  Starting Silver Layer Data Transformation...
echo =====================================================

:: Run the silver layer SQL
psql -U %PGUSER% -d %PGDB% -f "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project\scripts\load_to_silver.sql"

IF %ERRORLEVEL% NEQ 0 (
    echo  Error: Failed during silver layer transformation.
    pause
    exit /b 1
) ELSE (
    for /f %%b in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set END=%%b
    set /a ELAPSED=!END! - !START!
    echo =====================================================
    echo  Silver Layer Transformation Completed Successfully.
    echo  Total time taken: !ELAPSED! seconds.
    echo =====================================================
)

pause
endlocal
