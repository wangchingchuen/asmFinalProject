; ============================================
; constants.asm - 全域常數定義
; ============================================

.386
option casemap:none

; ----------------------
; 不會變動的常數（建議 EQU）
; ----------------------
MAX_LIVES       EQU 5
MAX_LEVEL       EQU 10

SCREEN_WIDTH    EQU 80
SCREEN_HEIGHT   EQU 25

MAX_ENEMIES     EQU 10

ENEMY_POINTS    EQU 10
BOSS_POINTS     EQU 100
BONUS_POINTS    EQU 50

; 遊戲狀態
STATE_MENU      EQU 0
STATE_PLAYING   EQU 1
STATE_PAUSED    EQU 2
STATE_GAMEOVER  EQU 3

; 方向常數
DIR_NONE        EQU 0
DIR_LEFT        EQU 1
DIR_RIGHT       EQU 2
DIR_UP          EQU 3
DIR_DOWN        EQU 4

; ----------------------
; 可能由遊戲調整的變數（保留 dd）
; ----------------------
.data
    PUBLIC FRAME_DELAY
    PUBLIC INPUT_DELAY
    PUBLIC ANIMATION_SPEED
    PUBLIC INITIAL_SCORE
    
    FRAME_DELAY     dd 33
    INPUT_DELAY     dd 100
    ANIMATION_SPEED dd 200
    INITIAL_SCORE   dd 0

END
