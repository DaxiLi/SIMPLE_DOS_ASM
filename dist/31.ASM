; /*
;  * ;Description: 
; 31、在第2行、第3列处显示1个红色的‘*’，参考int 10h（用法类似int 21h）。
; 32、从第2行、第3列处开始显示4个红色的‘*’，参考int 10h（用法类似int 21h）。
; 33、从第2行、第3列处开始显示4个红色的‘*’；然后在第3行、第5列处显示一个红色的‘*’，参考int 10h（用法类似int 21h）。
; 34、从第2行、第3列处开始显示3个红色的‘*’；然后在第3行、第5列处显示一个红色的‘*’；然后在第4行、第4列处显示一个红色的‘*’；然后在第5行、第3列处显示一个红色的‘*’。参考int 10h（用法类似int 21h）。
; （1-6行，1-8列，即每个字符占6*8）
; 35、定义自己的字符编码集合，把str字符串中的字符按自己的编码显示输出。
; 36、从接口中获取系统时间，然后输出。（参考课本P223）
; 37、编写除法出错提示信息子程序，显示除法出错时你想显示到显示器上的信息（或其它操作），用编写的子程序替换系统自带的除法出错提示信息“divide error”
; 38、编写读取文件程序，把一个文件中的字符读出显示！
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-11 22:05:21
;  * ;FileName: 
;  */


; ======================= NOTE =============
; 二进制数	颜色	例子	    二进制数	颜色	    例子
; 0000	    黑色	black	    1000	    灰色	    gray
; 0001	    蓝色	blue	    1001	    淡蓝色	    light blue
; 0010	    绿色	green	    1010	    淡绿色	    light green
; 0011	    青色	cyan	    1000	    淡青色	    light cyan
; 0100	    红色	red	        1100	    淡红色	    light red
; 0101	    紫红色	magenta	    1101	    淡紫红色	light magenta
; 0110	    棕色	brown	    1110	    黄色	    yellow
; 0111	    银色	light gray	1111	    白色	    white


.MODEL SMALL
.DATA


.STACK

.CODE
.STARTUP
    ; =====================  test

    ; 这没啥好写的,还是看实验 38
    MOV AX,003H
    INT 10H         ; 设置显示模式 80x25 彩色


    MOV AX,'*'
    MOV BX,100B  
    MOV CX, 3
    MOV DX,0203H
    CALL SHOW_CHAR

    MOV DX ,0305H
    MOV CX,1 
    CALL SHOW_CHAR

    MOV DX,0404H
    CALL SHOW_CHAR

    MOV DX,0503H
    CALL SHOW_CHAR


.EXIT 0

;
; AX CHAR
; BX COLOR
; CX COUNTS
; DH: LINE  DL: COL
SHOW_CHAR:


    MOV BH,DH       ; TMP
    MOV CH,DL       ; TMP

    XOR BH,BH
    MOV AH,02H
    INT 10H         ; 设置光标位置
	
    MOV DH,BH
    MOV DL,CH       ; 恢复
    XOR CH,CH

    MOV AH,09H
    INT 10H

    ; POP DX
    ; POP CX
    ; POP BX
    ; POP AX
    ret


END