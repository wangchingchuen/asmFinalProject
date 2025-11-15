@echo off
REM ===================================================
REM x86 ASM Game Project Compile Script
REM ===================================================

setlocal enabledelayedexpansion

REM 設定路徑
set SRC_DIR=src
set DATA_DIR=data
set OBJ_DIR=obj
set BIN_DIR=bin
set OUTPUT=%BIN_DIR%\game.exe

REM 使用正確的 MASM 路徑
set ASSEMBLER="C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Tools\MSVC\14.50.35717\bin\Hostx64\x86\ml.exe"

REM 尋找 link.exe
for /f "delims=" %%i in ('where link.exe 2^>nul') do (
    set LINKER=%%i
    goto found_linker
)

REM 嘗試常見位置
if exist "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Tools\MSVC\14.50.35717\bin\Hostx64\x86\link.exe" (
    set LINKER="C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Tools\MSVC\14.50.35717\bin\Hostx64\x86\link.exe"
    goto found_linker
)

set LINKER=link.exe

:found_linker

cls
echo.
echo ===================================================
echo  x86 ASM Game Project - Compiler
echo ===================================================
echo.

REM 檢查編譯器是否存在
if not exist %ASSEMBLER% (
    echo Error: ml.exe not found!
    echo Path: %ASSEMBLER%
    pause
    exit /b 1
)

echo [OK] Assembler found
echo.

REM 建立必要的目錄
if not exist %OBJ_DIR% (
    mkdir %OBJ_DIR%
    echo [OK] Created %OBJ_DIR% directory
)

if not exist %BIN_DIR% (
    mkdir %BIN_DIR%
    echo [OK] Created %BIN_DIR% directory
)

echo.
echo ===== Start Compiling =====
echo.

REM 清理舊的 OBJ 檔案
echo [Clean] Removing old object files...
del /q %OBJ_DIR%\*.obj >nul 2>&1

REM 編譯 SRC 目錄的檔案
echo.
echo [Compile] src directory...

%ASSEMBLER% /Fo%OBJ_DIR%\main.obj %SRC_DIR%\main.asm
if errorlevel 1 goto compile_error
echo   [OK] main.asm

%ASSEMBLER% /Fo%OBJ_DIR%\input.obj %SRC_DIR%\input.asm
if errorlevel 1 goto compile_error
echo   [OK] input.asm

%ASSEMBLER% /Fo%OBJ_DIR%\game_logic.obj %SRC_DIR%\game_logic.asm
if errorlevel 1 goto compile_error
echo   [OK] game_logic.asm

%ASSEMBLER% /Fo%OBJ_DIR%\display.obj %SRC_DIR%\display.asm
if errorlevel 1 goto compile_error
echo   [OK] display.asm

%ASSEMBLER% /Fo%OBJ_DIR%\math.obj %SRC_DIR%\math.asm
if errorlevel 1 goto compile_error
echo   [OK] math.asm

%ASSEMBLER% /Fo%OBJ_DIR%\boss.obj %SRC_DIR%\boss.asm
if errorlevel 1 goto compile_error
echo   [OK] boss.asm

%ASSEMBLER% /Fo%OBJ_DIR%\delay.obj %SRC_DIR%\delay.asm
if errorlevel 1 goto compile_error
echo   [OK] delay.asm

REM 編譯 DATA 目錄的檔案
echo.
echo [Compile] data directory...

%ASSEMBLER% /Fo%OBJ_DIR%\levels.obj %DATA_DIR%\levels.asm
if errorlevel 1 goto compile_error
echo   [OK] levels.asm

%ASSEMBLER% /Fo%OBJ_DIR%\strings.obj %DATA_DIR%\strings.asm
if errorlevel 1 goto compile_error
echo   [OK] strings.asm

%ASSEMBLER% /Fo%OBJ_DIR%\constants.obj %DATA_DIR%\constants.asm
if errorlevel 1 goto compile_error
echo   [OK] constants.asm

REM 連接所有 OBJ 檔案
echo.
echo [Link] Generating executable...

%LINKER% %OBJ_DIR%\main.obj %OBJ_DIR%\input.obj %OBJ_DIR%\game_logic.obj ^
         %OBJ_DIR%\display.obj %OBJ_DIR%\math.obj %OBJ_DIR%\boss.obj ^
         %OBJ_DIR%\delay.obj %OBJ_DIR%\levels.obj %OBJ_DIR%\strings.obj %OBJ_DIR%\constants.obj ^
         /OUT:%OUTPUT%

if errorlevel 1 goto link_error

echo.
echo ===================================================
echo  [SUCCESS] Compilation Complete!
echo  Executable: %OUTPUT%
echo ===================================================
echo.

REM 詢問是否執行遊戲
set /p RUN="Run game now? (Y/N): "
if /i "%RUN%"=="Y" (
    %OUTPUT%
) else (
    echo.
    pause
)

goto end

REM 錯誤處理
:compile_error
echo.
echo ===================================================
echo  [ERROR] Compilation failed!
echo ===================================================
echo.
pause
exit /b 1

:link_error
echo.
echo ===================================================
echo  [ERROR] Linking failed!
echo ===================================================
echo.
pause
exit /b 1

:end
endlocal