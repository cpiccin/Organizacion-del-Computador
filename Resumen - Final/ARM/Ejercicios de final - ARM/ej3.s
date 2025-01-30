@ Codificar un programa en Assembler ARM de 32 bits que lea desde un archivo 
@ números enteros e imprima SU SUMATORIA POR LA SALIDA ESTANDAR.

    .equ Open_File, 0x66
    .equ Read_Int, 0x6C
    .equ Print_Int, 0x6B
    .equ Close_File, 0x68
    .equ Exit, 0x11
    .equ Stdout, 1

    .data
filename:
    .asciz "numeros_enteros.txt"
fileHandle:
    .word 0
suma:
    .word 0

    .text
_start:
    @ abrir archivo
    ldr r0, =filename 
    mov r1, #0 @ es el modo de entrada
    swi Open_File
    bcs ErrorEnArchivo
    ldr r1, =fileHandle @ cargo direccion donde almacenar el handle
    str r0, [r1]

loop_lectura:
    @ lectura del entero 
    ldr r0, =fileHandle
    ldr r0, [r0]
    swi Read_Int
    bcs EndOfFile
    @ suma al acumulador
    ldr r1, =suma 
    ldr r2, [r1]
    add r2, r2, r0 
    str r2, [r1]
    b loop_lectura

ErrorEnArchivo:
EndOfFile:
    @ imprimir sumatoria 
    ldr r0, =Stdout
    ldr r1, =suma 
    ldr r1, [r1]
    swi Print_Int
    @ cerrar archivo
    ldr r0, =fileHandle
    ldr r0, [r0]
    swi Close_File
    swi Exit