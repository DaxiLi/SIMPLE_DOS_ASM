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
    FILE_PATH BYTE 61 dup(0),0,'$'   
    READ_BUF DB 12 dup(0)

.stack 
.code

; ============== 真他奶奶的邪门，绝了，不能打开文件报错。哪怕把那个程序复制到这个文件里面，也不行，可是文件都在一个目录下，并没有什么不同在另一个文件里面可以 include ，在这个文件里面写代码 include 
; 
include JLIB.asm

.startup
    MOV ah,09h
    lea dx,TIP_PATH_INPUT
    int 21h

    lea BX,FILE_PATH
    MOV CX,61
    MOV AH,01

    .inputpath:
    int 21H
    cmp AL,0dh
    jz .iptbreak
    mov [bx],al
    inc bx
    loop .inputpath
    .iptbreak:

    
    .wordoutput:


.exit 0

end
