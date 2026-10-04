;****************************************************************
;*                                                              *
;*      Ebc2Asc (Ver. 1.00)                                     *
;*                                                              *
;*      Ebcdic to Ascii convertor                               *
;*                                                              *
;*      Author   : F. Pynckels                                  *
;*                                                              *
;*      Date     : 22 june 1994                                 *
;*                                                              *
;*      Remark   : Compile with SMALL memory model              *
;*                 Assemble with option /ml                     *
;*                                                              *
;****************************************************************

	.386

	Ideal
	Dosseg
	Model   SMALL

	Dataseg

ascii   Db      000h, 001h, 002h, 003h, 0ECh, 009h, 0CAh, 07Fh          ; EBCDIC to ASCII translation table
        Db      0E2h, 0D2h, 0D3h, 00Bh, 00Ch, 00Dh, 00Eh, 0A9h
        Db      010h, 011h, 012h, 013h, 0EFh, 0C5h, 008h, 0CBh
        Db      018h, 019h, 0DCh, 0D8h, 01Ch, 01Dh, 01Eh, 01Fh
        Db      0B7h, 0B8h, 0B9h, 0BBh, 0C4h, 00Ah, 017h, 01Bh
        Db      0CCh, 0CDh, 0CFh, 0D0h, 0D1h, 005h, 006h, 007h
        Db      0D9h, 0DAh, 016h, 0DDh, 0DEh, 0DFh, 0E0h, 004h
        Db      0E3h, 0E5h, 0E9h, 0EBh, 0B0h, 0B1h, 09Eh, 01Ah
        Db      020h, 0C9h, 083h, 084h, 085h, 0A0h, 0F2h, 086h
        Db      087h, 0A4h, 05Bh, 02Eh, 03Ch, 028h, 02Bh, 021h
        Db      026h, 082h, 088h, 089h, 08Ah, 0A1h, 08Ch, 08Bh
        Db      08Dh, 0E1h, 05Dh, 024h, 02Ah, 029h, 03Bh, 05Eh
        Db      02Dh, 02Fh, 0B2h, 08Eh, 0B4h, 0B5h, 0B6h, 08Fh
        Db      080h, 0A5h, 07Ch, 02Ch, 025h, 05Fh, 03Eh, 03Fh
        Db      0BAh, 090h, 0BCh, 0BDh, 0BEh, 0F3h, 0C0h, 0C1h
        Db      0C2h, 060h, 03Ah, 023h, 040h, 027h, 03Dh, 022h
        Db      0C3h, 061h, 062h, 063h, 064h, 065h, 066h, 067h
        Db      068h, 069h, 0AEh, 0AFh, 0C6h, 0C7h, 0C8h, 0F1h
        Db      0F8h, 06Ah, 06Bh, 06Ch, 06Dh, 06Eh, 06Fh, 070h
        Db      071h, 072h, 0A6h, 0A7h, 091h, 0CEh, 092h, 00Fh
        Db      0E6h, 07Eh, 073h, 074h, 075h, 076h, 077h, 078h
        Db      079h, 07Ah, 0ADh, 0A8h, 0D4h, 0D5h, 0D6h, 0D7h
        Db      09Bh, 09Ch, 09Dh, 0FAh, 09Fh, 015h, 014h, 0ACh
        Db      0ABh, 0FCh, 0AAh, 0B3h, 0E4h, 0FEh, 0BFh, 0E7h
        Db      07Bh, 041h, 042h, 043h, 044h, 045h, 046h, 047h
        Db      048h, 049h, 0E8h, 093h, 094h, 095h, 0A2h, 0EDh
        Db      07Dh, 04Ah, 04Bh, 04Ch, 04Dh, 04Eh, 04Fh, 050h
        Db      051h, 052h, 0EEh, 096h, 081h, 097h, 0A3h, 098h
        Db      05Ch, 0F0h, 053h, 054h, 055h, 056h, 057h, 058h
        Db      059h, 05Ah, 0FDh, 0F5h, 099h, 0F7h, 0F6h, 0F9h
        Db      030h, 031h, 032h, 033h, 034h, 035h, 036h, 037h
        Db      038h, 039h, 0DBh, 0FBh, 09Ah, 0F4h, 0EAh, 0FFh

	Codeseg

	Public  _ebcdic_to_ascii

Proc _ebcdic_to_ascii Buffer:Word,BufLen:Word                           ; Translate EBCDIC to ASCII
	Push    Bp
	Mov     Bp, Sp

	Push    Cx
	Push    Di
	Push    Si

	Mov     Si, [Buffer]                                            ; Si = ^Buffer
	Mov     Di, Si                                                  ; Di = ^Buffer
	Mov     Cx, [BufLen]                                            ; Cx = Nr characters to convert
	Cld                                                             ; Load and store foreward
	Mov     Bx, Offset ascii                                        ; Translation table address
@@1:    Lodsb                                                           ; Get character in Al
	Xlat    [Byte Ptr Ds:Bx]                                        ; Translate character
	Stosb                                                           ; Store the translated character
	Loop    @@1
	
	Pop     Si
	Pop     Di
	Pop     Cx

	Pop     Bp
	Ret
Endp _ebcdic_to_ascii

	End