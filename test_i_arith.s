; Regfile is initialized w/ 0x32, 0x33, 0x34 ... from x0
;
; add, xor, or, and immediate
addi   x5,  x3,  4      ; 0 (x5 <= 0x35+4)
xori   x6,  x3,  5      ; 4 (x6 <= 0x35^5)
ori    x7,  x3,  6      ; 8 (x7 <= 0x35|6)
andi   x8,  x3,  7      ; c (x8 <= 0x35&7)

; shift immediate
slli   x9,  x3,  1      ; 10 (x9 <= 0x35<<1)
srli   x10, x3,  2      ; 14 (x10 <= 0x35>>2)
srai   x11, x3,  3      ; 18 (x11 <= 0x35>>>3)

; slt immediate
slti   x12, x3,  8      ; 1c (x12 <= 0), (0x35 < 8)
sltiu  x13, x3,  9      ; 20 (x13 <= 0), (0x35 <u 9)

; slt w/ negative immediate value
slti   x14, x3, 0xFF    ; 24 (x14 <= 1), (0x35 < 255)
slti   x15, x3, 0xFFF   ; 28 (x15 <= 0), (0x35 < -1)
sltiu  x16, x3, 0xFFF   ; 2c (x16 <= 1), (0x35 < 4095)

; sra w/ negative immediate value
addi   x4,  x3, 0x800   ; 30 (x4 <= 0xFFFF_F835), (53-2048 = -1995, 0xFFFF_F835)
srai   x17, x4,  3      ; 34 (x17 <= 0xFFFF_FF06), (0xFFFF_F835 >>> 3)

