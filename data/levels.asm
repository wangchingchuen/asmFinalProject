; ============================================
; levels.asm - 關卡資料 (重製版，支援 2D 地圖)
; ============================================

.386
.model flat, stdcall
option casemap:none

; --------------------------------------------------
; 地圖常數（你之後 display.asm、game_logic.asm 都會用）
; --------------------------------------------------
MAP_ROWS EQU 11
MAP_COLS EQU 32

.data

    ; --------------------------------------------------
    ; 關卡數量
    ; --------------------------------------------------
    PUBLIC level_count
    level_count     dd 5

    ; --------------------------------------------------
    ; 關卡資料
    ; 格式: 敵人數量, Boss血量, 時間限制(秒), 獎勵分數
    ; --------------------------------------------------
    PUBLIC level_data
    level_data      dd 3, 50, 60, 100    ; Level 1
                    dd 5, 75, 50, 200    ; Level 2
                    dd 7, 100, 45, 300   ; Level 3
                    dd 9, 125, 40, 400   ; Level 4
                    dd 12,150, 35, 500   ; Level 5

    ; --------------------------------------------------
    ; 關卡名稱
    ; --------------------------------------------------
    PUBLIC level_names
    level_names     dd OFFSET level1_name
                    dd OFFSET level2_name
                    dd OFFSET level3_name
                    dd OFFSET level4_name
                    dd OFFSET level5_name

    level1_name     db "The Beginning",0
    level2_name     db "Dark Forest",0
    level3_name     db "Haunted Castle",0
    level4_name     db "Dragon's Lair",0
    level5_name     db "Final Showdown",0

    ; --------------------------------------------------
    ; 敵人參數資料
    ; 格式: HP, ATK, DEF, SPD (全 DWORD)
    ; --------------------------------------------------
    PUBLIC enemy_types
    PUBLIC enemy_names

    enemy_types     dd 10, 5,  2, 1     ; Goblin
                    dd 20, 8,  4, 2     ; Orc
                    dd 30, 12, 6, 1     ; Troll
                    dd 15, 10, 3, 3     ; Wolf
                    dd 25, 15, 5, 2     ; Knight

    enemy_names     dd OFFSET goblin_name
                    dd OFFSET orc_name
                    dd OFFSET troll_name
                    dd OFFSET wolf_name
                    dd OFFSET knight_name

    goblin_name     db "Goblin",0
    orc_name        db "Orc",0
    troll_name      db "Troll",0
    wolf_name       db "Wolf",0
    knight_name     db "Dark Knight",0

    ; --------------------------------------------------
    ; Boss 資料
    ; 格式: HP, ATK, DEF, SPECIAL
    ; --------------------------------------------------
    PUBLIC boss_data
    PUBLIC boss_names

    boss_data       dd 50,  15, 10, 25
                    dd 75,  20, 12, 30
                    dd 100, 25, 15, 35
                    dd 125, 30, 18, 40
                    dd 150, 35, 20, 50

    boss_names      dd OFFSET boss1_name
                    dd OFFSET boss2_name
                    dd OFFSET boss3_name
                    dd OFFSET boss4_name
                    dd OFFSET boss5_name

    boss1_name      db "Shadow Guardian",0
    boss2_name      db "Forest Demon",0
    boss3_name      db "Castle Lord",0
    boss4_name      db "Ancient Dragon",0
    boss5_name      db "Dark Overlord",0

    ; --------------------------------------------------
    ; 地圖資料（重製成真正的 2D 地圖）
    ; 每行字串長度固定 32（MAP_COLS）
    ; 沒有 0 結尾，不會中斷地圖
    ; --------------------------------------------------
    PUBLIC map_data

map_data db \
"################################",\
"#P.............................#",\
"#......E.....E.....E...........#",\
"#..............................#",\
"#...........###########........#",\
"#......E....#.........#....E...#",\
"#...........#....B....#........#",\
"#...........#.........#........#",\
"#...........###########........#",\
"#..............................#",\
"################################"

.code

; ============================================
; get_level_data(level)
; 回傳：EAX=敵人數, EBX=Boss血, ECX=時間, EDX=獎勵
; ============================================
PUBLIC get_level_data@4
get_level_data@4 PROC
    push ebp
    mov ebp, esp
    push esi

    mov eax, [ebp+8]    ; level index

    ; 範圍檢查：0 ~ level_count-1
    cmp eax, level_count
    jae invalid_level

    ; 每關 16 bytes（4 DWORD）
    imul eax, 16
    lea esi, level_data
    add esi, eax

    mov eax, [esi]        ; 敵人數
    mov ebx, [esi+4]      ; Boss HP
    mov ecx, [esi+8]      ; 時間
    mov edx, [esi+12]     ; 獎勵
    jmp done

invalid_level:
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

done:
    pop esi
    pop ebp
    ret 4
get_level_data@4 ENDP

; ============================================
; get_level_name(level)
; 回傳 EAX = 字串位址
; ============================================
PUBLIC get_level_name@4
get_level_name@4 PROC
    push ebp
    mov ebp, esp

    mov eax, [ebp+8]

    cmp eax, level_count
    jae bad_name

    shl eax, 2
    mov eax, level_names[eax]
    jmp ok

bad_name:
    xor eax, eax

ok:
    pop ebp
    ret 4
get_level_name@4 ENDP

END
