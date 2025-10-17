; initialize registers
li   x5,  x0,  10        ; 0 (x5 <= 10)
li   x6,  x0,  15        ; 4 (x6 <= 15)
li   x7,  x0,  -1        ; 8 (x7 <= -1 (0xFFFF_FFFF))

; beq test
beq  x5,  x5,  8         ; c (branch taken (10=10), pc <= pc+8 (0x14))
li   x10, x0,  1         ; 10 (skipped)
li   x10, x0,  2         ; 14 (branch target, x10 <= 2)

; bne test
bne  x5,  x5,  999       ; 18 (branch not taken (10==10))
bne  x5,  x7,  8         ; 1c (branch taken (10!=-1), pc <= pc+8 (0x24))
li   x11, x0,  3         ; 20 (skipped)
li   x11, x0,  4         ; 24 (branch target, x11 <= 4)

; blt test
blt  x6,  x5,  999       ; 28 (branch not taken (15!<10))
blt  x7,  x5,  8         ; 2c (branch taken (-1<10), pc <= pc+8 (0x34))
li   x12, x0,  5         ; 30 (skipped)
li   x12, x0,  6         ; 34 (branch target, x12 <= 6)

; bge test
bge  x7,  x6,  999       ; 38 (branch not taken (-1!>=15))                
bge  x6,  x7,  8         ; 3c (branch taken (15>=-1), pc <= pc+8 (0x44))
li   x13, x0,  7         ; 40 (skipped)
li   x13, x0,  8         ; 44 (branch target, x13 <= 8)


; bltu test
blt   x5,  x7, 999       ; 48 (branch not taken (10!<-1))
bltu  x5,  x7, 8         ; 4c (branch taken (10<4294967295), pc <= pc+8 (0x54))
li    x14, x0, 9         ; 50 (skipped)
li    x14, x0, 10        ; 54 (branch target, x14 <= 10)

; bgeu test
bge   x7,  x6, 999       ; 58 (branch not taken (-1!>=15))
bgeu  x7,  x6, 8         ; 5c (branch taken (4294967295>=15), pc <= pc+8 (0x64))
li    x15, x0, 11        ; 60 (skipped)
li    x15, x0, 12        ; 64 (branch target, x15 <= 12)