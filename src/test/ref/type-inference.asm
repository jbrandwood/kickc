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
    lax.z b
    axs #-[-$30]
    lda.z b
    asl
    tay
    txa
    sta screen,y
    inc.z b
    lda #$15
    cmp.z b
    bne __b1
    rts
}
