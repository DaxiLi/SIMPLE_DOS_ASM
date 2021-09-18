.model small

.data
DOSFILE_TMP db "hello world",20 dup(0),'$'
DOSFILENAME db "DOS.asm",0
ZHS_FILE_NAME db ".\HZK16",0, 10 dup  (0)
STR_OPENFILE_FAIL db "can not open file",13,'$',0
STR_MOVOFFSET_FAIL db "mov ofset fail",13,'$',0
STR_READFILE_FAIL db "can not read file",13,'$',0
FILE_HANDLE word 2 dup(0)
FILE_TMP word 'h',32 dup(0),'$'
.stack

.code
.startup

; lea AX,ZHS_FILE_NAME
; 参数压栈
; AX,文件地址       STACK TOP
; BX,读取字节数     SP + 2  
; CX:（DX）,偏移量      SP + 4
; DX: (偏移量）     SP + 6
; 缓存地址          SP + 8

LEA AX,[FILE_TMP]
PUSH AX
XOR AX,AX
PUSH AX
PUSH AX
MOV AX,100d
PUSH AX
LEA AX,ZHS_FILE_NAME
PUSH AX

call openfile

lea dx,FILE_TMP
mov ah,09h
int 21h
; lea ax,FILE_TMP
; push ax
; lea ax,DOSFILENAME
; mov bx,15
; xor cx,cx
; mov dx,0
; call openfile






.exit 0

; lea AX,ZHS_FILE_NAME
; 参数压栈
; AX,文件地址       STACK TOP
; BX,读取字节数     SP + 2  
; CX:（DX）,偏移量  SP + 4
; DX: (偏移量）     SP + 6
; 缓存地址          SP + 8
openfile:

        PUSH BP
        mov BP,SP
        add BP,2                    ; AT FILENAME
        
        PUSH DX
        PUSH CX
        PUSH BX
        PUSH AX

        ; ============== OPEN FILE
        MOV AH,3DH
        MOV DX,[BP]
        MOV AL,0                    ; open attribute: 0 - read-only, 1 - write-only, 2 -read&write 
        INT 21H                     ; If file exists, it’s handle is returned in AX, ff file doesn’t exist Carry Flag is set. Now we can read from our file:
        jc .openfilefail
        MOV [FILE_HANDLE],AX

        ; ============== SET PTR OF FILE
        MOV AH,42H
        MOV BX,[FILE_HANDLE]
        MOV CX,[BP + 4]
        MOV DX,[BP + 6]             ; CX:DX : 位移量
        MOV AL,0                    ; 从文件头开始
        int 21H                     ; 如果成功，DX:AX=新文件指针位置
        jc .movoffsetfail

        ; ============== READ FROM FILE
        MOV AH,3FH
        MOV BX,[FILE_HANDLE]        ; HANDLE
        MOV CX,[BP + 2]             ; 读取字节数
        MOV DX,[BP + 8]             ; 缓存地址
        int 21H
        jc .readfilefail
        jmp .return
        
    .movoffsetfail:
        lea dx,STR_MOVOFFSET_FAIL
        mov ah,09h
        int 21h
        jmp .return

    .openfilefail:
        lea dx,STR_OPENFILE_FAIL
        mov ah,09h
        int 21h
        jmp .return
    .readfilefail:
        lea dx,STR_READFILE_FAIL
        mov ah,09h
        int 21h
        jmp .return

    .return:
    POP AX
    POP BX
    POP CX
    POP DX
    POP BP
    ret

createfolder:
        ; xor ,ax,ax

end