; ============================================
; math.asm
; 數學運算模組 - Windows 32-bit
; ============================================

.386
.model flat, stdcall
option casemap:none

.data
    seed    dd 12345678h  ; 隨機數種子

.code

; ============================================
; 加法
; 輸入: EAX = 第一個數, EBX = 第二個數
; 返回: EAX = 結果
; ============================================
PUBLIC add_numbers@8
add_numbers@8 PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]
    add eax, [ebp+12]
    
    pop ebp
    ret 8
add_numbers@8 ENDP

; ============================================
; 減法
; 輸入: EAX = 被減數, EBX = 減數
; 返回: EAX = 結果
; ============================================
PUBLIC sub_numbers@8
sub_numbers@8 PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]
    sub eax, [ebp+12]
    
    pop ebp
    ret 8
sub_numbers@8 ENDP

; ============================================
; 乘法
; 輸入: EAX = 第一個數, EBX = 第二個數
; 返回: EAX = 結果
; ============================================
PUBLIC mul_numbers@8
mul_numbers@8 PROC
    push ebp
    mov ebp, esp
    push ebx
    
    mov eax, [ebp+8]
    mov ebx, [ebp+12]
    mul ebx
    
    pop ebx
    pop ebp
    ret 8
mul_numbers@8 ENDP

; ============================================
; 除法
; 輸入: EAX = 被除數, EBX = 除數
; 返回: EAX = 商, EDX = 餘數
; ============================================
PUBLIC div_numbers@8
div_numbers@8 PROC
    push ebp
    mov ebp, esp
    push ebx
    
    mov eax, [ebp+8]
    xor edx, edx
    mov ebx, [ebp+12]
    
    ; 檢查除零
    test ebx, ebx
    jz div_by_zero
    
    div ebx
    jmp div_done
    
div_by_zero:
    xor eax, eax
    xor edx, edx
    
div_done:
    pop ebx
    pop ebp
    ret 8
div_numbers@8 ENDP

; ============================================
; 取模運算
; 輸入: EAX = 被除數, EBX = 除數
; 返回: EAX = 餘數
; ============================================
PUBLIC mod_numbers@8
mod_numbers@8 PROC
    push ebp
    mov ebp, esp
    push ebx
    
    mov eax, [ebp+8]
    xor edx, edx
    mov ebx, [ebp+12]
    
    test ebx, ebx
    jz mod_zero
    
    div ebx
    mov eax, edx  ; 返回餘數
    jmp mod_done
    
mod_zero:
    xor eax, eax
    
mod_done:
    pop ebx
    pop ebp
    ret 8
mod_numbers@8 ENDP

; ============================================
; 生成隨機數
; 輸入: EAX = 最大值
; 返回: EAX = 0 到 最大值-1 的隨機數
; ============================================
PUBLIC random@4
random@4 PROC
    push ebp
    mov ebp, esp
    push ebx
    push edx
    
    ; 線性同餘生成器 (LCG)
    ; seed = (seed * 1103515245 + 12345) & 0x7FFFFFFF
    
    mov eax, seed
    mov ebx, 1103515245
    mul ebx
    add eax, 12345
    and eax, 7FFFFFFFh
    mov seed, eax
    
    ; 取模得到範圍內的值
    xor edx, edx
    div DWORD PTR [ebp+8]
    mov eax, edx
    
    pop edx
    pop ebx
    pop ebp
    ret 4
random@4 ENDP

; ============================================
; 設定隨機數種子
; 輸入: EAX = 新種子
; ============================================
PUBLIC set_seed@4
set_seed@4 PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]
    mov seed, eax
    
    pop ebp
    ret 4
set_seed@4 ENDP

; ============================================
; 計算絕對值
; 輸入: EAX = 數值
; 返回: EAX = 絕對值
; ============================================
PUBLIC abs_value@4
abs_value@4 PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]
    test eax, eax
    jns abs_done
    neg eax
    
abs_done:
    pop ebp
    ret 4
abs_value@4 ENDP

; ============================================
; 取最大值
; 輸入: EAX = 第一個數, EBX = 第二個數
; 返回: EAX = 較大的數
; ============================================
PUBLIC max_value@8
max_value@8 PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]
    cmp eax, [ebp+12]
    jge max_done
    mov eax, [ebp+12]
    
max_done:
    pop ebp
    ret 8
max_value@8 ENDP

; ============================================
; 取最小值
; 輸入: EAX = 第一個數, EBX = 第二個數
; 返回: EAX = 較小的數
; ============================================
PUBLIC min_value@8
min_value@8 PROC
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]
    cmp eax, [ebp+12]
    jle min_done
    mov eax, [ebp+12]
    
min_done:
    pop ebp
    ret 8
min_value@8 ENDP

; ============================================
; 計算平方
; 輸入: EAX = 數值
; 返回: EAX = 平方值
; ============================================
PUBLIC square@4
square@4 PROC
    push ebp
    mov ebp, esp
    push ebx
    
    mov eax, [ebp+8]
    mov ebx, eax
    mul ebx
    
    pop ebx
    pop ebp
    ret 4
square@4 ENDP

END