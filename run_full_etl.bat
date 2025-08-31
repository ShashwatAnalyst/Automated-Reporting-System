@echo off
setlocal EnableDelayedExpansion

:: Set working directory
cd /d "C:\Users\fusio\Desktop\Data_warehouse_project\SQL-Data-Warehouse-Project"

:: Capture start time
for /f %%a in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set START=%%a

echo ========================================================
echo  Starting Full ETL Process...
echo ========================================================

:: Step 1: Load Bronze Layer
echo.
echo [1/4] Loading Bronze Layer...
call "scripts\01_bronze\load_to_bronze.bat"
IF %ERRORLEVEL% NEQ 0 (
    echo Bronze Layer loading failed. Aborting.
    pause
    exit /b 1
)

:: Step 2: Load Silver Layer  
echo.
echo [2/4] Loading Silver Layer...
call "scripts\02_silver\load_to_silver.bat"
IF %ERRORLEVEL% NEQ 0 (
    echo Silver Layer loading failed. Aborting.
    pause
    exit /b 1
)

:: Step 3: Load Gold Layer
echo.
echo [3/4] Loading Gold Layer...
call "scripts\03_gold\load_to_gold.bat"
IF %ERRORLEVEL% NEQ 0 (
    echo Gold Layer loading failed. Aborting.
    pause
    exit /b 1
)

:: Step 4: Run Analysis Report
echo.
echo [4/4] Running Analysis Report...

:: Activate conda environment and run jupyter
call conda activate base
if exist "Automated Reports\Analysis_&_Report.ipynb" (
    jupyter nbconvert ^
        --to notebook ^
        --execute ^
        --output "Analysis_Report_Executed.ipynb" ^
        --output-dir "Automated Reports" ^
        "Automated Reports\Analysis_&_Report.ipynb"
    
    IF !ERRORLEVEL! NEQ 0 (
        echo Report execution failed. Check the notebook for errors.
        pause
        exit /b 1
    )
) else (
    echo Error: Notebook file not found!
    pause
    exit /b 1
)

:: Calculate elapsed time
for /f %%b in ('powershell -command "[int](Get-Date).ToUniversalTime().Subtract([datetime]'1970-01-01').TotalSeconds"') do set END=%%b
set /a ELAPSED=!END! - !START!

echo.
echo ========================================================
echo  ETL Process Completed Successfully!
echo  Report generated: Automated Reports\Analysis_Report_Executed.ipynb
echo  Total Time: !ELAPSED! seconds
echo ========================================================
pause
endlocal
