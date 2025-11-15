; ============================================
; boss.asm
; Boss 戰鬥模組 - 最終戰鬥邏輯
; ============================================

.model small

include constants.asm
include strings.asm

data segment public
    boss_health     dw BOSS_HEALTH
    damage_dealt    dw 0
    round_count     db 0
data ends

code segment public

    extrn print_string:far
    extrn print_number:far
    extrn print_newline:far
    extrn delay_routine:far
    
    assume cs:code, ds:data

; ═══════════════════════════════════════
; Boss 戰鬥主程序
; ═══════════════════════════════════════
public boss_battle

boss_battle proc far
    
    push ax
    push bx
    push cx
    
    ; 初始化 Boss 血量
    mov boss_health, BOSS_HEALTH
    mov round_count, 0
    
    call print_newline
    lea dx, boss_title
    call print_string
    call print_newline
    call print_newline
    
    ; ─────────────────────────────────
    ; Boss 戰鬥迴圈
    ; ─────────────────────────────────
boss_battle_loop:
    
    inc round_count
    
    ; 顯示狀態
    lea dx, boss_health_str
    call print_string
    mov ax, boss_health
    call print_number
    call print_newline
    
    lea dx, your_soldiers_str
    call print_string
    mov ax, soldier_count
    call print_number
    call print_newline
    
    call print_newline
    
    ; 計算傷害 (士兵數 = 傷害)
    mov ax, soldier_count
    mov damage_dealt, ax
    
    ; 對 Boss 造成傷害
    lea dx, attacking_str
    call print_string
    call print_newline
    
    mov ax, boss_health
    sub ax, damage_dealt
    
    ; 檢查是否為負數
    cmp ax, 0
    jge boss_still_alive
    
    ; Boss 被擊敗
    mov boss_health, 0
    jmp boss_defeated
    
boss_still_alive:
    mov boss_health, ax
    
    ; Boss 反擊 (造成 10 點傷害)
    mov ax, soldier_count
    cmp ax, 10
    jbe soldier_all_dead
    
    sub soldier_count, 10
    
    lea dx, separator_line
    call print_string
    call print_newline
    
    call delay_routine
    jmp boss_battle_loop
    
soldier_all_dead:
    mov soldier_count, 0
    
boss_defeated:
    
    pop cx
    pop bx
    pop ax
    
    ret
    
boss_battle endp

; ═══════════════════════════════════════
; 顯示勝利訊息
; ═══════════════════════════════════════
public show_victory

show_victory proc far
    
    call print_newline
    call print_newline
    
    lea dx, victory_str
    call print_string
    call print_newline
    
    lea dx, victory_str2
    call print_string
    call print_newline
    
    lea dx, victory_str3
    call print_string
    call print_newline
    
    ret
    
show_victory endp

; ═══════════════════════════════════════
; 顯示失敗訊息
; ═══════════════════════════════════════
public show_defeat

show_defeat proc far
    
    call print_newline
    call print_newline
    
    lea dx, defeat_str
    call print_string
    call print_newline
    
    lea dx, defeat_str2
    call print_string
    call print_newline
    
    lea dx, defeat_str3
    call print_string
    call print_newline
    
    ret
    
show_defeat endp

code ends

end