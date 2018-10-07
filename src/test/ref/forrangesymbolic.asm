.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label BITMAP = $2000
    .label b = 2
    lda #<BITMAP+$1fff
    sta b
    lda #>BITMAP+$1fff
    sta b+1
  b1:
    lda #$5a
    ldy #0
    sta (b),y
    lda b
    bne !+
    dec b+1
  !:
    dec b
    lda b+1
    cmp #>BITMAP-1
    bne b1
    lda b
    cmp #<BITMAP-1
    bne b1
    rts
}
