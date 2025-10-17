; U-type
lui     x0, 0x0         ; 0 (x0 <= 0)
lui     x5, 0x12345     ; 4 (x5 <= 0x1234_5000)
auipc   x6, 0x1         ; 8 (x6 <= 0x1000 + pc(8))

; J-type (jal)
jal     x1, 8           ; c (x1 <= pc+4 (10), pc <= pc+8 (14))
addi    x3, x0, 0x222   ; 10 (skipped)
addi    x1, x0, 30      ; 14 (jal target, x1 <= 30)

; I-type (jalr)
jalr    x2, x1, 6       ; 18 (x2 <= pc+4(1c), pc <= x1+imm(36, 0x24))
addi    x3, x0, 0x333   ; 1c (skipped)
addi    x3, x0, 0x444   ; 20 (skipped)
addi    x3, x0, 0x555   ; 24 (jalr target)

