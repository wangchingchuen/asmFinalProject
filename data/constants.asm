; ============================================
; constants.asm
; 遊戲常數定義
; ============================================

data segment public

    ; 遊戲常數
    INITIAL_SOLDIERS    equ 1       ; 初始士兵數
    TOTAL_LEVELS        equ 10      ; 總關卡數
    MAX_SOLDIERS        equ 65000   ; 最大士兵數
    
    ; Boss 數據
    BOSS_HEALTH         equ 100     ; Boss 血量
    
    ; 公式類型
    FORMULA_MULTIPLY    equ 1       ; 乘法
    FORMULA_ADD         equ 2       ; 加法
    
    ; 螢幕常數
    SCREEN_WIDTH        equ 80
    SCREEN_HEIGHT       equ 25
    
    ; 鍵盤代碼
    KEY_LEFT            equ 61h     ; 'A' 鍵
    KEY_RIGHT           equ 64h     ; 'D' 鍵
    KEY_ESC             equ 1Bh     ; ESC 鍵

data ends

end