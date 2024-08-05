section .data
    x db 1
    y db 2
    z db 3

section .bss
    result resb 1 ;Result to be returned from function

section .text
        global _start
_start:
     movzx eax, BYTE[x] ;Use movzx to be able to move bytes into x64 regs
     movzx ebx, BYTE[y]
     movzx ecx, BYTE[z] ;Move variables into registers to push them

     push    eax ;Pass arguments
     push    ebx
     push    ecx

     call    _foobar

     pop eax ;Clear stack
     pop ebx
     pop ecx

     xor eax, eax
     xor ebx, ebx ;Clear registers used to pass arguments
     xor ecx, ecx

     mov     eax, 1
     int     0x80

;;; ;------------------------------------------------------
;;; ;------------------------------------------------------
;;; ; _foobar: needs 3 arguments. The arguments are pushed onto the stack before calling this function.
;;; ;
;;; ; Examples:
;;; ;          push    110
;;; ;          push    45
;;; ;          push    67
;;; ;          call _foobar
;;; ;
;;; ;REGISTERS MODIFIED: EAX
;;; ;------------------------------------------------------
;;; ;------------------------------------------------------
_foobar:
    ; ebp must be preserved across calls. Since
    ; this function modifies it, it must be
    ; saved.
    ;
    push    ebp

    ; From now on, ebp points to the current stack
    ; frame of the function
    ;
    mov     ebp, esp

    ; Make space on the stack for local variables
    ;
    sub     esp, 4

    ; eax <-- a. eax += 2. then store eax in xx
    ;
    mov     eax, DWORD[ebp+8]
    add     eax, DWORD[ebp+12]
    add     eax, DWORD[ebp+16]
    mov [result], eax ;Store result

    ; The leave instruction here is equivalent to:
    ;
    ;   mov esp, ebp
    ;   pop ebp
    ;
    ; Which cleans the allocated locals and restores
    ; ebp.
    ;
    leave
    ret

