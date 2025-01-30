;******************************************************
; teclado.asm
; Ejercicio para ingresar datos por teclado con gets
; Objetivos
;	- usar gets para leer de teclado
;	- entender que con gets se puede pisar memoria
;******************************************************
global 	main
extern 	printf
extern  gets

section  		.data
	msjIngTex	db	'Ingrese un texto (hasta 5 caracteres) o * para finalizar: ',0
	msjUdIng	db	'Usted ingresó:  %s',10,0
	msjUdPiso	db	'Usted piso memoria con: %s',10,0

section  		.bss
	texto		resb	6
	texto2	resb	10

section 		.text
main:
    sub rsp,8
ingTexto:
; Ingrese texto
	mov		rdi,msjIngTex
	call	printf

	mov		rdi,texto	;Parametro 1: direccion del campo donde se copia lo ingresado por teclado
	call	gets			;Lee de teclado hasta el fin de linea (enter) y guarda en formato caracteres 
									;agrega 0 binario como fin de string	
	cmp	byte[texto],'*'
	je	fin

; Ud ingresó
    mov		rdi,msjUdIng
    mov		rsi,texto
    call	printf

; Ud pisó
    mov		rdi,msjUdPiso
    mov		rsi,texto2
    call	printf

    jmp     ingTexto
fin:
    add     rsp,8
    ret
