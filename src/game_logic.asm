; ============================================
; game_logic.asm
; 遊戲邏輯模組 - Windows 32-bit
; ============================================

.386
.model flat, stdcall
option casemap:none

; Windows API
Sleep PROTO :DWORD
GetTickCount PROTO

; 外部程序
EXTERN clear_screen@0:PROC
EXTERN print_string@4:PROC
EXTERN print_number@4:PROC
EXTERN print_newline@0:PROC
EXTERN set_cursor@8:PROC
EXTERN get_player_choice@0:PROC
EXTERN wait_for_key@0:PROC
EXTERN get_arrow_key@0:PROC
EXTERN process_boss_battle@0:PROC
EXTERN game_delay@4:PROC
EXTERN print_char@4:PROC

.data
    ; 遊戲狀態
    PUBLIC game_state
    PUBLIC player_score
    PUBLIC player_lives
    PUBLIC current_level
    
    game_state      dd 0  ; 0=選單, 1=遊戲中, 2=結束
    player_score    dd 0
    player_lives    dd 3
    current_level   dd 1
    player_x        dd 40  ; 玩家X位置 (螢幕中央)
    player_y        dd 20  ; 玩家Y位置
    
    ; 遊戲訊息
    game_title      db "=== ASSEMBLY ADVENTURE ===", 0
    score_text      db "Score: ", 0
    lives_text      db "Lives: ", 0
    level_text      db "Level: ", 0
    game_over_msg   db "GAME OVER!", 0
    win_msg         db "YOU WIN!", 0
    play_again_msg  db "Play again? (Y/N): ", 0
    
    ; 遊戲物件
    enemy_count     dd 5
    enemy_x         dd 10, 20, 30, 50, 60
    enemy_y         dd 5, 8, 6, 7, 9
    enemy_active    dd 1, 1, 1, 1, 1

.code

; ============================================
; 初始化遊戲
; ============================================
PUBLIC init_game@0
init_game@0 PROC
    ; 重置遊戲狀態
    mov game_state, 1      ; 遊戲中
    mov player_score, 0
    mov player_lives, 3
    mov current_level, 1
    mov player_x, 40
    mov player_y, 20
    
    ; 重置敵人
    mov ecx, 5
    xor eax, eax
reset_enemies:
    mov enemy_active[eax*4], 1
    inc eax
    loop reset_enemies
    
    ret
init_game@0 ENDP

; ============================================
; 主遊戲迴圈
; ============================================
PUBLIC game_loop@0
game_loop@0 PROC
    push ebp
    mov ebp, esp
    
game_loop_start:
    ; 檢查遊戲狀態
    cmp game_state, 0
    je game_end
    cmp game_state, 2
    je game_end
    
    ; 清除螢幕並更新顯示
    call clear_screen@0
    call draw_game_screen
    
    ; 處理玩家輸入
    call get_arrow_key@0
    call process_player_input
    
    ; 更新遊戲邏輯
    call update_enemies
    call check_collisions
    
    ; 檢查勝利條件
    call check_win_condition
    
    ; 延遲 (控制遊戲速度)
    push 50  ; 50毫秒
    call game_delay@4
    
    jmp game_loop_start
    
game_end:
    pop ebp
    ret
game_loop@0 ENDP

; ============================================
; 繪製遊戲畫面
; ============================================
draw_game_screen PROC
    push ebx
    push esi
    
    ; 顯示標題
    push 30
    push 1
    call set_cursor@8
    push OFFSET game_title
    call print_string@4
    
    ; 顯示分數
    push 5
    push 3
    call set_cursor@8
    push OFFSET score_text
    call print_string@4
    push player_score
    call print_number@4
    
    ; 顯示生命
    push 20
    push 3
    call set_cursor@8
    push OFFSET lives_text
    call print_string@4
    push player_lives
    call print_number@4
    
    ; 顯示關卡
    push 35
    push 3
    call set_cursor@8
    push OFFSET level_text
    call print_string@4
    push current_level
    call print_number@4
    
    ; 繪製玩家 (使用 'P')
    push player_x
    push player_y
    call set_cursor@8
    push 'P'
    call print_char@4
    
    ; 繪製敵人 (使用 'E')
    xor ebx, ebx
draw_enemies:
    cmp ebx, 5
    jge done_drawing
    
    cmp enemy_active[ebx*4], 0
    je next_enemy
    
    push enemy_x[ebx*4]
    push enemy_y[ebx*4]
    call set_cursor@8
    push 'E'
    call print_char@4
    
next_enemy:
    inc ebx
    jmp draw_enemies
    
done_drawing:
    pop esi
    pop ebx
    ret
draw_game_screen ENDP

; ============================================
; 處理玩家輸入
; 輸入: EAX = 方向鍵碼
; ============================================
process_player_input PROC
    cmp eax, 0
    je no_input
    
    cmp eax, 1  ; 左
    je move_left
    cmp eax, 2  ; 右
    je move_right
    cmp eax, 3  ; 上
    je move_up
    cmp eax, 4  ; 下
    je move_down
    jmp no_input
    
move_left:
    cmp player_x, 1
    jle no_input
    dec player_x
    jmp no_input
    
move_right:
    cmp player_x, 78
    jge no_input
    inc player_x
    jmp no_input
    
move_up:
    cmp player_y, 5
    jle no_input
    dec player_y
    jmp no_input
    
move_down:
    cmp player_y, 23
    jge no_input
    inc player_y
    
no_input:
    ret
process_player_input ENDP

; ============================================
; 更新敵人位置
; ============================================
update_enemies PROC
    push ebx
    push esi
    
    ; 簡單的敵人移動邏輯
    call GetTickCount
    and eax, 1  ; 隨機方向
    
    xor ebx, ebx
update_loop:
    cmp ebx, 5
    jge update_done
    
    cmp enemy_active[ebx*4], 0
    je next_update
    
    ; 簡單移動
    test eax, 1
    jz move_enemy_left
    
    inc enemy_x[ebx*4]
    cmp enemy_x[ebx*4], 78
    jl next_update
    mov enemy_x[ebx*4], 10
    jmp next_update
    
move_enemy_left:
    dec enemy_x[ebx*4]
    cmp enemy_x[ebx*4], 1
    jg next_update
    mov enemy_x[ebx*4], 70
    
next_update:
    inc ebx
    jmp update_loop
    
update_done:
    pop esi
    pop ebx
    ret
update_enemies ENDP

; ============================================
; 檢查碰撞
; ============================================
check_collisions PROC
    push ebx
    
    xor ebx, ebx
collision_loop:
    cmp ebx, 5
    jge collision_done
    
    cmp enemy_active[ebx*4], 0
    je next_collision
    
    ; 檢查玩家與敵人碰撞
    mov eax, player_x
    cmp eax, enemy_x[ebx*4]
    jne next_collision
    
    mov eax, player_y
    cmp eax, enemy_y[ebx*4]
    jne next_collision
    
    ; 碰撞發生
    mov enemy_active[ebx*4], 0
    add player_score, 100
    dec player_lives
    
    cmp player_lives, 0
    jg next_collision
    mov game_state, 2  ; 遊戲結束
    
next_collision:
    inc ebx
    jmp collision_loop
    
collision_done:
    pop ebx
    ret
check_collisions ENDP

; ============================================
; 檢查勝利條件
; ============================================
check_win_condition PROC
    push ebx
    
    ; 檢查是否所有敵人都被消滅
    xor ebx, ebx
    xor eax, eax
check_enemies:
    cmp ebx, 5
    jge check_result
    
    add eax, enemy_active[ebx*4]
    inc ebx
    jmp check_enemies
    
check_result:
    test eax, eax
    jnz not_win
    
    ; 進入下一關
    inc current_level
    cmp current_level, 3
    jg game_complete
    
    ; 重置敵人
    mov ecx, 5
    xor ebx, ebx
reset_for_next:
    mov enemy_active[ebx*4], 1
    inc ebx
    loop reset_for_next
    jmp win_done
    
game_complete:
    mov game_state, 2
    
not_win:
win_done:
    pop ebx
    ret
check_win_condition ENDP

; ============================================
; 顯示遊戲結束畫面
; ============================================
PUBLIC show_game_over@0
show_game_over@0 PROC
    call clear_screen@0
    
    ; 顯示遊戲結束訊息
    push 35
    push 12
    call set_cursor@8
    
    cmp player_lives, 0
    jg show_win
    
    push OFFSET game_over_msg
    call print_string@4
    jmp show_score
    
show_win:
    push OFFSET win_msg
    call print_string@4
    
show_score:
    ; 顯示最終分數
    push 30
    push 14
    call set_cursor@8
    push OFFSET score_text
    call print_string@4
    push player_score
    call print_number@4
    
    call wait_for_key@0
    ret
show_game_over@0 ENDP

; ============================================
; 更新顯示
; ============================================
PUBLIC update_display@0
update_display@0 PROC
    ; 這個函數可以用來局部更新顯示
    ; 而不需要清除整個螢幕
    ret
update_display@0 ENDP

END