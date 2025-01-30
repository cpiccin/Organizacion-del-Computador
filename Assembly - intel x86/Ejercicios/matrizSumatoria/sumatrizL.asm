;*****************************************************************************
; sumatriz.asm
; Dada una matriz de 5x5 cuyos elementos son números enteros de 2 bytes (word)
; se pide solicitar por teclado un nro de fila y columna y realizar
; la sumatoria de los elementos de la fila elegida a partir de la
; columan elegida y mostrar el resultado por pantalla.
; Se deberá validar mediante una rutina interna que los datos ingresados por
; teclado sean validos.
;
;*****************************************************************************

global	main
extern	printf
extern	gets
extern	sscanf
extern	puts

section	.data
    ;matriz  dw  1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5
    matriz  dw  1,1,1,1,1
			dw  2,2,2,2,2
			dw	3,3,3,3,3
			dw	4,4,4,4,4
			dw	5,5,5,5,5
    msjIngFilCol	    db	"Ingrese fila (1 a 5) y columna (1 a 5) separados por un espacio: ",0
    formatInputFilCol	db	"%hi %hi",0 ; hi es numero entero con signo base 10 en 16 bits
    msjErrorInput       db  "Los datos ingresados son inválidos.  Intente nuevamente."
	sumatoria		    dd  0
	msjSumatoria	    db	"La sumatoria es: %i",10,0 ; i es numero entero con signo base 10 en 32 bits

section	.bss
	inputFilCol		resb	50
   	fila			resw	1
	columna			resw	1 	
    inputValido     resb    1   ;se grabara una letra S valido o N invalido
    desplaz			resw	1

section	.text
main:
	mov		rdi,msjIngFilCol
	sub		rsp,8
	call	printf
	add		rsp,8

    mov		rdi,inputFilCol	
	sub		rsp,8	
    call    gets    
	add		rsp,8	    

    sub     rsp,8
    call    validarFyC
    add     rsp,8

    cmp     byte[inputValido],'S'
    je      continuar

    mov     rdi,msjErrorInput
    sub     rsp,8
    call    puts
    add     rsp,8	

    jmp     main
continuar:
; sumatoria
	sub		rsp,8
    call	calcSumatoria
	add		rsp,8

;mostar por pantalla
    mov		rdi,msjSumatoria
	sub		rsi,rsi
	mov		esi,[sumatoria]
	sub		rsp,8
	call	printf
	add		rsp,8  


ret ;FIN DE PROGRAMA
;*********************************
; RUTINAS INTERNAS
;*********************************
validarFyC:
    mov     byte[inputValido],'N'

    mov     rdi,inputFilCol
    mov     rsi,formatInputFilCol
    mov     rdx,fila
    mov     rcx,columna
	sub		rsp,8
	call	sscanf ; extrae, si puede los valores decimales de fila y columna, devuelve la cantidad de valores convertidos
	add		rsp,8    

    cmp     rax,2
    jl      invalido ; si no pudo convertir 2 valores salta a invalido

    cmp     word[fila],1 ; compara el valor de fila con 1
    jl      invalido ; si es menor salta a invalido
    cmp     word[fila],5 ; compara el valor de fila con 5
    jg      invalido ; si es mayor salta a invalido

    cmp     word[columna],1 ; compara el valor de columna con 1
    jl      invalido ; si es menor salta a invalido
    cmp     word[columna],5 ; compara el valor de columna con 5
    jg      invalido ; si es mayor salta a invalido

    mov     byte[inputValido],'S'
invalido:
ret
;*********************************
calcDesplaz:
;  [(fila-1)*longFila]  + [(columna-1)*longElemento]
;  longFila = longElemento * cantidad columnas
    mov     bx,[fila] ; en vez de bx puedo usar cualquier otro registro de tamanio word (2 bytes, 16 bits)
    sub     bx,1
    imul    bx,bx,10    ;en bx tengo el desplazamiento a la fila

    mov     [desplaz],bx

    mov     bx,[columna]
    dec     bx
    imul    bx,bx,2

    add     [desplaz],bx    ;en desplaz tengo el desplazamiento total
ret

;*********************************
calcSumatoria:
	sub		rsp,8
    call	calcDesplaz
	add		rsp,8
;jmp FIN_NO_OLVIDAR_REMOVER
    mov     rcx,6
    sub     cx,[columna]
    mov     ebx,[desplaz]
sumarSiguiente:
    sub     eax,eax ;limpio el registro eax
    mov     ax,[matriz + ebx]   ; cargo el elemento de la matriz q es de 2 bytes
    add     [sumatoria],eax     ;actualizo la sumatoria con un campo de 4 bytes
    add     ebx,2
    loop    sumarSiguiente
FIN_NO_OLVIDAR_REMOVER:    
ret






