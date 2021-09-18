; .486
; include ".\CHS16"
.model small

.data
    ; ZH26 DB include
    ; str2  DWORD  0x380,0xffff800e,0xda0,0xffffa078,0x7790,0xffff9008,0x790,0xffff9008,0x784,0xffff83ff,0xfffffefe,0xfffffe08,0x780,0xffff8008,0x790,0xffff900a
    ; WO    dword 0380H,0ffff800eH,0da0H,0ffffa078H,07790H,0ffff9008H,0790H,0ffff9008H,0784H,0ffff83ffH,0fffffefeH,0fffffe08H,0780H,0ffff8008H,0790H,0ffff900aH
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
    STR1 BYTE 'HELLO WORLLD!',0Ah,'$'
    VID_PORT dword 0a000h
.stack

.code
.startup
    ; lea ax,WO
    ; mov bx,0808h
    ; call PUTS
        ; ========= cls

    mov ax,0013h
    mov bh,00h
    int 10h

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

    PADDING equ 2h
    LINE_SPACE equ 2d 
    WORD_SAPCE equ 2d
    SCREEN_WIDTH equ 320d
    SCREEN_HEIGHT equ 200d
    WORD_WIDTH equ 16d
    WORD_HEIGHT equ 16d

    FONT_COLOR equ GREEN
    BACKGROUND_COLOR equ BLACK

    
    ; mov ax,0a000h
    ; mov es,ax
    ; xor di,di
    ; mov al,4
    ; mov dl,4             
    ; mov es:[ di],dl

    ; dec di
    ; mov es:[di],al

    ; dec di
    ; mov es:[di],al

    ; dec di
    ; mov es:[di],al

    ; dec di
    ; mov es:[di],al

    ; mov ax,0013h
    ; int 10h



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
    

        





; .jmprow:
;         ; mov ax,ROW_PIXEL
;         mov dx,8000h

; .jmpcol:
;         test dx,[bp]
;         jz .nodraw
;         mov bl,RED
;         jmp .write

; .nodraw:
;         mov bl,BLACK

; .write:
;         mov es:[si],bl
;         shr dx,1
;         inc si
;         test dx,dx
;         jnz .jmpcol

;         inc bp
;         mov ax,es
;         add ax,320d
;         mov es,ax
;         xor si,si
;         loop .jmprow

    ; mov cx,0fh
    ; mov si,340
    ; lab1:
    ; mov ax,0a000h
    ; mov es,ax
    ; mov bl,4h
    ; mov es:[si],bl
    ; inc si
    ; loop lab1


    ; mov bp,0a000h
    ; mov [bp],230
    ; inc bp
    ; mov [bp],190
    ; inc bp
    ; mov [bp],67

    ; mov [0a000h],190

    ; mov ax,0600h
    ; mov bx,0700h
    ; mov cx,0
    ; mov dx,0184fh
    ; int 10h

    ; color equ  4
    ; lea ax,WO
    ; mov bx,0000h
    ; call PUTS

    ; mov bx,0a00h
    ; mov si,1
    ; mov [bx][si],255

;     mov bh,0
; lab:
;     mov dx,300
;     mov cx,100
;     mov ah,0cH
;     mov al,9
;     int 10h
;     cmp cx,700
;     inc cx
;     jnz lab

    ; mov cx,100
    ; mov bp,0a000h
    ; mov ax,0000h
    ; mov bp,ax
    ; xor si,si


;     mov dx,0
;     mov cx,10

; l:
;     mov ah,0ch
;     mov al,color
;     int 10h
;     loop l

;     mov dx,1
;     mov cx,10

; l1:
;     mov ah,0ch
;     mov al,color
;     int 10h
;     loop l1

;     mov dx,2
;     mov cx,10

; l2:
;     mov ah,0ch
;     mov al,color
;     int 10h
;     loop l2

;     mov dx,3
;     mov cx,10

; l3:
;     mov ah,0ch
;     mov al,color
;     int 10h
;     loop l3




    ; mov ax,0bh
    ; mov bx,60
    ; int 10h

    ; mov al,100d
    ; mov ah,0cH
    ; lab:
    ; mov dx,08
    ; mov cx,08
    ; int 10h
    ; loop lab

    mov ah,01
    int 21h

.EXIT 0

    ; ========= cls
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



    ; set display mod 

        ; lea bp,WO

        mov cx,16
        mov ax,0a000h
        mov es,ax

        ; ======= 计算偏移
        mov ax,WORD_HEIGHT
        mul bh               ; x offset
        add ax,PADDING          ; padding top
        mov cx,ax

        mov ax,LINE_SPACE
        mul bh
        add cx,ax               ; 行间距

        xor dx,dx               ; 16 bit 乘法前必须
        mov ax,SCREEN_WIDTH     ; 屏幕宽度
        mul cx
                                ; 由于屏幕最大偏移量为 320 * 200 = 64000 不超出 16 位,所以不必考虑 DX 值
        mov si,ax         

        mov ax,WORD_WIDTH       ; 字符宽度
        add ax,WORD_SAPCE       ; 字间距
        mul bl                  ; 列
        add si,ax               
        add si,PADDING          ; 左留白

        ; add ax,WORD_SAPCE
        ; mul bl
        ; add si,AX               ; 字间距

        xor cx,cx
.jmprow:
        mov dx,80h
.jmpw:
        mov bx,[bp]
        test [bp],dl
        mov al,BACKGROUND_COLOR
        jz .no_draw
        mov al,FONT_COLOR
.no_draw:
        mov es:[si],al
.continuew:
        shr dl,1
        inc si
        test dl,dl
        jnz .jmpw
        
        test cx,1
        jz .nonextline
        add si,320d            ; 换行
        sub si,16d
        
.nonextline:
.continuerow:
        inc bp
        inc cx
        cmp cx,32d
        jb .jmprow

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