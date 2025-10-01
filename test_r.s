; Regfile initialization
li   x3,  0x35         ; 0 (x3 <= 0x35)
li   x4,  0x36         ; 4 (x4 <= 0x36)

; add, sub, xor, or, and
add  x5,  x3,  x4      ; 8 (x5 <= 0x35 + 0x36)
sub  x6,  x3,  x4      ; c (x6 <= 0x35 - 0x36) 
xor  x7,  x3,  x4      ; 10 (x7 <= 0x35 ^ 0x36) -> 0x3
or   x8,  x3,  x4      ; 14 (x8 <= 0x35 | 0x36)
and  x9,  x3,  x4      ; 18 (x9 <= 0x35 & 0x36)

; shift
sll  x10, x3,  x7      ; 1c (x10 <= 0x35 << 3)
srl  x11, x3,  x7      ; 20 (x11 <= 0x35 >> 3)
sra  x12, x3,  x7      ; 24 (x12 <= 0x35 >>> 3)

; slt
slt  x13, x3,  x6     ; 28 (x13 <= 0), (0x35 < 0xFFFF_FFFF)
sltu x14, x3,  x6     ; 2c (x14 <= 1), (0x35 <u 0xFFFF_FFFF)

