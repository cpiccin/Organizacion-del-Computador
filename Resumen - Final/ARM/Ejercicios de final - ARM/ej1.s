    .equ Print_Int, 0x6B
    .equ Print_Str, 0x69
    .equ Exit, 0x11
    .equ Stdout, 1
    
    .data
vector:
    .word 1,2,5,6,7,8,9
longitud:
    .word 7
par: 
    .asciz " PAR\n"

     .text
_start:
    ldr r2, =vector
    ldr r3, =longitud
    ldr r3, [r3]

loop:
    ldr r1, [r2], #4 @ guarda el valor actual del vector y avanza su posicion

    and r4, r1, #1
    cmp r4, #0
    bne not_par

    ldr r0, =Stdout
    swi Print_Int
    ldr r1, =par 
    swi Print_Str

not_par:
    subs r3, r3, #1
    bne loop
    
    swi Exit