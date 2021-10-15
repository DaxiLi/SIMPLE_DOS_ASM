;Description: 
;26、编写子程序，把以‘$’结尾的字符串输出显示（有无入口参数？需要用循环实现）。
;27、综合实验5中子函数，完成如下操作：
; （1）用提示信息提示用户输入8个数，每个数输入后换行，在下一行输入下一个数；
; （2）输入后在新的一行显示这8个数；
; （3）然后对这8个数排序；
; （4）在新的一行显示排序后的8个数。
;Author: Yuan Jie
;LastEdit: moogila@outlook.com
;LastEditTime: 2021-09-10 13:06:01
;FileName: J1s26.asm



;========== Q ======
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
    STR2 BYTE 13,10,'PLEASE INPUT A NUMBER:',0DH,0Ah,0,'$'
    STR3 BYTE 13,10,'BEFORE SORT, THE %d NUMBERS ARE:',0dh,0Ah,0,'$'
    STR4 BYTE 13,10,'AFTER SORT, THE %d NUMBERS ARE:',13,0Ah,0,'$'
    STR5 BYTE 13,10,'PLEASE INPUT %d NUMBERS(END WITH ENTER):',13,0Ah,0,'$'
    STR6 BYTE 13,10,'BEFORE SORT, THE %d NUMBERS ARE(HEX):',13,0Ah,0,'$'
    STR7 BYTE 13,10,'BEFORE SORT, THE %d NUMBERS ARE(BIN):',13,0Ah,0,'$'
    NUMARRAY WORD  'B','A','C','F','E','G','D','E'


.STACK
.CODE 
;write your code here
.STARTUP

    ; ============= 带符号 正负数输出 测试 =============
    MOV AX,0FFFFh
    call PRINT_SNUM_D               ; 输出 -1 带符号输出整形

    ; ============ 输出换行回车 =====================
    MOV DL,13d
    INT 21H                         ; 输出换行符 \r
    MOV AH,02
    MOV DL,0ah
    INT 21H                         ; 输出回车符 \n 

    MOV AX,1
    call PRINT_SNUM_D               ; 输出  1 正数 省略 + 

    ; =============== 把以‘$’结尾的字符串输出显示 ===========
    LEA AX,STR1                     ; "hello world"
    CALL PROC_PRINT_STRING          ; 输出 

    ; =============== 输出 字符串 printf ==========
    LEA AX,STR2                     ; "pls input A number"
    CALL PRINTF         ; 


    CALL PROC_GET_NUM

    MOV CX,AX                       ; 计数器 
    MOV BX,AX

    ; MOV CX,8                        
    LEA AX,STR5                     ; "PLEASE INPUT %d NUMBERS(END WITH ENTER):"
    CALL PRINTF

    ; ============== 循环输入数组 数字 ===================
    LEA SI,NUMARRAY                 ; 将数组地址加载至 SI
    INPUT_NUMS:
        CALL PROC_GET_NUM
        MOV [SI],AX                 ; 调用GET_NUM 读取一个值,并将值放入 SI 地址
        ADD SI,2                    ; 使用的 16 位 ,加 2
        LOOP INPUT_NUMS             ; 循环输入

    LEA AX,STR3                     ; "print "BEFORE SORT, THE 8 NUMBERS ARE:""
    CALL PRINTF                     ; 
    LEA AX,NUMARRAY                 ; 函数调用约定 传入数组地址
    ; MOV BX,8                        ; 传入数组长度
                                    ; BX 明确未改变,故不重复赋值
    CALL PROC_PRINT_ARRAY       

    ; =============== 16 进制 输出数组 =============
    LEA AX,STR6                ; HEX
    call PRINTF
    LEA AX,NUMARRAY
    call PROC_PRINT_ARRAY_HEX

    ; ============== 2 进制输出数组 ==============
    LEA AX,STR7                 ; BIN
    call PRINTF
    LEA AX,NUMARRAY
    call PROC_PRINT_ARRAY_BIN

    ; ================ 排序  =====================
    LEA AX,NUMARRAY                 ; 函数调用约定 传入数组地址
    ; MOV BX,8                        ; 传入数组长度
                                    ; BX 明确未改变,故不重复赋值
    CALL PROC_SORT

    LEA AX,STR4                     ; "AFTER SORT, THE %d NUMBERS ARE:"
    CALL PRINTF

    ; ============= 10 进制 输出 排序后数组
    LEA AX,NUMARRAY                                 ; BX 明确未改变,故不重复赋值
    CALL PROC_PRINT_ARRAY


    ; ======== 结束

.EXIT 0


; 该子程序有已知 BUG ，不可使用跨段区 堆栈传参
; 实现类 c 语言 printf 的功能
; 使用 CDCEL 函数调用约定 
PRINTF:
    PUSH DX
    PUSH CX
    PUSH BX 
    PUSH BP
    PUSH SI

    ; call printbx

    MOV BP,AX               ; AX 为字符串首地址 
    MOV SI,SP               ; CDCEL 多余的参数使用栈传递,同时程序结束时,不清理堆栈,所以,需要记录初始堆栈顶部,以恢复堆栈
    ADD SI,4                ; 跳过栈中 BP SI 的值,
    OUT_PRINTF:
        MOV BX,[BP]         ; 将内存值放入 BX ,避免后续重复读取内存
        TEST BL,BL         
        JZ OUT_END          ; 为 0 ,截断字符串,结束
        CMP BL,'$'          
        JZ OUT_END          ; 为兼容 DOS 以 '$' 结尾字符串,同时判断是否 '$'
        CMP BL,'%'          ; 处理格式化输出
        JZ FORMAT_PRINTF    ; 直接输出字符
        MOV AH,02H
        MOV DL,BL
        INT 21H
        INC BP
        JMP OUT_PRINTF

    FORMAT_PRINTF:          ; 开始处理 % 后下一个字符
        INC BP              
        MOV BX,[BP]         
        CMP BL,'d'          ; d 输出整型
        JZ D_FORMAT
        CMP BL,'x'          ; x 16进制
        JZ X_FORMAT
        CMP BL,'b'          ; b 2进制
        JZ B_FORMAT
        CMP BL,'s'          ; s 字符串 和 有符号整型 ...... 自己莫名想这么做
        JZ S_FORMAT
        DEFAULT_FORMAT:     ; 啥也没有,直接输出 '%'
        MOV AH,02H
        MOV DL,'%'
        INT 21H
        INC BP
        JMP OUT_PRINTF

        D_FORMAT:           
        MOV AX,[SI]         ; 取堆栈值
        DEC SI              
        CALL PROC_PRINT_NUM 
        INC BP
        JMP OUT_PRINTF

        X_FORMAT:
        MOV AX,[SI]
        DEC SI
        CALL PRINT_NUM_HEX
        INC BP
        JMP OUT_PRINTF

        B_FORMAT:
        MOV AX,[SI]
        DEC SI
        CALL PRINT_NUM_BIN
        INC BP
        JMP OUT_PRINTF

        S_FORMAT:
        MOV AX,[SI]
        DEC SI
        INC BP
        MOV DX,[BP]
        CMP DX,'d'
        JZ S_FORMAT1
        CALL PROC_PRINT_STRING
        S_FORMAT1:
        CALL PRINT_SNUM_D
        INC BP
        JMP OUT_PRINTF

    OUT_END:
    POP SI
    POP BP
    POP BX
    POP CX
    POP DX
    ret

; 输出 ARRAY 
; AX 为地址
; BX 为长度
; 无返回值
PROC_PRINT_ARRAY_BIN:
    PUSH SI
    PUSH CX 
    PUSH DX
        MOV SI,AX 
        MOV CX,BX     
    PPAB_LOOP:
        MOV AX,[SI]

        ; call PRINT_NUM_HEX
        call PRINT_NUM_BIN

        MOV AH,02H
        MOV DL,'B'                  ; 以空格分割
        INT 21H 

        MOV AH,02H
        MOV DL,' '                  ; 以空格分割
        INT 21H
        ADD SI , 2
        LOOP PPAB_LOOP
        MOV  DL,0AH
        INT 21H
    POP DX
    POP CX 
    POP SI 
    RET

; 输出 ARRAY 
; AX 为地址
; BX 为长度
; 无返回值
PROC_PRINT_ARRAY_HEX:
    PUSH SI
    PUSH CX 
    PUSH DX
        MOV SI,AX 
        MOV CX,BX     
    PPAH_LOOP:
        MOV AX,[SI]    

        call PRINT_NUM_HEX

        MOV AH,02H
        MOV DL,'H'                  ; 以空格分割
        INT 21H 

        
        MOV AH,02H
        MOV DL,' '                  ; 以空格分割
        INT 21H
        ADD SI , 2
        LOOP PPAH_LOOP
        MOV  DL,0AH
        INT 21H
    POP DX
    POP CX 
    POP SI 
    RET

; 输出 ARRAY 
; AX 为地址
; BX 为长度
; 无返回值
PROC_PRINT_ARRAY:
    PUSH SI
    PUSH CX 
    PUSH DX
        MOV SI,AX 
        MOV CX,BX     
    PPA_LOOP:
        MOV AX,[SI]
        CALL PROC_PRINT_NUM

        ; MOV AH,02H
        ; MOV DL,':'                  ; 以空格分割
        ; INT 21H        

        ; call PRINT_NUM_HEX

        ; MOV AH,02H
        ; MOV DL,'H'                  ; 以空格分割
        ; INT 21H 

        ; MOV AH,02H
        ; MOV DL,':'                  ; 以空格分割
        ; INT 21H        

        ; call PRINT_NUM_BIN

        ; MOV AH,02H
        ; MOV DL,'B'                  ; 以空格分割
        ; INT 21H 

        MOV AH,02H
        MOV DL,' '                  ; 以空格分割
        INT 21H
        ADD SI , 2
        LOOP PPA_LOOP
        MOV  DL,0AH
        INT 21H
    POP DX
    POP CX 
    POP SI 
    RET


; 排序 传入两个参数 第一个 数组地址 第二个 数组长度
; 
PROC_SORT:
    PUSH CX
    PUSH DX 
    PUSH SI 
    PUSH DI
        MOV CX,BX
        DEC CX
        ADD CX,CX                           ; x2
        MOV BP,AX                           ; 基址
    PS_FORI:
        MOV SI,CX                           ;  
        MOV AX,[BP + SI]                    ; 将末尾值放入 AX 比较,避免多次读取内存 mov ax,array[array.length]
        LEA DI,[BP + SI]                    ; 尾值地址
    PS_FORJ: 
        SUB SI,2
        CMP AX,[BP + SI]                    ; if array[array.length] < array[array.length - 1]
        JNB PS_NO_SWAP                      ; 无需交换 JMP 
        XCHG AX,[BP + SI]
        MOV [DI],AX
    PS_NO_SWAP:
        CMP SI ,1                           ; 到0 则结束
        JNB PS_FORJ
        DEC CX                              ; 手动 -1 总共 -2
        LOOP PS_FORI
    POP DI
    POP SI
    POP DX
    POP CX
    RET


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

; ================ NOTE =========
; 在独自测试时, mul bl , 假若结果超出 8 位, AH 位 为 1
; 所以:
;   MOV AX,6553D
;   MOV BL,10D
;   MUL BL      ; AX -> 15530D
; 而:
;   MOV AX,6553D
;   MOV BX,10D
;   MUL BX      ; AX -> 65530D
; 但是在下面的程序里面
; PGN_LOOP:
;   MOV AH,01
;   INT 21H
;   CMP AL,0DH
;   JZ PGN_END      ; 输入为 \n 则结束
;   AND AX,00FFH    ; 将 AH 值置零
;   SUB AL,'0'      ;
;   XCHG AX,DX      ; 将值交换 , 以做乘法
;   MUL BX          
;   ADD AX,DX       ; x10 后将个位加上
;   XCHG AX,DX      ; 换回来
;   JMP PGN_LOOP    ; 继续输入
; 如果使用 BX -> 10d
; 最后程序返回的值永为 0 
; 使用 BL ,返回 低于 8 位的数字正常,高于 8 位 高位为 1
;
; NOTE : 16位乘法时,AX中为被乘数.8位乘法时,AL为被乘数.当16位乘法时,32位的乘积            存于DX及AX中;8位乘法的16位乘积存于AX中. 
; 所以在使用 BX 作为乘数时, DX 会被置为 0
; 而在下面的代码中使用 XCHG AX,DX ,使用 DX 暂存输入在 AX 中的值

;获得输入的十进制数字
;返回值在 AX 中
PROC_GET_NUM:
    PUSH BX
    PUSH CX
    PUSH DX
        xor AX,AX
        XOR CX,CX        ; 存储已输入值
        MOV BX,10D
    PGN_LOOP:
        MOV AH,01
        INT 21H
        CMP AL,0DH
        JZ PGN_END      ; 输入为 \n 则结束
        AND AX,00FFH    ; 将 AH 值置零
        SUB AL,'0'      ;
        XCHG AX,CX      ; 将值交换 , 以做乘法
        MUL BX          
        ADD AX,CX       ; x10 后将个位加上
        XCHG AX,CX      ; 换回来
        JMP PGN_LOOP    ; 继续输入
    PGN_END:
        MOV AX,CX       ; 将值放入 AX 返回
    POP DX 
    POP CX
    POP BX
    ret


; 函数调用约定
; 字符串地址从AX传入，输出直到'$''
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


; 将 AX 中的数据以十进制输出 区分正负 正号省略
;
PRINT_SNUM_D:
        PUSH BX 
        PUSH DX
 
        TEST AX,8000H
        JZ PSD_OUT
                MOV BX,AX 
                MOV AH,02H
                MOV DL,'-'
                INT 21H
                ; NEG BX
                NOT BX
                INC BX 
                MOV AX,BX
        PSD_OUT:
        CALL PROC_PRINT_NUM
        POP DX 
        POP BX
        RET


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


; 将 AX 中的数据以二进制形式输出至屏幕
PRINT_NUM_BIN:
        PUSH BX 
        PUSH CX 
        PUSH DX
                MOV BX,AX
                MOV AH,02H
                MOV CX,16D
        PNB_STARTSHL:
                SHL BX,1
                JC PNB_STARTOUT
                LOOP PNB_STARTSHL
                INC CX                  ; 为 0 ,需要输出一次 ,cx +1
        PNB_STARTOUT:
                MOV DL,'0'
                JNC $+4
                INC DL                  ;
                INT 21H
                SHL BX,1
                LOOP PNB_STARTOUT
        POP DX 
        POP CX 
        POP BX
        ret


END