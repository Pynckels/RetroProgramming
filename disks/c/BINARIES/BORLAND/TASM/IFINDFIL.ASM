
;   FILENAME: IFINDFIL.ASM
;
;   Copyright (c) 1988 by Borland International
;
;   DESCRIPTION:  This module implement a routine that performs a recursive
;   search through a hard disk of a specified file.
;
;   ASSEMBLY INSTRUCTIONS: To assemble this module use the following
;   TASM command line.
;
;       TASM /dMDL=memorymodel ifindfil
;
;   'memorymodel' in the above command line may be replaced by TINY, SMALL,
;   MEDIUM, COMPACT, LARGE or HUGE. If assembling this module to run on
;   a 286/386 machine, turn on the P286 directive in order to take advantage of
;   286/386 specific instructions. For example:
;
;       TASM /dMDL=memorymodel /jP286 ifindfil

%tabsize 4

ifndef  MDL
    display "Error: This module requires that you provide a memory model"
    display "    definition on the command line. I.E. /dMDL=SMALL."
    err ; Force a fatal error
else

    ideal                   ; Use TASM's Ideal mode
    model   MDL             ; Define the memory model

    include "iwhglobl.inc"
    include "imacros.mac"
    include "idos.inc"
    include "dos.inc"
    include "idos.mac"
    include "kbd.inc"
    include "bios.inc"
    include "ibios.mac"

    dataseg
        AllFiles    db  "*.*",0     ; ASCIIZ string representing all files
        SwitchChar  db  1,'\'       ; Directory seperating character
        CurrentDir  db  MAX_PATH_LENGTH dup (0)
        MakePascalString BlankLine, <13, 10>

    codeseg

    macro   NewLine                 ; Force a new line
        ifdef  _286_
            push    seg BlankLine
            push    offset BlankLine
        else
            mov     ax, seg BlankLine
            push    ax
            mov     ax, offset BlankLine
            push    ax
        endif
        call    WritePascalString
    endm


    proc    FindFiles

    ;   This routine does a recursive search down through the directory
    ;   structure of a disk looking for a file. If the routine finds a
    ;   match it displays the complete drive\path\filename. The routine
    ;   uses the following algorithm:
    ;
    ;       make room for a local copy of the Dta
    ;       change directories to the location of the file we're looking for
    ;       find all matches in the current directory
    ;       for each sub-directory in the current directory
    ;           Do a recursive call to this routine
    ;       restore the original directory
    ;
    ;   The routine uses the global variable FileSpec as the specification
    ;   of the file to search for.
    ;
    ;   Input
    ;       DS - points to the segment in which FileSpec resides
    ;       Path - A pascal style string representing the path in which to
    ;              search for the file
    ;   Output
    ;       none
    ;   Calling convention
    ;       Pascal
    ;   Registers modified
    ;       ax, bx, cx, dx, si, es, flags

    arg     Path:byte:MAX_PATH_LENGTH=PARM_SIZE
    local   DataTransferArea:byte:DTA_SIZE=LOCAL_SIZE

        push    bp
        mov     bp, sp

        ; make room for the Dta, Drive, Path and Filename on the stack

        sub     sp, LOCAL_SIZE
        mov     si, bp                  ; Get the address of the Dta buffer
        sub     si, DTA_SIZE
        push    ds                      ; Store ds before call to SetDTA
        SetDTA  <ss>, <si>              ; Set the current Dta address
        pop     ds                      ; Restore ds after SetDTA
        if @CodeSize eq 0               ; FindFiles is near
            add     si, DTA_SIZE + 5    ; Get the address of the Path
        else
            add     si, DTA_SIZE + 7    ; Get the address of the Path
        endif
        xor     bx, bx
        mov     bl, [byte ss:si-1]      ; Get the length byte
        cmp     bl, 1                   ; Check if the path is 1 letter. If it
        jle     short ChangeDirs        ; is we don't want to remove it.
        cmp     [byte ss:si+bx-1], '\'  ; Check if the path ends with a '\'. If
        jne     short ChangeDirs        ; it does, remove it.
        mov     [byte ss:si+bx-1], 0
        dec     [byte ss:si-1]
    ChangeDirs:
        push    ds
        ChangeDirectory <ss>, <si>      ; Change the directory
        GetCurrentDir   <0>, <seg CurrentDir>, <offset CurrentDir>
        pop     ds
        if (@Cpu and 100b) eq 100b
            push    seg CurrentDir
            push    offset CurrentDir
        else
            mov     ax, seg CurrentDir
            push    ax
            mov     ax, offset CurrentDir
            push    ax
        endif
        mov     ax, 0020h               ; Replace spaces with 0
        mov     cx, MAX_PATH_LENGTH
        call    FindAndReplace
        FindFirst   <0FFh>, <ds>, <offset FileSpec + 1>
    NextFile:                           ; Find each of the matching files
        cmp     ax, 0
        jne     CheckDirectories
        GetKbdStatus
        jz      short NoKey
        call    Terminate
    NoKey:
        if (@Cpu and 100b) eq 100b
            push    seg Drive           ; Get the address of the drive
            push    offset Drive        ; description
        else
            mov     ax, seg Drive
            push    ax
            mov     ax, offset Drive
            push    ax
        endif
        mov     al, [Drive]
        xor     ah, ah
        call    WritePascalString       ; Display the drive description
        mov     ax, seg CurrentDir
        mov     es, ax
        mov     di, offset CurrentDir
        cmp     [byte es:di], 'A'       ; Check if the string is empty
        jl      short DontNeedBackSlash
        dec     di                      ; Decrement the offset of the pointer
    DontNeedBackSlash:
        push    es
        push    di
        call    WriteASCIIZString
        if (@Cpu and 100b) eq 100b
            push    seg SwitchChar
            push    offset SwitchChar
        else
            mov     ax, seg SwitchChar
            push    ax
            mov     ax, offset SwitchChar
            push    ax
        endif
        call    WritePascalString
        push    ss                      ; Pass the address of the filename
        mov     si, bp
        sub     si, DTA_SIZE - (offset (Dta).Filename)
        push    si
        call    WriteASCIIZString
        NewLine
        FindNext
        jmp     NextFile
    CheckDirectories:
        push    ds
        FindFirst   <010000b>, <(seg AllFiles)>, <(offset AllFiles)>
        pop     ds
    NextDirectory:
        cmp     ax, 0                   ; Check if we've found a sub-directory
        je      CheckAttributes
        jmp     Exit
    CheckAttributes:                    ; Check if it's a directory
        mov     si, bp                  ; Get the address of the attribute
        sub     si, DTA_SIZE - (offset (Dta).FileAttribute)
        mov     al, [byte ss:si]        ; Get the directory entries attributes
        and     al, 10000b
        cmp     al, 10000b
        jne     short GetNextDirectory

        ; Check if the directory is '.' or '..'

        mov     si, bp                  ; Get the address of the attribute
        sub     si, DTA_SIZE - (offset (Dta).Filename)
        cmp     [byte ss:si], '.'       ; If it's '.' or '..' then skip
        je      GetNextDirectory        ; it

        ; Copy the new path onto the stack

        sub     sp, MAX_PATH_LENGTH     ; Make room on the stack
        mov     bx, sp
        push    ss                      ; Push segment address of Path
        mov     si, bp
        if @CodeSize eq 0               ; FindFiles is near
            add     si, 4               ; get offset of current path string
        else
            add     si, 6
        endif
        push    si                      ; Push offset of path
        push    ss                      ; Push address to copy to
        push    bx
        mov     al, [byte Path]         ; Get the path length
        inc     al                      ; Copy the length byte also
        call    ByteCopy                ; Copy the path onto the stack

        ; Append the new directory to the path on the stack

        push    es                      ; Save es:di before call to
        push    di                      ; GetASCIIZStrLen
        mov     si, bp                  ; Get the address of the current Dta

        ; Get the address of the directory name from it's location in the Dta

        sub     si, DTA_SIZE - (offset (Dta).Filename)
        push    ss                      ; Push the address of the directory
        push    si                      ; name
        call    GetASCIIZStrLen         ; Get the length of the directory name
        pop     di                      ; Restore es:di
        pop     es
        cmp     [byte es:di-1], '\'     ; Check if the path on the stack ends
        je      short HasBackSlash      ; with a '\'. If not append one.
        mov     [byte es:di], '\'
        inc     di
        push    si
        mov     si, sp                  ; Adjust the length byte of the string
        inc     [byte ss:si+2]
        pop     si
    HasBackSlash:
        push    ss                      ; Push the address of the directory
        push    si                      ; name
        push    es          ; Push the address to copy the directory name to
        push    di
        call    ByteCopy                ; Copy the directory name
        mov     si, sp                  ; Adjust the length byte of the string
        dec     al                      ; we appended to. Don't include the
        add     [byte ss:si], al        ; terminating 0 in the length

        ; Do recursive call

        call    FindFiles               ; Do the search for the file(s)
        push    ds
        mov     ax, bp
        if  @CodeSize eq 0              ; Near code models
            add     ax, 5
        else
            add     ax, 7
        endif
        ChangeDirectory <ss>, <ax>      ; Change to the directory that was
        pop     ds                      ; active before the recursive call
        add     sp, MAX_PATH_LENGTH     ; Remove space allocated on the stack
        mov     si, bp
        sub     si, DTA_SIZE
        push    ds
        SetDTA  <ss>, <si>              ; Restore the Dta
        pop     ds
    GetNextDirectory:
        FindNext                        ; Find the next sub-directory
        jmp     NextDirectory
    Exit:
        add     sp, LOCAL_SIZE
        pop     bp
        ret                             ; Let the caller clean up the stack
    endp    FindFiles

endif   ; ifndef MDL

end
