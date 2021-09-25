


.model small
.data


.stack
include JLIB.asm
.startup
    MOV AH,2Ah   ; 取日期CX=年
					; DH:DL=月:日(二进制) 
    int 21h
    MOV AX,CX
    MOV BX,DX
    call PROC_PRINT_NUM

    MOV DL,'Y'
    MOV AH,02
    int  21h

    XOR AX,AX
    MOV AL,BH
    call PROC_PRINT_NUM

    MOV DL,'M'
    MOV AH,02H
    int 21h

    XOR AX,AX
    MOV Al,BL
    call PROC_PRINT_NUM

    MOV Dl,'D'
    MOV AH,02H
    int 21h

    MOV AH,2CH
    int 21h

    XOR AX,AX
    MOV AL,CH
    call PROC_PRINT_NUM

    MOV Dl,'h'
    MOV AH,02H
    int 21H

    XOR AX,AX
    MOV AL,CL
    call PROC_PRINT_NUM

    MOV Dl,'m'
    MOV AH,02H
    int 21h

    XOR AX,AX
    MOV AL,DH
    call PROC_PRINT_NUM

    MOV Dl,'s'
    MOV AH,02H
    int 21h

.exit 0
end