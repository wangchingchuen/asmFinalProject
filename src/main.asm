; ============================================
; main.asm
; 遊戲主程式和主控制迴圈
; ============================================

.model small
.stack 256

; 引入其他模組
include constants.asm
include strings.asm
include levels.asm

data segment public
    
    ; 遊戲狀態變數
    current_level       db 0        ; 當前關卡 (0-9)
    soldier_count       dw 1        ; 士兵數量
    current_choice      db 0        ; 玩家選擇 (0=左, 1=右)
    temp_result         dw 0        ; 暫存計算結果
    
data ends

code segment public

    extrn display_title:far
    extrn display_level_info:far
    extrn get_player_choice:far
    extrn apply_formula:far
    extrn display_result:far
    extrn delay_routine:far
    extrn boss_battle:far
    extrn show_victory:far
    extrn show_defeat:far
    extrn clear_screen:far
    extrn print_string:far

    assume cs:code, ds:data

; ═══════════════════════════════════════
; 主程式入口
; ═══════════════════════════════════════
main proc far
    
    mov ax, data
    mov ds, ax
    
    ; 清屏並顯示標題
    call clear_screen
    call display_title
    
    ; 初始化遊戲
    mov current_level, 0
    mov soldier_count, 1
    mov current_choice, 0
    
    ; ─────────────────────────────────
    ; 主遊戲迴圈 (10關)
    ; ─────────────────────────────────
game_loop:
    
    ; 檢查是否完成10關
    cmp current_level, 10
    jae boss_battle_start
    
    ; 清屏顯示關卡資訊
    call clear_screen
    call display_level_info
    
    ; 等待玩家輸入
    call get_player_choice
    mov current_choice, al          ; AL = 0(左) or 1(右)
    
    ; 根據選擇計算士兵數量
    call apply_formula
    
    ; 顯示結果
    call display_result
    
    ; 暫停
    call delay_routine
    
    ; 進入下一關
    inc current_level
    jmp game_loop
    
    ; ─────────────────────────────────
    ; Boss 戰鬥
    ; ─────────────────────────────────
boss_battle_start:
    call clear_screen
    call boss_battle
    
    ; 檢查士兵是否存活
    cmp soldier_count, 0
    je game_over_lose
    
    ; Boss 被擊敗 - 勝利
    call show_victory
    jmp end_game
    
game_over_lose:
    call show_defeat
    
end_game:
    ; 等待按鍵後結束
    mov ah, 00h
    int 16h
    
    ; 回到 DOS
    mov ax, 4c00h
    int 21h
    
main endp

code ends

end main