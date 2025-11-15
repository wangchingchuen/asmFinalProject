; ============================================
; constants.asm
; 常數定義 - Windows 32-bit
; ============================================

.386
.model flat, stdcall
option casemap:none

.data
    ; 遊戲常數
    PUBLIC MAX_LIVES
    PUBLIC MAX_LEVEL
    PUBLIC SCREEN_WIDTH
    PUBLIC SCREEN_HEIGHT
    PUBLIC MAX_ENEMIES
    PUBLIC INITIAL_SCORE
    
    MAX_LIVES       dd 5
    MAX_LEVEL       dd 10
    SCREEN_WIDTH    dd 80
    SCREEN_HEIGHT   dd 25
    MAX_ENEMIES     dd 10
    INITIAL_SCORE   dd 0
    
    ; 分數常數
    PUBLIC ENEMY_POINTS
    PUBLIC BOSS_POINTS
    PUBLIC BONUS_POINTS
    
    ENEMY_POINTS    dd 10
    BOSS_POINTS     dd 100
    BONUS_POINTS    dd 50
    
    ; 時間常數 (毫秒)
    PUBLIC FRAME_DELAY
    PUBLIC INPUT_DELAY
    PUBLIC ANIMATION_SPEED
    
    FRAME_DELAY     dd 33   ; ~30 FPS
    INPUT_DELAY     dd 100
    ANIMATION_SPEED dd 200
    
    ; 遊戲狀態常數
    PUBLIC STATE_MENU
    PUBLIC STATE_PLAYING
    PUBLIC STATE_PAUSED
    PUBLIC STATE_GAMEOVER
    
    STATE_MENU      dd 0
    STATE_PLAYING   dd 1
    STATE_PAUSED    dd 2
    STATE_GAMEOVER  dd 3
    
    ; 方向常數
    PUBLIC DIR_NONE
    PUBLIC DIR_LEFT
    PUBLIC DIR_RIGHT
    PUBLIC DIR_UP
    PUBLIC DIR_DOWN
    
    DIR_NONE        dd 0
    DIR_LEFT        dd 1
    DIR_RIGHT       dd 2
    DIR_UP          dd 3
    DIR_DOWN        dd 4

.code
END