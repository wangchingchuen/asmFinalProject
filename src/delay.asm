; ============================================
; delay.asm
; 延遲功能模組
; ============================================

.386
.model flat, c
option casemap:none



Sleep PROTO :DWORD

.code
PUBLIC game_delay
game_delay PROC
    push ebp
    mov ebp, esp

    push [ebp+8]   ; 毫秒
    call Sleep     ; Windows API

    pop ebp
    ret 4
game_delay ENDP

END
