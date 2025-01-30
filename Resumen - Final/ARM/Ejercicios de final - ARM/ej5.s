@ Codificar un programa en ARM de 32 bits que recorra un vector de
@ enteros y genere un archivo de salida con el resultado de aplicar la
@ funcion AND en cada uno de los elementos del vector original contra una
@ constante

    .equ Print_Int, 0x6B
    .equ Open_File, 0x66
    .equ Close_File, 0x68
    .equ Exit, 0x11
    .equ Print_Str, 0x69
    .equ Stdout, 1

    .data
vector:
    .word 1,2,3,4,5
longitud:
    .word 5
filename: 
    .asciz "resultado.txt"
eol:
    .asciz "\n"
    .align 
filehandler:
    .word 0

    .text
_start:
    ldr r0, =filename 
    mov r1, #1 @modo: salida
    mov r2, #384 @permisos de escritura
    swi Open_File 
    bcs ErrorEnArchivo
    ldr r1, =filehandler @carga direccion donde almacenar el handler
    str r0, [r1]

    ldr r9, =vector @ en r9 el puntero al vector
    ldr r8, =longitud
    ldr r8, [r8]

loop_escritura:
    cmp r8, #0
    beq EndOfVector
    ldr r3, [r9] @ en r3 elemento del vector

escribir:
    and r4, r3, #1 @ comparo con and el elemento del vector con la constante 7
    ldr r0, =filehandler @ le paso filehandler para que escriba en el archivo
    ldr r0, [r0]
    mov r1, r4
    swi Print_Int
    ldr r1, =eol 
    swi Print_Str
    subs r8, r8, #1
    add r9, r9, #4
    b loop_escritura

ErrorEnArchivo:
EndOfVector:
    @ cierro archivo
    ldr r0, =filehandler
    ldr r0, [r0]
    swi Close_File
    swi Exit
