; ============================================
; display.asm  
; 顯示處理模組 - Windows 32-bit
; ============================================

.386
.model flat, stdcall
option casemap:none

; Windows API
GetStdHandle PROTO :DWORD
WriteConsoleA PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
SetConsoleCursorPosition PROTO :DWORD, :DWORD
GetConsoleScreenBufferInfo PROTO :DWORD, :DWORD
FillConsoleOutputCharacterA PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
SetConsoleTextAttribute PROTO :DWORD, :DWORD

; 常數定義
STD_OUTPUT_HANDLE equ -11

; 顏色屬性
COLOR_BLACK     equ 0
COLOR_BLUE      equ 1
COLOR_GREEN     equ 2
COLOR_CYAN      equ 3
COLOR_RED       equ 4
COLOR_MAGENTA   equ 5
COLOR_YELLOW    equ 6
COLOR_WHITE     equ 7
COLOR_BRIGHT    equ 8

.data
    hStdOutput      dd 0
    bytesWritten    dd 0
    consoleInfo     db 22 dup(0)  ; CONSOLE_SCREEN_BUFFER_INFO 結構
    newline_str     db 13, 10, 0

.code

; ============================================
; 初始化顯示系統
; ============================================
PUBLIC init_display@0
init_display@0 PROC
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov hStdOutput, eax
    ret
init_display@0 ENDP

; ============================================
; 清除螢幕
; ============================================
PUBLIC clear_screen@0
clear_screen@0 PROC
    push ebp
    mov ebp, esp
    sub esp, 8
    
    ; 取得控制台資訊
    push OFFSET consoleInfo
    push hStdOutput
    call GetConsoleScreenBufferInfo
    
    ; 計算螢幕大小 (寬 * 高)
    movzx eax, WORD PTR [consoleInfo]      ; X (寬)
    movzx ecx, WORD PTR [consoleInfo+2]    ; Y (高)
    mul ecx
    mov [ebp-4], eax  ; 儲存總字元數
    
    ; 填充空白字元
    lea eax, [ebp-8]
    push eax          ; 寫入的字元數
    push 0            ; 起始座標 (0,0)
    push [ebp-4]      ; 字元數
    push 20h          ; 空白字元
    push hStdOutput
    call FillConsoleOutputCharacterA
    
    ; 設定游標位置到左上角
    push 0  ; 座標 (0,0)
    push hStdOutput
    call SetConsoleCursorPosition
    
    mov esp, ebp
    pop ebp
    ret
clear_screen@0 ENDP

; ============================================
; 設定游標位置
; 輸入: EAX = X座標, EDX = Y座標
; ============================================
PUBLIC set_cursor@8
set_cursor@8 PROC
    push ebp
    mov ebp, esp
    
    ; 組合座標 (Y << 16 | X)
    mov eax, [ebp+8]   ; X
    mov edx, [ebp+12]  ; Y
    shl edx, 16
    or edx, eax
    
    push edx
    push hStdOutput
    call SetConsoleCursorPosition
    
    pop ebp
    ret 8
set_cursor@8 ENDP

; ============================================
; 顯示字串
; 輸入: 堆疊上推入字串位址
; ============================================
PUBLIC print_string@4
print_string@4 PROC
    push ebp
    mov ebp, esp
    push ebx
    push esi
    
    mov esi, [ebp+8]  ; 字串位址
    
    ; 計算字串長度
    xor ebx, ebx
count_loop:
    mov al, [esi+ebx]
    test al, al
    jz found_end
    inc ebx
    jmp count_loop
    
found_end:
    ; 顯示字串
    push 0
    push OFFSET bytesWritten
    push ebx
    push esi
    push hStdOutput
    call WriteConsoleA
    
    pop esi
    pop ebx
    pop ebp
    ret 4
print_string@4 ENDP

; ============================================
; 顯示換行
; ============================================
PUBLIC print_newline@0
print_newline@0 PROC
    push OFFSET newline_str
    call print_string@4
    ret
print_newline@0 ENDP

; ============================================
; 顯示字元
; 輸入: AL = 字元
; ============================================
PUBLIC print_char@4
print_char@4 PROC
    push ebp
    mov ebp, esp
    sub esp, 4
    
    mov al, [ebp+8]
    mov [ebp-4], al
    
    push 0
    push OFFSET bytesWritten
    push 1
    lea eax, [ebp-4]
    push eax
    push hStdOutput
    call WriteConsoleA
    
    mov esp, ebp
    pop ebp
    ret 4
print_char@4 ENDP

; ============================================
; 顯示數字 (十進位)
; 輸入: EAX = 數字
; ============================================
PUBLIC print_number@4
print_number@4 PROC
    push ebp
    mov ebp, esp
    sub esp, 12  ; 數字緩衝區
    push ebx
    push esi
    push edi
    
    mov eax, [ebp+8]
    lea edi, [ebp-1]  ; 緩衝區結尾
    mov BYTE PTR [edi], 0  ; null 終止
    dec edi
    
    ; 處理 0 的特殊情況
    test eax, eax
    jnz convert_loop
    mov BYTE PTR [edi], '0'
    jmp print_result
    
convert_loop:
    test eax, eax
    jz print_result
    
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    jmp convert_loop
    
print_result:
    inc edi
    push edi
    call print_string@4
    
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret 4
print_number@4 ENDP

; ============================================
; 設定文字顏色
; 輸入: EAX = 顏色屬性
; ============================================
PUBLIC set_color@4
set_color@4 PROC
    push ebp
    mov ebp, esp
    
    push [ebp+8]
    push hStdOutput
    call SetConsoleTextAttribute
    
    pop ebp
    ret 4
set_color@4 ENDP

; ============================================
; 顯示彩色字串
; 輸入: [ESP+4] = 字串位址, [ESP+8] = 顏色
; ============================================
PUBLIC print_color_string@8
print_color_string@8 PROC
    push ebp
    mov ebp, esp
    
    ; 設定顏色
    push [ebp+12]
    call set_color@4
    
    ; 顯示字串
    push [ebp+8]
    call print_string@4
    
    ; 恢復預設顏色 (白色)
    push COLOR_WHITE
    call set_color@4
    
    pop ebp
    ret 8
print_color_string@8 ENDP

END