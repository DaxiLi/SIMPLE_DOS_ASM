;Description: 
;26、编写子程序，把以‘$’结尾的字符串输出显示（有无入口参数？需要用循环实现）。
;Author: Yuan Jie
;LastEdit: moogila@outlook.com
;LastEditTime: 2021-09-10 13:06:01
;FileName: J1s26.asm



;========== QUESTION  ======
; 短类型转移  长类型转移 
;
; 寻址方式错误
; MASM 变址寻址方式
; 书中范例:
; 1. mov edi,[ebx + esi]
;    mov edi,[ebx + edx + 80h]
;    mov eax,[ebx][esi]
;    mov wax,80h[ebx + eax] 
;    mov eax,80h[ebx][eax]
;
;   但在实际 DOS MASM 中使用 mov ax,[si + dx] 寻址错误 A2031
;       使用 mov ax,[si + bx] 则不会报错
;   微软解释:
;       must be index or base register
;       An attempt was made to use a register that was not a base or index register in a memory expression.
;   解释及解答:
;       在 32 位处理器上 才可以通过:
;                基址寄存器(8个寄存器) + 变址寄存器(除ESP外的7个寄存器) * 比例 + 位移量
;           寻址
;       在 16 位处理器 只能使用:
;                基址寄存器(BX , BP) + 变址寄存器(SI , DI) + 位移量
;   在 DOS 环境下 使用 IA32 的寻址方式 会报错 error A2032 或 error A2031



;==========   NOTE ==== ===== 
; 1. AX 寄存器的值常常莫名改变
;   例如在 函数返回后 ,使用 AX 传送返回值
;   向 DX ???\\ BX 传送值
;   疑似 DEBUG 时 错误使用 N 指令导致
;   
; 2. 在 DIV CX 指令前,如果不xor dx,dx 程序会卡住
;
; 3.寻址是INC SI 只加 1 , 而 DWORD 是 16 位 ,是两个字节 ,所以需要 +2 
;
; 4. 寻址不可直接 [SI + BX + CX] 这样使用
;
;
;=============  函数调用约定  =====
;   参数从左到右使用 AX , BX , CX , DX 传入
;   更多参数从右至左压入堆栈
;

.MODEL SMALL
.DATA
    STR1 BYTE 13,10,'HELLO WORLLD!',0DH,0Ah,0,'$'
.STACK
.CODE 
;write your code here
.STARTUP

    LEA AX,STR1                     ; "hello world"
    CALL PROC_PRINT_STRING          ; 输出 
    LEA AX,STR1                     ; "pls input A number"
    CALL PRINTF         ; 


.EXIT 0


; 函数调用约定
; 字符串地址从AX传入，输出直到'$'
PROC_PRINT_STRING:
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

; 运行该代码请把以下子程序注释
; 实现类 c 语言 printf 的功能
; 该子程序有已知 bug : 在段间调用时,错误,原因是,没有使用 BP 传递调用前栈顶指针,在调用时,
;   call如果时FAR调用,会在堆栈顶部压入两个值,导致栈顶指针计算错误.解决方案时,在调用前,以BP传递栈顶指针
; 此外,该子程序依赖其他3个子程序 emmm ,在 J1SLIB中可以找到全部实现
; 使用 CDCEL 函数调用约定 
PRINTF:
    ; PUSH DX
    ; PUSH CX
    ; PUSH BX 
    ; PUSH BP
    ; PUSH SI

    ; ; call printbx

    ; MOV BP,AX               ; AX 为字符串首地址 
    ; MOV SI,SP               ; CDCEL 多余的参数使用栈传递,同时程序结束时,不清理堆栈,所以,需要记录初始堆栈顶部,以恢复堆栈
    ; ADD SI,4                ; 跳过栈中 BP SI 的值,
    ; OUT_PRINTF:
    ;     MOV BX,[BP]         ; 将内存值放入 BX ,避免后续重复读取内存
    ;     TEST BL,BL         
    ;     JZ OUT_END          ; 为 0 ,截断字符串,结束
    ;     CMP BL,'$'          
    ;     JZ OUT_END          ; 为兼容 DOS 以 '$' 结尾字符串,同时判断是否 '$'
    ;     CMP BL,'%'          ; 处理格式化输出
    ;     JZ FORMAT_PRINTF    ; 直接输出字符
    ;     MOV AH,02H
    ;     MOV DL,BL
    ;     INT 21H
    ;     INC BP
    ;     JMP OUT_PRINTF

    ; FORMAT_PRINTF:          ; 开始处理 % 后下一个字符
    ;     INC BP              
    ;     MOV BX,[BP]         
    ;     CMP BL,'d'          ; d 输出整型
    ;     JZ D_FORMAT
    ;     CMP BL,'x'          ; x 16进制
    ;     JZ X_FORMAT
    ;     CMP BL,'b'          ; b 2进制
    ;     JZ B_FORMAT
    ;     CMP BL,'s'          ; s 字符串 和 有符号整型 ...... 自己莫名想这么做
    ;     JZ S_FORMAT
    ;     DEFAULT_FORMAT:     ; 啥也没有,直接输出 '%'
    ;     MOV AH,02H
    ;     MOV DL,'%'
    ;     INT 21H
    ;     INC BP
    ;     JMP OUT_PRINTF

    ;     D_FORMAT:           
    ;     MOV AX,[SI]         ; 取堆栈值
    ;     DEC SI              
    ;     CALL PROC_PRINT_NUM 
    ;     INC BP
    ;     JMP OUT_PRINTF

    ;     X_FORMAT:
    ;     MOV AX,[SI]
    ;     DEC SI
    ;     CALL PRINT_NUM_HEX
    ;     INC BP
    ;     JMP OUT_PRINTF

    ;     B_FORMAT:
    ;     MOV AX,[SI]
    ;     DEC SI
    ;     CALL PRINT_NUM_BIN
    ;     INC BP
    ;     JMP OUT_PRINTF

    ;     S_FORMAT:
    ;     MOV AX,[SI]
    ;     DEC SI
    ;     INC BP
    ;     MOV DX,[BP]
    ;     CMP DX,'d'
    ;     JZ S_FORMAT1
    ;     CALL PROC_PRINT_STRING
    ;     S_FORMAT1:
    ;     CALL PRINT_SNUM_D
    ;     INC BP
    ;     JMP OUT_PRINTF

    ; OUT_END:
    ; POP SI
    ; POP BP
    ; POP BX
    ; POP CX
    ; POP DX
    ; ret




END