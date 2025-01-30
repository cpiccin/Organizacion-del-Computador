; Dado un vector de 20 números almacenados en el formato BPF c/s de 16 bits,
; escriba un programa que calcule el máximo, mínimo y el promedio de los números e
; imprimirlos por pantalla.

global main
extern printf

%macro mPrintf 2
    mov         rdi, %1
    mov         rsi, %2
    sub         rsp, 8
    call        printf
    add         rsp, 8
%endmacro

section .data
    vector      dw 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
    msgPromedio dw "El promedio de todos los numeros es: %li", 10, 0
    msgMaximo   dw "El maximo de todos los numeros es: %li", 10, 0
    msgMinimo   dw "El minimo de todos los numeros es: %li", 10, 0

section .bss 
    maximo      resb 10
    minimo      resb 10
    promedio    resb 10
    maximoAct   resb 10
    minimoAct   resb 10
    promedioAct resb 10

section .text
main:

    mov         rdi, [vector]
    mov         [maximoAct], rdi
    mov         [minimoAct].rdi

    mov         rcx, 20
    call        calcularMaximo
    mPrintf     msgMaximo, maximo

    mov         rcx, 20
    call        calcularMinimo
    mPrintf     msgMinimo, minimo 

    mov         rcx, 20
    call        calcularPromedio
    mPrintf     msgPromedio, promedio 

    ret 

calcularMaximo:
    cmp         rcx,0
    je          end 
    dec         rcx
    


nuevoMaximo:


end:
    ret
