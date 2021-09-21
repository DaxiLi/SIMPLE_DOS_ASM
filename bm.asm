 ;
 ; +-------------------------------------------------------------------------+
 ; |      This file was generated by The Interactive Disassembler (IDA)      |
 ; |           Copyright (c) 2020 Hex-Rays, <support@hex-rays.com>           |
 ; +-------------------------------------------------------------------------+
 ;
 ; Input SHA256 : 8699421D0C0EFA582FB26226C36DBA772993855FFF8ED258CA3C9B5BBC240A3E
 ; Input MD5    : B3930FBA2831513DBC9AEC42C9CC93B0
 ; Input CRC32  : 51F55ED1

 ; File Name   : C:\Users\aja\Desktop\汇编程序\案例15动画心\bm.COM
 ; Format      : MS-DOS COM-file
 ; Base Address: 1000h Range: 10100h-10347h Loaded length: 247h

                 .686p
                 .mmx
                ;  .model small

 ; ===========================================================================

 Segment type: Pure code
 seg000          segment byte public 'CODE' use16
                 assume cs:seg000
org 100h
                 assume es:nothing, ss:nothing, ds:seg000, fs:nothing, gs:nothing

 ; =============== S U B R O U T I N E =======================================

 ; Attributes: noreturn

                 public start
 start           proc near
                 mov     ax, 13h
                 int     10h             ; - VIDEO - SET VIDEO MODE
                                         ; AL = mode
                 mov     dx, 3C8h
                 xor     al, al
                 out     dx, al
                 inc     dx
                 mov     cx, 300h

 loc_1010F:                              ; CODE XREF: start+10↓j
                 out     dx, al
                 loop    loc_1010F
                 mov     ax, 0A000h
                 mov     es, ax
                 assume es:nothing
                 mov     cx, 96h

 loc_1011A:                              ; CODE XREF: start:loc_10161↓j
                 mov     ax, word_10343
                 mov     dx, 8405h
                 mul     dx
                 inc     ax
                 mov     word_10343, ax
                 push    dx
                 shr     dl, 1
                 shr     dl, 1
                 cmp     dl, 29h ; ')'
                 ja      short loc_10161
                 cmp     dl, 5
                 jb      short loc_10161
                 mov     ax, 140h
                 xor     dh, dh
                 mul     dx
                 pop     dx
                 cmp     dh, 70h ; 'p'
                 ja      short loc_10161
                 cmp     dh, 8
                 jb      short loc_10161
                 xor     dl, dl
                 xchg    dl, dh
                 add     ax, dx
                 xchg    ax, di
                 mov     al, 0FFh
                 push    cx
                 mov     bl, 4

 loc_10153:                              ; CODE XREF: start+5E↓j
                 mov     cx, 0Ah
                 rep stosb
                 add     di, 136h
                 dec     bl
                 jnz     short loc_10153
                 pop     cx

 loc_10161:                              ; CODE XREF: start+2E↑j
                                         ; start+33↑j ...
                 loop    loc_1011A
                 mov     ax, cs
                 inc     ah
                 mov     ds, ax
                 assume ds:nothing
                 push    ds
                 mov     bl, 19h

 loc_1016C:                              ; CODE XREF: start+A7↓j
                 xor     si, si
                 xor     di, di
                 mov     cx, 3E80h

 loc_10173:                              ; CODE XREF: start+9A↓j
                 mov     al, es:[di-1]
                 add     al, es:[di+1]
                 adc     ah, 0
                 add     al, es:[di+140h]
                 adc     ah, 0
                 add     al, es:[di-140h]
                 adc     ah, 0
                 shr     ax, 1
                 shr     ax, 1
                 jz      short loc_10196
                 dec     al

 loc_10196:                              ; CODE XREF: start+92↑j
                 mov     [si], al
                 inc     si
                 inc     di
                 loop    loc_10173
                 xor     si, si
                 xor     di, di
                 mov     cx, 1F40h
                 rep movsw
                 dec     bl
                 jnz     short loc_1016C
                 push    es
                 push    ds
                 pop     es
                 assume es:nothing
                 pop     ds
                 assume ds:seg000
                 mov     cx, 1902h
                 xor     si, si
                 xor     di, di
                 mov     dl, 80h ; '€'

 loc_101B6:                              ; CODE XREF: start+DA↓j
                 mov     ah, dl
                 shl     ah, 1
                 mov     al, 80h ; '€'
                 sub     al, ah
                 stosb
                 movsb
                 dec     dl
                 jnz     short loc_101CA
                 mov     dl, 80h ; '€'
                 add     si, 0C0h

 loc_101CA:                              ; CODE XREF: start+C2↑j
                 mov     ax, cx
                 shl     ax, 1
                 xor     al, al
                 xchg    ah, al
                 shl     al, 1
                 shl     al, 1
                 add     ax, 80h ; '€'
                 stosw
                 loop    loc_101B6
                 push    ds
                 pop     es
                 assume es:seg000
                 xor     di, di
                 mov     cx, 1F40h
                 xor     ax, ax
                 rep stosw
                 mov     dx, 30Ah
                 xor     bh, bh
                 mov     ah, 2
                 int     10h             ; - VIDEO - SET CURSOR POSITION
                                         ; DH,DL = row, column (0,0 = upper left)
                                         ; BH = page number
                 push    cs
                 pop     ds
                 mov     si, 30Eh
                 mov     cx, 15h

 loc_101F8:                              ; CODE XREF: start+FF↓j
                 lodsb
                 mov     bl, 7Dh ; '}'
                 mov     ah, 0Eh
                 int     10h             ; - VIDEO - WRITE CHARACTER AND ADVANCE CURSOR (TTY WRITE)
                                         ; AL = character, BH = display page (alpha modes)
                                         ; BL = foreground color (graphics modes)
                 loop    loc_101F8
                 add     dx, 1FBh
                 mov     ah, 2
                 int     10h             ; - VIDEO - SET CURSOR POSITION
                                         ; DH,DL = row, column (0,0 = upper left)
                                         ; BH = page number
                 mov     si, 323h
                 mov     cx, 20h ; ' '

 loc_1020F:                              ; CODE XREF: start+116↓j
                 lodsb
                 mov     bl, 32h ; '2'
                 mov     ah, 0Eh
                 int     10h             ; - VIDEO - WRITE CHARACTER AND ADVANCE CURSOR (TTY WRITE)
                                         ; AL = character, BH = display page (alpha modes)
                                         ; BL = foreground color (graphics modes)
                 loop    loc_1020F
                 mov     dx, 3C8h
                 xor     al, al
                 out     dx, al
                 inc     dx
                 xor     cx, cx

 loc_10221:                              ; CODE XREF: start+12D↓j
                 mov     al, cl
                 out     dx, al
                 xor     ax, ax
                 out     dx, al
                 out     dx, al
                 inc     cl
                 cmp     cl, 3Fh ; '?'
                 jnz     short loc_10221
                 xor     cx, cx

 loc_10231:                              ; CODE XREF: start+13E↓j
                 mov     al, 3Fh ; '?'
                 out     dx, al
                 mov     al, cl
                 out     dx, al
                 xor     al, al
                 out     dx, al
                 inc     cx
                 cmp     cx, 3Fh ; '?'
                 jnz     short loc_10231
                 pop     ds

 loc_10241:                              ; CODE XREF: start+201↓j
                 mov     cx, 1900h
                 xor     si, si
                 xor     di, di

 loc_10248:                              ; CODE XREF: start+1F8↓j
                 lodsb
                 xchg    dl, al
                 lodsb
                 xchg    bl, al
                 mov     bh, [si+7]
                 lodsw
                 mov     cs:word_10345, ax
                 cmp     ax, 80h ; '€'
                 ja      short loc_1025E
                 add     ax, 0C8h

 loc_1025E:                              ; CODE XREF: start+159↑j
                 dec     ax
                 mov     [si-2], ax
                 push    cx
                 xchg    ah, dl
                 cmp     ah, 80h ; '€'
                 jb      short loc_10272
                 neg     ah
                 mov     byte ptr cs:347h, 1

 loc_10272:                              ; CODE XREF: start+168↑j
                 xor     al, al
                 xor     dx, dx
                 div     cs:word_10345
                 push    ax
                 mov     al, bl
                 mov     cl, 4
                 shr     al, cl
                 mov     ah, 50h ; 'P'
                 sub     ah, al
                 xor     al, al
                 xor     dx, dx
                 div     cs:word_10345
                 xchg    ax, cx
                 pop     dx
                 cmp     cx, 8Eh
                 ja      short loc_102F4
                 cmp     dx, 9Bh
                 ja      short loc_102F4
                 push    dx
                 mov     ax, 140h
                 mul     cx
                 pop     dx
                 cmp     byte ptr cs:347h, 1
                 jnz     short loc_102B6
                 sub     ax, dx
                 mov     byte ptr cs:347h, 0
                 jmp     short loc_102B8
 ; ---------------------------------------------------------------------------

 loc_102B6:                              ; CODE XREF: start+1AA↑j
                 add     ax, dx

 loc_102B8:                              ; CODE XREF: start+1B4↑j
                 add     ax, 4BA0h
                 mov     di, ax
                 xchg    ax, bx
                 sub     al, ah
                 add     al, 64h ; 'd'
                 mov     bx, cs:word_10345
                 cmp     bx, 11Dh
                 jb      short loc_102CF
                 xor     al, al

 loc_102CF:                              ; CODE XREF: start+1CB↑j
                 shr     bx, 1
                 shr     bx, 1
                 sub     ax, bx
                 mov     bx, 148h
                 sub     bx, cs:word_10345
                 mov     cl, 6
                 shr     bx, cl
                 inc     bx
                 inc     bx
                 mov     dx, 2

 loc_102E6:                              ; CODE XREF: start+1F2↓j
                 mov     cx, bx
                 rep stosb
                 mov     cx, 140h
                 sub     cx, bx
                 add     di, cx
                 dec     dx
                 jnz     short loc_102E6

 loc_102F4:                              ; CODE XREF: start+195↑j
                                         ; start+19B↑j
                 pop     cx
                 dec     cx
                 jz      short loc_102FB
                 jmp     loc_10248
 ; ---------------------------------------------------------------------------

 loc_102FB:                              ; CODE XREF: start+1F6↑j
                 mov     ah, 1
                 int     16h             ; KEYBOARD - CHECK BUFFER, DO NOT CLEAR
                                         ; Return: ZF clear if character in buffer
                                         ; AH = scan code, AL = character
                                         ; ZF set if no character in buffer
                 jnz     short loc_10304
                 jmp     loc_10241
 ; ---------------------------------------------------------------------------

 loc_10304:                              ; CODE XREF: start+1FF↑j
                 mov     ax, 3
                 int     10h             ; - VIDEO - SET VIDEO MODE
                                         ; AL = mode
                 mov     ax, 4C00h
                 int     21h             ; DOS - 2+ - QUIT WITH EXIT CODE (EXIT)
 start           endp ; sp-analysis failed ; AL = exit code

 ; ---------------------------------------------------------------------------
                 db 4Dh, 61h, 72h, 73h, 20h, 4Ch, 61h, 6Eh, 64h, 2Ch, 20h
                 db 62h, 79h, 20h, 53h, 70h, 61h, 6Eh, 73h, 6Bh, 61h, 28h
                 db 63h, 6Fh, 64h, 69h, 6Eh, 67h, 20h, 61h, 20h, 76h, 69h
                 db 72h, 75h, 73h, 20h, 63h, 61h, 6Eh, 20h, 62h, 65h, 20h
                 db 63h, 72h, 65h, 61h, 74h, 69h, 76h, 65h, 29h
 word_10343      dw 0FAh                 ; DATA XREF: start:loc_1011A↑r
                                         ; start+23↑w
 word_10345      dw 3                    ; DATA XREF: start+152↑w
                                         ; start+176↑r ...
 seg000          ends


                 end start