; ============================================
; input.asm
; 輸入處理模組 - Windows 32-bit
; ============================================

.386
.model flat, stdcall
option casemap:none

; Windows API
GetStdHandle PROTO :DWORD
ReadConsoleA PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
FlushConsoleInputBuffer PROTO :DWORD
GetAsyncKeyState PROTO :DWORD

; 常數定義
STD_INPUT_HANDLE  equ -10
VK_LEFT          equ 25h  ; 左方向鍵
VK_RIGHT         equ 27h  ; 右方向鍵
VK_UP            equ 26h  ; 上方向鍵
VK_DOWN          equ 28h  ; 下方向鍵
VK_SPACE         equ 20h  ; 空白鍵
VK_ESCAPE        equ 1Bh  ; ESC 鍵
VK_A             equ 41h  ; A 鍵
VK_D             equ 44h  ; D 鍵

; 外部程序
EXTERN print_string@4:PROC
EXTERN print_newline@0:PROC

.data
    PUBLIC input_char
    input_char      db 0
    hStdInput       dd 0
    bytesRead       dd 0
    inputBuffer     db 10 dup(0)
    
    select_prompt   db "Select (A=Left, D=Right): ", 0
    press_any_key   db "Press any key to continue...", 0

.code

; ============================================
; 初始化輸入系統
; ============================================
PUBLIC init_input@0
init_input@0 PROC
    push STD_INPUT_HANDLE
    call GetStdHandle
    mov hStdInput, eax
    ret
init_input@0 ENDP

; ============================================
; 取得玩家選擇 (A=左, D=右)
; 返回: EAX = 0(左) or 1(右)
; ============================================
PUBLIC get_player_choice@0
get_player_choice@0 PROC
    push ebx
    push ecx
    push edx
    
    ; 顯示提示
    push OFFSET select_prompt
    call print_string@4
    
input_loop:
    ; 清空輸入緩衝區
    push hStdInput
    call FlushConsoleInputBuffer
    
    ; 讀取一個字元
    push 0
    push OFFSET bytesRead
    push 1
    push OFFSET inputBuffer
    push hStdInput
    call ReadConsoleA
    
    ; 檢查輸入
    mov al, inputBuffer
    
    ; 轉換為大寫
    cmp al, 'a'
    jb check_input
    cmp al, 'z'
    ja check_input
    sub al, 20h  ; 轉為大寫
    
check_input:
    cmp al, 'A'
    je select_left
    cmp al, 'D'
    je select_right
    
    ; 無效輸入，重新等待
    jmp input_loop
    
select_left:
    xor eax, eax  ; 返回 0 表示左
    jmp input_done
    
select_right:
    mov eax, 1    ; 返回 1 表示右
    
input_done:
    call print_newline@0
    
    pop edx
    pop ecx
    pop ebx
    ret
get_player_choice@0 ENDP

; ============================================
; 暫停等待按鍵
; ============================================
PUBLIC wait_for_key@0
wait_for_key@0 PROC
    push edx
    
    ; 顯示提示訊息
    push OFFSET press_any_key
    call print_string@4
    
    ; 清空輸入緩衝區
    push hStdInput
    call FlushConsoleInputBuffer
    
    ; 等待按鍵
    push 0
    push OFFSET bytesRead
    push 1
    push OFFSET inputBuffer
    push hStdInput
    call ReadConsoleA
    
    pop edx
    ret
wait_for_key@0 ENDP

; ============================================
; 檢查按鍵狀態 (非阻塞)
; 輸入: EAX = 虛擬鍵碼
; 返回: EAX = 1(按下) or 0(未按下)
; ============================================
PUBLIC check_key_state@4
check_key_state@4 PROC
    push ebp
    mov ebp, esp
    
    push [ebp+8]  ; 虛擬鍵碼
    call GetAsyncKeyState
    
    ; 檢查最高位元
    test ax, 8000h
    jz not_pressed
    
    mov eax, 1
    jmp done
    
not_pressed:
    xor eax, eax
    
done:
    pop ebp
    ret 4
check_key_state@4 ENDP

; ============================================
; 取得方向鍵輸入
; 返回: EAX = 0(無), 1(左), 2(右), 3(上), 4(下)
; ============================================
PUBLIC get_arrow_key@0
get_arrow_key@0 PROC
    ; 檢查左鍵
    push VK_LEFT
    call check_key_state@4
    test eax, eax
    jnz return_left
    
    ; 檢查右鍵
    push VK_RIGHT
    call check_key_state@4
    test eax, eax
    jnz return_right
    
    ; 檢查上鍵
    push VK_UP
    call check_key_state@4
    test eax, eax
    jnz return_up
    
    ; 檢查下鍵
    push VK_DOWN
    call check_key_state@4
    test eax, eax
    jnz return_down
    
    ; 無按鍵
    xor eax, eax
    ret
    
return_left:
    mov eax, 1
    ret
    
return_right:
    mov eax, 2
    ret
    
return_up:
    mov eax, 3
    ret
    
return_down:
    mov eax, 4
    ret
get_arrow_key@0 ENDP

END