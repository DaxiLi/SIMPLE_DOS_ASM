DATAS SEGMENT
    STR1 BYTE 'HELLO WORLLD!',0Ah,'$'
    STR2 BYTE 'PLEASE INPUT 8 NUMBERS(END WITH ENTER):',0Ah,'$'
    STR3 BYTE 'BEFORE SORT, THE 8 NUMBERS ARE:',0Ah,'$'
    STR4 BYTE 'AFTER SORT, THE 8NUMBERS ARE:',0Ah,'$'
    ; NUMARRAY WORD 8 DUP(0)
    NUMARRAY WORD  'B','A','C','F','E','G','D','E'

DATAS ENDS


STACK SEGMENT


STACK ENDS

CODE SEGMENT

START:

    LEA AX,STR1                     ; "hello world"
    CALL PROC_PRINT_STRING          ; 输出 
    ; LEA AX,STR2                     ; "pls input 8 numbers"
    ; CALL PROC_PRINT_STRING          ; 
    ; MOV CX,8                        ; 计数器 8
    ; LEA SI,NUMARRAY                 ; 将数组地址加载至 SI
    ; INPUT_NUMS:
    ;     CALL PROC_GET_NUM
    ;     MOV [SI],AX                 ; 调用GET_NUM 读取一个值,并将值放入 SI 地址
    ;     ADD SI,2                    ; 使用的 16 位 ,加 2
    ;     LOOP INPUT_NUMS             ; 循环输入
    ; LEA AX,STR3                     ; "print "BEFORE SORT, THE 8 NUMBERS ARE:""
    ; CALL PROC_PRINT_STRING          ; 
    ; LEA AX,NUMARRAY                 ; 函数调用约定 传入数组地址
    ; MOV BX,8                        ; 传入数组长度
    ; CALL PROC_PRINT_ARRAY           

    ; LEA AX,NUMARRAY                 ; 函数调用约定 传入数组地址
    ; MOV BX,8                        ; 传入数组长度
    ; CALL PROC_SORT

    ; LEA AX,STR4                     ; "AFTER SORT, THE 8NUMBERS ARE:"
    ; CALL PROC_PRINT_STRING

    ; LEA AX,NUMARRAY
    ; MOV BX,8
    ; CALL PROC_PRINT_ARRAY




; 函数调用约定
; 字符串地址从AX传入，输出直到'$''
PROC_PRINT_STRING proc
    PUSH BX 
    PUSH DX                            ; 将用到的寄存器压栈
        MOV BX,AX                      ; 将地址放到 bx 中
        MOV AH,02H                     ; 将 MOV AH ,02H 放到前面,减少循环次数
    PPS_LOOP:                         
        MOV DL,[BX]
        CMP DL,'$'                      
        JZ PPS_END                     ; 当 ....DL的值等于 '$' ....结束
        INT 21H;
        INC BX                         ; 地址加一
        JMP PPS_LOOP                   ; 继续
    PPS_END:
    POP DX
    POP BX                             ; 恢复
    MOV AX,0                           ; 返回值 0 放到ax中
    RET
PROC_PRINT_STRING endp



CODE ENDS
END START