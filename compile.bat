@echo off
setlocal
REM compile.bat - 修正版

REM ensure obj and bin directories exist
if not exist obj mkdir obj
if not exist bin mkdir bin

REM clean up previous builds
del obj\*.obj 2>nul
del bin\game.exe 2>nul

REM compile main module
ML /c /coff /Zi /Fo.\obj\main.obj .\src\main.asm
if errorlevel 1 goto terminate

REM compile other source files
ML /c /coff /Zi /Fo.\obj\display.obj .\src\display.asm
if errorlevel 1 goto terminate

ML /c /coff /Zi /Fo.\obj\input.obj .\src\input.asm
if errorlevel 1 goto terminate

ML /c /coff /Zi /Fo.\obj\boss.obj .\src\boss.asm
if errorlevel 1 goto terminate

ML /c /coff /Zi /Fo.\obj\delay.obj .\src\delay.asm
if errorlevel 1 goto terminate

ML /c /coff /Zi /Fo.\obj\game_logic.obj .\src\game_logic.asm
if errorlevel 1 goto terminate

ML /c /coff /Zi /Fo.\obj\math.obj .\src\math.asm
if errorlevel 1 goto terminate

ML /c /coff /Zi /Fo.\obj\arrow.obj .\src\arrow.asm
if errorlevel 1 goto terminate

ML /c /coff /Zi /Fo.\obj\round.obj .\src\round.asm
if errorlevel 1 goto terminate

REM compile data modules
ML /c /coff /Zi /Fo.\obj\constants.obj .\data\constants.asm
if errorlevel 1 goto terminate

ML /c /coff /Zi /Fo.\obj\strings.obj .\data\strings.asm
if errorlevel 1 goto terminate

ML /c /coff /Zi /Fo.\obj\levels.obj .\data\levels.asm
if errorlevel 1 goto terminate

REM link all object files into final executable
LINK /INCREMENTAL:no /debug /subsystem:console /entry:start /out:bin\game.exe obj\*.obj kernel32.lib user32.lib
if errorlevel 1 goto terminate

echo.
echo successfully compiled!
DIR bin\game.exe

:terminate
if errorlevel 1 echo failed to compile.
pause
endlocal