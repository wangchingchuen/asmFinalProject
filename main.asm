; rotating_log_anim.asm
; 旋轉木頭動畫 + 底部發射細刀，插在木頭上後以「刀形」跟著旋轉

INCLUDE Irvine32.inc

NUM_SLOTS      = 8
KNIFE_START_Y  = 22       ; 底部刀子的起始 Y（依 console 高度調整）
BOTTOM_INDEX   = 4        ; slot 中「正下方」的位置 index（對應 slotX/slotY）

.data
; slots[i] = 0 -> 沒刀, 1 -> 有刀
slots   BYTE NUM_SLOTS DUP(0)

; 螢幕中心位置（可微調）
centerX BYTE 40
centerY BYTE 12

msgTitle BYTE "=== Rotating Log + Knife Demo ===",0
msgInfo  BYTE "Knife shoots from below, sticks to the log, and rotates with it.",0

; 各 slot 在螢幕上的座標
; 排列順序：上, 右上, 右, 右下, 下, 左下, 左, 左上
slotX   BYTE 40, 43, 45, 43, 40, 37, 35, 37
slotY   BYTE  9, 10, 12, 14, 15, 14, 12, 10

; 每個 slot 的刀子朝向（0=上,1=右,2=下,3=左）
; 大概對應該 slot 在圓周上的方位
knifeOrient BYTE 0, 0, 1, 2, 2, 2, 3, 0

; 刀子狀態：
; 0 = 底部待機
; 1 = 飛行中
; 2 = 已經插在木頭上（不再畫下面那把）
knifeState   BYTE 0
knifeY       BYTE 0      ; 飛行中刀子的頂端 y
hitY         BYTE 0      ; 飛行命中判定 y
frameCounter DWORD 0     ; 等幾幀再發射

.code

; -----------------------------------------------------
; DrawCenter: 畫出中心木頭（單一字元 O）
; -----------------------------------------------------
DrawCenter PROC
    mov dl, centerX
    mov dh, centerY
    call Gotoxy

    mov al, 'O'
    call WriteChar
    ret
DrawCenter ENDP

; -----------------------------------------------------
; DrawKnifeOnLogSlot
; 依照 slot index (EBX) 以及 knifeOrient 畫一把
; 兩格～三格大小的小刀，方向會朝外（上/下/左/右）
; -----------------------------------------------------
DrawKnifeOnLogSlot PROC
    ; EBX = slot index (0~NUM_SLOTS-1)

    ; 取得此 slot 的螢幕座標 (x,y)
    movzx eax, slotX[ebx]   ; EAX = x
    movzx ecx, slotY[ebx]   ; ECX = y

    ; 取得此 slot 的方位
    mov dl, knifeOrient[ebx]

    ; 判斷方向：0=上,1=右,2=下,3=左
    cmp dl, 0
    je DrawUp
    cmp dl, 1
    je DrawRight
    cmp dl, 2
    je DrawDown
    ; 否則當作左
    jmp DrawLeft

DrawUp:
    ; 從 slot 往「外側」畫：上方向
    ; 位置1: (x, y-1) = '|'
    mov edx, 0
    mov dl, al      ; dl = x
    mov dh, cl      ; dh = y
    dec dh
    call Gotoxy
    mov al, '|'
    call WriteChar

    ; 位置2: (x, y-2) = '^'
    dec dh
    call Gotoxy
    mov al, '^'
    call WriteChar
    jmp DKOLS_End

DrawDown:
    ; 從 slot 往外畫：下方向
    ; 位置1: (x, y+1) = '|'
    mov edx, 0
    mov dl, al      ; x
    mov dh, cl      ; y
    inc dh
    call Gotoxy
    mov al, '|'
    call WriteChar

    ; 位置2: (x, y+2) = 'v'
    inc dh
    call Gotoxy
    mov al, 'v'
    call WriteChar
    jmp DKOLS_End

DrawRight:
    ; 從 slot 往外畫：右方向
    ; 位置1: (x+1, y) = '-'
    mov edx, 0
    mov dl, al      ; x
    mov dh, cl      ; y
    inc dl
    call Gotoxy
    mov al, '-'
    call WriteChar

    ; 位置2: (x+2, y) = '>'
    inc dl
    call Gotoxy
    mov al, '>'
    call WriteChar
    jmp DKOLS_End

DrawLeft:
    ; 從 slot 往外畫：左方向
    ; 位置1: (x-1, y) = '-'
    mov edx, 0
    mov dl, al      ; x
    mov dh, cl      ; y
    dec dl
    call Gotoxy
    mov al, '-'
    call WriteChar

    ; 位置2: (x-2, y) = '<'
    dec dl
    call Gotoxy
    mov al, '<'
    call WriteChar

DKOLS_End:
    ret
DrawKnifeOnLogSlot ENDP

; -----------------------------------------------------
; DrawSlots:
; 掃過 slots[]，凡是有刀 (1) 就呼叫 DrawKnifeOnLogSlot
; （不再用 '.' 或 '*' 畫點）
; -----------------------------------------------------
DrawSlots PROC
    mov ecx, NUM_SLOTS
    xor ebx, ebx            ; ebx = slot index

DrawSlotsLoop:
    mov al, slots[ebx]
    cmp al, 0
    je SkipThis

    ; 有刀，就畫這個 slot 上的刀形
    push ecx
    push ebx
    call DrawKnifeOnLogSlot
    pop ebx
    pop ecx

SkipThis:
    inc ebx
    loop DrawSlotsLoop

    ret
DrawSlots ENDP

; -----------------------------------------------------
; DrawKnife (底部/飛行中的細刀)：
;   - state = 0: 底部待機，畫在 KNIFE_START_Y
;   - state = 1: 飛行中，根據 knifeY 往上畫
;   - state = 2: 刀已插在木頭上，不再畫底部刀
; -----------------------------------------------------
DrawKnife PROC
    mov al, knifeState
    cmp al, 2
    je DK_End           ; 狀態 2 → 不畫

    ; X 固定在 centerX（木頭正下方）
    movzx eax, centerX
    mov dl, al          ; 這裡先用 AL 傳 x，有點繞，但可行
    ; 其實剛才 movzx eax, centerX，AL = centerX, 所以：
    mov dl, al          ; DL = centerX

    ; 決定刀子頂端 Y
    mov al, knifeState
    cmp al, 1
    jne UseStartY       ; 不是飛行中就用起始 Y

    ; state == 1, 飛行中
    mov al, knifeY
    jmp short HaveY

UseStartY:
    mov al, KNIFE_START_Y

HaveY:
    mov bl, al          ; BL = baseY (第一段)

    ; 第一段：上面刀身 '|'
    mov dh, bl
    call Gotoxy
    mov al, '|'
    call WriteChar

    ; 第二段：中間刀身 '|'
    inc bl
    mov dh, bl
    call Gotoxy
    mov al, '|'
    call WriteChar

    ; 第三段：最下方刀尖 '^'
    inc bl
    mov dh, bl
    call Gotoxy
    mov al, '^'
    call WriteChar

DK_End:
    ret
DrawKnife ENDP

; -----------------------------------------------------
; RotateSlotsRight: slots 陣列向右旋轉一格
; [a,b,c,d,e,f,g,h] -> [h,a,b,c,d,e,f,g]
; -----------------------------------------------------
RotateSlotsRight PROC
    lea esi, slots

    mov ecx, NUM_SLOTS
    dec ecx                 ; ecx = NUM_SLOTS - 1

    mov bl, [esi+ecx]       ; 暫存最後一格

RotateShiftLoop:
    mov al, [esi+ecx-1]
    mov [esi+ecx], al
    dec ecx
    jnz RotateShiftLoop

    mov [esi], bl           ; 最後一格放到 slots[0]

    ret
RotateSlotsRight ENDP

; -----------------------------------------------------
; UpdateKnife: 更新刀子狀態（自動發射一次，插入木頭下方）
; -----------------------------------------------------
UpdateKnife PROC
    mov al, knifeState
    cmp al, 0
    je StateIdle
    cmp al, 1
    je StateFlying
    jmp UK_End              ; state 2 -> 不用更新

StateIdle:
    ; 等幾幀再發射（讓你先看見畫面）
    mov eax, frameCounter
    inc eax
    mov frameCounter, eax
    cmp eax, 15             ; 等 15 幀左右再發射
    jb UK_End               ; 還沒到就不發射

    ; 開始發射
    mov knifeState, 1
    mov knifeY, KNIFE_START_Y
    jmp UK_End

StateFlying:
    ; 往上移動（Y--）
    mov al, knifeY
    dec al
    mov knifeY, al

    ; 檢查是否到達命中高度（hitY）
    mov bl, hitY
    cmp al, bl
    ja UK_End               ; 還在木頭下面，繼續飛

    ; 命中：刀子插入木頭下方 slot
    mov knifeState, 2
    mov BYTE PTR slots[BOTTOM_INDEX], 1

UK_End:
    ret
UpdateKnife ENDP

; -----------------------------------------------------
; main: 初始化 + 旋轉動畫主迴圈
; -----------------------------------------------------
main PROC
    ; 初始化 slots = 0
    lea edi, slots
    mov ecx, NUM_SLOTS
InitSlots:
    mov BYTE PTR [edi], 0
    inc edi
    loop InitSlots

    ; 初始化刀子狀態
    mov knifeState, 0
    mov frameCounter, 0
    mov knifeY, KNIFE_START_Y

    ; 命中高度 = 木頭下方 slot 的 y-1
    mov al, slotY[BOTTOM_INDEX]
    dec al
    mov hitY, al

AnimationLoop:
    call Clrscr

    mov edx, OFFSET msgTitle
    call WriteString
    call Crlf

    mov edx, OFFSET msgInfo
    call WriteString
    call Crlf
    call Crlf

    ; 畫木頭中心 & 插在木頭上的刀
    call DrawCenter
    call DrawSlots

    ; 畫底部 / 飛行中的細刀
    call DrawKnife

    ; 延遲一點時間（控制動畫速度）
    mov eax, 80
    call Delay

    ; 木頭上的刀旋轉
    call RotateSlotsRight

    ; 更新刀子狀態（自動發射一次）
    call UpdateKnife

    jmp AnimationLoop
main ENDP

END main