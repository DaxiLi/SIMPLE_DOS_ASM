.DATA

FILE_HANDLE word 2 dup(0)
ZHS_FILE_NAME db "HZK16",0, 10 dup  (0)
STR_OPENFILE_FAIL db "can not open file",13,'$',0
STR_MOVOFFSET_FAIL db "mov ofset fail",13,'$',0
STR_READFILE_FAIL db "can not read file",13,'$',0



.CODE

    ROW_PIXEL equ 340d
    BLACK equ 0h
    BLUE equ 1h
    GREEN equ 2h
    CYAN equ 3h
    RED equ 4h
    MAGENTA equ 5h
    BROWN equ 6h
    LIGHT_GRAY equ 7h
    DARK_GRAY equ 8h
    LIGHT_BLUE equ 9h
    LIGHT_GREEN equ 0ah
    LIGHT_CYAN equ 0bh
    LIGHT_RED equ 0ch
    LIGHT_MAGENTA equ 0dh
    YELLOW equ 0eh
    WHITE equ 0fh

    PADDING equ 2h
    LINE_SPACE equ 1d 
    WORD_SAPCE equ 2d
    SCREEN_WIDTH equ 320d
    SCREEN_HEIGHT equ 200d
    WORD_WIDTH equ 16d
    WORD_HEIGHT equ 16d
    EACH_LINE_WORDS equ (SCREEN_WIDTH - PADDING - PADDING)/(WORD_WIDTH + WORD_SAPCE)
    EACH_SCREEN_LINES equ (SCREEN_HEIGHT - PADDING)/(WORD_HEIGHT + LINE_SPACE)

    FONT_COLOR equ GREEN
    BACKGROUND_COLOR equ BLACK
    CLS_COLOR equ BACKGROUND_COLOR


; AX 缓存地址
; BX 汉字编码
; 目前仅支持双字节的GBK汉字编码,
; 16 点英文符号 , 日后看心情
loadwordmodel:
; === 加载字库 读取字模 ==
; lea AX,ZHS_FILE_NAME
; 参数压栈
; AX,文件地址       STACK TOP
; BX,读取字节数     SP + 2  
; CX:（DX）,偏移量      SP + 4
; DX: (偏移量）     SP + 6
; 缓存地址          SP + 8
    PUSH AX
    PUSH BP

    PUSH AX             ; TMP_FILE SP + 8

    mov AX,BX
    call calOffsetZH        ; 计算偏移
    push AX
    push DX

    MOV AX,32d          ; 假若支持 16 点字库,该值改动
    PUSH AX             ; 读取数

    LEA AX,ZHS_FILE_NAME
    PUSH AX             ; 文件名

    mov bp,sp           ; 传入 BP 作为栈顶指针传入,用于栈内传参
    ; add bp,2            

    call near  ptr  openfile 
        
    add sp,10d          ; 恢复现场
    ; ==  读取完毕 ===
    POP BP
    POP AX
    ret

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
        CMP [BP],'d'
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
PROC_PRINT_ARRAY:
    PUSH SI
    PUSH CX 
    PUSH DX
        MOV SI,AX 
        MOV CX,BX     
    PPA_LOOP:
        MOV AX,[SI]
        CALL PROC_PRINT_NUM
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





; ====== 设置显示模式 位 13H ======
SETDISPLAYMOD:
    PUSH  AX
    PUSH BX
    mov ax,0013h
    mov bh,00h
    int 10h
    POP BX
    POP AX
    ret

; ========= cls  ===============
; 10   6   屏幕初始化或上卷	  AL=上卷行数
; 			  AL=0 整个窗口空白
; 			  BH=卷入行属性
; 			  CH=左上角行号
; 			  CL=左上角列号
; 			  DH=右下角行号
; 			  DL=右下角列号 
CLS:
    push AX
    push bx

    mov ax,0600h
    mov bh,CLS_COLOR            ; BH 屏幕初始化颜色
    mov cx,0
    mov dx,0184fh
    int 10h

    pop bx
    pop ax
    ret

; 从 AX 的位置开始的数据,将点阵输出于屏幕
; 使用 16 位点阵字库
; BH : row ; BL : rol
PUTS:
    push dx
    push cx
    push bx
    push ax
    push si
    push bp

        mov bp,ax
        mov si,sp
        add si,4
            mov cx,16
            mov ax,0a000h
            mov es,ax

            ; ======= ======== 计算行偏移像素 =========

            mov ax,WORD_HEIGHT
            add ax,LINE_SPACE
            mul bh                  ; x offset
            add ax,PADDING          ; padding top
            mov cx,ax               ; 纵轴偏移量 => (行数 * (一行的像素数 + 行间距像素数) ) + 顶边距的像素数 就是总的便宜像素行数

            ; mov ax,LINE_SPACE
            ; mul bh
            ; add cx,ax               ; 行间距


            ; ============== 计算列偏移像素 =======

            xor dx,dx               ; 16 bit 乘法前必须
            mov ax,SCREEN_WIDTH     ; 屏幕宽度
            mul cx                  ; CX -> 行像素数
                                    ; 由于屏幕最大偏移量为 320 * 200 = 64000 不超出 16 位,所以不必考虑 DX 值
            mov si,ax         

            mov ax,WORD_WIDTH       ; 字符宽度
            add ax,WORD_SAPCE       ; 字间距
            mul bl                  ; 列
            add si,ax               
            add si,PADDING          ; 左留白 padding left

            ; add ax,WORD_SAPCE
            ; mul bl
            ; add si,AX               ; 字间距

            ; ============= 开始在偏移处写入像素 ======
            xor cx,cx
    .jmprow:
            mov dx,80h                  ; 初始化 DX -> 0000 1000B
    .jmpw:                                    
            test [bp],dl                ; [BP] & DX
            mov al,BACKGROUND_COLOR     
            jz .no_draw
            mov al,FONT_COLOR           
    .no_draw:
            mov     es:[si],al          ; 写像素
    .continuew:
            shr     dl,1                ; DX BIT 逻辑右移 
            inc     si                  ; 显存 inc
            test    dl,dl               ; DX == 0
            jnz     .jmpw
            
            test    cx,1                ; 一次循环写 8 BIT,而一行有 16 BIT ,所以 CX % 2 时才换行       
            jz      .nonextline
            add     si,304d             ; 换行 SCREEN_WIDTH - WORD_WIDTH
            ; sub     si,16d             ; 不必要的一行
            
    .nonextline:
    .continuerow:                       ; 下一个 BIT -> inc BP ;计数 CX INC
            inc bp
            inc cx
            cmp cx,32d
            jb .jmprow
    .return:
    pop bp
    pop si
    pop ax
    pop bx
    pop cx
    pop dx
    ret

claer:
mov al,0
mov bx,0
mov cx,0
mov dx,0
int 10h
ret




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
    PUSH CX
    PUSH BX

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
    MUL CX              ; 结果超过16位,使用32位乘法

    POP BX
    POP CX
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
; BP 栈顶指针
; 返回 读取字节数 0 到达末尾
; -1 出错，失败
openfile:
        ; PUSH BP
        ; mov BP,SP
        ; add BP,4                    ; AT FILENAME
        
        ; XCHG AX,BP
        ; call PRINT_NUM_HEX
        ; XCHG AX,BP

        PUSH DX
        PUSH CX
        PUSH BX
        ; PUSH AX

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
        MOV AX,BX
        jc .readfilefail

        MOV AH,3EH
        MOV DX,[FILE_HANDLE]                                     ;CLOSE
        INT 21H  

        MOV AX,BX
        jmp .openfilereturn
        
    .movoffsetfail:
        lea dx,STR_MOVOFFSET_FAIL
        mov ah,09h
        int 21h
        MOV AX,-1
        jmp .openfilereturn

    .openfilefail:
        lea dx,STR_OPENFILE_FAIL
        mov ah,09h
        int 21h
        MOV AX,-1
        jmp .openfilereturn
    .readfilefail:
        lea dx,STR_READFILE_FAIL
        mov ah,09h
        int 21h
        MOV AX,-1
        jmp .openfilereturn

    .openfilereturn:
    ; POP AX
    POP BX
    POP CX
    POP DX
    ; POP BP
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

