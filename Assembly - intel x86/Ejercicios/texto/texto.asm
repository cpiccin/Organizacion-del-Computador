%macro mPuts 0
    sub     rsp,8
    call    puts
    add     rsp,8
%endmacro

%macro mGets 0
    sub     rsp,8
    call    gets
    add    rsp,8
%endmacro

%macro mPrintf 0
    sub     rsp,8
    call    printf
    add     rsp,8
%endmacro

global main
extern puts
extern gets
extern printf

section .data ; para campos con contenido inicial
    msgIngreseTexto db "Ingrese texto por teclado (max 99 caracteres)", 0 ; 0 binario indica fin de string
    msgIngreseChar db "Ingrese un caracter: ", 0
    textLenght dq 0 ; longitud del texto inicialmente es 0
    counterChar dq 0 ; contador de caracteres iguales inicialmente es 0
    textoInvertido db "Texto invertido: %s",10,0 ; formato para imprimir texto invertido
    numeroDeCaracteres db "El caracter %c aparece %li veces.",10,0
    porcentajeDeAparicion db "El porcentaje de aparicion es %li %%", 10, 0

section .bss ; para campos sin contenido inicial
    text resb 500 ; reserva 500 bytes para texto
    char resb 50 ; reserva 50 bytes para caracter
    reversedText resb 500 ; reserva 500 bytes para texto invertido

section .text ; para código
main: 
    ; Imprimir mensaje para ingresar texto
    mov rdi, msgIngreseTexto
    mPuts
    ; Leer texto, lo guarda en text
    mov rdi, text
    mGets
    ; Imprimir mensaje para ingresar caracter
    mov rdi, msgIngreseChar
    mPuts
    ; Leer caracter, lo guarda en char
    mov rdi, char
    mGets

    mov rsi, 0 ; contador inicializado en 0

nextCharFindLast: ; etiqueta para el loop

    ; la idea es comparar byte a byte contra el 0 binario, para saber cuando se llego al fin de string
    
    cmp byte[text + rsi], 0 ; fin de string?
    je endString ; si la instruccion anterior arrojo que son iguales bifurca a endString
    inc rsi ; si no llego al final, incrementa contador
    jmp nextCharFindLast ; salta a nextChar y reinicia el ciclo, es un salto no condicional

endString: ; etiqueta para el fin de string
    mov [textLenght],rsi ; mueve el valor del registro rsi a la ubicacion de memoria apuntada por textLenght
    mov rdi, 0 ; para que apunte al primer caracter de reversedText

charCopy: ; etiqueta para copiar el texto invertido
    cmp rsi, 0 ; si se llego al final, termina la copia
    je endCopy ; si la instruccion anterior arrojo que son iguales bifurca a endCopy
    ;queiro hacer una copia de memoria a memoria, mov no lo permite entonces tengo que hacer un pivot
    mov al,[text+rsi-1] ; almaceno el valor de la ultima posicion del texto en al
    mov [reversedText+rdi],al ; almaceno el valor de al en la posicion actual+rsi de reversedText
    cmp al,[char] ; comparo el caracter ingresado con el caracter guardado en al
    jne movePointers ; si el caracter no es igual, voy a movePointer para avanzar
    add qword[counterChar],1 ; si el caracter es igual, incremento el contador de caracteres iguales

movePointers:
    inc     rdi
    dec     rsi
    jmp     charCopy

endCopy:
    mov     byte[reversedText+rdi],0 ;rdi es el que estoy incrementando

; imprimo texto invertido
    mov     rdi,textoInvertido
    mov     rsi,reversedText
    mPrintf

; imprimo cantidad de apariciones del caracter 
    mov rdi, numeroDeCaracteres
    mov rsi, [char]
    mov rdx, [counterChar]
    mPrintf

; calculo porcenta
    imul rax, [counterChar], 100 ; multiplico contador de caracteres iguales por 100
    sub rdx, rdx ; limpio rdx
    idiv qword[textLenght] ; usa implicitamente como dividendo al rax y el divisor es el operando que le proporcione

; imprimo porcentaje de aparicion
    mov rdi, porcentajeDeAparicion
    mov rsi,rax
    mPrintf

    ret