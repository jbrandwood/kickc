// Demonstrates a problem where wrong alive ranges result in clobbering an alive variable
// The compiler does not realize that A is alive in the statement b=b-a - and thus can clobber it.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #2
    lda #$80
    sta euclid.a
    jsr euclid
    lda euclid.a
    sta SCREEN
    ldx #$45
    lda #$a9
    sta euclid.a
    jsr euclid
    lda euclid.a
    sta SCREEN+1
    ldx #$9b
    lda #$ff
    sta euclid.a
    jsr euclid
    lda euclid.a
    sta SCREEN+2
    ldx #3
    lda #$63
    sta euclid.a
    jsr euclid
    lda euclid.a
    sta SCREEN+3
    rts
}
// Calculate least common denominator using euclids subtraction method
// euclid(byte zeropage(2) a, byte register(X) b)
euclid: {
    .label a = 2
  b1:
    cpx a
    bne b2
    rts
  b2:
    cpx a
    bcc b3
    txa
    sec
    sbc a
    tax
    jmp b1
  b3:
    txa
    eor #$ff
    sec
    adc a
    sta a
    jmp b1
}
