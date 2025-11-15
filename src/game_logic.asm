; ============================================
; game_logic.asm
; 遊戲邏輯 - 公式計算和士兵數量管理
; ============================================

.model small

include constants.asm
include strings.asm
include levels.asm

data segment public
    formula_type    db 0
    formula_param   db 0
    level_offset    dw 0
data ends

code segment public

    extrn print_string:far
    extrn print_number:far
    extrn print_newline:far
    
    assume cs:code, ds:data

; ═══════════════════════════════════════
; 根據關卡和選擇取得公式資訊
; 輸入: current_level, current_choice
; 返回: formula_type (AL), formula_param (BL)
; ═══════════════════════════════════════
public get_formula

get_formula proc far
    
    push bx
    push cx
    
    ; 計算偏移量: level_offset = current_level * 4
    mov al, current_level
    mov bl, 4
    mul bl
    mov level_offset, ax
    
    ; 取得 level_data 的地址
    lea bx, level_data
    add bx, level_offset
    
    ; 檢查選擇是左還是右
    cmp current_choice, 0
    je get_left_formula
    
    ; 右邊公式 (偏移 +2)
    mov al, [bx + 2]                ; 公式類型
    mov bl, [bx + 3]                ; 公式參數
    jmp get_formula_done
    
get_left_formula:
    ; 左邊公式 (偏移 +0)
    mov al, [bx]                    ; 公式類型
    mov bl, [bx + 1]                ; 公式參數
    
get_formula_done:
    mov formula_type, al
    mov formula_param, bl
    
    pop cx
    pop bx
    
    ret
    
get_formula endp

; ═══════════════════════════════════════
; 應用公式到士兵數量
; ═══════════════════════════════════════
public apply_formula

apply_formula proc far
    
    push ax
    push bx
    push dx
    
    ; 取得公式
    call get_formula
    
    mov al, formula_type
    mov bl, formula_param
    
    ; 檢查公式類型
    cmp al, FORMULA_MULTIPLY
    je apply_multiply
    
    cmp al, FORMULA_ADD
    je apply_add
    
    jmp apply_done
    
apply_multiply:
    ; 士兵數量 *= 參數
    mov ax, soldier_count
    mov cl, bl
    mul cl
    
    ; 檢查溢出
    cmp ax, MAX_SOLDIERS
    jle apply_multiply_safe
    mov ax, MAX_SOLDIERS
    
apply_multiply_safe:
    mov soldier_count, ax
    jmp apply_done
    
apply_add:
    ; 士兵數量 += 參數
    mov ax, soldier_count
    xor bh, bh
    add ax, bx
    
    ; 檢查溢出
    cmp ax, MAX_SOLDIERS
    jle apply_add_safe
    mov ax, MAX_SOLDIERS
    
apply_add_safe:
    mov soldier_count, ax
    
apply_done:
    pop dx
    pop bx
    pop ax
    
    ret
    
apply_formula endp

; ═══════════════════════════════════════
; 顯示當前選擇的公式
; ═══════════════════════════════════════
public display_formula_choice

display_formula_choice proc far
    
    push ax
    push bx
    
    call get_formula
    
    ; 顯示公式類型和參數
    cmp formula_type, FORMULA_MULTIPLY
    je show_multiply
    
    lea dx, add_str
    call print_string
    jmp show_param
    
show_multiply:
    lea dx, multiply_str
    call print_string
    
show_param:
    mov al, formula_param
    xor ah, ah
    call print_number
    
    pop bx
    pop ax
    
    ret
    
display_formula_choice endp

code ends

end