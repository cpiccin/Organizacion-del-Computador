@ hacer un programa en assembler ARM 32 bits que recorra un vector de
@ enteros y genere un nuevo vector adicionando un valor constante a cada
@ uno de los elementos del vector original e imprimiendo por la salida
@ estándar cada uno de los elementos del nuevo vector


    .equ Print_Int, 0x6B
    .equ Stdout, 1
    .equ Exit, 0x11
    .equ Print_Str, 0x69

    .data
vector: 
    .word 4,2,1,7,8,0
longitud:
    .word 6
nuevo_vector:
    .word 0,0,0,0,0,0
    .text
_start:
    ldr r5, =nuevo_vector
    ldr r4, =vector
    ldr r3, =longitud
    ldr r3, [r3]

loop:
    cmp r3, #0
    beq Fin
    ldr r2, [r4], #4 @ cargo y paso a la siguiente posicion
    add r2, r2, #5 @ sumo 5 al valor 
    str r2, [r5], #4 @ guardo en el nuevo vector y voy a la sig posicion
    @ imprimo
    ldr r0, =Stdout
    mov r1, r2
    swi Print_Int
    @ avanzo 
    sub r3, r3, #1
    b loop 

Fin:
    swi Exit

