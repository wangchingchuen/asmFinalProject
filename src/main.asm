; ============================================
; main.asm
; 主程式進入點 - Windows 32-bit
; ============================================

.386
.model flat, stdcall
option casemap:none

; Windows API 函數
ExitProcess PROTO :DWORD
GetStdHandle PROTO :DWORD
WriteConsoleA PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
Sleep PROTO :DWORD

; 常數定義
STD_OUTPUT_HANDLE equ -11

; ============================================
; 引入資料檔案
; ============================================
include .\data\constants.asm
include .\data\strings.asm
include .\data\levels.asm

; 外部程序宣告
EXTERN init_game@0:PROC
EXTERN game_loop@0:PROC
EXTERN show_game_over@0:PROC
EXTERN init_display@0:PROC
EXTERN clear_screen@0:PROC

.data
    welcome_msg db "=================================", 13, 10
                db "     ASSEMBLY GAME PROJECT       ", 13, 10
                db "        Windows 32-bit           ", 13, 10
                db "=================================", 13, 10, 0
    msg_len     dd $ - welcome_msg

.code
public _start

start PROC
    ; 初始化顯示系統
    call init_display@0
    
    ; 顯示歡迎訊息
    call show_welcome
    
    ; 初始化遊戲
    call init_game@0
    
    ; 主遊戲迴圈
    call game_loop@0
    
    ; 顯示結束畫面
    call show_game_over@0
    
    ; 結束程式
    push 0
    call ExitProcess
start ENDP

; ============================================
; 顯示歡迎訊息
; ============================================
show_welcome PROC
    push ebp
    mov ebp, esp
    sub esp, 8  ; 局部變數空間
    
    ; 取得標準輸出句柄
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov [ebp-4], eax  ; 儲存句柄
    
    ; 顯示歡迎訊息
    push 0
    lea eax, [ebp-8]
    push eax
    push msg_len
    push OFFSET welcome_msg
    push DWORD PTR [ebp-4]
    call WriteConsoleA
    
    ; 等待一下
    push 2000  ; 2 秒
    call Sleep
    
    mov esp, ebp
    pop ebp
    ret
show_welcome ENDP

END _start