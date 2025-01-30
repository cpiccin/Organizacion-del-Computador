
# Codigo en ARM
## Estructura de un programa
- Forma general de una linea en un modulo de ARM <br>
`label <espacio> opcode <espacio> operandos <espacio> @ comentario`
- Las instrucciones no empiezan en la primer columna, dado que deben estar precedidas por un espacio en blanco, incluso aunque no haya label
- ARM acepta lineas en blanco para mejorar la claridad del codigo

```
    .text                          @ Indica que los siguientes
                                   @ ítems en memoria son
                                   @ instrucciones
start:
    mov r0, #15                    @ Seteo de parámetros:
    mov r1, #20                    @ Se cargan los valores 15 y 20 al registro R0 y R1 respectivamente
    bl func                        @ Llamado a subrutina: se usa branch with link (bl) que bifurca y permite volver al flujo del cual bifurco. Se guarda la direc de la prox instruccion en el LR
    swi 0x11                       @ Fin de programa utilizando Software Interrupt (SWI)
func:                              @ Subrutina
    add r0, r0, r1                 @ r0 = r0 + r1
    mov pc, lr                     @ Retornar desde subrutina: esta guardado en el LR la direc sig al llamado a func, entonces digo que la proxima instruccion (lo que guarda el PC para seguir con el programa) sea lo que esta en el LR
    .end                           @ Marcar fin de archivo
```

## Interrupciones de software
La instruccion `SWI` le pide al OS que se encargue de algo. Segun el operando que se agregue va a ser la directiva para el OS. 
- El operando `0x6B` indica "imprimir un entero"
- El registro `LR` contiene el entero a imprimir
- El registro `R0` contiene donde imprimirlo: por ej si el `R0` contiene un 1 significa que se lo va a imprimir por Stdout
```
mov r0, #5
mov r1, #7
add r2, r0,r1
mov r1, r2         ; r1: entero a imprimir
mov r0, #1         ; r0: donde imprimir
swi 0x6B           ; 0x6B: imprimir entero
```
- Si se quiere indicar el fin del programa: operando `0x11`
```
mov r0, #5
mov r1, #7
add r2, r0,r1
mov r1, r2         ; r1: entero a imprimir
mov r0, #1         ; r0: donde imprimir
swi 0x6B           ; 0x6B: imprimir entero
swi 0x11           ; 0x11: salir del programa
```

## Secciones del programa
Necesitamos decirle al ensamblador qué bits deben colocarse en qué parte de la memoria.

- La directiva `.text` especifica la sección de código.
- La directiva `.data` especifica la sección de variables.
```
    .data
string1:
    .asciz “hola” ; .asciz agrega el bit nulo al final del string, .ascii no 
string2:
    .asciz “chau”
```

#### Ejemplo
```
    .data
cadena:
    .asciz "linea"
entero:
    .word 78         ; se esta reservando una word que va a ocupar 78
    .text
    .global _start   ; indica que va a ser el punto de entrada
_start:
    @ Comentario
    swi 0x11
    .end             ; indica que se termino de escribir el programa
```
```
    .data
cadena:
    .asciz "Soy una cadena"
    .text
    .global _start
_start:
    ldr r0, =cadena         ; se esta cargando la direccion de "cadena" en el r0
    swi 0x02                ; va a imprimir la cadena hasta que encuentro el nulo
```
