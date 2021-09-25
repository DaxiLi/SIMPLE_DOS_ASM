; /*
;  * ;Description: 编写输出子程序，把AX中的数以两个字符的形式（把AX两个字节中的二进制序列看成字符）显示输出，并在主程序中验证。
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-24 15:29:05
;  * ;FileName: 
;  */


MOV DL,AH
MOV AH,02
int 21H

MOV DL,AL
INT 21H