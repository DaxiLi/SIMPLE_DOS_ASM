; org 0100h		;PSP前缀，程序从0100h开始运行
; mov	ax, cs		;初始化 ds和dx寄存器，为调用9号程序（显示字符串）做准备
; mov	ds, ax
; mov dx, string	;取偏移地址，等价于MASM的 lea dx, string 或 mov dx, offset string
; mov ah, 9
; int 21h
; MOV AH,4CH		;回到操作系统
; INT 21H
; string		db	"Hello, OS world!$"

; segment data
; hello : db 'hello world',13,10,'$'
; segment code


; ============================ DOC ======================
;  Using the bin Format To Generate .COM Files
;           .COM files expect to be loaded at offset 100h into their segment (though the segment may change).
;       Execution then begins at 100h, i.e. right at the start of the program. So to write a .COM program, you
;       would create a source file looking like


; ========== NOTE ======
; 这是一个可完整运行编译的 DOS 代码结构

; ========= 
; DOS 程序 从100h 处开始
; org 100h 

; section .text 

; start: 
;         ; put your code here 
;         mov ah,02
;         mov al,'a'
;         int 21h
;         call hello
;         mov ax,04ch
;         int 21h


; ;description
; hello :
;     mov ah,02
;     mov dl,'f'
;     int 21h
;     ret
            
        
; section .data 

;         ; put data items here 

; section .bss 

        ; put uninitialized data here


; ========================= a standard end ==



; ========== NOTE ======
; 这是一个可完整运行编译的代码结构
; org 100h

; segment code
; .start: 
;     mov ah,02h
;     mov dl,'h'
;     int 21h

;     mov ax,04ch
;     int 21h



; ===================== WIN32 HELLO WORLD =======
%include "include\io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    push str1
    call _printf
    add sp,4

    push num
    push str2
    call _scanf
    add sp ,8
;     mov bx,ax

    push num
    push str3
    call _printf
    add sp,4

    xor eax, eax
    ret
    
push    ebp
mov     ebp, esp
and     esp, 0FFFFFFF0h
sub     esp, 20h
push str1
call    _printf
; lea     eax, [esp+1Ch]
; mov     [esp+4], eax
; mov     dword ptr [esp], offset Format ; "%d"
; call    _scanf
; mov     eax, [esp+1Ch]
; mov     [esp+4], eax
; mov     dword ptr [esp], offset aUInputD ; "u input: %d"
; call    _printf
;     add sp,8
;     retn
ret

section .data
hello : db 'hello jjj world',13,10,0
str1  : db 'pls input a number:',0
str2  : db '%d',0
str3  : db 'u input %d',0
num   : db 0