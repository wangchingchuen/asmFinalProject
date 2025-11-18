; ============================================
; main.asm - 修正版
; 主程式進入點 - Windows 32-bit
; ============================================

.386
.model flat, c
option casemap:none



; Windows API 函數
ExitProcess PROTO :DWORD
GetStdHandle PROTO :DWORD
WriteConsoleA PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
Sleep PROTO :DWORD

; 常數定義
STD_OUTPUT_HANDLE equ -11

; 外部資料和程序宣告
EXTERN game_title_str:BYTE
EXTERN version_str:BYTE
EXTERN init_game:PROC
EXTERN game_loop:PROC
EXTERN show_game_over:PROC
EXTERN init_display:PROC
EXTERN init_input:PROC
EXTERN clear_screen:PROC

.data
    welcome_msg db "=================================", 13, 10
                db "     ASSEMBLY GAME PROJECT       ", 13, 10
                db "        Windows 32-bit           ", 13, 10
                db "=================================", 13, 10, 0
    msg_len     dd 35*4  ; 約略長度
    hConsole    dd 0
    bytesWritten dd 0

.code
PUBLIC start

start PROC
    ; 初始化顯示系統
    call init_display
    
    ; 初始化輸入系統
    call init_input
    
    ; 顯示歡迎訊息
    call show_welcome
    
    ; 初始化遊戲
    call init_game
    
    ; 主遊戲迴圈
    call game_loop
    
    ; 顯示結束畫面
    call show_game_over
    
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
    
    ; 取得標準輸出句柄
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov hConsole, eax
    
    ; 計算字串長度
    lea esi, welcome_msg
    xor ecx, ecx
count_loop:
    mov al, [esi + ecx]
    test al, al
    jz count_done
    inc ecx
    jmp count_loop
count_done:
    
    ; 顯示歡迎訊息
    push 0
    push OFFSET bytesWritten
    push ecx                    ; 實際長度
    push OFFSET welcome_msg
    push hConsole
    call WriteConsoleA
    
    ; 等待 2 秒
    push 2000
    call Sleep
    
    pop ebp
    ret
show_welcome ENDP

END start