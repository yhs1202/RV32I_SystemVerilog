/* 251002_1541 Checked */
_start:	li		sp, 200

main:
        addi    sp,sp,-64
        sw      ra,60(sp)
        sw      s0,56(sp)
        addi    s0,sp,64
        sw      zero,-52(s0)
        sw      zero,-48(s0)
        sw      zero,-44(s0)
        sw      zero,-40(s0)
        sw      zero,-36(s0)
        sw      zero,-32(s0)
        li      a5,4
        sw      a5,-52(s0)
        li      a5,1
        sw      a5,-48(s0)
        li      a5,2
        sw      a5,-40(s0)
        li      a5,3
        sw      a5,-36(s0)
        li      a5,5
        sw      a5,-28(s0)
        sw      zero,-20(s0)
        j       .L2
.L6:
        sw      zero,-24(s0)
        j       .L3
.L5:
        lw      a4,-24(s0)
        addi    a5,s0,-52
        slli    a4,a4,2
        add     a5,a4,a5
        lw      a4,0(a5)
        lw      a5,-24(s0)
        addi    a3,a5,1
        addi    a5,s0,-52
        slli    a3,a3,2
        add     a5,a3,a5
        lw      a5,0(a5)
        ble     a4,a5,.L4
        addi    a4,s0,-52
        lw      a5,-24(s0)
        slli    a5,a5,2
        add     a3,a4,a5
        lw      a5,-24(s0)
        addi    a5,a5,1
        addi    a4,s0,-52
        slli    a5,a5,2
        add     a5,a4,a5
        mv      a1,a5
        mv      a0,a3
        call    swap
.L4:
        lw      a5,-24(s0)
        addi    a5,a5,1
        sw      a5,-24(s0)
.L3:
        lw      a4,-28(s0)
        lw      a5,-20(s0)
        sub     a5,a4,a5
        addi    a5,a5,-1
        lw      a4,-24(s0)
        blt     a4,a5,.L5
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
.L2:
        lw      a5,-28(s0)
        addi    a5,a5,-1
        lw      a4,-20(s0)
        blt     a4,a5,.L6
        li      a5,0
        mv      a0,a5
        lw      ra,60(sp)
        lw      s0,56(sp)
        addi    sp,sp,64
        jr      ra
swap:
        addi    sp,sp,-48
        sw      ra,44(sp)
        sw      s0,40(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        lw      a5,-36(s0)
        lw      a5,0(a5)
        sw      a5,-20(s0)
        lw      a5,-40(s0)
        lw      a4,0(a5)
        lw      a5,-36(s0)
        sw      a4,0(a5)
        lw      a5,-40(s0)
        lw      a4,-20(s0)
        sw      a4,0(a5)
        nop
        lw      ra,44(sp)
        lw      s0,40(sp)
        addi    sp,sp,48
        jr      ra