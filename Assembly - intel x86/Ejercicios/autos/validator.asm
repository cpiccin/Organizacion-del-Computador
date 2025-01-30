global  existsInArray

section .bss
    dirStr      resq    1
    dirVec      resq    1
    strLen      resq    1

section .text
;rdi: dir del string a buscar
;rsi: dir del vector
;rdx: cantidad de elmentos del vector
;rcx: longitud de cada elemento
existsInArray:
    mov     [dirStr],rdi ;Resguardo param 1 (dir del string)
    mov     [dirVec],rsi ;Resguardo param 2 (dir vector)
    mov     [strLen],rcx ;Resguardo param 4 (longitud de cada elemento del vector) 

    mov     rax,0  ;no existe por default

cmpNextElem:    
    cmp     rdx,0 ;voy a ir decrementando RDX para controlar el fin del recorrido del vector
    je      endExistInArray    

    repe cmpsb
    je      exists

    mov     rcx,[strLen] ;restauro long string (rcx se modifica con cmpsb)
    add     [dirVec],rcx ;muevo el puntero al sgte elemento del vector
    mov     rsi,[dirVec] ;actualizo dir sgte elem del vector
    mov     rdi,[dirStr] ;restauro dir string (rdi se modifica con cmpsb)
    dec     rdx
    jmp     cmpNextElem
exists:
    mov     rax,1
endExistInArray:
ret