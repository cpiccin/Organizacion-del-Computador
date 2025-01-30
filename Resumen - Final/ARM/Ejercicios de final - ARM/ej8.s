@ Escribir el código ARM que ejecutado bajo ARMSim# encuentre e imprima el
@ menor elemento de un vector, donde el vector está especificado con el label vector y
@ la longitud del vector con el label long_vector.
    
    .equ Print_Int, 0x6B
    .equ Stdout, 1
    .equ Exit, 0x11
    .equ Print_Str, 0x69

    .data
vector: 
    .word 4,-2,2,1,9,0
longitud:
    .word 6

    .text
_start:
    ldr r5, =vector @ puntero al vector
    ldr r6, [r5] @ elemento minimo inicial
    ldr r4, =longitud
    ldr r4, [r4]

loop: 
    cmp r4, #0 
    beq End
    @ comparo con el minimo actual
    ldr r3, [r5]
    cmp r6, r3
    movgt r6, r3 
    @ avanzo
    add r5, r5, #4
    sub r4, r4, #1
    b loop

End: 
    ldr r0, =Stdout
    mov r1, r6
    swi Print_Int
    swi Exit