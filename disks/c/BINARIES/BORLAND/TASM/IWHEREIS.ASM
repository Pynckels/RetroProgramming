
;   FILENAME: IWHEREIS.ASM
;
;   Copyright (c) 1988 by Borland International
;
;   DESCRIPTION:  This program does a search for the file(s) specified on the
;   command line.
;
;   ASSEMBLY INSTRUCTIONS: To assemble this module use the following
;   TASM command line.
;
;       TASM /dMDL=memorymodel iwhereis
;
;   'memorymodel' in the above command line may be replaced by TINY, SMALL,
;   MEDIUM, COMPACT, LARGE or HUGE. If assembling this module to run on
;   a 286/386 machine, turn on the P286 directive in order to take advantage of
;   286/386 specific instructions. For example:
;
;       TASM /dMDL=memorymodel /jP286 iwhereis
;
;   SYSTEM REQUIREMENTS:
;       TASM 1.0
;       256K
;       DOS 2.0 or later

%tabsize 4

ifndef  MDL
    display "Error: This module requires that you provide a memory model"
    display "    definition on the command line. I.E. /dMDL=SMALL."
    err ; Force a fatal error
else

    ideal                   ; Use TASM's Ideal mode
    model   MDL             ; Define the memory model

    Version EQU "1.00"

    include "iwhglobl.inc"  ; Public symbol declarations
    include "imacros.mac"   ; Various macros
    include "bios.inc"
    include "ibios.mac"
    include "kbd.inc"      ; Keyboard scan codes
    include "dos.inc"      ; Equates representing DOS functions/services
    include "idos.mac"

    stack   7FFFh           ; Allocate 32K stack

    dataseg

    PspAddress  dw  ?       ; Segment address of Program Segment Prefix(PSP)
    DisplayPage db  0       ; Current display page
    include "WHUSAGE.INC"   ; Usage screen declaration

    ; Pascal style strings to store the parsed file specification.

    global  Drive:byte:5
    Drive       db  0," :  "
    Path        db  MAX_PATH_LENGTH  dup (0)
    FileSpec    db  15  dup (0) ; Make room for the filename with a preceding
                                ; length byte and terminating 0
    db  '\'
    HomeDirectory   db  MAX_PATH_LENGTH dup (0)
    OldDrive    db  ?


    codeseg

    proc    main


    ;************************* Program Entry Point ***************************
    ; Execution of the program begins here.

    EntryPoint:
        mov     ax, @data       ; Initialize ds by moving segment address
        mov     ds, ax          ; of data segment into ds register
        push    bp
        mov     bp, sp
        call    Initialize      ; Initialize data structures, etc.
        mov     al, 1
        call    ParamString
        push    es              ; Store the location of the file spec.
        push    di
    @@DeleteSpaces:
        cmp     [byte es:di+1], SPACE
        jne     short @@NoMoreSpaces
        mov     cx, 1           ; Remove the first character
        mov     ax, 1           ; from the string
        push    es              ; Pass the location of the parameter to
        push    di              ; DeletChar
        call    DeleteChar
        jmp     @@DeleteSpaces
    @@NoMoreSpaces:

        ; Pull apart the drive, path and filename so we can store the
        ; filename specification.

        push    ds              ; Push the address to store the drive spec. in
        if (@Cpu and 100b) eq 100b
            push    offset Drive
        else
            mov     ax, offset Drive
            push    ax
        endif
        push    ds              ; Push the address to store the path spec. in
        if (@Cpu and 100b) eq 100b
            push    offset Path
        else
            mov     ax, offset Path
            push    ax
        endif
        push    ds              ; Push address to store filename spec. in
        if (@Cpu and 100b) eq 100b
            push    offset FileSpec
        else
            mov     ax, offset FileSpec
            push    ax
        endif
        call    ParseFilename           ; Parse the filename
        cmp     [byte Path], 0          ; Check if the path is empty
        jne     short HaveAPath
        mov     [byte Path], 1
        mov     [byte Path+1], '\'
    HaveAPath:
        cmp     [byte Drive], 0         ; Check if a drive definition exists
        je      short DontChangeDrives
        cmp     [byte Drive+1], 61h     ; Check if the drive letter is lower
        jng     short IsCapitalized     ; case
        sub     [byte Drive+1], 20h     ; Capitalize the drive letter
    IsCapitalized:
        mov     al, [byte Drive+1]
        sub     al, 'A'
        ChangeDrive <al>                ; Change to the appropriate drive
        jmp     short CopyPath
    DontChangeDrives:
        mov     [byte Drive], 2         ; Initialize the drive
        mov     al, [byte OldDrive]
        mov     [byte Drive+1], al      ; string with the
        add     [byte Drive+1], 'A'     ; current drive.
    CopyPath:

        ; Copy the start path onto the stack

        sub     sp, MAX_PATH_LENGTH     ; Make room on the stack
        mov     si, sp
        push    ds                      ; Push segment address of Path
        if (@Cpu and 100b) eq 100b       ; Push offset
            push    offset Path
        else
            mov     ax, offset Path
            push    ax
        endif
        push    ss                      ; Push address to copy to
        push    si
        xor     ah, ah
        mov     al, [byte Path]         ; Get the path length
        inc     al                      ; We want to copy the length byte also
        inc     al                      ; And the null terminator
        call    ByteCopy                ; Copy the path onto the stack
        call    FindFiles               ; Do the search for the file(s)
        add     sp, MAX_PATH_LENGTH     ; Remove data on stack
        call    Terminate               ; End the program
    ;*************************************************************************
    endp    main

    proc    Initialize

    ;   This procedure initializes all global variables and data structures
    ;   used by the program.
    ;
    ;   Input
    ;       none
    ;   Output
    ;       none
    ;   Calling conventions
    ;       NA
    ;   Registers modified
    ;       ax, flags

        ; Store the PSP address by storing es in the variable PspAddress.
        ; Note that we do it this way instead of using DOS function 62h because
        ; the function is only available on DOS 3.0 or later.

        mov     [PspAddress], es
        push    ds
        GetCurrentDir   <0>, <seg HomeDirectory>, <offset HomeDirectory>
        pop     ds
        GetDrive                        ; Get the current disk drive
        mov     [byte OldDrive], al     ; Save it

        ; Verify that the user provided command line parameters.

        call    ParamCount
        cmp     al, 0                   ; Were any parameters passed by user?
        jne     SHORT @@Exit
        call    UsageScreen             ; If no, display usage screen

    @@Exit:
        ret
    endp    ; Initialize


    proc    Terminate   ;   This routine terminates the WHEREIS program.
        mov     al, [byte OldDrive]     ; Get the original disk drive
        ChangeDrive <al>                ; Restore the original disk drive
        ChangeDirectory <seg HomeDirectory>, <((offset HomeDirectory) - 1)>
        mov     ah, DOS_TERMINATE_EXE
        int     DOS_FUNCTION
    endp    Terminate


    proc    UsageScreen

    ;   This routine displays a 'usage' screen that describes the syntax for
    ;   using WHEREIS. It then terminates the program.
    ;
    ;   Input
    ;       ds - Points to data segment where usage screen text is located
    ;   Output
    ;       none
    ;   Calling conventions
    ;       NA
    ;   Registers modified
    ;       ax, cx, dx

        push    ds
        if (@Cpu and 100b) eq 100b
            push    offset Syntax
        else
            mov     ax, offset Syntax
            push    ax
        endif
        call    WritePascalString
        call    Terminate               ; Terminate program
    endp    ; UsageScreen


endif   ; ifndef MDL

end EntryPoint
