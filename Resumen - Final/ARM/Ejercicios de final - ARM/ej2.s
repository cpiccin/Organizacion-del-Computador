@ Codificar un programa en assembler ARM de 32 bits que recorra un
@ vector de enteros y genere un nuevo vector formado por elementos que
@ resultan de sumar pares de elementos del vector original. Ej. vector
@ original{1,2,5,6}, vector nuevo {3,11}

    .equ Print_Int, 0x6B
    .equ Stdout, 1
    .equ Exit, 0x11
    .equ Print_Str, 0x69

    .data
vector_origen:
    .word 3,1,4,2,8,1 
longitud: 
    .word 6
vector_final:
    .word 0, 0, 0 @ tiene que resultar en 4,6,9
eol: 
    .asciz "\n"
    
    .text
_start:
    ldr r0, =vector_origen
    ldr r1, =vector_final
    ldr r2, =longitud
    ldr r2, [r2]

loop_suma:
    ldr r4, [r0], #4
    sub r2, r2, #1
    ldr r5, [r0], #4
    add r6, r4, r5 
    str r6, [r1], #4
    
    subs r2, r2, #1
    bne loop_suma 
    @ aca ya se termino de sumar
    ldr r2, =vector_final 
    mov r3, #3

loop_mostrar:
    cmp r3, #0
    beq exit 

    ldr r0, =Stdout
    ldr r1, [r2]
    swi Print_Int
    ldr r1, =eol 
    swi Print_Str
    add r2, r2, #4
    sub r3, r3, #1
    b loop_mostrar

exit:
    swi Exit