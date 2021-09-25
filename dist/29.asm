; /*
;  * ;Description: 编写输出子程序，把AX中的数以十六进制形式显示输出，并在主程序中验证。（需要使用循环移位指令，逻辑与指令。）
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-24 15:29:05
;  * ;FileName: 
;  */

; 运行效果见 28.asm
; 此处给出子程序实现

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
