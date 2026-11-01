; ------------------------------------------------------------------------------
; SLEEP.COM - wait N seconds (0-65535)
; ------------------------------------------------------------------------------
;
; Usage: SLEEP seconds
;
; Errorlevel: 0 on correct seconds parameter
;             1 on bad/missing/extra parameter (usage text is printed).
;
; ------------------------------------------------------------------------------
;
; Build (MASM 6.x):   ml /AT sleep.asm
;
; Runs on any 8086+; timing uses the BIOS tick counter (18.2065 Hz) and
; handles midnight rollover.  Yields CPU to the host via INT 2Fh/1680h.
;
; ------------------------------------------------------------------------------

                .model tiny
                .code

                org     100h                    ; COM file entry point

start:
                cld
                mov     si, 81h                 ; PSP command tail

; ------------------------------------------------------------------------------
; - Parse parameter
; ------------------------------------------------------------------------------

skip1:          lodsb                           ; skip leading blanks
                cmp     al, ' '
                je      skip1
                cmp     al, 9
                je      skip1
                dec     si

                xor     bx, bx                  ; bx = parsed seconds
                xor     cx, cx                  ; cx = digit count
digit:          mov     al, [si]
                sub     al, '0'
                cmp     al, 9
                ja      enddig
                xor     ah, ah
                mov     di, ax                  ; di = digit
                mov     ax, bx
                mov     dx, 10
                mul     dx                      ; dx:ax = bx*10
                jc      usage                   ; > 65535
                add     ax, di
                jc      usage
                mov     bx, ax
                inc     cx
                inc     si
                jmp     digit

enddig:         or      cx, cx                  ; no digits at all?
                jnz     skip2
                jmp     usage                   ; (JCXZ is short-range only)
skip2:          mov     al, [si]                ; only blanks may follow
                inc     si
                cmp     al, ' '
                je      skip2
                cmp     al, 9
                je      skip2
                cmp     al, 0Dh                 ; must reach end of line
                jne     usage

                or      bx, bx
                jz      done                    ; sleep 0 = no-op

; ------------------------------------------------------------------------------
; - Calculate BIOS ticks to wait
; - target ticks = sec*18 + sec*2065/10000 + 1   (~ sec*18.2065)
; ------------------------------------------------------------------------------

                mov     ax, bx
                mov     cx, 18
                mul     cx
                mov     target_lo, ax
                mov     target_hi, dx
                mov     ax, bx
                mov     cx, 2065
                mul     cx
                mov     cx, 10000
                div     cx                      ; ax = quotient (fits in 16 bits)
                add     target_lo, ax
                adc     target_hi, 0
                add     target_lo, 1
                adc     target_hi, 0

                xor     ah, ah                  ; start tick count
                int     1Ah
                mov     last_lo, dx
                mov     last_hi, cx

; ------------------------------------------------------------------------------
; - Wait for target_hi:target_lo BIOS ticks (mind midnight switchover)
; ------------------------------------------------------------------------------

wait_:          mov     ax, 1680h               ; release time slice (harmless if unsupported)
                int     2Fh
                xor     ah, ah
                int     1Ah                     ; cx:dx = ticks since midnight
                mov     ax, dx
                mov     bx, cx
                sub     ax, last_lo
                sbb     bx, last_hi
                jnc     nowrap
                add     ax, 00B0h               ; midnight: add 1573040 (0018_00B0h)
                adc     bx, 0018h
nowrap:         add     elap_lo, ax
                adc     elap_hi, bx
                mov     last_lo, dx
                mov     last_hi, cx

                mov     ax, elap_hi
                cmp     ax, target_hi
                ja      done
                jb      wait_
                mov     ax, elap_lo
                cmp     ax, target_lo
                jb      wait_

done:           mov     ax, 4C00h
                int     21h

; ------------------------------------------------------------------------------
; - Print usage message
; ------------------------------------------------------------------------------

usage:          mov     dx, offset usage_msg
                mov     ah, 9
                int     21h
                mov     ax, 4C01h
                int     21h

; ------------------------------------------------------------------------------
; - Data
; ------------------------------------------------------------------------------

usage_msg       db      'Usage: SLEEP seconds', 13, 10
                db      'Where: seconds is between 0 and 65535', 13, 10
                db      '$'
target_lo       dw      0
target_hi       dw      0
elap_lo         dw      0
elap_hi         dw      0
last_lo         dw      0
last_hi         dw      0

        end     start
