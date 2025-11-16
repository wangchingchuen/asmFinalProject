; ============================================
; init_game.asm
; 初始化遊戲系統
; ============================================

.386
.model flat, stdcall
option casemap:none

EXTERN init_arrows@12:PROC

.data
    PUBLIC total_rounds
    total_rounds dd 10      ; 玩 10 回合

    PUBLIC boss_hp
    boss_hp     dd 25       ; Boss 需要 25 箭

.code

; ============================================
; 初始化遊戲
; 設定箭數 = 5
; 左 = +1, 右 = -1
; ============================================
PUBLIC init_game@0
init_game@0 PROC
    
    push 5      ; 初始箭數
    push 1      ; 右邊效果 = -1
    push 0      ; 左邊效果 = +1
    call init_arrows@12

    ret
init_game@0 ENDP

END
