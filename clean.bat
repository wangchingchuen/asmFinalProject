@echo off
REM ===================================================
REM Clean Compiled Files
REM ===================================================

echo.
echo ===================================================
echo  清理編譯輸出...
echo ===================================================
echo.

if exist obj (
    echo [刪除] obj 資料夾...
    rmdir /s /q obj
    echo ✓ obj 已刪除
) else (
    echo   obj 資料夾不存在
)

if exist bin (
    echo [刪除] bin 資料夾...
    rmdir /s /q bin
    echo ✓ bin 已刪除
) else (
    echo   bin 資料夾不存在
)

echo.
echo ===================================================
echo  清理完成！
echo ===================================================
echo.
pause