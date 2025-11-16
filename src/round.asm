; ============================================
; round.asm
; 一回合流程：顯示 → 等輸入 → 套用效果
; ============================================

.386
.model flat, stdcall
option casemap:none

EXTERN display_arrow_info@0:PROC
EXTERN get_player_choice@0:PROC
EXTERN apply_effect@4:PROC
EXTERN clear_screen@0:PROC
EXTERN print_string@4:PROC
EXTERN set_cursor@8:PROC

.data
    round_msg db "Round: ", 0

    PUBLIC current_round
    current_round dd 1

.code

; ============================================
; 執行一回合
; ============================================
PUBLIC play_round@0
play_round@0 PROC

    call clear_screen@0

    ; 顯示 Round X
    push 10
    push 2
    call set_cursor@8

    push OFFSET round_msg
    call print_string@4

    push current_round
    call print_number@4

    ; 顯示箭數與選項
    call display_arrow_info@0

    ; 等玩家輸入：0=左, 1=右
    call get_player_choice@0

    ; 套用效果
    push eax
    call apply_effect@4

    ; 下一回合
    inc current_round

    ret
play_round@0 ENDP

END
