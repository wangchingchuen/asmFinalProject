; ============================================
; round.asm
; 一回合流程：顯示 → 等輸入 → 套用效果
; ============================================

.386
.model flat, c
option casemap:none



EXTERN display_arrow_info:PROC
EXTERN get_player_choice:PROC
EXTERN apply_effect:PROC
EXTERN clear_screen:PROC
EXTERN print_string:PROC
EXTERN set_cursor:PROC
EXTERN print_number:PROC

.data
    round_msg db "Round: ", 0

    PUBLIC current_round
    current_round dd 1

.code

; ============================================
; 執行一回合
; ============================================
PUBLIC play_round
play_round PROC

    call clear_screen

    ; 顯示 Round X
    push 10
    push 2
    call set_cursor

    push OFFSET round_msg
    call print_string

    push current_round
    call print_number

    ; 顯示箭數與選項
    call display_arrow_info

    ; 等玩家輸入：0=左, 1=右
    call get_player_choice

    ; 套用效果
    push eax
    call apply_effect

    ; 下一回合
    inc current_round

    ret
play_round ENDP

END
