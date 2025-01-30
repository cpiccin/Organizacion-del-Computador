## Microinstrucciones para: FASE DE EJECUCION

Los primeros 4 bits que esten en el RI son lo que significa para la maquina
- **CO**: codigo de operacion (ID de instruccion), referencia sobre lo que le estoy pidiendo a la maquina.
Los siguientes 12 bits es para el campo 
- **OP**: operando, que es el dato. El CPU lo va a usar como referencia a una celda de memoria que lo va a usar para buscar el contenido para dejarlo en el AC.
```
|======|=======|
|4 bits|12 bits|
|======|=======|
   CO     OP
```
**AC**: acumulador, es un registro temporario para que la maquina pueda hacer operaciones.

### Operacion de CARGA (LOAD):
Carga el contenido de la celda apuntada por el campo OP y lo deja en el acumulador.

```(OP) ----> RDM```<br>
"Referencia de OP va a RDM"<br>
```((RDM)) ----> RM```<br>
"El contenido de la celda referenciada en RDM va a RM"<br>
<<<< Operacion de lectura >>>><br>
```(RM) ----> AC```<br>
"El contenido de RM se persiste en el AC"<br>


### Operacion de ALMACENAMIENTO (STORE):
Copia el contenido del AC y lo almacena en la celda de la memoria que corresponda a la direccion que este referencia en el OP del RI. El OP contiene la direccion de donde se quiere guardar el contenido del AC.

```(OP) ----> RDM```<br>
"El contenido del OP se copia en el RDM"<br>
```(AC) ----> RM```<br>
"El contenido del AC viaja al RM"<br>
```(RM) ----> (RDM)```<br>
"El contenido del RM se guarda en la celda a la que apunta la direccion del RDM"<br>
<<<< Operacion de escritura >>>><br>


### Operacion de SUMA(ADD):
Parte de un dato del AC y le adiciona, le agrega algo que esta referenciado en la memoria

```(OP) ----> RDM```<br>
"El contendio del OP se copia en el RDM para ir a buscarlo"<br>
```((RDM)) ----> RM```<br>
"El contendio de la celda referenciada en RDM va a RM"<br>
<<<< Operacion de lectura >>>><br>
```(RM)+(AC) ----> AC```<br>
"A lo que se fue a buscar a la memoria se le adiciona lo que este en el AC y queda en el AC"<br>
El circuito electrico dentro de la UAL realiza la suma.<br>


### Operacion de BIFURCACION:
Permite la ruptura de secuencia. Evalua condiciones contra un valor del AC. Es un "if". EJ: si AC == 0 se cumple la condicion y se bifurca.

```(OP) ----> RPI```<br>
"Si se cumple la condicion, el contenido del OP va a ir al RPI"<br>
