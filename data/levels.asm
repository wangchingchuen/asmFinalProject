; ============================================
; levels.asm
; 關卡資料 - Windows 32-bit
; ============================================

.386
.model flat, stdcall
option casemap:none

.data
    ; 關卡資料結構
    ; 每個關卡包含：敵人數量、Boss 血量、時間限制等
    
    PUBLIC level_data
    PUBLIC level_names
    PUBLIC level_count
    
    level_count     dd 5
    
    ; 關卡資料陣列
    ; 格式: 敵人數量, Boss血量, 時間限制(秒), 獎勵分數
    level_data      dd 3, 50, 60, 100    ; Level 1
                    dd 5, 75, 50, 200    ; Level 2
                    dd 7, 100, 45, 300   ; Level 3
                    dd 9, 125, 40, 400   ; Level 4
                    dd 12, 150, 35, 500  ; Level 5
    
    ; 關卡名稱
    level_names     dd OFFSET level1_name
                    dd OFFSET level2_name
                    dd OFFSET level3_name
                    dd OFFSET level4_name
                    dd OFFSET level5_name
    
    level1_name     db "The Beginning", 0
    level2_name     db "Dark Forest", 0
    level3_name     db "Haunted Castle", 0
    level4_name     db "Dragon's Lair", 0
    level5_name     db "Final Showdown", 0
    
    ; 敵人類型資料
    PUBLIC enemy_types
    PUBLIC enemy_names
    
    ; 格式: 血量, 攻擊力, 防禦力, 速度
    enemy_types     dd 10, 5, 2, 1     ; Goblin
                    dd 20, 8, 4, 2     ; Orc
                    dd 30, 12, 6, 1    ; Troll
                    dd 15, 10, 3, 3    ; Wolf
                    dd 25, 15, 5, 2    ; Knight
    
    enemy_names     dd OFFSET goblin_name
                    dd OFFSET orc_name
                    dd OFFSET troll_name
                    dd OFFSET wolf_name
                    dd OFFSET knight_name
    
    goblin_name     db "Goblin", 0
    orc_name        db "Orc", 0
    troll_name      db "Troll", 0
    wolf_name       db "Wolf", 0
    knight_name     db "Dark Knight", 0
    
    ; Boss 資料
    PUBLIC boss_data
    PUBLIC boss_names
    
    ; 格式: 血量, 攻擊力, 防禦力, 特殊攻擊
    boss_data       dd 50, 15, 10, 25    ; Level 1 Boss
                    dd 75, 20, 12, 30    ; Level 2 Boss
                    dd 100, 25, 15, 35   ; Level 3 Boss
                    dd 125, 30, 18, 40   ; Level 4 Boss
                    dd 150, 35, 20, 50   ; Level 5 Boss
    
    boss_names      dd OFFSET boss1_name
                    dd OFFSET boss2_name
                    dd OFFSET boss3_name
                    dd OFFSET boss4_name
                    dd OFFSET boss5_name
    
    boss1_name      db "Shadow Guardian", 0
    boss2_name      db "Forest Demon", 0
    boss3_name      db "Castle Lord", 0
    boss4_name      db "Ancient Dragon", 0
    boss5_name      db "Dark Overlord", 0
    
    ; 地圖資料 (簡化版，用字元表示)
    PUBLIC map_data
    
    ; # = 牆壁, . = 空地, E = 敵人, B = Boss, P = 玩家起始點
    map_data        db "################################", 0
                    db "#P.............................#", 0
                    db "#......E.....E.....E...........#", 0
                    db "#..............................#", 0
                    db "#...........###########........#", 0
                    db "#......E....#.........#....E...#", 0
                    db "#...........#....B....#........#", 0
                    db "#...........#.........#........#", 0
                    db "#...........###########........#", 0
                    db "#..............................#", 0
                    db "################################", 0

.code

; ============================================
; 取得關卡資料
; 輸入: EAX = 關卡編號 (0-based)
; 返回: EAX = 敵人數量, EBX = Boss血量, 
;       ECX = 時間限制, EDX = 獎勵分數
; ============================================
PUBLIC get_level_data@4
get_level_data@4 PROC
    push ebp
    mov ebp, esp
    push esi
    
    mov eax, [ebp+8]  ; 關卡編號
    
    ; 檢查範圍
    cmp eax, level_count
    jae invalid_level
    
    ; 計算偏移 (每個關卡 4 個 DWORD)
    shl eax, 4  ; 乘以 16
    lea esi, level_data
    add esi, eax
    
    ; 讀取資料
    mov eax, [esi]      ; 敵人數量
    mov ebx, [esi+4]    ; Boss血量
    mov ecx, [esi+8]    ; 時間限制
    mov edx, [esi+12]   ; 獎勵分數
    jmp get_done
    
invalid_level:
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    
get_done:
    pop esi
    pop ebp
    ret 4
get_level_data@4 ENDP

; ============================================
; 取得關卡名稱
; 輸入: EAX = 關卡編號
; 返回: EAX = 名稱字串位址
; ============================================
PUBLIC get_level_name@4
get_level_name@4 PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]
    
    ; 檢查範圍
    cmp eax, level_count
    jae invalid_name
    
    ; 取得名稱位址
    shl eax, 2  ; 乘以 4
    mov eax, level_names[eax]
    jmp name_done
    
invalid_name:
    xor eax, eax
    
name_done:
    pop ebp
    ret 4
get_level_name@4 ENDP

END