; /*
;  * ;Description: 编写输出子程序，把AX中的数以2进制形式显示输出，并在主程序中验证。（需要使用循环移位指令，逻辑与指令。）
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-24 15:29:05
;  * ;FileName: 
;  */

; 运行效果见 27综合程序.asm
; 此处给出子程序实现


; 将 AX 中的数据 以 2 进制输出

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
