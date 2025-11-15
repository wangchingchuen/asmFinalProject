@echo off
REM ============================================
REM Clean batch file for Windows 32-bit Assembly
REM Removes all build artifacts
REM ============================================

REM Set console to English
chcp 437 > nul

echo ============================================
echo Cleaning build files...
echo ============================================

REM Clean executable files
if exist bin\*.exe (
    echo Deleting executable files...
    del /Q bin\*.exe
)

REM Clean object files
if exist obj\*.obj (
    echo Deleting object files...
    del /Q obj\*.obj
)

REM Clean debug files
if exist bin\*.pdb (
    echo Deleting debug files (bin)...
    del /Q bin\*.pdb
)

if exist obj\*.pdb (
    echo Deleting debug files (obj)...
    del /Q obj\*.pdb
)

REM Clean incremental link files
if exist bin\*.ilk (
    echo Deleting incremental link files...
    del /Q bin\*.ilk
)

REM Clean listing files
if exist obj\*.lst (
    echo Deleting listing files...
    del /Q obj\*.lst
)

REM Clean map files
if exist bin\*.map (
    echo Deleting map files...
    del /Q bin\*.map
)

echo.
echo ============================================
echo Clean completed!
echo ============================================

pause
exit /b 0