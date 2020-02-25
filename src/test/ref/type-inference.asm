// Test inference of integer types in expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label b = 2
    lda #0
    sta.z b
  __b1:
    // -0x30+b
    lax.z b
    axs #-[-$30]
    // screen[b] = -0x30+b
    lda.z b
    asl
    tay
    txa
    sta screen,y
    // for( byte b: 0..20)
    inc.z b
    lda #$15
    cmp.z b
    bne __b1
    // }
    rts
}
