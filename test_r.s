; Regfle is initialized w/ 0x32, 0x33, 0x34 ... from x0

; add, sub, xor, or, and
add   x5,  x3,  x4      ; 0 (x5 <= 0x35 + 0x36)
sub   x6,  x3,  x4      ; 4 (x6 <= 0x35 - 0x36) 
xor   x7,  x3,  x4      ; 8 (x7 <= 0x35 ^ 0x36) -> 0x3
or    x8,  x3,  x4      ; c (x8 <= 0x35 | 0x36)
and   x9,  x3,  x4      ; 10 (x9 <= 0x35 & 0x36)

; shift
sll   x10, x3,  x7      ; 14 (x10 <= 0x35 << 3)
srl   x11, x3,  x7      ; 18 (x11 <= 0x35 >> 3)
sra   x12, x3,  x7      ; 1c (x12 <= 0x35 >>> 3)

; slt
slt   x13, x3,  x6     ; 20 (x13 <= 0), (0x35 < 0xFFFF_FFFF)
sltu  x14, x3,  x6     ; 24 (x14 <= 1), (0x35 <u 0xFFFF_FFFF)