// Range-based for does not recognize symbolic constants.
// The following should work but gives a not-constant exception
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label BITMAP = $2000
    .label b = 2
    lda #<BITMAP+$1fff
    sta.z b
    lda #>BITMAP+$1fff
    sta.z b+1
  __b1:
    lda #$5a
    ldy #0
    sta (b),y
    lda.z b
    bne !+
    dec.z b+1
  !:
    dec.z b
    lda.z b+1
    cmp #>BITMAP-1
    bne __b1
    lda.z b
    cmp #<BITMAP-1
    bne __b1
    rts
}
