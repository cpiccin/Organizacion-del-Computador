; autos.asm
;Se cuenta con un archivo "listado.dat" en formato binario con informacion de autos.  Cada registro tiene los campos:
; - Marca: 10 caracteres ascii
; - Modelo: 10 caracteres ascii
; - Año fabricacion: 2 bytes en bpf s/s
; 
; Se pide realizar un programa que pida ingresar por teclado una marca de automovil e imprima por pantalla todos los autos
; de dicha marca que se encuentran en el archivo.

; Las marcas válidas de autos posible son Fiat, Ford, Chevrolet y Peugeot y se deberá validar que la marca ingresada 
; sea alguna de ellas previo a la busqueda en el archivo

global main
%macro mPuts 1
    mov     rdi,%1
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

%macro mGets 1
    mov     rdi,%1
    sub     rsp,8
    call    gets  
    add     rsp,8
%endmacro

extern  puts
extern  gets
extern  strLen
extern  existsInArray
extern  fopen
extern  fread
extern  fclose
extern  printf

section .data
    msgInMarca                  db  "Ingrese una marca de auto",0
    arrMarcas                   db  "Fiat      Ford      Chevrolet Peugeot   "
    marca10Chars    times 10    db  " "
    msgMarcaNotExists           db  "La marca ingresada no existe",0
    msgDataAuto                 db  "%s %hi",10,0
    
    fileAutos		            db	"listado.dat",0
    modeListado		            db	"rb",0		;read | binario | abrir o error
    msgErrOpenLis       	    db	"Error en apertura de archivo Listado",0

    marcaModelo     times 20    db  " "
     endStr                     db  0

section .bss
    inMarca                 resb 200
    handleListado           resq 1
    regListado      times 0 resb 1  ;Cabecera del registro (con times 0 para q no reserve espacio)
      marca                 resb 10 ;Campo donde se guardara la marca leida del archivo
      modelo                resb 10 ;Campo donde se guardara el modelo leido del archivo
      anioFabric            resb 2  ;Campo donde se guardara el año de fabricacion leido del archivo

section .text
main:
    ;Pido ingreso de marca
    mPuts   msgInMarca
    mGets   inMarca

    ;Obtengo en RAX la longitud del string donde se guardo la marca
    mov     rdi,inMarca ;Parametro 1: marca ingresada por teclado
    sub     rsp,8
    call    strLen
    add     rsp,8

    ;Copio la marca en un campo inicializado con 10 espacios en blanco
    mov rsi,inMarca
    mov rdi,marca10Chars 
    mov rcx,rax ;La longitud q esta en RAX la copio en RCX
    rep movsb

    ;Valido si la marca esta en el vector de marcas
    mov     rdi,marca10Chars    ;Param 1: string con la marca
    mov     rsi,arrMarcas       ;Param 2: vector con las marcas validas
    mov     rdx,4               ;Param 3: cantidad de elementos del vector
    mov     rcx,10              ;Param 4: long de cada elemento del vector
    sub     rsp,8
    call    existsInArray
    add     rsp,8

    cmp     rax,0
    je      marcaNotExists

    ;Abro el archivo
    mov     rdi,fileAutos   ;Param 1: string con nombre del archivo (finaliza con 0 binario!!)
    mov     rsi,modeListado ;Param 2: string con el modo de apertura
    sub     rsp,8
    call    fopen
    add     rsp,8

	cmp		rax,0
	jle		errorOpenLis
	mov     [handleListado],rax

    ;Leo un registro del archivo
readNexRegister:    
    mov     rdi,regListado          ;Param 1: campo de memoria para guardar el registro q se leerá del archivo
    mov     rsi,22                  ;Param 2: Tamaño del registro en bytes
    mov     rdx,1                   ;Param 3: Cantidad de registros a leer (** usamos siempre 1 **)
	mov		rcx,[handleListado]     ;Param 4: id o handle del archivo (obtenido en fopen)
	sub		rsp,8  
	call    fread                   ;Retorna la cantidad de bloques leidos
	add		rsp,8

    cmp     rax,0                   ;Si la cantidad de bloques leidos es 0, llego al fin
    je      closeFile

    ;Comparo la marca ingresada por teclado con el campo marca del registro leido del archivo
    mov     rsi,marca
    mov     rdi,marca10Chars
    mov     rcx,10
    repe cmpsb

    jne     readNexRegister

    ;Copio la marca y modelo en un campo q finalice con 0 binario (para poder usarlo en printf)
    mov     rsi,marca
    mov     rdi,marcaModelo
    mov     rcx,20 ;copio 20 bytes por lo tanto se copia marca y modelo
    rep movsb

    ;Imprimo los datos del auto encontrado en el archivo
    mov     rdi,msgDataAuto
    mov     rsi,marcaModelo
    xor     rdx,rdx
    mov     dx,[anioFabric]
    sub     rsp,8
    call    printf
    add     rsp,8
    
    jmp     readNexRegister

    ;Cierro el archivo
closeFile:
    mov     rdi,[handleListado]
    sub     rsp,8
    call    fclose
    add     rsp,8

    jmp     endProg

marcaNotExists:
    mPuts   msgMarcaNotExists  
    jmp		endProg  
errorOpenLis:
    mPuts   msgErrOpenLis
	jmp		endProg

endProg:
ret