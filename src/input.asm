; ============================================
; input.asm
; 輸入處理模組 - 鍵盤輸入
; ============================================

.model small

include constants.asm
include strings.asm

data segment public
    input_char  db 0
data ends

code segment public

    extrn print_string:far
    extrn print_newline:far
    
    assume cs:code, ds:data

; ═══════════════════════════════════════
; 取得玩家選擇 (A=左, D=右)
; 返回: AL = 0(左) or 1(右)
; ═══════════════════════════════════════
public get_player_choice

get_player_choice proc far
    
    push bx
    push cx
    
    ; 顯示提示
    lea dx, select_prompt
    call print_string
    
input_wait_loop:
    ; 等待鍵盤輸入 (INT 16H AH=0)
    mov ah, 00h
    int 16h
    
    ; AL 包含掃描碼
    ; 檢查是否為 'A' 或 'a' (左)
    cmp al, 41h                     ; 'A'
    je input_left
    cmp al, 61h                     ; 'a'
    je input_left
    
    ; 檢查是否為 'D' 或 'd' (右)
    cmp al, 44h                     ; 'D'
    je input_right
    cmp al, 64h                     ; 'd'
    je input_right
    
    ; 無效輸入，重新等待
    jmp input_wait_loop
    
input_left:
    mov al, 0                       ; 返回 0 表示左
    jmp input_done
    
input_right:
    mov al, 1                       ; 返回 1 表示右
    
input_done:
    call print_newline
    pop cx
    pop bx
    ret
    
get_player_choice endp

; ═══════════════════════════════════════
; 暫停等待按鍵
; ═══════════════════════════════════════
public wait_for_key

wait_for_key proc far
    
    lea dx, press_any_key
    call print_string
    
    mov ah, 00h
    int 16h
    
    ret
    
wait_for_key endp

code ends

end