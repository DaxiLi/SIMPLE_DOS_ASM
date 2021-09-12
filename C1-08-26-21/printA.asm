;/*
; * @Description: 
; * @Author: 
; * @Data: 
; * @LastEdit: moogila@outlook.com
; * @LastEditTime: 2021-08-26 19:14:36
; * @FileName: 
; */

CODES SEGMENT
    ASSUME CS:CODES
START:
    
    ;此处输入代码段代码
    mov dl,'A'
    mov ah,2
    int 21h
    MOV AH,4CH  
    INT 21H  ;这两句是程序结束语句，通过4CH功能调用能够结束当前正在执行的程序，返回DOS系统，一般用于汇编程序的结束位置。
CODES ENDS
    END START