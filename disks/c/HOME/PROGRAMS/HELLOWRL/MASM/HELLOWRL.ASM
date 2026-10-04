    .MODEL small

    .STACK 100h

    .DATA

msg db 'Hello world !$'

    .CODE

main PROC
    mov ax,@data
    mov ds,ax
    mov ah,09h
    lea dx,msg
    int 21h
    mov ax,4C00h
    int 21h
main ENDP

END main
