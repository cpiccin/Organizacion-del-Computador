; Realizar un programa en assembler Intel x86 que imprima por pantalla la siguiente
; frase: “El alumno [Nombre] [Apellido] de Padrón N° [Padrón] tiene [Edad] años para
; esto se debe solicitar previamente el ingreso por teclado de:
;   Nombre y Apellido
;   N° de Padrón
;   Fecha de nacimiento

global main 
extern puts
extern gets
extern printf

%macro mPuts 1
    mov rdi, %1
    sub rsp, 8
    call puts
    add rsp, 8
%endmacro

%macro mGets 1
    mov rdi, %1
    sub rsp, 8
    call gets
    add rsp, 8
%endmacro

section .data
    msgFinal    db "El alumno %s %s de Padrón N° %s tiene %s años", 10, 0
    msgNombre   db "Ingrese su nombre: ", 0
    msgApellido db "Ingrese su apellido: ", 0
    msgPadron   db "Ingrese su padron: ", 0
    msgEdad     db "Ingrese su edad: ", 0

section .bss
    nombre      resb 20
    apellido    resb 20
    padron      resb 20
    edad        resb 20

section .text
main:
    mPuts       msgNombre 
    mGets       nombre

    mPuts       msgApellido
    mGets       apellido

    mPuts       msgPadron
    mGets       padron

    mPuts       msgEdad
    mGets       edad


    mov         rdi, msgFinal 
    mov         rsi, nombre 
    mov         rdx, apellido
    mov         rcx, padron 
    mov         r8, edad
    sub         rsp, 8
    call        printf
    add         rsp, 8 
    ret

