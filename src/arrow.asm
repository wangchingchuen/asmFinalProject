; ============================================
; arrows.asm
; 管理玩家箭數、左右選項效果
; ============================================

.386
.model flat, stdcall
option casemap:none

EXTERN print_string@4:PROC
EXTERN print_number@4:PROC
EXTERN set_cursor@8:PROC

.data
    ; 玩家箭數
    PUBLIC arrow_count
    arrow_count     dd 0

    ; 左右選項效果類型 (0=+1, 1=-1, 2=*2, 3=/2, 4=+5, 5=-3 ...)
    PUBLIC left_type
    PUBLIC right_type
    left_type       dd 0
    right_type      dd 0

    ; 對應顯示文字
    effect_texts    dd OFFSET eff_add1     ; 0
                    dd OFFSET eff_sub1     ; 1
                    dd OFFSET eff_mul2     ; 2
                    dd OFFSET eff_div2     ; 3
                    dd OFFSET eff_add5     ; 4
                    dd OFFSET eff_sub3     ; 5

    eff_add1        db "+1", 0
    eff_sub1        db "-1", 0
    eff_mul2        db "x2", 0
    eff_div2        db "/2", 0
    eff_add5        db "+5", 0
    eff_sub3        db "-3", 0

.code

; ============================================
; 初始化箭數與左右效果
; 輸入：EAX = 左效果類型, EBX = 右效果類型, ECX = 初始箭數
; ============================================
PUBLIC init_arrows@12
init_arrows@12 PROC
    push ebp
    mov ebp, esp

    mov eax, [ebp+8]
    mov left_type, eax

    mov eax, [ebp+12]
    mov right_type, eax

    mov eax, [ebp+16]
    mov arrow_count, eax

    pop ebp
    ret 12
init_arrows@12 ENDP

; ============================================
; 顯示箭數 & 左右選項
; ============================================
PUBLIC display_arrow_info@0
display_arrow_info@0 PROC

    ; 顯示：Arrows: X
    push 5        ; X 座標
    push 3        ; Y 座標
    call set_cursor@8
    push OFFSET arrow_label
    call print_string@4
    push dword ptr arrow_count
    call print_number@4

    ; 顯示左選項
    push 10
    push 6
    call set_cursor@8
    mov eax, left_type
    shl eax, 2
    push effect_texts[eax]
    call print_string@4

    ; 顯示右選項
    push 30
    push 6
    call set_cursor@8
    mov eax, right_type
    shl eax, 2
    push effect_texts[eax]
    call print_string@4

    ret
display_arrow_info@0 ENDP

; 顯示標籤文字
arrow_label db "Arrows: ", 0

; ============================================
; 套用左右選項效果
; 輸入：EAX = 0 (左) 或 1 (右)
; 目的：更新 arrow_count
; ============================================

EXTERN add_numbers@8:PROC
EXTERN sub_numbers@8:PROC
EXTERN mul_numbers@8:PROC
EXTERN div_numbers@8:PROC

PUBLIC apply_effect@4
apply_effect@4 PROC
    push ebp
    mov  ebp, esp
    push ebx

    ; 取得輸入：0 = 左，1 = 右
    mov eax, [ebp+8]

    cmp eax, 0
    je apply_left
    cmp eax, 1
    je apply_right
    jmp done        ; 非法輸入就忽略

; ---------------------------
; 套用左邊效果
; ---------------------------
apply_left:
    mov eax, left_type
    jmp do_effect

; ---------------------------
; 套用右邊效果
; ---------------------------
apply_right:
    mov eax, right_type

; ============================================
; 根據效果類型來計算
; eax = 效果類型
; ============================================
do_effect:
    cmp eax, 0
    je eff_add1_lbl
    cmp eax, 1
    je eff_sub1_lbl
    cmp eax, 2
    je eff_mul2_lbl
    cmp eax, 3
    je eff_div2_lbl
    cmp eax, 4
    je eff_add5_lbl
    cmp eax, 5
    je eff_sub3_lbl
    jmp done

; ------ (+1)
eff_add1_lbl:
    push 1
    push dword ptr arrow_count
    call add_numbers@8
    mov arrow_count, eax
    jmp done

; ------ (-1)
eff_sub1_lbl:
    push 1
    push dword ptr arrow_count
    call sub_numbers@8
    mov arrow_count, eax
    jmp done

; ------ (x2)
eff_mul2_lbl:
    push 2
    push dword ptr arrow_count
    call mul_numbers@8
    mov arrow_count, eax
    jmp done

; ------ (/2)
eff_div2_lbl:
    push 2
    push dword ptr arrow_count
    call div_numbers@8
    mov arrow_count, eax
    jmp done

; ------ (+5)
eff_add5_lbl:
    push 5
    push dword ptr arrow_count
    call add_numbers@8
    mov arrow_count, eax
    jmp done

; ------ (-3)
eff_sub3_lbl:
    push 3
    push dword ptr arrow_count
    call sub_numbers@8
    mov arrow_count, eax
    jmp done

done:
    pop ebx
    pop ebp
    ret 4
apply_effect@4 ENDP

END