global strLen

section .text
; rdi: dir inicio del string
strLen:
    mov     rax,0
nextChar:
    cmp     byte[rdi+rax],0
    je      endStrLen
    inc     rax
    jmp     nextChar
endStrLen:

ret