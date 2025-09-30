; S-type (store)
li  x1, 0x12345678  ; 0,4 (x1 <= 0x1234_5678)
sb  x1, 4(x0)       ; 8 (RAM[0x4] <= 0x78)
sh  x1, 8(x0)       ; c (RAM[0x8] <= 0x5678)
sw  x1, 12(x0)      ; 10 (RAM[0xC] <= 0x1234_5678)

; I-type (load)
lb  x4, 4(x0)       ; 14 (x4 <= RAM[0x4] = 0x78)
lh  x5, 8(x0)       ; 18 (x5 <= RAM[0x8] = 0x5678)
lw  x6, 12(x0)      ; 1c (x6 <= RAM[0xc] = 0x1234_5678)


; lbu, lhu test
li  x1, 0xFFFF_FF80 ; 20, 24 (x1 <= 0xFFFF_FF80)
li  x2, 0xc         ; 28 (x2 <= 0xc, base RAM addr)

sb  x1, 4(x2)       ; 2c (RAM[0x10] <= 0x80)
lb  x7, 4(x2)       ; 30 (x7 <= 0xFFFF_FF80, -128)
lbu x8, 4(x2)       ; 34 (x8 <= 0x0000_0080, +128)

li  x1, 0xFFFF_8000 ; 38 (x1 <= 0xFFFF_8000)

sh  x1, 8(x2)       ; 3c (RAM[0x14] <= 0x8000)
lh  x9, 8(x2)       ; 40 (x9 <= 0xFFFF8000, -32768)
lhu x10, 8(x2)      ; 44 (x9 <= 0x8000, +32768)