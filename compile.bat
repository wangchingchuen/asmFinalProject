@echo off
setlocal
REM compile.bat
REM Assembles and links the 32-bit ASM program into .exe
REM Uses MicroSoft Macro Assembler version 6.11 and 32-bit Incremental Linker version 5.10.7303
REM Created by group25

REM ensure obj and bin directories exist
if not exist obj mkdir obj
if not exist bin mkdir bin

REM delete related files
REM 	del obj\*.obj
REM 	del obj\*.ilk
REM 	del obj\*.pdb
REM 	del bin\game.exe


REM /c          assemble without linking
REM /coff       generate object code to be linked into flat memory model 
REM /Zi         generate symbolic debugging information for WinDBG
REM /Fo         specify output object file path

 

ML /c /coff /Zi /Fo.\obj\ .\src\main.asm
ML /c /coff /Zi /Fo.\obj\ .\src\display.asm
ML /c /coff /Zi /Fo.\obj\ .\src\input.asm
ML /c /coff /Zi /Fo.\obj\ .\src\boss.asm
ML /c /coff /Zi /Fo.\obj\ .\src\delay.asm
ML /c /coff /Zi /Fo.\obj\ .\src\game_logic.asm
ML /c /coff /Zi /Fo.\obj\ .\src\math.asm
ML /c /coff /Zi /Fo.\obj\ .\src\arrow.asm
ML /c /coff /Zi /Fo.\obj\ .\src\round.asm
if errorlevel 1 goto terminate

REM /debug              generate symbolic debugging information
REM /subsystem:console  generate console application code
REM /entry:_start        entry point to the program 
REM                     the entry point of the program must be _start

REM /out:%1.exe         output %1.exe code
REM %1.obj              input %1.obj
REM Kernel32.lib        library procedures to be invoked from the program
REM irvine32.lib
REM user32.lib

LINK /INCREMENTAL:no /debug /subsystem:console /entry:start /out:bin\game.exe obj\*.obj kernel32.lib user32.lib irvine32.lib
if errorlevel 1 goto terminate

REM Display all files related to this program:
DIR bin\game.*

:terminate
pause
endlocal