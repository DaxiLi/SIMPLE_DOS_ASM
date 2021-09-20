; /*
;  * ;Description: DOS 文件读取 函数
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-19 10:35:51
;  * ;FileName: 
;  */
.model small

.data
DOSFILE_TMP db "hello world",20 dup(0),'$'
DOSFILENAME db "DOS.asm",0
ZHS_FILE_NAME db "HZK16",0, 10 dup  (0)
STR_OPENFILE_FAIL db "can not open file",13,'$',0
STR_MOVOFFSET_FAIL db "mov ofset fail",13,'$',0
STR_READFILE_FAIL db "can not read file",13,'$',0
FILE_HANDLE word 2 dup(0)
FILE_TMP word 'h',200 dup(0),'$'
.stack

.code
.startup

; lea AX,ZHS_FILE_NAME
; 参数压栈
; AX,文件地址       STACK TOP
; BX,读取字节数     SP + 2  
; CX:（DX）,偏移量      SP + 4
; DX: (偏移量）     SP + 6
; 缓存地址          SP + 8

LEA AX,FILE_TMP
PUSH AX             ; TMP_FILE SP + 8

XOR AX,AX
PUSH AX             ;   DX

PUSH AX             ;  CX

MOV AX,100d
PUSH AX             ; 读取数

LEA AX,DOSFILENAME
PUSH AX             ; 文件名

MOV AX,SP

call PRINT_NUM_HEX

call openfile
      


add sp,10d

lea dx,FILE_TMP
mov ah,09h
int 21h

; lea ax,FILE_TMP
; push ax
; lea ax,DOSFILENAME
; mov bx,15
; xor cx,cx
; mov dx,0






.exit 0




; ============= 扩展资料=========
; 一个GB2312汉字是由两个字节编码的,范围为0xA1A1~0xFEFE. 
; A1-A9为符号区, B0到F7为汉字区. 每一个区有94个字符
; 区码:汉字的第一个字节-0xA0 
; (因为汉字编码是从0xA0区开始的, 所以文件最前面就是从0xA0区开始, 要算出相对区码)
; 位码:汉字的第二个字节-0xA0
; (94*(区码-0xa1)+(位码-0xa1))*32
; 将汉字计算 在 HKZ16 字库中的偏移量
; AX 传送 2 字节数据
; 返回值 在 DX:AX 中
calOffsetZH:
;     PUSH DX
    PUSH CX
    PUSH BX
;     PUSH BP

    XOR DX,DX
    XOR BX,BX

    SUB AX,0A1A1h       ; - A1
    MOV BL,AL           ; BX 00AL
    MOV AL,AH
    XOR AH,AH
    MOV CX,94D
    MUL CL
    ADD AX,BX

    MOV CX,32D
;     XOR DX,DX
    MUL CX              ; 结果超过16位,使用32位乘法

;     LEA BP,ZH_OFFSET
;     MOV [BP],DX
;     MOV [BP - 2],AX
;     MOV AX,BP
    
;     POP BP
    POP BX
    POP CX
;     POP DX
    ret
; ============================================= NOTE =======================================
; openfile ----------- 子程序:
;   Q：运行时，程序头一天运行良好，第二天突然不能运行//。。。。。心塞
;       经测试，发现，程序在 MIAN （START）里面正常运行，放到子函数不能正常运行
;       测试猜测 SP 偏移量计算错误，但是由于程序后面使用 DOS 09 中断输出字符串，
;       该中断会覆盖使用DOS 02 中断输出的字符，导致卡点的输出调试信息不显示
;       并且,在之前编写 PRINTF 子程序时,和该程序使用同样的压栈传参方式,未发生异常
;       因此，没有将原因定位到 SP 指针上，猜测是 使用 BP 寄存器的原因。
;       
;  A: 后经测试,发现是 SP 指针的问题,在使用 压栈传递参数时,需要靠栈顶偏移量确定参数,
;       由于没有考虑 call 指令在调用时的压栈操作,错误的将偏移量少加 2 ,导致参数错误传递
;       相关 call 指令背景:
;
;  <1> 段内直接调用: CALL NEAR类型的过程名 
;               每一个过程在定义时,应指定它是近类型(NEAR),还是远类型(FAR).本指令
;               是段内直接调用,因而过程与调用指令同处在一个代码段内.在执行该调用
;               指令时,首先将IP的内容入栈保护,然后由指令代码给出的目的地址段内偏
;               移量送入IP,从而实现过程调用,将程序转至过程入口. 

;           <2> 段内间接调用: CALL OPRD 
;               其中OPRD为16位通用寄存器或存储器数. 
;               本指令执行时,首先将IP的内容入栈保护,然后将目的地址在段内偏移量由 
;               指定的16位寄存器或存储器字中取至IP中,从而实现过程调用. 
;               例如: CALL BX 
;                     CALL WORD PTR [BX+SI+20] 
;               注意: 寄存器间接调用时,寄存器不用方括号括起来.如果用方括号,则为 
;                      存储器操作数间接调用.
 
;           <3> 段间直接调用: CALL FAR 类型的过程名 
;               由于是段间调用,在指令执行时,应同是时将当前的CS及IP的值入栈保护,然 
;               后将FAR类型的过程名所在的段基址和段内偏移值送CS及IP, 从而实现过程
;               调用.

;           <4> 段间间接调用: CALL DWOPRD  
;               其中DWOPRD为存储器操作数,段间间接调用只能通过存储器双字进行.本指 
;               令执行时,首先将当前的CS及IP的值入栈保护,然后将存储器双字操作数的 
;               第一个字的内容送IP,将第二个字的内容送CS,以实现段间调用. 
;               例如: CALL DWOPRD PTR[SI]




; lea AX,ZHS_FILE_NAME
; 参数压栈
; AX,文件地址       STACK TOP
; BX,读取字节数     SP + 2  
; CX:（DX）,偏移量  SP + 4
; DX: (偏移量）     SP + 6
; 缓存地址          SP + 8
openfile:
        PUSH BP
        mov BP,SP
        add BP,4                    ; AT FILENAME
        
        XCHG AX,BP
        call PRINT_NUM_HEX
        XCHG AX,BP

        PUSH DX
        PUSH CX
        PUSH BX
        PUSH AX

        ; ============== OPEN FILE ================
        MOV AH,3DH
        MOV DX,[BP]
        MOV AL,0                    ; open attribute: 0 - read-only, 1 - write-only, 2 -read&write 
        INT 21H                     ; If file exists, it’s handle is returned in AX, if file doesn’t exist Carry Flag is set. Now we can read from our file:
        jc .openfilefail 
        MOV [FILE_HANDLE],AX

        ; ============== SET PTR OFFSET OF FILE ===
        MOV AH,42H
        MOV BX,[FILE_HANDLE]
        MOV CX,[BP + 4]
        MOV DX,[BP + 6]             ; CX:DX : 位移量
        MOV AL,0                    ; 从文件头开始
        int 21H                     ; 如果成功，DX:AX= 新文件指针位置
        jc .movoffsetfail

        ; ============== READ FROM FILE ===========
        MOV AH,3FH
        MOV BX,[FILE_HANDLE]        ; HANDLE
        MOV CX,[BP + 2]             ; 读取字节数
        MOV DX,[BP + 8]             ; 缓存地址
        int 21H
        jc .readfilefail

        MOV AH,3EH
        MOV DX,[FILE_HANDLE]                                     ;CLOSE
        INT 21H  

        jmp .return
        
    .movoffsetfail:
        lea dx,STR_MOVOFFSET_FAIL
        mov ah,09h
        int 21h
        jmp .return

    .openfilefail:
        lea dx,STR_OPENFILE_FAIL
        mov ah,09h
        int 21h
        jmp .return
    .readfilefail:
        lea dx,STR_READFILE_FAIL
        mov ah,09h
        int 21h
        jmp .return

    .return:
    POP AX
    POP BX
    POP CX
    POP DX
    POP BP
    ret

createfolder:
        ; xor ,ax,ax

; 将 AX 中的数据 以 16 进制输出
PRINT_NUM_HEX:
        PUSH AX
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
        POP AX
        RET


end