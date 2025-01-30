# Instrucciones de transferencia y copia

- LEA op1, op2<br>
load effective address
Copia en el op1 (un registro) la direccion de memoria del op2. Ej:
```LEA RAX,[VARIABLE]``` es equivalente a ```MOV RAX,VARIABLE```
Los corchetes indican el "contenido de" y el nombre solo es la "direccion de"

## Copia de Strings 

- MOVSB<br>
Copia el contenido de memoria apuntado por RSI (source) al apuntado por RDI (destination). Copia tantos bytes como los indicados en el registro RCX (contador).
Se copia el contenido del origen RSI al destino RDI, el RCX tendria que tener la longitud del origen o la cantidad de bytes a copiar.

- CMPSB<br>
Compara el contenido de memoria apuntado por RSI (source) con el apuntado por RDI (destination) y compara tantos bytes como los indicados en RCX.
Ej:
```
	MOV RCX,4
	LEA RSI,[MSG1]
	LEA RDI,[MSG2]
REPE	CMPSB 		; ver prefijos REPE para comparar, REP para copiar: REP MOVSB
	JE IGUALES
```

Al final de la instruccion el RSI, RDI y RCX quedan alterados.

## Manejo de pila (stack) 

- PUSH op<br>
Inserta el operando (de 64 bits) en la pila. Decrementa en 1 el contenido del registro RSP (stack pointer, tope de la pila)

- POP op<br>
Elimina el ultimo elemento insertado en la pila (de 64 bits) y lo copia en el operando. Incrementa en 1 al contenido del registro RSP (stack pointer, tope de la pila)

El stack pointer SP se incrementa con POP y se decrementa con PUSH
VER ESQUEMA REGISTRO DE PILA
