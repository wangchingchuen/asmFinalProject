; ============================================
; delay.asm
; 延遲功能模組
; ============================================

.386
.model flat, stdcall
option casemap:none

Sleep PROTO :DWORD

.code
PUBLIC game_delay@4
game_delay@4 PROC
    push ebp
    mov ebp, esp

    push [ebp+8]   ; 毫秒
    call Sleep     ; Windows API

    pop ebp
    ret 4
game_delay@4 ENDP

END
