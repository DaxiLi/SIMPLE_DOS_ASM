; /*
;  * ;Description: 输出目录,打开输入的目录并显示当中的中文文字
;               要求 GBK 编码,且不含半角字符.
;  * ;Author: Yuan Jie
;  * ;Data: 
;  * ;LastEdit: moogila@outlook.com
;  * ;LastEditTime: 2021-09-21 13:02:26
;  * ;FileName: 
;  */

.model small

.data
    TIP_PATH_INPUT DB "pls input a file name:",13,0ah,'$',0
    FILE_OPEN_FAIL DB "open file fail(main)",0ah,13,'$','0'
    FILE_PATH BYTE 'README.txt',61 dup(0),0,'$'   

    READ_FILE_BUF DB 2047 dup(0),0
    READ_FILE_BUF_LENGTH DW ?
    READ_FILE_BUF_LINES DW 0

    FILE_HANDLE word 2 dup(0)
    ZHS_FILE_NAME db "HZK16",0, 10 dup  (0)
    STR_OPENFILE_FAIL db "can not open file",13,'$',0
    STR_MOVOFFSET_FAIL db "mov ofset fail",13,'$',0
    STR_READFILE_FAIL db "can not read file",13,'$',0

    WORD_MODEL_BUF DB 32 dup(0)

    FLAG DB 0

.stack 
.code

FILE_BUF_SIZE equ 2048

; ============== 真他奶奶的邪门，绝了，不能打开文件报错。哪怕把那个程序复制到这个文件里面，也不行，可是文件都在一个目录下，并没有什么不同在另一个文件里面可以 include ，在这个文件里面写代码 include 
; ~~似乎要先  cd 到当前目录 DOSBOX 才会把文件都复制过去，，，，晕。。~~
; DOSBOX 的复制逻辑成谜！
; 经过我细心调试，现在没法 include 了
; include J1SLIB.asm

.startup

; ===================== 一些字符显示的宏定义==========

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
;=================================================
    MOV ah,09h
    lea dx,TIP_PATH_INPUT
    int 21h

    lea BX,FILE_PATH
    MOV CX,61
    MOV AH,01

    ; .inputpath:   ; 无需输入
    ; int 21H
    ; cmp AL,0dh
    ; jz .iptbreak
    ; mov [bx],al
    ; inc bx
    ; loop .inputpath
    ; .iptbreak:

    
    ; ==== READ FROM FILE 
    LEA AX,READ_FILE_BUF
    PUSH AX

    XOR AX,AX
    PUSH AX

    PUSH AX

    MOV AX,FILE_BUF_SIZE
    PUSH AX

    LEA AX,FILE_PATH
    PUSH AX

    MOV Bp,SP

    call openfile
    cmp AX,-1
    jnz .readoptfinished
   

.readoptfinished:

    call SETDISPLAYMOD          ; 设置显示模式
    ; call  CLS
    MOV BH,0
    
.show:
    LEA AX,READ_FILE_BUF
    ; ADD AX,EACH_LINE_WORDS * 2
    call CLS
    call refreshwords   

.checkKeyAction:
    MOV AH,08
    int 21h

    cmp al,'j'
    jz .keyJ
    cmp al,'k'
    jz .keyK
    cmp al,'q'
    jz .keyQ

    jmp .checkKeyAction

    .keyJ:
    inc BH
    jmp .show
    
    .keyK:
    cmp BH,0
    jbe .checkKeyAction             ; <= 0,啥也不做
    dec BH
    jmp .show

    .keyQ:
    call CLS
    mov ax,0003h
    int 10h
    jmp .mainExit

    jmp .checkKeyAction

.mainExit:
.exit 0

; 计算 AX 地址开始的,下一行首字符的地址
getnextlineptr:
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH BP

    MOV BP,AX
.wilgnl:
    MOV AX,[BP]
    test AX,AX
    jz .wilreturn        ; has no next line then return 0 

    cmp AX,0D0ah
    MOV AX,BP
    ADD AX,2
    jz .wilreturn       ; 换行,返回下一个地址

    ADD BP,2
    jmp .wilreturn

.wilreturn:
    POP BP
    POP DX
    POP CX
    POP BX

; 将 ax 地址处的字符串刷新到屏幕上，
; BH ,为要从第几行开始显示
; 0,0 开始,自动换行
; 遇到 0 截止
refreshwords:
    PUSH BP
    PUSH DX
    PUSH CX
    PUSH BX
    PUSH AX

    MOV BP,AX                   ; 字符串地址

    ; call SETDISPLAYMOD          ; 设置显示模式
    ; call CLS                    ; CLS

    XOR CX,CX
    ; MOV CL,BH
.whilenextline:
    CMP BH,0
    jz .whilenextlineEnd        ; END BH -> 0

    MOV DX,[BP]
    XCHG DH,DL

    TEST DX,DX                  ; 为空
    jz .w_no_char

    CMP DX,0D0ah                ; 换行符
    jz .w_r_n
    
    CMP DH,20H                  ;空格
    jz .w_space

    jmp .w_default

.w_no_char:
    jmp .whilenextlineEnd        ; 为空,末尾,直接结束
.w_r_n:
    DEC BH
    XOR CX,CX
    jmp .w_final
.w_default:
    INC CX
    CMP CX,EACH_LINE_WORDS
    JNB .w_r_n
    jmp .w_final
.w_space:
    DEC BP
    INC CX
    jmp .w_default       ; 空格 还需要按照正常字符处理一次

.w_final:
    ADD BP,2
    jmp .whilenextline
.whilenextlineEnd:


xor bx,bx                   ; 0 row 0 col
                                ; PUTS 传递参数

.wput:
    XOR DX,DX
    MOV DX,[BP]                 ; 将字符读入 DX
    XCHG DH,DL

.checkword:
    test DX,DX                  ; 0 截止
    jz .wbreak 

    CMP DX,0D0ah
    JZ .IS_R_N                  ; 换行符 两个

    cmp bl,EACH_LINE_WORDS      ; 是否行末
    jnb .IS_END_OF_LINE             
    
    cmp bh,EACH_SCREEN_LINES
    jnbe .wbreak                ; 屏幕写满,结束

    CMP DH,20H                  ;空格
    JZ .IS_SPACE
    
    ; default case
    jmp .writescreen            ; 不匹配,则直接写
   
.checkopts:

.IS_R_N:
    inc BH
    xor bl,bl                   ; 换行
    ADD BP,2
    jmp .wput              ; 继续下一个字符

.IS_END_OF_LINE:   
    inc BH
    xor bl,bl                   ; 换行
    JMP .checkword            ; 换行后 需检查是否写满

.IS_SPACE:
    DEC BP                      ; 空格可只占一个字节,防止出现单字节空格导致乱码
    MOV DX,2020H                 ;  所以把情况统一成单字节处理
    JMP .writescreen            ;   BP 减一,以平衡数据

.writescreen:
    lea AX,WORD_MODEL_BUF
    XCHG BX,CX
    MOV BX,DX
    call loadwordmodel
    XCHG BX,CX
    lea AX,WORD_MODEL_BUF
    call PUTS

.wcontinue:
    ADD BP,2
    INC BL

    jmp .wput
.wbreak:

    POP AX
    POP BX
    POP CX
    POP DX
    POP BP

    ret



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
    mov bh,BLACK            ; BH 屏幕初始化颜色
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




end
