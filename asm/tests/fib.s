addi x1, zero, 1
addi x2, zero, 1

.loop:
    mov x3, x2
    add x2, x2, x1
    mov x1, x3
    jmp .loop