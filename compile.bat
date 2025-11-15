@echo off
setlocal enabledelayedexpansion

REM ============================================
REM Automatically find latest VS MSVC tools path
REM ============================================

set "VS_BASE=%ProgramFiles(x86)%\Microsoft Visual Studio"
set "VSTOOLS="

REM Loop all VS installations
for /d %%V in ("%VS_BASE%\*") do (
    for /d %%E in ("%%V\*\VC\Tools\MSVC\*") do (
        if exist "%%E\bin\Hostx86\x86" (
            set "VSTOOLS_CANDIDATE=%%E\bin\Hostx86\x86"
            REM Compare version strings to keep the latest one
            if "!VSTOOLS!"=="" (
                set "VSTOOLS=!VSTOOLS_CANDIDATE!"
            ) else (
                for /f "tokens=1-4 delims=." %%a in ("%%~nxE") do set "newver=%%a%%b%%c%%d"
                for /f "tokens=1-4 delims=." %%a in ("!VSTOOLS:*-*=%") do set "curver=%%a%%b%%c%%d"
                if !newver! gtr !curver! set "VSTOOLS=!VSTOOLS_CANDIDATE!"
            )
        )
    )
)

if "%VSTOOLS%"=="" (
    echo ERROR: Could not find VS Build Tools MSVC bin folder!
    pause
    exit /b 1
)

echo Found VS Tools: %VSTOOLS%
set PATH=%VSTOOLS%;%PATH%

REM ============================================
REM Set console to English
REM ============================================
chcp 437 > nul

REM ============================================
REM Windows SDK LIB PATH
REM ============================================
set LIBPATH_CRT=C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x86
set LIBPATH_UCRT=C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\ucrt\x86

echo Using LIBPATH:
echo %LIBPATH_CRT%
echo %LIBPATH_UCRT%
echo.

REM ============================================
REM Clean previous build
REM ============================================
echo Cleaning previous build...
if exist bin\*.exe del /Q bin\*.exe
if exist obj\*.obj del /Q obj\*.obj
if exist obj\*.lst del /Q obj\*.lst
if exist obj\*.pdb del /Q obj\*.pdb
if exist bin\*.pdb del /Q bin\*.pdb
if exist bin\*.ilk del /Q bin\*.ilk

if not exist bin mkdir bin
if not exist obj mkdir obj

REM ============================================
REM Assemble source files
REM ============================================
echo.
echo ============================================
echo Assembling source files...
echo ============================================

REM Assemble your data files and src files
ML /c /coff /Zi /Fo obj\constants.obj data\constants.asm
ML /c /coff /Zi /Fo obj\levels.obj data\levels.asm
ML /c /coff /Zi /Fo obj\strings.obj data\strings.asm
ML /c /coff /Zi /Fo obj\main.obj src\main.asm
ML /c /coff /Zi /Fo obj\display.obj src\display.asm
ML /c /coff /Zi /Fo obj\input.obj src\input.asm
ML /c /coff /Zi /Fo obj\game_logic.obj src\game_logic.asm
ML /c /coff /Zi /Fo obj\boss.obj src\boss.asm
ML /c /coff /Zi /Fo obj\delay.obj src\delay.asm
ML /c /coff /Zi /Fo obj\math.obj src\math.asm

REM ============================================
REM Linking object files
REM ============================================
LINK /INCREMENTAL:no /debug /subsystem:console /entry:start /out:bin\game.exe obj\*.obj kernel32.lib user32.lib

if errorlevel 1 (
    echo ERROR: Failed to link object files
    goto terminate
)

echo.
echo ============================================
echo BUILD SUCCESSFUL!
echo Executable: bin\game.exe
echo ============================================

dir /b bin\*.exe
dir /b obj\*.obj

goto end

:terminate
echo.
echo ============================================
echo BUILD FAILED!
echo Check error messages above
echo ============================================
pause
exit /b 1

:end
pause
exit /b 0
