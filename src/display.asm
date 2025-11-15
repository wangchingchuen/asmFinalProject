; ============================================
; display.asm
; 顯示模組 - 螢幕輸出和 UI
; ============================================

.model small

include constants.asm
include strings.asm

data segment public
    temp_num    dw 0
    num_buffer  db 10 dup(0)
data ends

code segment public

    assume cs:code, ds:data

; ═══════════════════════════════════════
; 清屏 (使用 INT 10H)
; ═══════════════════════════════════════
public clear_screen

clear_screen proc far
    
    mov ax, 0600h                   ; AH=6 (捲動), AL=0 (清空)
    mov bh, 07h                     ; BH=顏色屬性 (白底黑字)
    mov cx, 0000h                   ; 左上角 (0,0)
    mov dx, 184Fh                   ; 右下角 (24,79)
    int 10h
    
    ; 定位光標到 (0,0)
    mov ah, 02h
    mov bh, 00h
    mov dx, 0000h
    int 10h
    
    ret
    
clear_screen endp

; ═══════════════════════════════════════
; 打印字符串
; 輸入: DS:DX = 字符串位址 (以 '$' 結尾)
; ═══════════════════════════════════════
public print_string

print_string proc far
    
    mov ah, 09h
    int 21h
    
    ret
    
print_string endp

; ═══════════════════════════════════════
; 打印新行
; ═══════════════════════════════════════
public print_newline

print_newline proc far
    
    mov ah, 02h
    mov dl, 0Dh                     ; 回車
    int 21h
    
    mov ah, 02h
    mov dl, 0Ah                     ; 換行
    int 21h
    
    ret
    
print_newline endp

; ═══════════════════════════════════════
; 打印整數 (16位無符號)
; 輸入: AX = 要打印的數字
; ═══════════════════════════════════════
public print_number

print_number proc far
    
    push bx
    push cx
    push dx
    
    mov temp_num, ax
    mov bx, 10
    mov cx, 0
    
    ; 將數字轉換為字符串
convert_loop:
    mov ax, temp_num
    xor dx, dx
    div bx
    mov temp_num, ax
    
    add dl, '0'
    push dx
    inc cx
    
    cmp ax, 0
    jne convert_loop
    
    ; 打印數字字符
print_num_loop:
    pop dx
    mov ah, 02h
    int 21h
    loop print_num_loop
    
    pop dx
    pop cx
    pop bx
    
    ret
    
print_number endp

; ═══════════════════════════════════════
; 顯示遊戲標題
; ═══════════════════════════════════════
public display_title

display_title proc far
    
    lea dx, title_str
    call print_string
    call print_newline
    
    lea dx, title_str2
    call print_string
    call print_newline
    
    lea dx, title_str3
    call print_string
    call print_newline
    
    call print_newline
    lea dx, press_any_key
    call print_string
    
    ; 等待按鍵
    mov ah, 00h
    int 16h
    
    ret
    
display_title endp

; ═══════════════════════════════════════
; 顯示關卡資訊
; ═══════════════════════════════════════
public display_level_info

display_level_info proc far
    
    push ax
    
    call print_newline
    lea dx, level_label
    call print_string
    call print_newline
    call print_newline
    
    ; 顯示關卡數
    lea dx, level_num_str
    call print_string
    
    mov al, current_level
    xor ah, ah
    inc ax                          ; 顯示 1-10 而不是 0-9
    call print_number
    
    call print_newline
    call print_newline
    
    ; 顯示士兵數量
    lea dx, soldiers_str
    call print_string
    
    mov ax, soldier_count
    call print_number
    
    call print_newline
    call print_newline
    
    ; 顯示兩條路選項
    lea dx, left_formula_str
    call print_string
    
    ; 取得左邊公式資訊並顯示
    ; 這部分會在 game_logic.asm 中更詳細實現
    lea dx, multiply_str
    call print_string
    
    call print_newline
    call print_newline
    
    lea dx, right_formula_str
    call print_string
    
    lea dx, multiply_str
    call print_string
    
    call print_newline
    call print_newline
    
    pop ax
    
    ret
    
display_level_info endp

; ═══════════════════════════════════════
; 顯示結果
; ═══════════════════════════════════════
public display_result

display_result proc far
    
    call print_newline
    lea dx, separator_line
    call print_string
    call print_newline
    
    lea dx, result_str
    call print_string
    
    mov ax, soldier_count
    call print_number
    
    call print_newline
    call print_newline
    
    ret
    
display_result endp

code ends

end