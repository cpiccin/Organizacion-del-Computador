# Caso de estudio: ARM

## ARM - Arquitectura
ARM está basado en una arquitectura load/store, reduciendo así el set de instrucciones; esto significa que el núcleo no puede operar directamente con la memoria. Todas las operaciones de datos deben realizarse mediante registros.

### Organizacion de memoria
- Maximo: 2<sup>32</sup> bytes de memoria
- Las **palabras** son de 32 bits
- Existe la **half-word** de 16 bits
- Words están alineadas en posiciones divisibles por 4
- Half-words están alineadas en posiciones pares

### Set de registros
`R0` a `R12` son registros de proposito general (32 bits)
- Usados por el programador para casi cualquier proposito sin restriccion

`R13` es el Stack Pointer (SP)

`R14` es el Link Register (LR). Se usa para poder volver al flujo principal, se relaciona con poder tener rutinas internas dentro del programa: es usado como registro enlace a subrutinas (LR) y almacena la dirección de retorno cuando una se realiza una operación *Branch with Link*, la cual se calcula desde el registro PC. Siendo así, para volver desde una subrutina puede ejecutarse: `MOV r15, r14` o `MOV pc, lr`.

`R15` es el Program Counter (PC). El RPI en abacus, tiene la direccion de la proxima direccion a ser ejecutada. Como todas las instrucciones tienen longitud de 32 bits y deben estar alineadas a word (cada word es de 4 bytes, esto significa que cada instrucción comienza en una posición de memoria divisible por 4), el valor almacenado en el registro Contador del Programa (PC) es almacenado en los bits [31:2] con los bits [1:0].

El *Current Program Status Register* (CPSR) contiene indicadores condicionales y otros bits de estado. No se interactuamos con este registro

![cpsr](https://github.com/user-attachments/assets/90ad0b0b-643d-4e75-9241-dbd0d9265cfe)

### Condition flags
![fefe](https://github.com/user-attachments/assets/6e832438-abee-4a50-b546-ead58befc2be)

### Sintaxis
- Las etiquetas pueden definirse utilizando una secuencia de caracteres alfanuméricos, barras inferiores (_) y puntos (.) que no comienzan con un número.
- Los códigos de operación son palabras reservadas que no pueden ser utilizados como identificadores válidos.
- Las cadenas de caracteres (strings) deben ir entre comillas dobles (") y los caracteres especiales siguen la convención de C:
```
    newline \n
    tab \t
    quote \"
```
- La presencia del caracter @ en una línea indica el comienzo de un comentario que se extiende hasta el final de la línea.
- El caracter ; puede ser usado en lugar de una nueva línea para separar sentencias.
- Tanto # como $ pueden ser usados para indicar operandos inmediatos.

### Directivas
| Directiva            | Comportamiento | 
|----------------------|----------------|
|`.equ sym, constant`| Da el nombre simbólico *sym* a una constante *constant*.|
|`.data <addr>`| Indica que los siguientes ítems son datos (variables) y deben almacenarse en el segmento de datos. Si el argumento opcional *addr* está presente, los ítems son almacenados desde la dirección *addr*.|
|`.align n` | Alinear el siguiente dato en una posición de memoria divisible por 2<sup>n</sup>. Por ejemplo, `.align 2` alinea el siguiente valor en una dirección divisible por 4 (alineado a word) límite de palabra.|
|`.align 0` | Desactiva la alineación automática de las directivas `.half`, `.word`, `.float` y `.double` hasta la siguiente directiva `.data`.|
|`.ascii str`|Almacena el string en memoria pero no agrega byte nulo al final.|
|`.asciiz str`| Almacena el string en memoria y agrega byte nulo al final.|
|`.byte b1, ..., bn`| Almacena los n valores en bytes sucesivos en memoria.|
|`.half h1, ..., hn`|Almacena los n valores de 16 bits en halfwords sucesivos en memoria.|
|`.word w1, ..., wn` |Almacena los n valores de 32 bits en words sucesivos en memoria.|
|`.float f1, ..., fn` |Almacena los n flotantes de precisión simple sucesivos en memoria.|
|`.double d1, ..., dn` |Almacena los n flotantes de precisión doble sucesivos en memoria.|
|`.comm sym size` |Aloca size bytes en el segmento de datos para el símbolo sym.|
|`.global sym`|Declara que el símbolo sym es global y que puede ser referenciado desde otros archivos.|
|`.label sym`|Declara que el símbolo sym es una etiqueta.|
|`.text <addr>`|Indica que los siguientes ítems en memoria son instrucciones. Si el argumento opcional addr está presente, los ítems son almacenados desde la dirección addr.|
|`.end`|Marca el fin del archivo del módulo del programa.|

## ARM - Set de instrucciones
### Características principales 
- Arquitectura Load/Store: la forma de comunicarse con la memoria es solamente a través de Load y Store
- Instrucciones de longitud fija (32 bits) 
- Formatos de instrucciones de 3 direcciones:
    - 2 registros de operacion 
    - 1 registro de resultado
- Ejecución condicional de todas las instrucciones: permite que las instrucciones se ejecuten si se cumplen ciertas instrucciones
- Existen instrucciones de Load-Store de registros múltiples. Si se quiere cargar info de una dirección de memoria se puede hacer de una a varios registros. 

### Formato de instrucciones
Cada instrucción es codificada en una 32-bit word.

![aaa](https://github.com/user-attachments/assets/268cb383-83d2-41ed-8352-d9a2d18d35bc)

Una instrucción especifica un código de ejecución condicional (Condition), el código OP (OP code), dos o tres registros (Rn, Rd y Rm) y alguna otra información adicional.

### Ejecucion condicional
Una característica distintiva y algo inusual de los procesadores ARM es que todas las instrucciones se ejecutan condicionalmente dependiendo de una condición especificada en la instrucción.

La instrucción es ejecutada sólo si el estado actual del flag del código de condición del procesador satisface la condición especificada. Por lo tanto, las instrucciones cuya condición no se ve satisfecha en el flag de código de condición del procesador no se ejecutan. 

Una de las condiciones se utiliza para indicar que la instrucción siempre se ejecuta.

🟢 Esta característica elimina la necesidad de utilizar muchas bifurcaciones. El costo en tiempo de no ejecutar una instrucción condicional es frecuentemente menor que el uso de una bifurcación o llamado a una subrutina que, de otra manera, sería necesaria.

#### Ejemplo
```
	.equ SWI_Print_Int, 0x6B
	.equ SWI_Exit, 0x11

	.text
	.global _start
_start:
	mov r0, #4
	mov r1, #4
	cmp r0, r1                    @ Se compara r0 con r1, como son iguales se setea el ZF
	addeq r2, r0, r1              @ Como esta seteado el ZF se ejecuta la suma
	mov r1, r2
	mov r0, #1
	swi SWI_Print_Int
	swi SWI_Exit
```

Las instrucciones de procesamiento de datos no afectan a las *condition flags* (las instrucciones de comparacion si). Para que los condition flags se vean afectados, el bit S de la instrucción necesita estar seteado. Esto se hace agregando el sufijo S a la instrucción (y a cualquier código de condición).

#### Ejemplo 
Restar uno al r1 y afectar los condition flags en un loop
```
.loop: ...
    subs r1, r1, #1
    bne loop           @ si en la resta el resultado no fue 0 (los dos valores iguales), se vuelve al loop
```

### Load/Store Multiple
En los procesadores ARM, hay dos instrucciones para cargar y almacenar múltiples operandos y son las llamadas instrucciones de transferencia de bloques.

Cualquier subconjunto de los registros de propósito general se puede cargar o almacenar. Solo se permiten operandos word y los códigos OP utilizados son LDM (Load Multiple) y STM (Store Multiple).

Por ejemplo la instruccion
- `ldmia r10!, {r0,r1,r6,r7}` <br>
La instruccion carga consecutivamente valores de memoria en los registros `R0`, `R1`, `R6`, y `R7`, comenzando desde la dirección contenida en `R10`. Después de la operación, `R10` se incrementa en 16 bytes (ese autoincremento es siempre 4) para apuntar más allá de los datos recién cargados.

### Instrucciones de bifurcacion
Las instrucciones de bifurcación condicionales contienen un desplazamiento de 24 bits con signo que se agrega al contenido actualizado del PC para generar la dirección de destino de la bifurcación.
En la arquitectura ARM, una ejecución condicional de una instrucción permite que una instrucción se ejecute solo si se cumple una condición específica.

![aaa](https://github.com/user-attachments/assets/0c410d86-bbaf-48ac-963a-5ce236c4d8a3)

Por ejemplo la instruccion `BEQ` que bifurca si igual a 0, o sea si el flag Z esta seteado en 1

![ssssss](https://github.com/user-attachments/assets/dca7ce7a-1aa6-4d25-8451-459e893cbf17)

### Barrel Shifter
ARM no tiene instrucciones de shift. En su lugar tiene un barrel shifter que provee un mecanismo que lleva a cabo shifts como parte de otras instrucciones.
Cuando se especifica que el segundo operando es un registro shifteado, la operación del Barrel Shifter es controlada por el campo Shift en la instrucción. Este campo indica el tipo de shift a realizar. La cantidad de bits a shiftear puede estar contenida en un campo inmediato o en el byte inferior de otro
- Desplazamiento lógico a la izquierda (LSL): Desplaza los bits hacia la izquierda (segun la cantidad especificada, multiplicando por potencia de 2), rellenando con ceros.
	- `LSL #5 @ multiplica por 32`
- Desplazamiento lógico a la derecha (LSR): Desplaza los bits hacia la derecha (divide por potencia de 2), rellenando con ceros.
	- `LSR #5 @ divide por 32`
- Desplazamiento aritmético a la derecha (ASR):Shift a la derecha según la cantidad especificada (divide por potencia de 2) preservando el bit de signo (el bit más significativo).
	- `ASR #5 @ divide por 32`
- Rotación a la derecha (ROR): Rota los bits hacia la derecha, moviendo los bits desplazados al extremo izquierdo.
- Rotación a la derecha con extensión (RRX): Rota los bits hacia la derecha, incluyendo el bit de acarreo en la rotación.

### Instrucciones Load/Store
#### Transferencia de datos de un registro
```
ldr 	@ Load Word
str 	@ Store Word
ldrb 	@ Load Byte
strb	@ Store Byte
ldrh 	@ Load Halfword
strh 	@ Store Halfword
ldrsb 	@ Load Signed Byte (load and extent sign to 32 bits)
ldrsh 	@ Load Signed Halfword (load and extent sign to 32 bits)
```
#### Ejecucion condicional
Estas instrucciones pueden ser ejecutadas condicionalmente insertando el condition code apropiado luego de `LDR/STR`. Ejemplo: `LDREQB`

#### Registro base
La dirección de memoria accedida está contenido en un registro base
```
str r0, [r1] 	@ Almacena (r0) en la memoria apuntada por r1
ldr r2, [r1] 	@ Carga en (r2) el valor apuntado por r1
```

#### Offset desde el registro base
Las instrucciones Load/Store pueden acceder la dirección contenida en el registro base así como una dirección offset desde el Registro Base. Este offset puede ser:
- Valor inmediato: BPF s/s de 12 bits
- Registro (opcionalmente shifteado por un valor inmediato)

El offset puede ser sumado o restado del Registro Base prefijando el valor del offset o registro
con + (por defecto) o -

El offset puede aplicarse
- Antes de que se realice la transferencia: Direccionamiento Pre-indexado
	- Puede auto-incrementarse el Registro Base agregando ! al final de la instrucción.
- Después de que se realice la transferencia: Direccionamiento Post-indexado
	- Causando que el Registro Base se vea auto-incrementado

##### Direccionamiento Pre-Indexado
Ejemplo: `STR r0, [r1, #12]`

![weedfef](https://github.com/user-attachments/assets/9cf46974-600f-4341-8daa-db8823ad7b03)

- Para almacenar en la dirección 0x1f4
	- `STR r0, [r1, #-12]`
- Para auto-incrementar el Registro Base a 0x20c
	- `STR r0, [r1, #12]!`
- Si (r2)=3 puede accederse a 0x20c multiplicándolo por 4
 	- `STR r0, [r1, r2, LSL #2]`
 
##### Direccionamiento Post-Indexado
Ejemplo: `STR r0, [r1], #12`

![adas](https://github.com/user-attachments/assets/564c5a94-5580-4fb6-90e7-6a722569963d)

- Para auto-incrementar el Registro Base a la dirección 0x1f4
	- `STR r0, [r1], #-12`
- Si (r2)=3 puede auto-incrementarse a 0x20c multiplicándolo por 4
	- `STR r0, [r1], r2, LSL #2`

### Pila (Stack)
Una pila es un área de la memoria que crece a medida que nuevos datos se insertan (push) en la parte superior de la misma, y se reduce a medida que los datos se remueven (pop) desde la parte superior. Dos punteros definen los límites actuales de la pila:
- Un puntero de base: apunta a la parte inferior de la pila (la primera posición).
- Un puntero a la pila: apunta a la parte superior actual de la pila.

#### Pilas y subrutinas
Uno de los usos de las pilas es crear un área de memoria temporal para los registros para las subrutinas. Cualquier registro que sea necesario puede ser agregado (push) a la pila al principio de la subrutina y tomado (pop) desde la pila para recuperar el valor antes de volver de la subrutina.


### Interrupcion de Software (SWI)
Una interrupción de software es un tipo de interrupción causada por una instrucción especial en el set de instrucciones. El software invoca una interrupción de software, a diferencia de una interrupción de hardware, y se considera una de las formas de invocar llamadas al sistema.

En ARMSim# se utilizan interrupciones de software para operaciones comunes de entrada/salida.

La sintaxis para hacer un llamada es: `swi <swi code>`

![edfefef](https://github.com/user-attachments/assets/a0a2cf1c-3be8-485f-bca8-5552220fa980)

### Modos de direccionamiento 
![eeeeee](https://github.com/user-attachments/assets/84bcfab5-fb7b-45f3-859d-afba1cb12427)

- **Registro a registro:** Es entre dos registros `mov r0, r1`
- **Absoluto:** La dirección de memoria es especificada directamente en la instrucción. `ldr r0, mem`
- **Literal:** La instrucción contiene un valor constante (literal) que se utiliza directamente. `mov r0, #15` , `add r1, r2, #12`
- **Indexado, base:** La dirección efectiva se obtiene del contenido de un registro `ldr r0, [r1]`	
- **Pre-Indexado, base con desplazamiento:** Se suma un desplazamiento fijo al contenido del registro base antes de acceder a la memoria `ldr r0, [r1, #4] @ carga en r0 el contenido de la direccion resultante de sumar 4 al contenido de r1`
- **Pre-Indexado, autoindexado:**  El registro base se actualiza con el desplazamiento antes del acceso. `ldr r0, [r1, #4]! @ carga en r0 el contenido de la direccion resultante de sumar 4 al contenido de r1 y luego actualiza r1 con esa nueva direccion`
- **Post-indexado, autoindexado:** la direccion de memoria se accede primero y luego se actualiza el registro base con el desplazamiento. `ldr r0, [r1], #4 @ carga en r0 el contenido de la direccion almacenada en r1 y luego suma 4 a r1`
- **Doble registro indirecto:** la direccion efectiva se obtiene sumando el contenido de dos registros. `ldr r0, [r1, r2] @ carga en r0 el contenido de la direccion resultante de sumar el contenido de r1 y r2`
-  **Doble registro indirecto escalado:** un registro se escala (multiplicar el valor de un registro por una potencia de dos. Esto se logra mediante operaciones de shift a la izquierda o a la derecha) antes de sumarlo a otro. `ldr r0, [r1, r2, lsl #2] @ carga en r0 el contenido de la direccion resultante de sumar el contenido de r1 y el contenido de r2 escalado por 4`
-  **Relativo al PC:**  La dirección efectiva se calcula sumando un desplazamiento al contador de programa (PC). `ldr r0, [PC, #offset] @ carga en r0 el contenido de la direccion resultante de sumar un desplazamiento al PC
#### Modo pre-indexado
La dirección efectiva del operando es la suma de los contenidos del registro base Rn y un offset.

#### Modo pre-indexado con reescritura
La dirección efectiva del operando se genera de la misma manera que en el modo Pre-indexado pero la dirección efectiva se escribe también en Rn.

#### Modo post-indexado
La dirección efectiva del operando es el contenido de Rn. El desplazamiento se agrega a esta dirección y el resultado se escribe de nuevo en Rn.
