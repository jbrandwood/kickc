// Demonstrates a problem where wrong alive ranges result in clobbering an alive variable
// The compiler does not realize that A is alive in the statement b=b-a - and thus can clobber it.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #2
    lda #$80
    sta.z euclid.a
    jsr euclid
    lda.z euclid.a
    sta SCREEN
    ldx #$45
    lda #$a9
    sta.z euclid.a
    jsr euclid
    lda.z euclid.a
    sta SCREEN+1
    ldx #$9b
    lda #$ff
    sta.z euclid.a
    jsr euclid
    lda.z euclid.a
    sta SCREEN+2
    ldx #3
    lda #$63
    sta.z euclid.a
    jsr euclid
    lda.z euclid.a
    sta SCREEN+3
    rts
}
// Calculate least common denominator using euclids subtraction method
// euclid(byte zp(2) a, byte register(X) b)
euclid: {
    .label a = 2
  __b1:
    cpx.z a
    bne __b2
    rts
  __b2:
    cpx.z a
    bcc __b3
    txa
    sec
    sbc.z a
    tax
    jmp __b1
  __b3:
    txa
    eor #$ff
    sec
    adc.z a
    sta.z a
    jmp __b1
}
