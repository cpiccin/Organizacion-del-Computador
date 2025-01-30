; Escribir un programa que imprima por pantalla “Organización del Computador”.

global main
extern puts
section .data
    mensaje db 'Organización del Computador', 0

section .bss

section .text
main:
    mov rdi, mensaje
    sub rsp, 8
    call puts
    add rsp, 8
    ret
