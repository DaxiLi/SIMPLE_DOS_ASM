org 0x700
; ========================== NOTE ============
; 这是一段  直接 写入显存操作 VGA Graphics Programming Using Mode 13h
; 我花了整整一天查找，但是，没有得到具体的相关文档教程，最后，，，，，才想起来，google这个好东西
; 然后,困扰了一天的东西就这么解决了
; BIOS 中断 AX <- 0x13 int 10 设置为VGA模式
        ; INT  AH  功能			  调用参数			  返回参数 
        ; ---  --  ----                     --------                        --------
        ; 10   0   设置显示方式 		  AL=00 40×25黑白方式
        ;                 AL=01 40×25彩色方式
        ;                 AL=02 80×25黑白方式
        ;                 AL=03 80×25彩色方式
        ;                 AL=04 320×200彩色图形方式
        ;                 AL=05 320×200黑白图形方式
        ;                 AL=06 320×200黑白图形方式
        ;                 AL=07 80×25单色文本方式
        ;                 AL=08 160×200 16色图形 (PCjr)
        ;                 AL=09 320×200 16色图形 (PCjr)
        ;                 AL=0A 640×200 16色图形 (PCjr)
        ;                 AL=0B 保留(EGA)
        ;                 AL=0C 保留(EGA)
        ;                 AL=0D 320×200 彩色图形 (EGA)
        ;                 AL=0E 640×200 彩色图形 (EGA)
        ;                 AL=0F 640×350 黑白图形 (EGA)
        ;                 AL=10 640×350 彩色图形 (EGA)
        ;                 AL=11 640×480 单色图形 (EGA)
        ;                 AL=12 640×480 16色图形 (EGA)
        ;                 AL=13 320×200 256色图形 (EGA)
        ;                 AL=40 80×30 彩色文本(CGE400)
        ;                 AL=41 80×50 彩色文本(CGE400)
        ;                 AL=42 640×400 彩色图形(CGE400) 
;
; 接下来粘贴一段 google 来的介绍
; A 64K segment of memory is assigned for use with graphics video modes. This segment starts at address A000:0000 and ends at A000:FFFF. (If you recall from Chapter Four, "Memory in the PC", another segment exists for text-based video modes; this segment begins at B000:0000.)
; 
; In Mode 13h, one byte represents one pixel on the screen. The value of a byte, from 0 to 255 dec, determines which color, from 0 to 255 dec, the corresponding pixel on the screen should have. Because there are 320 pixels by 200 pixels on the screen, 320 * 200 = 64000 dec bytes are required to hold a Mode 13h screen image.
; 
section .code

    mov ax,0x0013
    int 10h
    
    ; mov ah,02h
    ; mov dl,'l'
    ; int 21h

    mov cx,1000
    mov si,0
    lab1:
    mov ax,0a000h
    mov es,ax
    mov bl,4h
    mov [es:si],bl
    inc si
    loop lab1
; push bp
; 	mov bp, sp

; 	mov ax, 0xa000
; 	mov es, ax

; 	xor cx, cx ; cx = y

; .jmpY:
; 	cmp cx, [bp + 10]
; 	jae .breakY

; 	xor di, di ; di = x

; .jmpX:
; 	mov ax, [bp + 12]
; 	cmp di, ax
; 	jae .breakX

; 	mul cx
; 	add ax, di        ; (y * width) + x
; 	mov bx, ax
; 	mov si, [bp + 4]
; 	mov bl, [si + bx] ; bl = tex[y * width + x]

; 	mov ax, [bp + 6]
; 	add ax, cx
; 	mov si, 320
; 	mul si          ; (yoffs + y) * 320
; 	add ax, [bp + 8]
; 	add ax, di      ; + xoffs + x
; 	mov si, ax
; 	mov [es:si], bl

; 	inc di
; 	jmp .jmpX

; .breakX:
; 	inc cx
; 	jmp .jmpY

; .breakY:
; 	pop bp

    ; l:
    ;     mov ah,0ch
    ;     mov al,4h
    ;     int 10h
    ;     loop l

    ; lab1:
    ; mov bx,cx
    ; mov al,04h
    ; mov [es:bx],al
    ; loop lab1

    mov ax,0x4c
    int 21h
    
section .data
