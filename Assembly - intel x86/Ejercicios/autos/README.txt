Para generar el ejecutable:
--------------------------
1)
Ensamblado
nasm autos.asm -felf64
nasm utils.asm -felf64
nasm validator.asm -felf64

Ensamblado para debug
nasm autos.asm -felf64 -g -F dwarf -l autos.lst
nasm utils.asm -felf64 -g -F dwarf -l utils.lst
nasm validator.asm -felf64 -g -F dwarf -l validator.lst

2)
Linkedicion
gcc autos.o utils.o validator.o -no-pie

tambien funciona
gcc *.o -no-pie

Archivo de prueba
-----------------
El archivo listado.dat debe ser leido/editado con un editor hexadecimal.

Una opcion puede ser "Free Hex Editor Neo"
https://www.hhdsoftware.com/free-hex-editor

Hay muchas mas.  Tambien hay plugins para Visual Studio code.

Debug
-----
Comandos usados en clase

gdb a.out			inicia el debugger con el ejecutable a.out
layout regs			cambia la interfaz a algo mas "amigable" para ver registros y codigo fuente
b 61				coloca un breakpoint en la linea 61
r				inicia la corrida del programa (y para en el primer breakpoint q encuentra)
n   				ejecuta la siguiente instruccion o funcion (si es funcion NO entra al codigo de la misma)
s   				ejecuta la siguiente instruccion o funcion (si es funcion entra al codigo de la misma)
p (char*) &inMarca		imprime el contenido del campo inMarca como string