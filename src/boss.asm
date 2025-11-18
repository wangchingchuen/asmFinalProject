; ============================================
; boss.asm
; Boss 戰鬥模組 - Windows 32-bit
; ============================================

.386
.model flat, c
option casemap:none



; 外部程序
EXTERN clear_screen:PROC
EXTERN print_string:PROC
EXTERN print_number:PROC
EXTERN set_cursor:PROC
EXTERN get_player_choice:PROC
EXTERN game_delay:PROC
EXTERN print_color_string:PROC

; 顏色常數
COLOR_RED       equ 4
COLOR_YELLOW    equ 6
COLOR_WHITE     equ 7
COLOR_GREEN     equ 2

.data
    ; Boss 狀態
    boss_health     dd 100
    boss_attack     dd 15
    boss_defense    dd 10
    boss_x          dd 40
    boss_y          dd 5
    
    ; Boss 訊息
    boss_appear     db "A WILD BOSS APPEARS!", 0
    boss_name       db "DARK OVERLORD", 0
    boss_health_txt db "Boss Health: ", 0
    boss_attack_txt db "Boss attacks for ", 0
    boss_defeat     db "BOSS DEFEATED! +500 Points!", 0
    
    ; 戰鬥選項
    attack_option   db "1. Attack", 0
    defend_option   db "2. Defend", 0
    special_option  db "3. Special Move", 0
    
    ; Boss ASCII 圖
    boss_art1       db "    /\_/\    ", 0
    boss_art2       db "   ( o.o )   ", 0
    boss_art3       db "    > ^ <    ", 0

.code

; ============================================
; 初始化 Boss
; ============================================
PUBLIC init_boss
init_boss PROC
    mov boss_health, 100
    mov boss_attack, 15
    mov boss_defense, 10
    mov boss_x, 40
    mov boss_y, 5
    ret
init_boss ENDP

; ============================================
; 處理 Boss 戰鬥
; 返回: EAX = 1(勝利) or 0(失敗)
; ============================================
PUBLIC process_boss_battle
process_boss_battle PROC
    push ebp
    mov ebp, esp
    push ebx
    push esi
    
    ; 顯示 Boss 出現
    call clear_screen
    call show_boss_appear
    
battle_loop:
    ; 檢查 Boss 血量
    cmp boss_health, 0
    jle boss_defeated
    
    ; 顯示戰鬥畫面
    call draw_boss_battle
    
    ; 玩家回合
    call player_turn
    
    ; 檢查 Boss 血量
    cmp boss_health, 0
    jle boss_defeated
    
    ; Boss 回合
    call boss_turn
    
    ; 延遲
    push 1000
    call game_delay
    
    jmp battle_loop
    
boss_defeated:
    ; 顯示勝利訊息
    call show_boss_defeat
    mov eax, 1  ; 返回勝利
    jmp battle_end
    
battle_end:
    pop esi
    pop ebx
    pop ebp
    ret
process_boss_battle ENDP

; ============================================
; 顯示 Boss 出現動畫
; ============================================
show_boss_appear PROC
    ; 顯示警告訊息
    push 30
    push 10
    call set_cursor
    
    push COLOR_RED
    push OFFSET boss_appear
    call print_color_string
    
    ; 顯示 Boss 名稱
    push 33
    push 12
    call set_cursor
    
    push COLOR_YELLOW
    push OFFSET boss_name
    call print_color_string
    
    ; 延遲
    push 2000
    call game_delay
    
    ret
show_boss_appear ENDP

; ============================================
; 繪製 Boss 戰鬥畫面
; ============================================
draw_boss_battle PROC
    call clear_screen
    
    ; 繪製 Boss ASCII 藝術
    push 35
    push 5
    call set_cursor
    push OFFSET boss_art1
    call print_string
    
    push 35
    push 6
    call set_cursor
    push OFFSET boss_art2
    call print_string
    
    push 35
    push 7
    call set_cursor
    push OFFSET boss_art3
    call print_string
    
    ; 顯示 Boss 血量
    push 30
    push 10
    call set_cursor
    push OFFSET boss_health_txt
    call print_string
    push boss_health
    call print_number
    
    ; 顯示戰鬥選項
    push 10
    push 15
    call set_cursor
    push OFFSET attack_option
    call print_string
    
    push 10
    push 16
    call set_cursor
    push OFFSET defend_option
    call print_string
    
    push 10
    push 17
    call set_cursor
    push OFFSET special_option
    call print_string
    
    ret
draw_boss_battle ENDP

; ============================================
; 玩家回合
; ============================================
player_turn PROC
    push ebx
    
    ; 取得玩家選擇
    call get_player_choice
    
    ; 根據選擇執行動作
    cmp eax, 0
    je player_attack
    jmp player_defend
    
player_attack:
    ; 計算傷害
    mov ebx, 20  ; 基礎傷害
    sub ebx, boss_defense
    cmp ebx, 0
    jg apply_damage
    mov ebx, 1  ; 最小傷害
    
apply_damage:
    sub boss_health, ebx
    cmp boss_health, 0
    jge turn_done
    mov boss_health, 0
    jmp turn_done
    
player_defend:
    ; 防禦動作
    add boss_defense, 5
    
turn_done:
    pop ebx
    ret
player_turn ENDP

; ============================================
; Boss 回合
; ============================================
boss_turn PROC
    push ebx
    
    ; Boss 攻擊訊息
    push 30
    push 20
    call set_cursor
    push OFFSET boss_attack_txt
    call print_string
    push boss_attack
    call print_number
    
    ; 延遲顯示
    push 1000
    call game_delay
    
    pop ebx
    ret
boss_turn ENDP

; ============================================
; 顯示 Boss 擊敗訊息
; ============================================
show_boss_defeat PROC
    call clear_screen
    
    push 25
    push 12
    call set_cursor
    
    push COLOR_GREEN
    push OFFSET boss_defeat
    call print_color_string
    
    push 2000
    call game_delay
    
    ret
show_boss_defeat ENDP

; ============================================
; Boss AI 行為
; ============================================
PUBLIC boss_ai
boss_ai PROC
    ; 簡單的 AI 邏輯
    ; 可以根據血量改變行為
    
    cmp boss_health, 30
    jl aggressive_mode
    
    ; 正常模式
    mov boss_attack, 15
    jmp ai_done
    
aggressive_mode:
    ; 低血量時更具攻擊性
    mov boss_attack, 25
    
ai_done:
    ret
boss_ai ENDP

END