; /*
;  * ;Description: 编写输出子程序，把AX中的数以十六进制形式显示输出，并在主程序中验证。（需要使用循环移位指令，逻辑与指令。）
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-24 15:29:05
;  * ;FileName: 
;  */

; 此处给出子程序实现

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
