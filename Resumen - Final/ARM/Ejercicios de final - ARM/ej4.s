@ Codificar un programa en Assembler ARM de 32 bits que lea desde un
@ archivo números enteros e imprima por la salida estándar la productoria
@ de aquellos números que sean positivos.


    .equ Open_File, 0x66
    .equ Read_Int, 0x6C
    .equ Print_Int, 0x6B
    .equ Close_File, 0x68
    .equ Exit, 0x11
    .equ Stdout, 1

    .data
filename:
    .asciz "numeros_enteros.txt"
filehandle:
    .word 0
productoria:
    .word 1

    .text
_start:
    ldr r0, =filename
    mov r1, #0
    swi Open_File @ deja almacenado en r0 el file handle
    bcs ErrorEnArchivo
    ldr r1, =filehandle
    str r0, [r1]

loop_lectura:
    ldr r0, =filehandle
    ldr r0, [r0]
    swi Read_Int
    bcs EOF @ no pudo leer nada porque llego al end of file
    @ multiplico
    ldr r1, =productoria
    ldr r2, [r1] @ agarro la productoria actual
    mul r2, r2, r0 
    str r2, [r1]
    b loop_lectura

ErrorEnArchivo:
EOF:
    @ imprimo productoria
    ldr r1, =productoria
    ldr r1, [r1]
    ldr r0, =Stdout
    swi Print_Int
    @ cierro archivo
    ldr r0, =filehandle
    ldr r0, [r0]
    swi Close_File
    swi Exit