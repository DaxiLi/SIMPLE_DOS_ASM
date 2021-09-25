; /*
;  * ;Description: 屏幕上输出点阵汉字,
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-19 10:35:11
;  * ;FileName: 
;  */
; .486
; include ".\CHS16"
.model small

.data
    WO  DB  04H,80H,0EH,0A0H,78H,90H,08H,90H
        DB  08H,84H,0FFH,0FEH,08H,80H,08H,90H
        DB  0AH,90H,0CH,60H,18H,40H,68H,0A0H
        DB  09H,20H,0AH,14H,28H,14H,10H,0CH
    NI  DB  11H,00H,11H,00H,11H,04H,23H,0FEH
        DB  22H,04H,64H,08H,0A8H,40H,20H,40H
        DB  21H,50H,21H,48H,22H,4CH,24H,44H
        DB  20H,40H,20H,40H,21H,40H,20H,80H
        ;爱
    AI  DB  00H,10H,3FH,0F8H,12H,20H,09H,44H
        DB  7FH,0FEH,42H,08H,82H,10H,3FH,0F8H
        DB  04H,00H,07H,0E0H,08H,20H,0CH,40H
        DB  12H,40H,21H,80H,46H,60H,18H,1CH
        
POEM_ZH_CN DB  04H,80H,0EH,0A0H,78H,90H,08H,90H
DB  08H,84H,0FFH,0FEH,08H,80H,08H,90H
DB  0AH,90H,0CH,60H,18H,40H,68H,0A0H
DB  09H,20H,0AH,14H,28H,14H,10H,0CH

;写
DB  00H,00H,7FH,0FEH,40H,02H,88H,04H
DB  08H,20H,0FH,0F0H,08H,00H,08H,08H
DB  0FH,0FCH,00H,08H,00H,48H,7FH,0E8H
DB  00H,08H,00H,08H,00H,50H,00H,20H

;的
DB  10H,40H,10H,40H,20H,44H,7EH,7EH
DB  42H,84H,42H,84H,43H,04H,42H,44H
DB  7EH,24H,42H,24H,42H,04H,42H,04H
DB  42H,04H,7EH,04H,42H,28H,00H,10H

;代
DB  08H,80H,08H,0A0H,08H,90H,10H,90H
DB  10H,84H,30H,0FEH,5FH,80H,90H,40H
DB  10H,40H,10H,40H,10H,20H,10H,20H
DB  10H,12H,10H,12H,10H,0AH,10H,06H

;码
DB  00H,10H,7DH,0F8H,10H,10H,11H,10H
DB  11H,10H,21H,10H,3DH,10H,65H,10H
DB  0A5H,0FCH,24H,04H,24H,24H,27H,0F4H
DB  24H,04H,3CH,04H,24H,14H,00H,08H

;像
DB  09H,00H,09H,0F0H,0AH,20H,17H,0FCH
DB  1CH,44H,37H,0FCH,50H,80H,91H,44H
DB  16H,68H,10H,0B0H,17H,30H,10H,68H
DB  11H,0A6H,16H,20H,10H,0A0H,10H,40H

;诗
DB  00H,40H,20H,48H,13H,0FCH,10H,40H
DB  00H,44H,07H,0FEH,0F0H,10H,10H,10H
DB  17H,0FEH,10H,10H,11H,10H,10H,90H
DB  14H,90H,18H,10H,10H,50H,00H,20H

;一
DB  00H,00H,00H,00H,00H,00H,00H,00H
DB  00H,00H,00H,00H,00H,04H,0FFH,0FEH
DB  00H,00H,00H,00H,00H,00H,00H,00H
DB  00H,00H,00H,00H,00H,00H,00H,00H

;样
DB  12H,08H,11H,10H,11H,20H,17H,0FCH
DB  0FCH,40H,10H,40H,3BH,0F8H,34H,40H
DB  54H,40H,50H,44H,9FH,0FEH,10H,40H
DB  10H,40H,10H,40H,10H,40H,10H,40H


;过 
STR_ZH_CN DB  00H,10H,40H,10H,20H,10H,17H,0FCH
DB  00H,10H,00H,10H,0F1H,10H,10H,90H
DB  10H,90H,10H,10H,10H,10H,10H,50H
DB  10H,20H,28H,00H,47H,0FEH,00H,00H

;节
DB  04H,40H,04H,44H,0FFH,0FEH,04H,40H
DB  04H,40H,04H,48H,3FH,0FCH,02H,08H
DB  02H,08H,02H,08H,02H,08H,02H,48H
DB  02H,30H,02H,00H,02H,00H,02H,00H

;了
DB  00H,08H,7FH,0FCH,00H,10H,00H,20H
DB  01H,40H,01H,80H,01H,00H,01H,00H
DB  01H,00H,01H,00H,01H,00H,01H,00H
DB  01H,00H,01H,00H,05H,00H,02H,00H
;,
DB  00H,1 dup(0)
DB  00H,1 dup(0)
DB  00H,1 dup(0)
DB  00H,1 dup(0)
DB  00H,1 dup(0)
DB  00H,1 dup(0)
DB  00H,1 dup(0)
DB  00H,1 dup(0)
DB  00H,1 dup(0)
DB  18H,1 dup(0)
DB  18H,1 dup(0)
DB  18H,1 dup(0)
DB  30H,1 dup(0)
DB  00H,1 dup(0)
DB  00H,1 dup(0)
DB  00H,1 dup(0)
; DB  16 dup(0)

;写
DB  00H,00H,7FH,0FEH,40H,02H,88H,04H
DB  08H,20H,0FH,0F0H,08H,00H,08H,08H
DB  0FH,0FCH,00H,08H,00H,48H,7FH,0E8H
DB  00H,08H,00H,08H,00H,50H,00H,20H

;个
DB  01H,00H,01H,00H,02H,80H,02H,80H
DB  04H,40H,09H,30H,31H,0EH,0C1H,04H
DB  01H,00H,01H,00H,01H,00H,01H,00H
DB  01H,00H,01H,00H,01H,00H,01H,00H

;代
DB  08H,80H,08H,0A0H,08H,90H,10H,90H
DB  10H,84H,30H,0FEH,5FH,80H,90H,40H
DB  10H,40H,10H,40H,10H,20H,10H,20H
DB  10H,12H,10H,12H,10H,0AH,10H,06H

;码
DB  00H,10H,7DH,0F8H,10H,10H,11H,10H
DB  11H,10H,21H,10H,3DH,10H,65H,10H
DB  0A5H,0FCH,24H,04H,24H,24H,27H,0F4H
DB  24H,04H,3CH,04H,24H,14H,00H,08H

;吧
DB  00H,00H,00H,08H,7BH,0FCH,4AH,48H
DB  4AH,48H,4AH,48H,4AH,48H,4AH,48H
DB  4BH,0F8H,4AH,08H,4AH,00H,7AH,00H
DB  4AH,02H,02H,02H,01H,0FEH,00H,00H

STR_ZH_CN_LENGTH WORD ($ - STR_ZH_CN)
    STR1 BYTE 'HELLO WORLLD!',0Ah,'$'
    VID_PORT dword 0a000h
.stack

.code
.startup

    ; ===================== 一些常数 和 参数 的宏定义 ==================


    ROW_PIXEL equ 340d
    BLACK equ 0h
    BLUE equ 1h
    GREEN equ 2h
    CYAN equ 3h
    RED equ 4h
    MAGENTA equ 5h
    BROWN equ 6h
    LIGHT_GRAY equ 7h
    DARK_GRAY equ 8h
    LIGHT_BLUE equ 9h
    LIGHT_GREEN equ 0ah
    LIGHT_CYAN equ 0bh
    LIGHT_RED equ 0ch
    LIGHT_MAGENTA equ 0dh
    YELLOW equ 0eh
    WHITE equ 0fh

    PADDING equ 20h
    LINE_SPACE equ 2d 
    WORD_SAPCE equ 2d
    SCREEN_WIDTH equ 320d
    SCREEN_HEIGHT equ 200d
    WORD_WIDTH equ 16d
    WORD_HEIGHT equ 16d

    FONT_COLOR equ GREEN
    BACKGROUND_COLOR equ BLACK

    call SETDISPLAYMOD

    MOV CX,10
    LEA AX,[STR_ZH_CN]
    MOV BX,0
    .outstr:
    call PUTS
    add BL,1
    add AX,32d
    loop .outstr

    MOV AH,01
    int 21H

    .exit 0

    lea ax,WO
    mov bx,00h
    call PUTS

    call CLS

    lea ax,AI
    mov bx,0001h
    call PUTS

    lea ax,NI
    mov bx,0101h
    call PUTS

    mov ah,01
    int 21h

.EXIT 0

; ====== 设置显示模式 位 13H ======
SETDISPLAYMOD:
    PUSH  AX
    PUSH BX
    mov ax,0013h
    mov bh,00h
    int 10h
    POP BX
    POP AX
    ret

; ========= cls  ===============
; 10   6   屏幕初始化或上卷	  AL=上卷行数
; 			  AL=0 整个窗口空白
; 			  BH=卷入行属性
; 			  CH=左上角行号
; 			  CL=左上角列号
; 			  DH=右下角行号
; 			  DL=右下角列号 
CLS:
    push AX
    push bx

    mov ax,0600h
    mov bh,RED            ; BH 屏幕初始化颜色
    mov cx,0
    mov dx,0184fh
    int 10h

    pop bx
    pop ax
    ret

; 从 AX 的位置开始的数据,将点阵输出于屏幕
; 使用 16 位点阵字库
; BH : row ; BL : rol
PUTS:
    push dx
    push cx
    push bx
    push ax
    push si
    push bp

        mov bp,ax
        mov si,sp
        add si,4
            mov cx,16
            mov ax,0a000h
            mov es,ax

            ; ======= ======== 计算行偏移像素 =========

            mov ax,WORD_HEIGHT
            add ax,LINE_SPACE
            mul bh                  ; x offset
            add ax,PADDING          ; padding top
            mov cx,ax               ; 纵轴偏移量 => (行数 * (一行的像素数 + 行间距像素数) ) + 顶边距的像素数 就是总的便宜像素行数

            ; mov ax,LINE_SPACE
            ; mul bh
            ; add cx,ax               ; 行间距


            ; ============== 计算列偏移像素 =======

            xor dx,dx               ; 16 bit 乘法前必须
            mov ax,SCREEN_WIDTH     ; 屏幕宽度
            mul cx                  ; CX -> 行像素数
                                    ; 由于屏幕最大偏移量为 320 * 200 = 64000 不超出 16 位,所以不必考虑 DX 值
            mov si,ax         

            mov ax,WORD_WIDTH       ; 字符宽度
            add ax,WORD_SAPCE       ; 字间距
            mul bl                  ; 列
            add si,ax               
            add si,PADDING          ; 左留白 padding left

            ; add ax,WORD_SAPCE
            ; mul bl
            ; add si,AX               ; 字间距

            ; ============= 开始在偏移处写入像素 ======
            xor cx,cx
    .jmprow:
            mov dx,80h                  ; 初始化 DX -> 0000 1000B
    .jmpw:                                    
            test [bp],dl                ; [BP] & DX
            mov al,BACKGROUND_COLOR     
            jz .no_draw
            mov al,FONT_COLOR           
    .no_draw:
            mov     es:[si],al          ; 写像素
    .continuew:
            shr     dl,1                ; DX BIT 逻辑右移 
            inc     si                  ; 显存 inc
            test    dl,dl               ; DX == 0
            jnz     .jmpw
            
            test    cx,1                ; 一次循环写 8 BIT,而一行有 16 BIT ,所以 CX % 2 时才换行       
            jz      .nonextline
            add     si,304d             ; 换行 SCREEN_WIDTH - WORD_WIDTH
            ; sub     si,16d             ; 不必要的一行
            
    .nonextline:
    .continuerow:                       ; 下一个 BIT -> inc BP ;计数 CX INC
            inc bp
            inc cx
            cmp cx,32d
            jb .jmprow
    .return:
    pop bp
    pop si
    pop ax
    pop bx
    pop cx
    pop dx
    ret

claer:
mov al,0
mov bx,0
mov cx,0
mov dx,0
int 10h
ret



; 将 AX 中的数据 以 16 进制输出
PRINT_NUM_HEX:
        PUSH BX 
        PUSH CX 
        PUSH DX 

        MOV BX,AX 
        MOV AH,02H      
        MOV CX,0404H                    ; 高位作计数 低位作 ROL 指令的 ORDER2
        PNH_STARTROL:
                ROL BX,CL               ; 左移 4 位
                TEST BX,0FH             ; 测试低 4 位
                JNZ PNH_STARTOUT        ; 低 4 位 != 0 跳转至输出
                DEC CH                  ; 手动计数 -1
                TEST CH,CH              
                JNZ PNH_STARTROL        ; if CH > 0 continue else break
                INC CH                  ; 没有跳转,输入为 0 ,需要输出一次 , 计数器 +1
        PNH_STARTOUT:
                MOV DX,0FH              ; 
                AND DX,BX               ; 低 4 位移入 DL 
                ADD DX,'0'              ; 加上 '0'
                CMP DX,':'              ; ':' asiic 是 '9' + 1
                JB PNH_IS_NUM           ; 
                ADD DX,7D
        PNH_IS_NUM:
                INT 21H
                ROL BX,CL
                DEC CH 
                TEST CH,CH
                JNZ PNH_STARTOUT
        POP DX 
        POP CX 
        POP BX
        RET



end