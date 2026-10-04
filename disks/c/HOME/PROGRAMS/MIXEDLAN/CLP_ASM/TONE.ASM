; TONE.ASM
;
; Clipper call:
;
;       Tone(1000)
;
; Generates a 440 Hz tone for the specified number of milliseconds.
;
; Assemble with:
;
;       MASM TONE.ASM;
;
; or:
;
;       ML /c /Zm TONE.ASM

        .8086

DGROUP  GROUP   DATASG

DATASG  SEGMENT WORD PUBLIC '_DATA'
        ; No private data required.
DATASG  ENDS

_PROG   SEGMENT PARA PUBLIC 'CODE'

        ASSUME  CS:_PROG, DS:DGROUP

        EXTRN   __PARNI:FAR
        EXTRN   __RET:FAR

        PUBLIC  Tone

Tone    PROC    FAR

        push    bp
        mov     bp,sp

        push    ds
        push    es
        push    si
        push    di
        push    bx

        ; Get parameter 1 from the Clipper stack.
        ;
        ; AX = parameter number
        ; __PARNI returns the numeric value in AX

        mov     ax,1
        push    ax
        call    __PARNI
        add     sp,2

        mov     si,ax              ; SI = duration in milliseconds

        ; Program PIT channel 2 for approximately 440 Hz.
        ;
        ; PIT divisor = 1193180 / 440 = 2711

        mov     al,0B6h            ; Channel 2, square-wave mode
        out     43h,al

        mov     ax,2711            ; 440 Hz divisor
        out     42h,al             ; Low byte
        mov     al,ah
        out     42h,al             ; High byte

        ; Enable the PC speaker and connect PIT channel 2.

        in      al,61h
        mov     bl,al              ; Save original speaker-port value

        or      al,03h
        out     61h,al

ToneDelay:

        ; BIOS wait service:
        ;
        ; AH = 86h
        ; CX:DX = number of microseconds
        ;
        ; Wait 1 millisecond at a time.

        cmp     si,0
        je      ToneOff

        mov     cx,0
        mov     dx,1000            ; 1000 microseconds = 1 ms
        mov     ah,86h
        int     15h

        dec     si
        jmp     ToneDelay

ToneOff:

        ; Restore the original speaker-port state.

        mov     al,bl
        out     61h,al

        pop     bx
        pop     di
        pop     si
        pop     es
        pop     ds
        pop     bp

        ; Tell Clipper that the external function has returned.

        call    __RET

        ret

Tone    ENDP

_PROG   ENDS

        END
