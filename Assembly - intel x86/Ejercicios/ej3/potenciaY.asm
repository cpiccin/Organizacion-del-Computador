; Realizar un programa que resuelva X^Y teniendo en cuenta que tanto X e Y pueden ser positivos o negativos.

global main
extern puts 
extern gets 
extern atoi
extern printf

%macro mPuts 1
    mov rdi, %1
    sub rsp, 8
    call puts
    add rsp, 8
%endmacro

%macro mGets 1
    mov rdi, %1
    sub rsp, 8
    call gets
    add rsp, 8
%endmacro

section .data 
    msgX    db "Ingrese un numero X: ", 0
    msgY    db "Ingrese un numero Y: ", 0
    msgFin  db "%d^%d = %d", 10, 0


section .bss
    X       resd 20
    Y       resd 20
    Xint    resd 1 
    Yint    resd 1
    res     resd 20
    

section .text
main:
    mPuts   msgX
    mGets   X 

    mPuts   msgY 
    mGets   Y 

    call    pasarAInt

    call    definirContador

    mov     rcx, [Yint]
    mov     rdi, 1 
    mov     [res], rdi 
    call    hacerCuenta

    mov     rdi, msgFin
    mov     rsi, [Xint]
    mov     rdx, [Yint]
    mov     rcx, [res]
    sub     rsp, 8 
    call    printf 
    add     rsp, 8
    ret

hacerCuenta:
    call    multiplicar
    cmp     rcx, 0
    jg      hacerCuenta
    jz      end

multiplicar:
    mov     rdi, [res]
    imul    rdi, [Xint]
    mov     [res], rdi
    dec     rcx
    ret

end:
    ret

pasarAInt:
    mov     rdi, X 
    call    atoi 
    mov     [Xint], eax

    mov     rdi, Y 
    call    atoi
    mov     [Yint], eax
    ret

definirContador:
    mov     rdi, 0
    cmp     rdi, [Yint]
    je      expCero; el exponente es 0
    jl      expNegativo
    jg      expPositivo
    ret

expCero: 
    ; seteo contador=0
    mov     rdi, 0 
    mov     [Yint], rdi

    ret

expNegativo:
    mov     rdi, [Yint]
    ret

expPositivo:
    ret
