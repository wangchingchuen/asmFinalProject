; ============================================
; math.asm
; 數學計算模組
; ============================================

.model small

data segment public
    dividend    dw 0
    divisor     db 0
    quotient    dw 0
    remainder   db 0
data ends

code segment public

    assume cs:code, ds:data

; ═══════════════════════════════════════
; 乘法 (16位 x 8位)
; 輸入: AX = 被乘數, BL = 乘數
; 返回: AX = 結果
; ═══════════════════════════════════════
public multiply

multiply proc far
    
    push bx
    mov bl, bl                      ; 乘數在 BL
    mul bl                          ; AX *= BL
    pop bx
    
    ret
    
multiply endp

; ═══════════════════════════════════════
; 除法 (16位 ÷ 8位)
; 輸入: AX = 被除數, BL = 除數
; 返回: AX = 商, DL = 餘數
; ═══════════════════════════════════════
public divide

divide proc far
    
    mov cl, bl                      ; 除數在 CL
    xor dx, dx
    div cx
    
    ret
    
divide endp

; ═══════════════════════════════════════
; 比較兩個數
; 輸入: AX = 第一個數, BX = 第二個數
; 返回: CF 旗標
;       CF=0 且 ZF=0: AX > BX
;       CF=0 且 ZF=1: AX = BX
;       CF=1: AX < BX
; ═══════════════════════════════════════
public compare_numbers

compare_numbers proc far
    
    cmp ax, bx
    
    ret
    
compare_numbers endp

; ═══════════════════════════════════════
; 最大值
; 輸入: AX, BX
; 返回: AX = 最大值
; ═══════════════════════════════════════
public max_value

max_value proc far
    
    cmp ax, bx
    jge max_is_ax
    mov ax, bx
    
max_is_ax:
    ret
    
max_value endp

; ═══════════════════════════════════════
; 最小值
; 輸入: AX, BX
; 返回: AX = 最小值
; ═══════════════════════════════════════
public min_value

min_value proc far
    
    cmp ax, bx
    jle min_is_ax
    mov ax, bx
    
min_is_ax:
    ret
    
min_value endp

code ends

end