@ Escribir el código ARM que ejecutado bajo ARMSim# lea dos enteros desde 
@ un archivo e imprima:
@ El primer entero en su propia línea.
@ El resultado de aplicar NOT al primer entero en su propia línea.
@ El segundo entero en su propia línea.
@ El resultado de aplicar NOT al segundo entero en su propia línea.


    .equ Print_Int, 0x6B
    .equ Open_File, 0x66
    .equ Close_File, 0x68
    .equ Exit, 0x11
    .equ Print_Str, 0x69
    .equ Read_Int, 0x6C
    .equ Stdout, 1


    .data
filename:
    .asciz "numeros_enteros.txt"
filehandler:
    .word 0
eol:
    .asciz "\n"
@ asumo que solo hay dos enteros en el archivo
    .text 
_start:
    @ abro archivo
    ldr r0, =filename
    mov r1, #0
    swi Open_File
    ldr r1, =filehandler
    str r0, [r1]

lectura:
    @ leo entero
    ldr r0, =filehandler
    ldr r0, [r0]
    swi Read_Int
    bcs EOF
    mov r5, r0 @ muevo al r5 el entero leido

    @ imprimo el entero
    ldr r0, =Stdout
    mov r1, r5
    swi Print_Int
    ldr r1, =eol 
    swi Print_Str

    @ imprimo not(entero)
    mvn r5, r5
    add r5, r5, #1
    ldr r0, =Stdout
    mov r1, r5 
    swi Print_Int
    ldr r1, =eol 
    swi Print_Str

    b lectura

ErrorEnArchivo:
EOF:
    ldr r0, =filehandler
    ldr r0, [r0]
    swi Close_File
    swi Exit
.end