; /*
;  * ;Description: 从接口中获取系统时间，然后输出。
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-9-15 22:48:20
;  * ;FileName: 
;  */



.model small
.data


.stack
; include JLIB.asm
.startup
    MOV AH,2Ah   ; 取日期CX=年
					; DH:DL=月:日(二进制) 
    int 21h
    MOV AX,CX
    MOV BX,DX
    call PROC_PRINT_NUM

    MOV DL,'Y'
    MOV AH,02
    int  21h

    XOR AX,AX
    MOV AL,BH
    call PROC_PRINT_NUM

    MOV DL,'M'
    MOV AH,02H
    int 21h

    XOR AX,AX
    MOV Al,BL
    call PROC_PRINT_NUM

    MOV Dl,'D'
    MOV AH,02H
    int 21h

    MOV AH,2CH
    int 21h

    XOR AX,AX
    MOV AL,CH
    call PROC_PRINT_NUM

    MOV Dl,'h'
    MOV AH,02H
    int 21H

    XOR AX,AX
    MOV AL,CL
    call PROC_PRINT_NUM

    MOV Dl,'m'
    MOV AH,02H
    int 21h

    XOR AX,AX
    MOV AL,DH
    call PROC_PRINT_NUM

    MOV Dl,'s'
    MOV AH,02H
    int 21h

.exit 0





; 以十进制输出数字
; 传入参数在 AX
PROC_PRINT_NUM:
    PUSH BX 
    PUSH CX 
    PUSH DX 
        MOV CX,10D
        XOR BX,BX           ; 计数
    PPN_LOOP:
        XOR DX,DX           ; 如果不写这一句会卡住，玄，不懂 虽然是使用两个寄存器的值,但是,为什么我一定要置零一下呢
        DIV CX
                            ; 余数在 DX 中 商在  AX 中
        INC BX              ; 计数 +1
        ADD DX,'0'
        PUSH DX             ; 压入堆栈
        TEST AX,AX          ; 测试 AX 是否为空 
        JNZ PPN_LOOP        ; 不为空 继续 输出
        MOV AH,02H
        MOV CX,BX           ; 将计数 放入CX
    PPN_OUT:
        POP DX
        INT 21H 
        LOOP PPN_OUT        ; 循环从堆栈输出字符
    POP DX 
    POP CX 
    POP BX 
    RET

    
end