
; Description: 
;   28、编写输出子程序，把AX中的数以二进制形式显示输出，并在主程序中验证。（需要使用循环移位指令，逻辑与指令。）
;   29、编写输出子程序，把AX中的数以十六进制形式显示输出，并在主程序中验证。（需要使用循环移位指令，逻辑与指令。）
;   30-1、编写输出子程序，把AX中的数以两个字符的形式（把AX两个字节中的二进制序列看成字符）显示输出，并在主程序中验证。
;   30-2、编写输出子程序，把AX中的数以带符号十进制形式（把AX中的二进制序列看成带符号数，ax=123，显示123，ax=-123，显示-123，参考neg指令）显示输出，并在主程序中验证。
;
; Author: Yuan Jie
; Data: 
; LastEdit: moogila@outlook.com
; LastEditTime: 2021-09-11 13:48:09
; FileName: 



; =============== NOTE =====
; TEST
; TEMP ←SRC1 AND SRC2;
; 　　SF ←MSB(TEMP);
; IF TEMP = 0
; 　　THEN ZF ←1;
; 　　ELSE ZF ←0;
; 　　FI:
; 　　
; 　　PF ←BitwiseXNOR(TEMP[0:7]);
; 　　CF ←0;
; 　　OF ←0;
; 　　(* AF is undefined *)

.MODEL SMALL

.DATA

.STACK

.CODE
.STARTUP


; ======================= TEST ===========
; MOV AX,0
        
;     CALL PRINT_NUM_BIN
; MOV AX,5
; CALL PRINT_NUM_BIN

; MOV AX,256
; CALL PRINT_NUM_BIN
; CALL PRINT_NUM_HEX
; MOV AX,1111111111111110B

; ==========================================
MOV AX,-2
CALL PRINT_SNUM_D






PROEND:
.EXIT 0

; 将 AX 中的数据以十进制输出 区分正负
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


; 以十进制输出数字
; 传入参数在 AX
PROC_PRINT_NUM:
    PUSH BX 
    PUSH CX 
    PUSH DX 
        MOV CX,10D
        XOR BX,BX               ; 计数
    PPN_LOOP:
        XOR DX,DX               ; 如果不写这一句会卡住，玄，不懂 虽然是使用两个寄存器的值,但是,为什么我一定要置零一下呢
        DIV CX
                                ; 余数在 DX 中 商在  AX 中
        INC BX                  ; 计数 +1
        ADD DX,'0'
        PUSH DX                 ; 压入堆栈
        TEST AX,AX              ; 测试 AX 是否为空 
        JNZ PPN_LOOP            ; 不为空 继续 输出
        MOV AH,02H
        MOV CX,BX               ; 将计数 放入CX
    PPN_OUT:
        POP DX
        INT 21H 
        LOOP PPN_OUT            ; 循环从堆栈输出字符
    POP DX 
    POP CX 
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
                INC DL                  ; MOV DL,'1' 的变态写法
                INT 21H
                SHL BX,1
                LOOP PNB_STARTOUT
        POP DX 
        POP CX 
        POP BX
        ret

WXH28:
        PUSH BX
    	PUSH CX
    	PUSH DX
    	
    	MOV CX,0
    LAGAIN:
    	ROL AL,1
    	MOV BL,AL
    	AND AL,00000001B
    	MOV DL,AL
    	ADD DL,48
    	MOV AH,2
    	INT 21H
    	ADD CX,1
    	MOV AL,BL
    	CMP CX,8
    	JE LOVER
    	JMP LAGAIN
    LOVER:		
    	POP DX
    	POP CX
    	POP BX
    	RET
END