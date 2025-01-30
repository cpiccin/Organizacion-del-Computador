# Instrucciones aritmeticas

## Conversion

- CBW<br>
Convierte el byte almacenado en AL a un word en AX (valor de 8bits a 16bits)

- CWD "Convert Word to Doubleword"<br>
Convierte la word almacenada en AX a una double-word en DX:AX (valor de 16bits a 32bits)

- CWDE "Convert Word to Doubleword Extend"<br>
Convierte la word almacenada en AX a una double-word en EAX (valor de 16bits a 32bits)

- CDQE<br>
Convierte la double-word almacenada en EAX en una quad-word en RAX (32bits a 64bits)

## Operaciones aritmeticas

### Negacion
- NEG op<br>
Realiza el complemento a 2 del operando, es decir, le cambia el signo. Hace NOT(op)+1

### Suma
- ADD op1, op2<br>
Suma los valores de los dos operandos (BPF c/s) dejando el resultado en op1.

### Resta
- SUB op1, op2 <br>
Resta los valores de los dos operandos (BFP c/s) dejando el resultado en op1.

### Multiplicacion
#### Formato 1 operando
- IMUL op<br>
Si la longitud del op (interpretado como BPF c/s) es de:
    * 8 bits: multiplica AL * op y deja el resultado en AX
    * 16 bits: multiplica AX * op y deja el resultado en DX:AX
    * 32 bits: multiplica EAX * op y deja el resultado en EDX:EAX
    * 64 bits: multiplica RAX * op y deja el resultado en RDX:RAX

- MUL op <br>
Igual que IMUL pero los operandos son interpretados como BPF s/s

#### Formato con 2 operandos
- IMUL op1, op2<br>
Multiplica el contenido de los operandos (interpretados como BPF c/s) y almacena el resultado en op1.
El op1 debe ser si o si un registro y ambos operandos deben tener la misma longitud.
Si el resultado no entra en op1, se trunca.

- MUL op1, op2<br>
Igual que IMUL pero los operandos son interpretados como BPF s/s

#### Formato con 3 operandos
- IMUL op1, op2, op3<br>
Multiplica el contenido de op2 con op3 y almacena el resultado en op1. 
El op1 es si o si un registro y el op3 siempre un valor inmediato. 
Tanto op1 como op2 deben tener la misma longitud.
Si el resultado no entra en op1, se trunca.
Operandos interpretados como BPF c/s

- MUL op1, op2, op3<br>
Igual que IMUL pero los operandos son interpretados como BPF s/s

### Division
- IDIV op<br>
Si la longitud del op (interpretado como BPF c/s) es de:
    * 8 bits:<br>
    AX/op       resto en AH y cociente en AL
    * 16 bits:<br>
    DX:AX/op    resto en DX y cociente en AX
    * 32 bits:<br>
    EDX:EAX/op  resto en EDX y cociente en RAX
    * 8 bits:<br>
    RDX:RAX/op  resto en RDX y cociente en RAX
    
- DIV op<br>
Igual que IDIV pero el operando es interpretado como BPF s/s

### Incremento y Decremento
- INC op<br>
Suma 1 al operando (BPF c/s)

- DEC op<br>
Resta 1 al operando (BPF c/s)
