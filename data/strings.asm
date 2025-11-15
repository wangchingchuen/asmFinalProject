; ============================================
; strings.asm
; 字串資料 - Windows 32-bit
; ============================================

.386
.model flat, stdcall
option casemap:none

.data
    ; 遊戲標題
    PUBLIC game_title_str
    PUBLIC version_str
    
    game_title_str  db "ASSEMBLY ADVENTURE v1.0", 0
    version_str     db "Windows 32-bit Edition", 0
    
    ; 選單字串
    PUBLIC menu_title
    PUBLIC menu_start
    PUBLIC menu_help
    PUBLIC menu_quit
    PUBLIC menu_select
    
    menu_title      db "===== MAIN MENU =====", 0
    menu_start      db "1. Start Game", 0
    menu_help       db "2. Help", 0
    menu_quit       db "3. Quit", 0
    menu_select     db "Select option: ", 0
    
    ; 遊戲訊息
    PUBLIC msg_welcome
    PUBLIC msg_gameover
    PUBLIC msg_win
    PUBLIC msg_pause
    PUBLIC msg_continue
    
    msg_welcome     db "Welcome to Assembly Adventure!", 0
    msg_gameover    db "GAME OVER! Thanks for playing!", 0
    msg_win         db "CONGRATULATIONS! You Won!", 0
    msg_pause       db "Game Paused. Press any key to continue...", 0
    msg_continue    db "Press ENTER to continue...", 0
    
    ; 狀態訊息
    PUBLIC msg_score
    PUBLIC msg_lives
    PUBLIC msg_level
    PUBLIC msg_health
    
    msg_score       db "Score: ", 0
    msg_lives       db "Lives: ", 0
    msg_level       db "Level: ", 0
    msg_health      db "Health: ", 0
    
    ; 說明文字
    PUBLIC help_title
    PUBLIC help_controls
    PUBLIC help_objective
    PUBLIC help_arrows
    PUBLIC help_space
    PUBLIC help_esc
    
    help_title      db "===== GAME HELP =====", 0
    help_controls   db "Controls:", 0
    help_objective  db "Objective: Defeat all enemies and the boss!", 0
    help_arrows     db "Arrow Keys - Move", 0
    help_space      db "Space - Attack", 0
    help_esc        db "ESC - Pause/Menu", 0
    
    ; 錯誤訊息
    PUBLIC err_invalid
    PUBLIC err_file
    PUBLIC err_memory
    
    err_invalid     db "Invalid input! Please try again.", 0
    err_file        db "Error: Cannot load file.", 0
    err_memory      db "Error: Not enough memory.", 0
    
    ; 戰鬥訊息
    PUBLIC battle_start
    PUBLIC battle_attack
    PUBLIC battle_defend
    PUBLIC battle_special
    PUBLIC battle_damage
    PUBLIC battle_miss
    
    battle_start    db "Battle begins!", 0
    battle_attack   db "You attack!", 0
    battle_defend   db "You defend!", 0
    battle_special  db "Special move!", 0
    battle_damage   db " damage dealt!", 0
    battle_miss     db "Attack missed!", 0

.code
END