; ============================================
; delay.asm
; 延遲和輔助函數
; ============================================

.model small

data segment public
    delay_counter   dw 0
data ends

code segment public

    extrn wait_for_key:far
    
    assume cs:code, ds:data

; ═══════════════════════════════════════
; 延遲常式 (約 1 秒)
; ═══════════════════════════════════════
public delay_routine

delay_routine proc far
    
    push ax
    push bx
    push cx
    push dx
    
    ; 簡單的迴圈延遲
    mov cx, 5                       ; 外迴圈計數
    
delay_outer_loop:
    mov bx, 65535                   ; 內迴圈計數
    
delay_inner_loop:
    dec bx
    jnz delay_inner_loop
    
    loop delay_outer_loop
    
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret
    
delay_routine endp

; ═══════════════════════════════════════
; 快速延遲 (約 0.1 秒)
; ═══════════════════════════════════════
public quick_delay

quick_delay proc far
    
    push bx
    
    mov bx, 10000
    
quick_delay_loop:
    dec bx
    jnz quick_delay_loop
    
    pop bx
    
    ret
    
quick_delay endp

code ends

end