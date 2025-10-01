; Regfile initialization
li   x3,  0x35          ; 0 (x3 <= 0x35)
li   x4,  0x831         ; 4 (x4 <= 0x831)

; addi, xori, ori, andi
addi   x5,  x3,  4      ; 8 (x5 <= 0x35+4)
xori   x6,  x3,  5      ; c (x6 <= 0x35^5)
ori    x7,  x3,  6      ; 10 (x7 <= 0x35|6)
andi   x8,  x3,  7      ; 14 (x8 <= 0x35&7)

; shift immediate
slli   x9,  x3,  1      ; 18 (x9 <= 0x35<<1)
srli   x10, x3,  2      ; 1c (x10 <= 0x35>>2)

; slt w/ negative immediate value
slti   x11, x3, 0xFFF   ; 20 (x11 <= 0), (0x35 < -1)
sltiu  x12, x3, 0xFFF   ; 24 (x12 <= 1), (0x35 < 4095)

; sra w/ negative immediate value
srai   x13, x4,  3      ; 28 (x15 <= 0xFFFF_FF06), (0xFFFF_F831 >>> 3)