# Saltos/Bifurcaciones

- JMP op<br>
Bifurca a la direccion indicada por el operando

- Jcc op<br>
Bifurca a la direccion indicada del operando si se cumple la condicion.


## Llamada y Retorno de procedimiento
- CALL op<br>
Almacena en la pila la direccion de la instruccion siguiente a la call y bifurca al punto indicado por el operando

- RET op<br>
Toma el elemento del tope de la pila que debe ser una direccion de memoria y bifurca hacia la misma.

## Loop
- LOOP op<br>
Resta 1 al contenido del RCX (por convencion es el contador) y si el resultado es distinto de 0, bifurca al punto indicado por el operando, sino continua con la ejecucion de la siguiente instruccion.
```
    mov rcx,5
inicio:
    . . .
    . . .
    loop inicio
    . . .
```

## Condicionales. JUMP IF...
ZF = Zero Flag ; CF = Carry Flag ; OF = Overflow Flag ; SF = Sign Flag

### Condicionales generales
- JE op&emsp;-> si son iguales ZF=1
- JNE op&emsp;-> si no son iguales ZF=0
- JZ op&emsp;-> si es igual a cero ZF=1
- JNZ op&emsp;-> si es distinto a cero ZF=0
- JRCXZ op&emsp;-> si el contenido del RCX es cero, salta a la label op si es cero, si no sigue
- JC op&emsp;-> si CF es distinto de cero CF=1
    * The Carry Flag is set by previous arithmetic instructions (like ADD, SUB, MUL, etc.) if an operation resulted in a carry out of the most significant bit (for addition) or a borrow into the most significant bit (for subtraction).
    * The JC instruction checks the Carry Flag. If CF is 1 (indicating a carry or borrow occurred), it jumps to the specified label in the program. If CF is 0 (indicating no carry or borrow occurred), it continues to the next instruction.
- JO op&emsp;-> si hubo overflow (OF=1)

### Condicionales con signo
- JG op&emsp;-> si es mayor (ZF=0 and SF=OF)
- JGE op&emsp;-> si es mayor o igual (SF=OF)
- JL op&emsp;-> si es menor (SF!=OF)
- JLE op&emsp;-> si es menor o igual (ZF=1 or SF!=OF)

- JNG op&emsp;-> si no es mayor (ZF=1 or SF!=OF)
- JNGE op&emsp;-> si no es mayor o igual (SF!=OF)
- JNL op&emsp;-> si no es menor (SF=OF)
- JNLE op&emsp;-> si no es menor o igual (ZF=0 and SF=OF)

### Condicionales sin signo
- JA op&emsp;-> si es mayor (CF=0 and ZF=0)
- JAE op&emsp;-> si es mayor o igual (CF=0)
- JB op&emsp;-> si es menor (CF=1)
- JBE op&emsp;-> si es menor o igual (CF=1 or ZF=1).

- JNA op&emsp;-> si no es mayor (CF=1 or ZF=1)
- JNAE op&emsp;-> si no es mayor o igual (CF=1)
- JNB op&emsp;-> si no es menor (CF=0)
- JNBE op&emsp;-> si no es menor o igual CF=0 and ZF=0)
