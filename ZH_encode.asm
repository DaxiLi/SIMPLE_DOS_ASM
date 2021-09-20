; /*
;  * ;Description: 汉字解码计算偏移量模块
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-19 22:26:57
;  * ;FileName: 
;  */



.model small

.data
; ZH_OFFSET DWORD 0FEDCBA98H , 0AA998877H
ZH_OFFSET DWORD 0ceh,0d2h
.stack

.code
.startup

; MOV ah,1
; int 21h

; LEA BP,ZH_OFFSET
; MOV CX,4
; lout:
; MOV AX,[BP]
; call PRINT_NUM_HEX
; MOV AH,02
; MOV DL,':'
; int 21h
; inc BP
; loop lout

MOV AH,0ceh
MOV AL,0d2h

call calOffsetZH


    
 



; MOV BP,AX
; MOV AX,[BP]
XCHG AX,DX
call PRINT_NUM_HEX

XCHG AX,DX
call PRINT_NUM_HEX








; jmp PRINT_NUM_HEX
.exit 0


; ============= 扩展资料=========
; 一个GB2312汉字是由两个字节编码的,范围为0xA1A1~0xFEFE. 
; A1-A9为符号区, B0到F7为汉字区. 每一个区有94个字符
; 区码:汉字的第一个字节-0xA0 
; (因为汉字编码是从0xA0区开始的, 所以文件最前面就是从0xA0区开始, 要算出相对区码)
; 位码:汉字的第二个字节-0xA0
; (94*(区码-0xa1)+(位码-0xa1))*32
; 将汉字计算 在 HKZ16 字库中的偏移量
; AX 传送 2 字节数据
; 返回值 在 DX:AX 中
calOffsetZH:
;     PUSH DX
    PUSH CX
    PUSH BX
;     PUSH BP

    XOR DX,DX
    XOR BX,BX

    SUB AX,0A1A1h       ; - A1
    MOV BL,AL           ; BX 00AL
    MOV AL,AH
    XOR AH,AH
    MOV CX,94D
    MUL CL
    ADD AX,BX

    MOV CX,32D
;     XOR DX,DX
    MUL CX              ; 结果超过16位,使用32位乘法

;     LEA BP,ZH_OFFSET
;     MOV [BP],DX
;     MOV [BP - 2],AX
;     MOV AX,BP
    
;     POP BP
    POP BX
    POP CX
;     POP DX
    ret

; ======================================= BUG =======
; 此程序中,这个子函数有 BUG 
; 
; MOV BP,AX
; MOV AX,[BP]
; call PRINT_NUM_HEX

; MOV AX,[BP - 2]
; call PRINT_NUM_HEX
; 在这个调用中,在第一次输出以后,程序卡住
; 经 DBG 发现,在第一次调用完成,运行到最后一行时,出现一个死循环
; 问题在 POP BX ,ret 之后,所以,很疑惑
; DBG 时显示该指令
; F000:0000E4CC FE380300            callback 0003  (default)
; F000:0000E4D0 CF                  iret 
; 然后跳转至 
; 075C:0000010B FE                  db FF
; 然后又跳转至 F000:0000E4CC FE380300
; 死循环,...........
; 如果在调用 PRINT_NUM_HEX 前不调用 CALOFFSET 子程序,
; 则无该问题
; ===================== THINK ==========
; 猜测是因为在 调用 PRINT_NUM_HEX 之前的一下语句错误
; MOV BP,AX
; MOV AX,[BP]
; 似乎不应该随意改变 BP 的值,但是,....删除后依然存在问题
; 最后.......发现一个事实,为什么不使用寄存器传返回值呢????????
; 于是,改用寄存器返回参数
; 问题,解决..........!!!!


; ; 将 AX 中的数据 以 16 进制输出
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
                JZ .printxreturn
                jmp PNH_STARTOUT
        .printxreturn:
        POP DX 
        POP CX 
        POP BX
        ret

end