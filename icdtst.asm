; /*
;  * ;Description: 输出目录,打开输入的目录并显示当中的中文文字
;               要求 GBK 编码,且不含半角字符.
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-21 13:02:26
;  * ;FileName: 
;  */

.model small

.data
    TIP_PATH_INPUT DB "pls input a file name:",0ah,'$',0
    FILE_OPEN_FAIL DB "open file fail(main)",0ah,'$','0'
    FILE_PATH BYTE 'README.txt',61 dup(0),0,'$'   

    READ_FILE_BUF DB 2047 dup(0),0
    READ_FILE_BUF_LENGTH DW ?
    READ_FILE_BUF_LINES DW 0

    WORD_MODEL_BUF DB 32 dup(0)

    FLAG DB 0

.stack 
.code

FILE_BUF_SIZE equ 2048

; ============== 真他奶奶的邪门，绝了，不能打开文件报错。哪怕把那个程序复制到这个文件里面，也不行，可是文件都在一个目录下，并没有什么不同在另一个文件里面可以 include ，在这个文件里面写代码 include 
; ~~似乎要先  cd 到当前目录 DOSBOX 才会把文件都复制过去，，，，晕。。~~
; DOSBOX 的复制逻辑成谜！
; 经过我细心调试，现在没法 include 了
include JLIB.asm

.startup
    MOV ah,09h
    lea dx,TIP_PATH_INPUT
    int 21h

    lea BX,FILE_PATH
    MOV CX,61
    MOV AH,01

    ; .inputpath:
    ; int 21H
    ; cmp AL,0dh
    ; jz .iptbreak
    ; mov [bx],al
    ; inc bx
    ; loop .inputpath
    ; .iptbreak:

    
    ; ==== READ FROM FILE 
    LEA AX,READ_FILE_BUF
    PUSH AX

    XOR AX,AX
    PUSH AX

    PUSH AX

    MOV AX,FILE_BUF_SIZE
    PUSH AX

    LEA AX,FILE_PATH
    PUSH AX

    MOV Bp,SP

    call openfile
    cmp AX,-1
    jnz .readoptfinished
    ; .readoptfail:
    ; MOV AH,09
    ; LEA DX,FILE_OPEN_FAIL
    ; int 21h
    ; .exit 0
;********* ERROR CODE ***********
    ; MOV CX,2d
    ; XOR DX,DX
    ; MOV BX,2d     ; 先一次读取 2 字节
    ; LEA BP,READ_FILE_BUF
    ; .readtxtfile:
    ; PUSH AX
    ; PUSH DX
    ; PUSH DX
    ; PUSH BX
    ; LEA AX,FILE_PATH
    ; PUSH AX
    
    ; MOV BP,SP
    ; call openfile
    ; test AX,AX
    ; jz .fileEOF
    ; cmp AX,-1
    ; jz .readoptfail

    ; add BP,2

    ; loop .readtxtfile
    ; jmp .fileEOF

    ; .readoptfail:
    ; MOV AH,09
    ; LEA DX,FILE_OPEN_FAIL
    ; int 21h
    ; .exit 0

    ; .fileEOF:
;  .readoptfinished:
;********* ERROR CODE ***********


 ; ================= TEST==========

; lea SI,READ_FILE_BUF
; MOV CX,32d
; lab1:
;     xor ah,ah
;     mov al,[si]
;     call PRINT_NUM_HEX
;     inc si
;     mov ah,02
;     mov dl,':'
;     int 21h
;     loop lab1

    ; mov ah,01
    ; int 21h

 ; ============== TEST END========


.readoptfinished:

    call SETDISPLAYMOD          ; 设置显示模式
    ; call  CLS
    MOV BH,0
    
.show:
    LEA AX,READ_FILE_BUF
    ; ADD AX,EACH_LINE_WORDS * 2
    call CLS
    call refreshwords   

.checkKeyAction:
    MOV AH,08
    int 21h

    cmp al,'j'
    jz .keyJ
    cmp al,'k'
    jz .keyK
    cmp al,'q'
    jz .keyQ

    jmp .checkKeyAction

    .keyJ:
    inc BH
    jmp .show
    
    .keyK:
    cmp BH,0
    jbe .checkKeyAction             ; <= 0,啥也不做
    dec BH
    jmp .show

    .keyQ:
    call CLS
    jmp .mainExit

    jmp .checkKeyAction

.mainExit:
.exit 0

; 计算 AX 地址开始的,下一行首字符的地址
getnextlineptr:
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH BP

    MOV BP,AX
.wilgnl:
    MOV AX,[BP]
    test AX,AX
    jz .wilreturn        ; has no next line then return 0 

    cmp AX,0D0ah
    MOV AX,BP
    ADD AX,2
    jz .wilreturn       ; 换行,返回下一个地址

    ADD BP,2
    jmp .wilreturn

.wilreturn:
    POP BP
    POP DX
    POP CX
    POP BX

; 将 ax 地址处的字符串刷新到屏幕上，
; BH ,为要从第几行开始显示
; 0,0 开始,自动换行
; 遇到 0 截止
refreshwords:
    PUSH BP
    PUSH DX
    PUSH CX
    PUSH BX
    PUSH AX

    MOV BP,AX                   ; 字符串地址

    ; call SETDISPLAYMOD          ; 设置显示模式
    ; call CLS                    ; CLS

    XOR CX,CX
    ; MOV CL,BH
.whilenextline:
    CMP BH,0
    jz .whilenextlineEnd        ; END BH -> 0

    MOV DX,[BP]
    XCHG DH,DL

    TEST DX,DX                  ; 为空
    jz .w_no_char

    CMP DX,0D0ah                ; 换行符
    jz .w_r_n
    
    CMP DH,20H                  ;空格
    jz .w_space

    jmp .w_default

.w_no_char:
    jmp .whilenextlineEnd        ; 为空,末尾,直接结束
.w_r_n:
    DEC BH
    XOR CX,CX
    jmp .w_final
.w_default:
    INC CX
    CMP CX,EACH_LINE_WORDS
    JNB .w_r_n
    jmp .w_final
.w_space:
    DEC BP
    INC CX
    jmp .w_default       ; 空格 还需要按照正常字符处理一次

.w_final:
    ADD BP,2
    jmp .whilenextline
.whilenextlineEnd:


xor bx,bx                   ; 0 row 0 col
                                ; PUTS 传递参数

.wput:
    XOR DX,DX
    MOV DX,[BP]                 ; 将字符读入 DX
    XCHG DH,DL

.checkword:
    test DX,DX                  ; 0 截止
    jz .wbreak 

    CMP DX,0D0ah
    JZ .IS_R_N                  ; 换行符 两个

    cmp bl,EACH_LINE_WORDS      ; 是否行末
    jnb .IS_END_OF_LINE             
    
    cmp bh,EACH_SCREEN_LINES
    jnbe .wbreak                ; 屏幕写满,结束

    CMP DH,20H                  ;空格
    JZ .IS_SPACE
    
    ; default case
    jmp .writescreen            ; 不匹配,则直接写
   
.checkopts:

.IS_R_N:
    inc BH
    xor bl,bl                   ; 换行
    ADD BP,2
    jmp .wput              ; 继续下一个字符

.IS_END_OF_LINE:   
    inc BH
    xor bl,bl                   ; 换行
    JMP .checkword            ; 换行后 需检查是否写满

.IS_SPACE:
    DEC BP                      ; 空格可只占一个字节,防止出现单字节空格导致乱码
    MOV DX,2020H                 ;  所以把情况统一成单字节处理
    JMP .writescreen            ;   BP 减一,以平衡数据

.writescreen:
    lea AX,WORD_MODEL_BUF
    XCHG BX,CX
    MOV BX,DX
    call loadwordmodel
    XCHG BX,CX
    lea AX,WORD_MODEL_BUF
    call PUTS

.wcontinue:
    ADD BP,2
    INC BL

    jmp .wput
.wbreak:

    POP AX
    POP BX
    POP CX
    POP DX
    POP BP

    ret



end
