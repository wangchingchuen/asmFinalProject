@echo off
REM make.bat
REM Uses MicroSoft Macro Assembler version 6.11 and 32-bit Incremental Linker version 5.10.7303

REM delete related files
REM 	del main.obj
REM 	del main.exe
REM 	del main.pdb


REM /c          assemble without linking
REM /coff       generate object code to be linked into flat memory model 
REM /Zi         generate symbolic debugging information for WinDBG
REM /Fl		Generate a listing file
 

ML /c /coff /Zi   main.asm
if errorlevel 1 goto terminate

REM /debug              generate symbolic debugging information
REM /subsystem:console  generate console application code
REM /entry:start        entry point from WinDBG to the program 
REM                           the entry point of the program must be _start

REM /out:%1.exe         output %1.exe code
REM %1.obj              input %1.obj
REM Kernel32.lib        library procedures to be invoked from the program
REM irvine32.lib
REM user32.lib

LINK /INCREMENTAL:no /debug /subsystem:console /entry:main /out:main.exe main.obj Kernel32.lib irvine32.lib user32.lib
if errorlevel 1 goto terminate

REM Display all files related to this program:
DIR main.*

:terminate
pause
endlocal