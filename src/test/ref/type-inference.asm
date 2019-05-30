// Test inference of integer types in expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label b = 2
    lda #0
    sta b
  b1:
    lax b
    axs #-[-$30]
    lda b
    asl
    tay
    txa
    sta screen,y
    inc b
    lda #$15
    cmp b
    bne b1
    rts
}
