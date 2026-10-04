;----------------------------------------------------------------------
; INT255.ASM - Installs a resident handler on int 255 (XOR AH,AL)
; Turbo Assembler, Ideal mode, tiny model (.COM), 8086
;
; Assemble:  tasm int255
; Link:      tlink /t int255
;----------------------------------------------------------------------

        P8086
        Model tiny

INTNUM  = 0FFh                  ; Interrupt vector used
ENVSEG  = 002Ch                 ; PSP offset holding the environment segment

        .code

        org   000h
Int255:                         ; Interrupt handler will be copied here
        org   100h              ; Set the program entry point at offset 100h
Start:
        jmp   short Install     ; Skip over the code that will be copied

;----------------------------------------------------------------------
; Handler code (the template that is copied to INT255)
;----------------------------------------------------------------------

Intr:
        sti                     ; Enable interrupts
        xor   ah, al            ; Execute XOR
        iret                    ; Return value in AH

Intr_Len = $ - Intr             ; Number of bytes to copy to INT255

;----------------------------------------------------------------------
; Installation code
;----------------------------------------------------------------------

Install:
        cld                     ; Copy Intr to Int255
        mov   si, offset Intr
        mov   di, offset Int255
        mov   cx, Intr_Len
        rep   movsb

        mov   dx, offset Int255 ; Set Int255 as entry for interrupt 0FFh
        mov   ax, 2500h + INTNUM
        int   21h

        mov   ax, [ds:ENVSEG]   ; Free program environment memory block
        mov   es, ax
        mov   ah, 49h
        int   21h
                                ; Terminate and keep INT255 resident
        mov   dx, (Intr_Len + 15) / 16
        mov   ax, 3100h
        int   21h

        END Start
