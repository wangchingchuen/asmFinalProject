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

REM 編譯器和連接器
set ASSEMBLER=ml.exe
set LINKER=link.exe

REM 顏色代碼 (用於訊息)
REM 藍色 = 訊息, 綠色 = 成功, 紅色 = 錯誤

echo.
echo ===================================================
echo  x86 ASM Game Project - Compiler
echo ===================================================
echo.

REM 檢查編譯器是否存在
%ASSEMBLER% >nul 2>&1
if errorlevel 1 (
    echo [錯誤] 找不到 ml.exe 編譯器！
    echo 請確保已安裝 Microsoft Macro Assembler (MASM)
    echo.
    pause
    exit /b 1
)

%LINKER% >nul 2>&1
if errorlevel 1 (
    echo [錯誤] 找不到 link.exe 連接器！
    echo 請確保已安裝 Visual Studio 或 Microsoft Linker
    echo.
    pause
    exit /b 1
)

echo [✓] 編譯器和連接器檢查完成
echo.

REM 建立必要的目錄
if not exist %OBJ_DIR% (
    mkdir %OBJ_DIR%
    echo [✓] 建立 %OBJ_DIR% 目錄
)

if not exist %BIN_DIR% (
    mkdir %BIN_DIR%
    echo [✓] 建立 %BIN_DIR% 目錄
)

echo.
echo ===== 開始編譯 =====
echo.

REM 清理舊的 OBJ 檔案
echo [清理] 移除舊的 OBJ 檔案...
del /q %OBJ_DIR%\*.obj >nul 2>&1

REM 編譯 SRC 目錄的檔案
echo.
echo [編譯] src 目錄...

%ASSEMBLER% /Fo%OBJ_DIR%\main.obj %SRC_DIR%\main.asm
if errorlevel 1 goto compile_error
echo   ✓ main.asm

%ASSEMBLER% /Fo%OBJ_DIR%\input.obj %SRC_DIR%\input.asm
if errorlevel 1 goto compile_error
echo   ✓ input.asm

%ASSEMBLER% /Fo%OBJ_DIR%\game_logic.obj %SRC_DIR%\game_logic.asm
if errorlevel 1 goto compile_error
echo   ✓ game_logic.asm

%ASSEMBLER% /Fo%OBJ_DIR%\display.obj %SRC_DIR%\display.asm
if errorlevel 1 goto compile_error
echo   ✓ display.asm

%ASSEMBLER% /Fo%OBJ_DIR%\math.obj %SRC_DIR%\math.asm
if errorlevel 1 goto compile_error
echo   ✓ math.asm

%ASSEMBLER% /Fo%OBJ_DIR%\boss.obj %SRC_DIR%\boss.asm
if errorlevel 1 goto compile_error
echo   ✓ boss.asm

REM 編譯 DATA 目錄的檔案
echo.
echo [編譯] data 目錄...

%ASSEMBLER% /Fo%OBJ_DIR%\levels.obj %DATA_DIR%\levels.asm
if errorlevel 1 goto compile_error
echo   ✓ levels.asm

%ASSEMBLER% /Fo%OBJ_DIR%\strings.obj %DATA_DIR%\strings.asm
if errorlevel 1 goto compile_error
echo   ✓ strings.asm

%ASSEMBLER% /Fo%OBJ_DIR%\constants.obj %DATA_DIR%\constants.asm
if errorlevel 1 goto compile_error
echo   ✓ constants.asm

REM 連接所有 OBJ 檔案
echo.
echo [連接] 生成可執行檔...

%LINKER% %OBJ_DIR%\main.obj %OBJ_DIR%\input.obj %OBJ_DIR%\game_logic.obj ^
         %OBJ_DIR%\display.obj %OBJ_DIR%\math.obj %OBJ_DIR%\boss.obj ^
         %OBJ_DIR%\levels.obj %OBJ_DIR%\strings.obj %OBJ_DIR%\constants.obj ^
         /OUT:%OUTPUT%

if errorlevel 1 goto link_error

echo.
echo ===================================================
echo  [成功] 編譯完成！
echo  可執行檔: %OUTPUT%
echo ===================================================
echo.

REM 詢問是否執行遊戲
set /p RUN="是否立即執行遊戲? (Y/N): "
if /i "%RUN%"=="Y" (
    %OUTPUT%
) else (
    echo.
    echo 命令：
    echo   - 編譯: compile.bat
    echo   - 執行: %OUTPUT%
    echo   - 清理: clean.bat
    echo.
    pause
)

goto end

REM 錯誤處理
:compile_error
echo.
echo ===================================================
echo  [錯誤] 編譯失敗！
echo ===================================================
echo.
pause
exit /b 1

:link_error
echo.
echo ===================================================
echo  [錯誤] 連接失敗！
echo ===================================================
echo.
pause
exit /b 1

:end
endlocal